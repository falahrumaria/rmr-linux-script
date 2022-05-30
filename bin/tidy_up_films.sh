#! /bin/bash

echo "start tidy up films"
source_dirs=("$HOME/Downloads/" "$HOME/Downloads/Compressed/")
watchlist_dir="/mnt/d/film/watchlist"
script_home="$RMR_CODE_HOME/rumaria-linux-script/bin"

for dir in ${source_dirs[*]}; do
  echo "in ${dir}"
  rar_files=
  if cd "${dir}"; then
    rar_files=($(ls | grep --ignore-case --extended-regexp "(.*webrip.*|.*bluray.*|.*brrip.*)\.rar"))
  else
    exit 1
  fi

  for rar_file in ${rar_files[*]}; do
    echo "extracting rars"
    if rar e $rar_file; then
      rm --verbose $rar_file
    fi
  done

  # move series file and unite to one folder
  films=($(ls | grep --ignore-case --extended-regexp "S[[:digit:]][[:digit:]]E[[:digit:]][[:digit:]].*(\.mkv|\.mp4)"))
  for film in ${films[*]}; do
    echo "bundling ${film}"
    folder=${watchlist_dir}/$(python3 $script_home/truncate_season.py ${film})_rmrscript_
    if [ ! -d ${folder} ]; then
      mkdir ${folder}
    fi
    mv --verbose ${film} "${folder}/"
  done

  # Move regular films to the watchlist directory and delete unused residual rar files.
  # Residual rar files could be from partitioned rar files numbered 2, 3, etc whose number 1 has been successfully
  # extracted above
  films=($(ls | grep --ignore-case --extended-regexp "(.*webrip.*|.*bluray.*|.*brrip.*)(\.mkv|\.mp4)"))
  for film in ${films[*]}; do
    mv --verbose ${film} "${watchlist_dir}/"
    filename_without_extension=$(python3 $script_home/filename_without_extension.py ${film})
    residual_rars=$(ls | grep "${filename_without_extension}.*\.rar")
    if [ -n "$residual_rars" ]; then
      echo "delete residual rars"
      rm --verbose ${residual_rars}
    fi
  done
done

echo "done"
