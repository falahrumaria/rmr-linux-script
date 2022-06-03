#!/bin/bash

cd /data/app || exit 1
read -p "input name : "
name=$REPLY

echo "choose one from availabe scripts below"
entries=($(ls -d */)) # list only dirs
for entry in ${entries[*]}; do
  entry=$(echo "$entry" | rev | cut -c 2- | rev) # remove last char: '/'
  entries[$i]=$entry
  echo "$((i + 1)). ${entry}"
  ((i++))
done

# create new dir for jars and run scripts
mkdir "$name"
mkdir "$name/scripts"

read -p "input no : "
no=$REPLY
if [ -n "$no" ]; then
  entry="${entries[$((no - 1))]}"
  echo "creating scripts emulating $entry's scripts"
  sed "s/$entry/$name/" "$entry/scripts/start.sh" >"$name/scripts/start.sh"
  chmod +x "$name/scripts/start.sh"
  sed "s/$entry/$name/" "$entry/scripts/stop.sh" >"$name/scripts/stop.sh"
  chmod +x "$name/scripts/stop.sh"
fi

# create new dir for logs
mkdir "/data/logs/$name"

echo "finished, thank you!"
