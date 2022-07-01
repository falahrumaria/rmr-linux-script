#! /bin/bash

# this script is to install/update dbeaver from tarball in ~/Downloads
# and create sym link so that user can start dbeaver by typing command:
# dbeaver
# from anywhere

base_dir=$HOME/rmr_code_repo/rmr-linux-script
path_linux_app=/mnt/d/linux
path_download=$HOME/Downloads

# args: new_version
get_dl_url() {
    awk "\$1 ~ /url\.dbeaver\.dl/ { print \$3 }" $base_dir/config | sed "s/servion/$1/g"
}

cd "$path_download" || exit
file_tarball=$(ls dbeaver*.tar.gz)

if ! test "$file_tarball"; then
    echo "dbeaver's tarball does not exist"
    echo "please download first, input new version below"
    read -p "input : "
    download_url=$(get_dl_url "$REPLY")
    if ! wget "$download_url"; then
        echo "trying to open the download page, hopefully it will prompt the browser to download"
        echo "but copy the url below because we want to download here instead for automation purpose of the next step"
        firefox $(awk '$1 ~ /url\.dbeaver\.page/ { print $3 }' $base_dir/config)
        read -p "input : " download_url
        wget "$download_url"
    fi
    file_tarball=$(ls dbeaver*.tar.gz)
    if ! test "$file_tarball"; then
        echo "dbeaver's tarball does not exist"
        exit 1
    fi
    # save new download url
    sed "s|url.dbeaver.dl = .*|url.dbeaver.dl = $download_url|" "$base_dir/config" > "$base_dir/config1"
    mv "$base_dir/config1" "$base_dir/config"
fi

# close running app
main_pid=$(ps -ef \
    | grep --max-count=1 dbeaver/jre/bin/java \
    | awk '{print $2}') # field 2 is pid
kill -9 $main_pid

cd $path_linux_app || exit
cur_dbeaver_dir=$(ls -d dbeaver*)
echo "current dbeaver dir : " $cur_dbeaver_dir
# remove existing dir app if exist
if test "$cur_dbeaver_dir"; then
    trash-put "$cur_dbeaver_dir"
    echo "move $cur_dbeaver_dir to trash"
fi

# extract tarball
tar xvf $path_download/$file_tarball

path_script=$(ls dbeaver*/dbeaver)

# create symbolic link
ln --force -s $path_linux_app/$path_script $base_dir/bin/dbeaver

trash-put $path_download/$file_tarball

echo "dbeaver updated!"
echo -e "please run \n$ dbeaver"
