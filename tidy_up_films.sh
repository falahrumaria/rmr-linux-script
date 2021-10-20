echo "start tidy up films"
locations=("/home/rumaria/Downloads/" "/home/rumaria/Downloads/Compressed/")
watchlist_folder="/mnt/70BA29B4BA2977AC/film/watchlist/"

for location in ${locations[*]}; do
    echo "in ${location}"
    rar_files=
    if cd "${location}"; then
        rar_files=($(ls | grep ".*\.rar"))
    else
        exit 1
    fi

    for rar_file in ${rar_files[*]}; do
        echo "masuk sini 1"
        if unrar e $rar_file; then
            rm --verbose $rar_file
        fi
    done

    # move series file and unite to one folder
    films=($(ls | grep "S[[:digit:]][[:digit:]]E[[:digit:]][[:digit:]]"))
    for film in ${films[*]}; do
        echo "masuk sini 2"
        folder=${watchlist_folder}$(python3 /home/rumaria/bin/truncate_season.py ${film})_rmrscript_
        if [ ! -d ${folder} ]; then
            mkdir ${folder}
        fi
        mv --verbose ${film} "${folder}/"
    done

    # move remaining files to the watchlist directory and delete unused residual rar files
    films+=($(ls | grep ".*\.mkv"))
    for film in ${films[*]}; do
        echo "masuk sini 3"
        mv --verbose ${film} "${watchlist_folder}"
        filename_without_extension=$(python3 /home/rumaria/bin/filename_without_extension.py ${film})
        rm --verbose $(ls | grep "${filename_without_extension}.*\.rar")
    done
done
echo "done"
