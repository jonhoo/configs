-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("vicious");

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

tags = {
  names  = { 'cmd', 'web', 'mail', 'daemon', 'music', 'chat', 'progress', 8, 9 },
  layout = { layouts[5],  layouts[12], layouts[12], layouts[5], layouts[5],
             layouts[12], layouts[5],  layouts[5],  layouts[5]
}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
    -- Each screen has its own tag table.
end
-- }}}

-- {{{ Widgets

-- Separator
spacer = widget({ type = "textbox" })
spacer.text = " <span color='#000088'>::</span> "

-- CPU usage
cpugraph  = awful.widget.graph()
cpugraph:set_width(40)
cpugraph:set_height(16)
cpugraph:set_background_color('#000000')
cpugraph:set_gradient_angle(0)
cpugraph:set_color("#CC0000")
cpugraph:set_border_color("#222222")
cpugraph:set_gradient_colors({ "#CC0000", "#CCCC00", "#00CC00" })
vicious.register(cpugraph, vicious.widgets.cpu, "$1")

-- Memory usage
memgraph  = awful.widget.graph()
memgraph:set_width(40)
memgraph:set_height(16)
memgraph:set_background_color('#000000')
memgraph:set_gradient_angle(0)
memgraph:set_color("#CC0000")
memgraph:set_border_color("#222222")
memgraph:set_gradient_colors({ "#CC0000", "#CCCC00", "#00CC00" })
vicious.register(memgraph, vicious.widgets.mem, "$1")

-- Battery time
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$3", 61, "BAT0")

-- Battery usage
batbar = awful.widget.progressbar()
batbar:set_width(8)
batbar:set_height(16)
batbar:set_vertical(true)
batbar:set_background_color("#000000")
batbar:set_border_color("#222222")
batbar:set_color("#00CC00")
vicious.register(batbar, vicious.widgets.bat, "$2", 61, "BAT0")

-- Brightness
brightbar = awful.widget.progressbar()
brightbar:set_width(8)
brightbar:set_height(16)
brightbar:set_vertical(true)
brightbar:set_background_color('#000000')
brightbar:set_border_color("#222222")
brightbar:set_color("#CCCC00")
vicious.register(brightbar, vicious.widgets.proc, "$2", 5, "/sys/class/backlight/psblvds/brightness")

-- File system usage
fs = awful.widget.progressbar()
fs:set_width(8)
fs:set_height(16)
fs:set_vertical(true)
fs:set_background_color("#000000")
fs:set_border_color("#222222")
fs:set_color("#CCCCCC")
vicious.register(fs, vicious.widgets.fs, "${/ avail_p}", 599)

-- File system usage
fsh = awful.widget.progressbar()
fsh:set_width(8)
fsh:set_height(16)
fsh:set_vertical(true)
fsh:set_background_color("#000000")
fsh:set_border_color("#222222")
fsh:set_color("#CCCCCC")
vicious.register(fsh, vicious.widgets.fs, "${/home avail_p}", 599)

-- File system usage
fsv = awful.widget.progressbar()
fsv:set_width(8)
fsv:set_height(16)
fsv:set_vertical(true)
fsv:set_background_color("#000000")
fsv:set_border_color("#222222")
fsv:set_color("#CCCCCC")
vicious.register(fsv, vicious.widgets.fs, "${/var avail_p}", 599)

-- Network usage
netwidget = widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net, ''
  .. '<span color="#00CC00">${wlan0 down_kb}</span> / '
  .. '<span color="#CC0000">${wlan0 up_kb}</span>', 3)

-- Volume level
volbar    = awful.widget.progressbar()
volbar:set_width(8)
volbar:set_height(16)
volbar:set_vertical(true)
volbar:set_background_color("#000000")
volbar:set_border_color("#222222")
volbar:set_color("#5555CC")
vicious.register(volbar,    vicious.widgets.volume, "$1", 5, "Master")

-- Wifi
wifi = widget({ type = "textbox" })
vicious.register(wifi, vicious.widgets.wifi, ''
  .. '${ssid} <span color="#EEEEEE">(${link}%)</span>', 10, "wlan0")

-- Date and time
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, "%c", 1)

-- System tray
systray = widget({ type = "systray" })

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "reboot", "sudo shutdown -r now" },
   { "shutdown", "sudo shutdown -h now" },
   { "restart awesome", awesome.restart },
   { "lock", "xscreensaver-command -lock" },
   { "quit", awesome.quit }
}

local oopath = '/usr/lib/openoffice/program/'
openoffice = {
    { "Writer", oopath .. "swriter" },
    { "Impress", oopath .. "simpress" },
    { "Draw", oopath .. "sdraw" },
    { "Mat", oopath .. "smath" },
    { "Calc", oopath .. "scalc" },
    { "Base", oopath .. "sbase" }
}

mymainmenu = awful.menu({ 
    items = { 
        { "Chrome", "chromium" },
        { "Firefox", "firefox" },
        { "Mail", "thunderbird" },
        { "Spotify", 'wine "C:\\Program Files\\Spotify\\spotify.exe"' },
        { "OpenOffice", openoffice },
        { "awesome", myawesomemenu }
    }
})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylayoutbox[s],
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and systray or nil,
        spacer, datewidget,
        spacer, volbar.widget,
            fs.widget,
            fsh.widget,
            fsv.widget,
            brightbar.widget,
            memgraph.widget,
            cpugraph.widget,
            batbar.widget,
        spacer, batwidget,
        spacer, wifi,
        spacer, netwidget,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
   
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer -q sset Master toggle")   end),
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 2dB+", false) end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 2dB-", false) end),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("sudo /usr/local/bin/brightness.sh up", false) end),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("sudo /usr/local/bin/brightness.sh down", false) end),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c)
            then c.above       =  true  end
        end
    end)
end
-- }}}
-- }}}

awful.util.spawn("sudo -u jon dropboxd");
