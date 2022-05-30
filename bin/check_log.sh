#! /bin/bash

if [ -z "$1" ]; then
  cd /data/logs || exit
  echo "Hi let's check log! Choose below"
  i=0
  log_names=($(ls -d */)) # list only dirs
  for log_name in ${log_names[*]}; do
    log_name=$(echo $log_name | rev | cut -c 2- | rev) # remove last char: '/'
    log_names[$i]=$log_name
    echo "$((i + 1)). ${log_name}"
    ((i++))
  done

  read -p "input: "
  in_no=$REPLY
  read -p "number of lines (enter for default 100): "
  in_nol=100
  if [ -n "$REPLY" ]; then
    in_nol=$REPLY
  fi
  while [ -n "$in_no" ]; do
    #    show log based on user input
    log_name="${log_names[$((in_no - 1))]}"
    tail -n $in_nol -f "$log_name/$log_name.log"
    read -p "input: "
  done
  exit 0
fi

# user directly input argument
cd /data/logs/"$1" || exit

tail -n 100 -f "$1".log
