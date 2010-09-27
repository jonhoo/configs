/**
 * Reflection.java
 *
 * A utility class for javacomplete mainly for reading class or package information.
 * Version:	0.77
 * Maintainer:	cheng fang <fangread@yahoo.com.cn>
 * Last Change:	2007-09-16
 * Copyright:	Copyright (C) 2007 cheng fang. All rights reserved.
 * License:	Vim License	(see vim's :help license)
 * 
 */

import java.lang.reflect.*;
import java.io.*;
import java.util.*;
import java.util.zip.*;

class Reflection {
    static final String VERSION	= "0.77";

    static final int OPTION_FIELD		=  1;
    static final int OPTION_METHOD		=  2;
    static final int OPTION_STATIC_FIELD	=  4;
    static final int OPTION_STATIC_METHOD	=  8;
    static final int OPTION_CONSTRUCTOR		= 16;
    static final int OPTION_STATIC		= 12;	// compound static
    static final int OPTION_INSTANCE		= 15;	// compound instance
    static final int OPTION_ALL			= 31;	// compound all
    static final int OPTION_SUPER		= 32;
    static final int OPTION_SAME_PACKAGE	= 64;

    static final int STRATEGY_ALPHABETIC	= 128;
    static final int STRATEGY_HIERARCHY		= 256;
    static final int STRATEGY_DEFAULT		= 512;

    static final int RETURN_ALL_PACKAGE_INFO	= 0x1000;

    static final String KEY_NAME		= "'n':";	// "'name':";
    static final String KEY_TYPE		= "'t':";	// "'type':";
    static final String KEY_MODIFIER		= "'m':";	// "'modifier':";
    static final String KEY_PARAMETERTYPES	= "'p':";	// "'parameterTypes':";
    static final String KEY_RETURNTYPE		= "'r':";	// "'returnType':";
    static final String KEY_DESCRIPTION		= "'d':";	// "'description':";
    static final String KEY_DECLARING_CLASS	= "'c':";	// "'declaringclass':";

    static final String NEWLINE = "";	// "\r\n"

    static boolean debug_mode = false;

    static Hashtable htClasspath = new Hashtable();

    public static boolean existed(String fqn) {
	boolean result = false;
	try {
	    Class.forName(fqn);
	    result = true;
	}
	catch (Exception ex) {
	}
	return result;
    }

    public static String existedAndRead(String fqns) {
	Hashtable mapPackages = new Hashtable();	// qualified name --> StringBuffer
	Hashtable mapClasses = new Hashtable();		// qualified name --> StringBuffer

	for (StringTokenizer st = new StringTokenizer(fqns, ","); st.hasMoreTokens(); ) {
	    String fqn = st.nextToken();
	    try {
		Class clazz = Class.forName(fqn);
		putClassInfo(mapClasses, clazz);
	    }
	    catch (Exception ex) {
		String binaryName = fqn;
		boolean found = false;
		while (true) {
		    try {
			int lastDotPos = binaryName.lastIndexOf('.');
			if (lastDotPos == -1)
			    break;
			binaryName = binaryName.substring(0, lastDotPos) + '$' + binaryName.substring(lastDotPos+1, binaryName.length());
			Class clazz = Class.forName(binaryName);
			putClassInfo(mapClasses, clazz);
			found = true;
			break;
		    }
		    catch (Exception e) {
		    }
		}
		if (!found)
		    putPackageInfo(mapPackages, fqn);
	    }
	}

	if (mapPackages.size() > 0 || mapClasses.size() > 0) {
	    StringBuffer sb = new StringBuffer(4096);
	    sb.append("{");
	    for (Enumeration e = mapPackages.keys(); e.hasMoreElements(); ) {
		String s = (String)e.nextElement();
		sb.append("'").append( s.replace('$', '.') ).append("':").append(mapPackages.get(s)).append(",");
	    }
	    for (Enumeration e = mapClasses.keys(); e.hasMoreElements(); ) {
		String s = (String)e.nextElement();
		sb.append("'").append( s.replace('$', '.') ).append("':").append(mapClasses.get(s)).append(",");
	    }
	    sb.append("}");
	    return sb.toString();
	}
	else
	    return "";
    }

    private static String getPackageList(String fqn) {
	Hashtable mapPackages = new Hashtable();
	putPackageInfo(mapPackages, fqn);
	return mapPackages.size() > 0 ? mapPackages.get(fqn).toString() : "";
    }

    private static Hashtable collectClassPath() {
	if (!htClasspath.isEmpty())
	    return htClasspath;

	// runtime classes
	if ("Kaffe".equals(System.getProperty("java.vm.name"))) {
	    addClasspathesFromDir(System.getProperty("java.home") + File.separator + "share" + File.separator + "kaffe" + File.separator);
	}
	else if ("GNU libgcj".equals(System.getProperty("java.vm.name"))) {
	    if (new File(System.getProperty("sun.boot.class.path")).exists())
		htClasspath.put(System.getProperty("sun.boot.class.path"), "");
	}

	if (System.getProperty("java.vendor").toLowerCase(Locale.US).indexOf("microsoft") >= 0) {
	    // `*.ZIP` files in `Packages` directory
	    addClasspathesFromDir(System.getProperty("java.home") + File.separator + "Packages" + File.separator);
	}
	else {
	    // the following code works for several kinds of JDK
	    // - JDK1.1:		classes.zip 
	    // - JDK1.2+:		rt.jar 
	    // - JDK1.4+ of Sun and Apple:	rt.jar + jce.jar + jsse.jar
	    // - JDK1.4 of IBM		split rt.jar into core.jar, graphics.jar, server.jar
	    // 				combined jce.jar and jsse.jar into security.jar
	    // - JDK for MacOS X	split rt.jar into classes.jar, ui.jar in Classes directory
	    addClasspathesFromDir(System.getProperty("java.home") + File.separator + "lib" + File.separator);
	    addClasspathesFromDir(System.getProperty("java.home") + File.separator + "jre" + File.separator + "lib" + File.separator);
	    addClasspathesFromDir(System.getProperty("java.home") + File.separator + ".."  + File.separator + "Classes" + File.separator);
	}

	// ext
	String extdirs = System.getProperty("java.ext.dirs");
	for (StringTokenizer st = new StringTokenizer(extdirs, File.pathSeparator); st.hasMoreTokens(); ) {
	    addClasspathesFromDir(st.nextToken() + File.separator);
	}

	// user classpath
	String classPath = System.getProperty("java.class.path");
	StringTokenizer st = new StringTokenizer(classPath, File.pathSeparator);
	while (st.hasMoreTokens()) {
	    String path = st.nextToken();
	    File f = new File(path);
	    if (!f.exists())
		continue;

	    if (path.endsWith(".jar") || path.endsWith(".zip"))
		htClasspath.put(f.toString(), "");
	    else {
		if (f.isDirectory())
		    htClasspath.put(f.toString(), "");
	    }
	}

	return htClasspath;
    }

    private static void addClasspathesFromDir(String dirpath) {
	File dir = new File(dirpath);
	if (dir.isDirectory()) {
	    String[] items = dir.list();		// use list() instead of listFiles() since the latter are introduced in 1.2
	    for (int i = 0; i < items.length; i++) {
		File f = new File(dirpath + items[i]);
		if (!f.exists())
		    continue;

		if (items[i].endsWith(".jar") || items[i].endsWith(".zip") || items[i].endsWith(".ZIP")) {
		    htClasspath.put(f.toString(), "");
		}
		else if (items.equals("classes")) {
		    if (f.isDirectory())
			htClasspath.put(f.toString(), "");
		}
	    }
	}
    }
	

    /**
     * If name is empty, put all loadable package info into map once.
     */
    private static void putPackageInfo(Hashtable map, String name) {
	String prefix = name.replace('.', '/') + "/";
	Hashtable subpackages = new Hashtable();
	Hashtable classes = new Hashtable();
	for (Enumeration e = collectClassPath().keys(); e.hasMoreElements(); ) {
	    String path = (String)e.nextElement();
	    if (path.endsWith(".jar") || path.endsWith(".zip"))
		appendListFromJar(subpackages, classes, path, prefix);
	    else
		appendListFromFolder(subpackages, classes, path, prefix);
	}

	if (subpackages.size() > 0 || classes.size() > 0) {
	    StringBuffer sb = new StringBuffer(1024);
	    sb.append("{'tag':'PACKAGE','subpackages':[");
	    for (Enumeration e = subpackages.keys(); e.hasMoreElements(); ) {
		sb.append("'").append(e.nextElement()).append("',");
	    }
	    sb.append("],'classes':[");
	    for (Enumeration e = classes.keys(); e.hasMoreElements(); ) {
		sb.append("'").append(e.nextElement()).append("',");
	    }
	    sb.append("]}");
	    map.put(name, sb.toString());
	}
    }

    public static void appendListFromJar(Hashtable subpackages, Hashtable classes, String path, String prefix) {
	try {
	    for (Enumeration entries = new ZipFile(path).entries(); entries.hasMoreElements(); ) {
		String entry = entries.nextElement().toString();
		int len = entry.length();
		if (entry.endsWith(".class") && entry.indexOf('$') == -1
			&& entry.startsWith(prefix)) {
		    int splitPos = entry.indexOf('/', prefix.length());
		    String shortname = entry.substring(prefix.length(), splitPos == -1 ? entry.length()-6 : splitPos);
		    if (splitPos == -1) {
			if (!classes.containsKey(shortname))
			    classes.put(shortname, ""); //classes.put(shortname, "{'tag':'CLASSDEF','name':'"+shortname+"'}");
		    }
		    else {
			if (!subpackages.containsKey(shortname))
			    subpackages.put(shortname, ""); //subpackages.put(shortname, "{'tag':'PACKAGE','name':'" +shortname+"'}");
		    }
		}
	    }
	}
	catch (Throwable e) {
	    //e.printStackTrace();
	}
    }

    public static void appendListFromFolder(Hashtable subpackages, Hashtable classes, String path, String prefix) {
	try {
	    String fullPath = path + "/" + prefix;
	    File file = new File(fullPath);
	    if (file.isDirectory()) {
		String[] descents = file.list();
		for (int i = 0; i < descents.length; i++) {
		    if (descents[i].indexOf('$') == -1) {
			if (descents[i].endsWith(".class")) {
			    String shortname = descents[i].substring(0, descents[i].length()-6);
			    if (!classes.containsKey(shortname))
				classes.put(shortname, "");
			}
			else if ((new File(fullPath + "/" + descents[i])).isDirectory()) {
			    if (!subpackages.containsKey(descents[i]))
				subpackages.put(descents[i], "");
			}
		    }
		}
	    }						
	}
	catch (Throwable e) {
	}
    }

    private static int INDEX_PACKAGE = 0;
    private static int INDEX_CLASS = 1;

    // generate information of all packages in jar files.
    public static String getPackageList() {
	Hashtable map = new Hashtable();

	for (Enumeration e = collectClassPath().keys(); e.hasMoreElements(); ) {
	    String path = (String)e.nextElement();
	    if (path.endsWith(".jar") || path.endsWith(".zip"))
		appendListFromJar(path, map);
	}

	StringBuffer sb = new StringBuffer(4096);
	sb.append("{");
	//sb.append("'*':'").append( map.remove("") ).append("',");	// default package
	for (Enumeration e = map.keys(); e.hasMoreElements(); ) {
	    String s = (String)e.nextElement();
	    StringBuffer[] sbs = (StringBuffer[])map.get(s);
	    sb.append("'").append( s.replace('/', '.') ).append("':")
	      .append("{'tag':'PACKAGE'");
	    if (sbs[INDEX_PACKAGE].length() > 0)
		sb.append(",'subpackages':[").append(sbs[INDEX_PACKAGE]).append("]");
	    if (sbs[INDEX_CLASS].length() > 0)
		sb.append(",'classes':[").append(sbs[INDEX_CLASS]).append("]");
	    sb.append("},");
	}
	sb.append("}");
	return sb.toString();

    }

    public static void appendListFromJar(String path, Hashtable map) {
	try {
	    for (Enumeration entries = new ZipFile(path).entries(); entries.hasMoreElements(); ) {
		String entry = entries.nextElement().toString();
		int len = entry.length();
		if (entry.endsWith(".class") && entry.indexOf('$') == -1) {
		    int slashpos = entry.lastIndexOf('/');
		    String parent = entry.substring(0, slashpos);
		    String child  = entry.substring(slashpos+1, len-6);
		    putItem(map, parent, child, INDEX_CLASS);

		    slashpos = parent.lastIndexOf('/');
		    if (slashpos != -1) {
			AddToParent(map, parent.substring(0, slashpos), parent.substring(slashpos+1));
		    }
		}
	    }
	}
	catch (Throwable e) {
	    //e.printStackTrace();
	}
    }

    public static void putItem(Hashtable map, String parent, String child, int index) {
	StringBuffer[] sbs = (StringBuffer[])map.get(parent);
	if (sbs == null) {
	    sbs = new StringBuffer[] {  new StringBuffer(256), 		// packages
					new StringBuffer(256)		// classes
				      };
	}
	if (sbs[index].toString().indexOf("'" + child + "',") == -1)
	    sbs[index].append("'").append(child).append("',");
	map.put(parent, sbs);
    }

    public static void AddToParent(Hashtable map, String parent, String child) {
	putItem(map, parent, child, INDEX_PACKAGE);

	int slashpos = parent.lastIndexOf('/');
	if (slashpos != -1) {
	    AddToParent(map, parent.substring(0, slashpos), parent.substring(slashpos+1));
	}
    }


    public static String getClassInfo(String className) {
	Hashtable mapClasses = new Hashtable();
	try {
	    Class clazz = Class.forName(className);
	    putClassInfo(mapClasses, clazz);
	}
	catch (Exception ex) {
	}

	if (mapClasses.size() == 1) {
	    return mapClasses.get(className).toString();	// return {...}
	}
	else if (mapClasses.size() > 1) {
	    StringBuffer sb = new StringBuffer(4096);
	    sb.append("[");
	    for (Enumeration e = mapClasses.keys(); e.hasMoreElements(); ) {
		String s = (String)e.nextElement();
		sb.append(mapClasses.get(s)).append(",");
	    }
	    sb.append("]");
	    return sb.toString();				// return [...]
	}
	else
	    return "";
    }

    private static void putClassInfo(Hashtable map, Class clazz) {
	if (map.containsKey(clazz.getName()))
	    return ;

	try {
	    StringBuffer sb = new StringBuffer(1024);
	    sb.append("{")
	      .append("'tag':'CLASSDEF',").append(NEWLINE)
	      .append("'flags':'").append(Integer.toString(clazz.getModifiers(), 2)).append("',").append(NEWLINE)
	      .append("'name':'").append(clazz.getName().replace('$', '.')).append("',").append(NEWLINE)
	      //.append("'package':'").append(clazz.getPackage().getName()).append("',").append(NEWLINE)	// no getPackage() in JDK1.1
	      .append("'classpath':'1',").append(NEWLINE)
	      .append("'fqn':'").append(clazz.getName().replace('$', '.')).append("',").append(NEWLINE);

	    Class[] interfaces = clazz.getInterfaces();
	    if (clazz.isInterface()) {
		sb.append("'extends':[");
	    } else {
		Class superclass = clazz.getSuperclass();
		if (superclass != null && !"java.lang.Object".equals(superclass.getName())) {
		    sb.append("'extends':['").append(superclass.getName().replace('$', '.')).append("'],").append(NEWLINE);
		    putClassInfo(map, superclass);	// !!
		}
		sb.append("'implements':[");
	    }
	    for (int i = 0, n = interfaces.length; i < n; i++) {
	      sb.append("'").append(interfaces[i].getName().replace('$', '.')).append("',");
	      putClassInfo(map, interfaces[i]);			// !!
	    }
	    sb.append("],").append(NEWLINE);;

	    Constructor[] ctors = clazz.getConstructors();
	    sb.append("'ctors':[");
	    for (int i = 0, n = ctors.length; i < n; i++) {
		Constructor ctor = ctors[i];
		sb.append("{");
		appendModifier(sb, ctor.getModifiers());
		appendParameterTypes(sb, ctor.getParameterTypes());
		sb.append(KEY_DESCRIPTION).append("'").append(ctors[i].toString()).append("'");
		sb.append("},").append(NEWLINE);
	    }
	    sb.append("], ").append(NEWLINE);

	    Field[] fields = clazz.getFields();
	    //java.util.Arrays.sort(fields, comparator);
	    sb.append("'fields':[");
	    for (int i = 0, n = fields.length; i < n; i++) {
		Field f = fields[i];
		int modifier = f.getModifiers();
		sb.append("{");
		sb.append(KEY_NAME).append("'").append(f.getName()).append("',");
		if (!f.getDeclaringClass().getName().equals(clazz.getName()))
		    sb.append(KEY_DECLARING_CLASS).append("'").append(f.getDeclaringClass().getName()).append("',");
		appendModifier(sb, modifier);
		sb.append(KEY_TYPE).append("'").append(f.getType().getName()).append("'");
		sb.append("},").append(NEWLINE);
	    }
	    sb.append("], ").append(NEWLINE);

	    Method[] methods = clazz.getMethods();
	    //java.util.Arrays.sort(methods, comparator);
	    sb.append("'methods':[");
	    for (int i = 0, n = methods.length; i < n; i++) {
		Method m = methods[i];
		int modifier = m.getModifiers();
		sb.append("{");
		sb.append(KEY_NAME).append("'").append(m.getName()).append("',");
		if (!m.getDeclaringClass().getName().equals(clazz.getName()))
		    sb.append(KEY_DECLARING_CLASS).append("'").append(m.getDeclaringClass().getName()).append("',");
		appendModifier(sb, modifier);
		sb.append(KEY_RETURNTYPE).append("'").append(m.getReturnType().getName()).append("',");
		appendParameterTypes(sb, m.getParameterTypes());
		sb.append(KEY_DESCRIPTION).append("'").append(m.toString()).append("'");
		sb.append("},").append(NEWLINE);
	    }
	    sb.append("], ").append(NEWLINE);

	    Class[] classes = clazz.getClasses();
	    sb.append("'classes': [");
	    for (int i = 0, n = classes.length; i < n; i++) {
		Class c = classes[i];
		sb.append("'").append(c.getName().replace('$', '.')).append("',");
		putClassInfo(map, c);			// !!
	    }
	    sb.append("], ").append(NEWLINE);

	    appendDeclaredMembers(map, clazz, sb);

	    sb.append("}");
	    map.put(clazz.getName(), sb);
	}
	catch (Exception ex) {
	    //ex.printStackTrace();
	}
    }

    private static void appendDeclaredMembers(Hashtable map, Class clazz, StringBuffer sb) {
	    Constructor[] ctors = clazz.getDeclaredConstructors();
	    sb.append("'declared_ctors':[");
	    for (int i = 0, n = ctors.length; i < n; i++) {
		Constructor ctor = ctors[i];
		if (!Modifier.isPublic(ctor.getModifiers())) {
		    sb.append("{");
		    appendModifier(sb, ctor.getModifiers());
		    appendParameterTypes(sb, ctor.getParameterTypes());
		    sb.append(KEY_DESCRIPTION).append("'").append(ctors[i].toString()).append("'");
		    sb.append("},").append(NEWLINE);
		}
	    }
	    sb.append("], ").append(NEWLINE);

	    Field[] fields = clazz.getDeclaredFields();
	    sb.append("'declared_fields':[");
	    for (int i = 0, n = fields.length; i < n; i++) {
		Field f = fields[i];
		int modifier = f.getModifiers();
		if (!Modifier.isPublic(modifier)) {
		    sb.append("{");
		    sb.append(KEY_NAME).append("'").append(f.getName()).append("',");
		    if (!f.getDeclaringClass().getName().equals(clazz.getName()))
			sb.append(KEY_DECLARING_CLASS).append("'").append(f.getDeclaringClass().getName()).append("',");
		    appendModifier(sb, modifier);
		    sb.append(KEY_TYPE).append("'").append(f.getType().getName()).append("'");
		    sb.append("},").append(NEWLINE);
		}
	    }
	    sb.append("], ").append(NEWLINE);

	    Method[] methods = clazz.getDeclaredMethods();
	    sb.append("'declared_methods':[");
	    for (int i = 0, n = methods.length; i < n; i++) {
		Method m = methods[i];
		int modifier = m.getModifiers();
		if (!Modifier.isPublic(modifier)) {
		    sb.append("{");
		    sb.append(KEY_NAME).append("'").append(m.getName()).append("',");
		    if (!m.getDeclaringClass().getName().equals(clazz.getName()))
			sb.append(KEY_DECLARING_CLASS).append("'").append(m.getDeclaringClass().getName()).append("',");
		    appendModifier(sb, modifier);
		    sb.append(KEY_RETURNTYPE).append("'").append(m.getReturnType().getName()).append("',");
		    appendParameterTypes(sb, m.getParameterTypes());
		    sb.append(KEY_DESCRIPTION).append("'").append(m.toString()).append("'");
		    sb.append("},").append(NEWLINE);
		}
	    }
	    sb.append("], ").append(NEWLINE);

	    Class[] classes = clazz.getDeclaredClasses();
	    sb.append("'declared_classes': [");
	    for (int i = 0, n = classes.length; i < n; i++) {
		Class c = classes[i];
		if (!Modifier.isPublic(c.getModifiers())) {
		    sb.append("'").append(c.getName().replace('$', '.')).append("',");
		    putClassInfo(map, c);			// !!
		}
	    }
	    sb.append("], ").append(NEWLINE);
    }

    private static void appendModifier(StringBuffer sb, int modifier) {
	sb.append(KEY_MODIFIER).append("'").append(Integer.toString(modifier, 2)).append("', ");
    }

    private static void appendParameterTypes(StringBuffer sb, Class[] paramTypes) {
	if (paramTypes.length == 0) return ;

	sb.append(KEY_PARAMETERTYPES).append("[");
	for (int j = 0; j < paramTypes.length; j++) {
	    sb.append("'").append(paramTypes[j].getName()).append("',");
	}
	sb.append("],");
    }

    private static boolean isBlank(String str) {
        int len;
        if (str == null || (len = str.length()) == 0)
            return true;
        for (int i = 0; i < len; i++)
            if ((Character.isWhitespace(str.charAt(i)) == false))
                return false;
        return true;
    }

    // test methods

    static void debug(String s) {
	if (debug_mode)
	    System.out.println(s);
    }
    static void output(String s) {
	if (!debug_mode)
	    System.out.print(s);
    }


    private static void usage() {
	System.out.println("Reflection for javacomplete (" + VERSION + ")");
	System.out.println("  java [-classpath] Reflection [-c] [-d] [-e] [-h] [-v] [-p] [-s] name[,comma_separated_name_list]");
	System.out.println("Options:");
	System.out.println("  -a	list all members in alphabetic order");
	System.out.println("  -c	list constructors");
	System.out.println("  -C	return class info");
	System.out.println("  -d	default strategy, i.e. instance fields, instance methods, static fields, static methods");
	System.out.println("  -e	check class existed");
	System.out.println("  -E	check class existed and read class information");
	System.out.println("  -D	debug mode");
	System.out.println("  -p	list package content");
	System.out.println("  -P	print all package info in the Vim dictionary format");
	System.out.println("  -s	list static fields and methods");
	System.out.println("  -h	help");
	System.out.println("  -v	version");
    }

    public static void main(String[] args) {
	String className = null;
	int option = 0x0;
	boolean wholeClassInfo = false;
	boolean onlyStatic = false;
	boolean onlyConstructor = false;
	boolean listPackageContent = false;
	boolean checkExisted = false;
	boolean checkExistedAndRead = false;
	boolean allPackageInfo = false;

	for (int i = 0, n = args.length; i < n && !isBlank(args[i]); i++) {
	    //debug(args[i]);
	    if (args[i].charAt(0) == '-') {
		if (args[i].length() > 1) {
		switch (args[i].charAt(1)) {
		case 'a':
		    break;
		case 'c':	// request constructors
		    option = option | OPTION_CONSTRUCTOR;
		    onlyConstructor = true;
		    break;
		case 'C':	// class info
		    wholeClassInfo = true;
		    break;
		case 'd':	// default strategy
		    option = option | STRATEGY_DEFAULT;
		    break;
		case 'D':	// debug mode
		    debug_mode = true;
		    break;
		case 'e':	// class existed
		    checkExisted = true;
		    break;
		case 'E':	// check existed and read class information
		    checkExistedAndRead = true;
		    break;
		case 'h':	// help
		    usage();
		    return ;
		case 'v':	// version
		    System.out.println("Reflection for javacomplete (" + VERSION + ")");
		    break;
		case 'p':
		    listPackageContent = true;
		    break;
		case 'P':
		    option = RETURN_ALL_PACKAGE_INFO;
		    break;
		case 's':	// request static members
		    option = option | OPTION_STATIC_METHOD | OPTION_STATIC_FIELD;
		    onlyStatic = true;
		    break;
		default:
		}
		}
	    }
	    else {
		className = args[i];
	    }
	}
	if (className == null && (option & RETURN_ALL_PACKAGE_INFO) != RETURN_ALL_PACKAGE_INFO) {
	    return;
	}
	if (option == 0x0)
	    option = OPTION_INSTANCE;

	if (wholeClassInfo)
	    output( getClassInfo(className) );
	else if ((option & RETURN_ALL_PACKAGE_INFO) == RETURN_ALL_PACKAGE_INFO)
	    output( getPackageList() );
	else if (checkExistedAndRead)
	    output( existedAndRead(className) );
	else if (checkExisted)
	    output( String.valueOf(existed(className)) );
	else if (listPackageContent)
	    output( getPackageList(className) );
    }
}
