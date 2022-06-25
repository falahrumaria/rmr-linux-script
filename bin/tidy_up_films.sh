#! /bin/bash

echo "start tidy up films"
source_dirs=("$HOME/Downloads/" "$HOME/Downloads/Compressed/")
watchlist_dir="/mnt/d/film/watchlist"
script_home="$HOME/rmr_code_repo/rmr-linux-script/bin"

for dir in ${source_dirs[*]}; do
    if ! cd "${dir}"; then
        continue
    fi

    echo "in ${dir}"

    # partitioned rar files
    rar_files=(
        $(ls | grep --ignore-case --extended-regexp "(.*webrip.*|.*bluray.*|.*brrip.*)part1\.rar")
    )
    for rar_file in ${rar_files[*]}; do
        # cut out ".part1.rar"
        main_name=$(echo $rar_file | rev | cut --bytes=11- | rev)
        bundle_rars=(
            $(ls $main_name.*.rar)
        )
        if rar e $bundle_rars; then
            trash-put ${bundle_rars[*]}
        fi
    done

    # single rar file
    rar_files=(
        $(ls | grep --ignore-case --extended-regexp "(.*webrip.*|.*bluray.*|.*brrip.*)\.rar")
    )
    for rar_file in ${rar_files[*]}; do
        if rar e $rar_file; then
            trash-put $rar_file
        fi
    done

    # move series file and unite to one folder
    films=($(ls \
        | grep --ignore-case --extended-regexp "S[[:digit:]][[:digit:]]E[[:digit:]][[:digit:]].*(\.mkv|\.mp4)")
    )
    for film in ${films[*]}; do
        echo "bundling ${film}"
        folder=${watchlist_dir}/$(python3 $script_home/truncate_season.py ${film})_rmrscript_
        if [ ! -d ${folder} ]; then
            mkdir ${folder}
        fi
        mv --verbose ${film} "${folder}/"
    done

    # Move regular films to the watchlist dir
    films=(
        $(ls | grep --ignore-case --extended-regexp "(.*webrip.*|.*bluray.*|.*brrip.*)(\.mkv|\.mp4)")
    )
    for film in ${films[*]}; do
        mv --verbose ${film} "${watchlist_dir}/"
    done
done

echo "done"
