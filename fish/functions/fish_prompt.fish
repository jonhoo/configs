function fish_prompt
  set_color white
  echo -n "["(date "+%H:%M")"] "
  set_color yellow
  echo -n (whoami)
  set_color normal
  echo -n '@'
  set_color blue
  echo -n (hostname)" "
  set_color green
  echo -n (prompt_pwd)
  set_color brown
  printf '%s ' (__fish_git_prompt)
  set_color red
  if [ (whoami) = "root" ]
    echo -n '# '
  else
    echo -n '$ '
  end
  set_color normal
end
