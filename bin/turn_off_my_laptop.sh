#! /bin/bash

notify-send -t 15000 "killing all apps and shutting down"

patterns=(
  "/usr/bin/dolphin"
  "Telegram/Telegram"
  "ktorrent"
  "smplayer"
  "pycharm.*/jbr/bin/java"
  "idea.*/jbr/bin/java"
  "firefox$"
  "/opt/brave.com/brave/brave"
  "/opt/google/chrome/chrome"
  "dbeaver/jre/bin/java"
  "Postman/app/postman"
  "/opt/zoom/zoom"
)

for pattern in ${patterns[*]}; do
  echo "current pattern: $pattern"
  pids=($(ps -ef |
    grep --extended-regexp "$pattern" |
    grep -v grep |    # filter out grep itself
    awk '{print $2}') # output only pid
  )
  for pid in ${pids[*]}; do
    echo -e "\tnow $pid"
    kill -9 $pid
  done
done

# power off the computer 1 minute from now
shutdown
