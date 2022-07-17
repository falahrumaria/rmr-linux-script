#! /bin/bash

# this script is to install/update jetbrains product from tarball in ~/Downloads
# and create sym link so that user can start it from anywhere:
# listed product: intellij idea, pycharm

base_dir=$HOME/rmr_code_repo/rmr-linux-script
path_linux_app=/mnt/d/linux
path_download=$HOME/Downloads

if ! test "$product"; then
    echo "choose product:"
    echo "1. idea"
    echo "2. pycharm"
    echo "3. dbeaver"
    read -p "input number : " product
    case $product in
        "1")
            product="idea"
            download_url="https://download-cdn.jetbrains.com/idea/ideaIC-servion.tar.gz"
            page_url="https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux&code=IIC"
            process_path="idea.*/jbr/bin/java"
            starter_path="idea*/bin/idea.sh"
            ;;
        "2")
            product="pycharm"
            download_url="https://download-cdn.jetbrains.com/python/pycharm-community-servion.tar.gz"
            page_url="https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux&code=PCC"
            process_path="pycharm.*/jbr/bin/java"
            starter_path="pycharm*/bin/pycharm.sh"
            ;;
        "3")
            product="dbeaver"
            download_url="https://download.dbeaver.com/community/servion/dbeaver-ce-servion-linux.gtk.x86_64.tar.gz"
            page_url="https://dbeaver.io/download/"
            process_path="dbeaver/jre/bin/java"
            starter_path="dbeaver/dbeaver"
            ;;
        *)
            echo "wrong input!"
            exit
            ;;
    esac
fi

cd "$path_download" || exit
file_tarball=$(ls $product*.tar.gz)

if ! test "$file_tarball"; then
    echo "$product's tarball does not exist"
    echo "please download first, input new version below"
    read -p "input : "
    if ! wget "${download_url//servion/$REPLY}"; then
        echo "trying to open the download page, hopefully it will prompt the browser to download"
        echo "but copy the url below because we want to download here instead for automation purpose of the next step"
        firefox $page_url
        read -p "input : " download_url
        wget "$download_url"
    fi
    file_tarball=$(ls $product*.tar.gz)
    if ! test "$file_tarball"; then
        echo "$product's tarball does not exist"
        exit 1
    fi
fi

# close running app
main_pid=$(ps -ef \
    | grep --max-count=1 $process_path \
    | awk '{print $2}') # field 2 is pid
kill -9 "$main_pid"

cd $path_linux_app || exit
cur_dir=$(ls -d $product*)
echo "current $product dir : $cur_dir"
# remove existing app dir if exist
if test "$cur_dir"; then
    trash-put "$cur_dir"
    echo "move $cur_dir to trash"
fi

# extract tarball
tar xvf "$path_download/$file_tarball"

starter_path=$(ls $starter_path)
starter_command=$(basename "$starter_path")

# create symbolic link
ln --force --symbolic "$path_linux_app/$starter_path" "$base_dir/bin/$starter_command"

trash-put "$path_download/$file_tarball"

echo "$product updated!"
echo -e "please run \n$ $starter_command"
