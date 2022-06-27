#! /bin/bash

echo "start tidy up films"
source_dirs=("$HOME/Downloads/" "$HOME/Downloads/Compressed/")
watchlist_dir="/mnt/d/film/watchlist"

truncate_season() {
    echo "$1" | sed s/E[[:digit:]][[:digit:]].*/""/i
}

main_name_from_partitioned_rars() {
    echo "$1" | sed s/\.part1\.rar/""/i
}

for dir in ${source_dirs[*]}; do
    if ! cd "${dir}"; then
        continue
    fi

    echo "in ${dir}"

    # partitioned rar files
    mapfile -t rar_files < <(ls | grep --ignore-case --perl-regexp ".*(webrip|bluray|brrip).*\.part1\.rar")
    for rar_file in ${rar_files[*]}; do
        # cut out ".part1.rar"
        main_name=$(main_name_from_partitioned_rars $rar_file)
        mapfile -t bundle_rars < <(ls $main_name.part*.rar)
        if ! rar t ${bundle_rars[0]}; then
            continue
        fi
        rar e ${bundle_rars[0]}
        trash-put ${bundle_rars[*]}
    done

    # single rar file
    mapfile -t rar_files < <(ls \
        | grep --ignore-case --perl-regexp ".*(webrip|bluray|brrip).*\.rar" \
        | grep --ignore-case --invert-match --perl-regexp '.*part\d\.rar')
    for rar_file in ${rar_files[*]}; do
        if rar e $rar_file; then
            trash-put $rar_file
        fi
    done

    # move series file and unite to one folder
    mapfile -t films < <(ls | grep --ignore-case --perl-regexp "S\d\dE\d\d.*(\.mkv|\.mp4)")
    for film in ${films[*]}; do
        echo "bundling ${film}"
        folder="${watchlist_dir}/$(truncate_season ${film})_rmrscript_"
        if [ ! -d ${folder} ]; then
            mkdir ${folder}
        fi
        mv --verbose ${film} "${folder}/"
    done

    # Move regular films to the watchlist dir
    mapfile -t films < <(ls | grep --ignore-case --perl-regexp ".*(webrip|bluray|brrip).*(\.mkv|\.mp4)")
    for film in ${films[*]}; do
        mv --verbose ${film} "${watchlist_dir}/"
    done
done

echo "done"
