function fish_prompt
  set_color brblack
  echo -n "["(date "+%H:%M")"] "
  #set_color yellow
  #echo -n (whoami)
  #set_color normal
  set_color blue
  echo -n (hostname)
  if [ $PWD != $HOME ]
    set_color brblack
    echo -n ':'
    set_color yellow
    echo -n (basename $PWD)
  end
  set_color green
  printf '%s ' (__fish_git_prompt)
  set_color red
  echo -n '| '
  set_color normal
end
