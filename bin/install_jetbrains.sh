#! /bin/bash

# this script is to install/update jetbrains product from tarball in ~/Downloads
# and create sym link so that user can start it from anywhere:
# listed product: intellij idea, pycharm

base_dir=$HOME/rmr_code_repo/rmr-linux-script
path_linux_app=/mnt/d/linux
path_download=$HOME/Downloads

product=$1
if [ -z $product ]; then
    echo "choose product:"
    echo "1. idea"
    echo "2. pycharm"
    read -p "input number : " product
    case $product in
        "1")
            product="idea"
            ;;
        "2")
            product="pycharm"
            ;;
    esac
fi

case $product in
    "idea" | "pycharm") ;;
    *)
        echo "wrong input!"
        exit
        ;;
esac

get_dl_url() {
    awk "\$1 ~ /url\.$1\.dl/ { print \$3 }" $base_dir/config
}

get_page_url() {
    awk "\$1 ~ /url\.$1\.page/ { print \$3 }" $base_dir/config
}

cd $path_download
file_tarball=$(ls $product*.tar.gz)

if [ -z "$file_tarball" ]; then
    echo "$product's tarball does not exist"
    download_url=$(get_dl_url $product)
    echo "please download first, input url below"
    echo "(for reference, sample url: $download_url)"
    read -p "input : " download_url
    if ! wget "$download_url"; then
        echo "trying to open the download page, hopefully it will prompt the browser to download"
        echo "but copy the url below because we want to download here instead for automation purpose of the next step"
        firefox $(get_page_url $product)
        read -p "input : " download_url
        wget "$download_url"
    fi
    file_tarball=$(ls $product*.tar.gz)
    if [ -z "$file_tarball" ]; then
        echo "$product's tarball does not exist"
        exit 1
    fi
    # save new download url
    sed "s|url.$product.dl = .*|url.$product.dl = $download_url|" "$base_dir/config" > "$base_dir/config1"
    mv "$base_dir/config1" "$base_dir/config"
fi

# close running app
main_pid=$(ps -ef \
    | grep --max-count=1 $product.*/jbr/bin/java \
    | awk '{print $2}') # field 2 is pid
kill -9 $main_pid

cd $path_linux_app
cur_product_dir=$(ls -d $product*)
echo "current $product dir : " $cur_product_dir
# remove existing dir app if exist
if [ -n "$cur_product_dir" ]; then
    trash-put "$cur_product_dir"
    echo "move $cur_product_dir to trash"
fi

# extract tarball
tar xvf $path_download/$file_tarball

path_script=$(ls $product*/bin/$product.sh)

# create symbolic link
ln --force -s $path_linux_app/$path_script $base_dir/bin/$product.sh

trash-put $path_download/$file_tarball

echo "$product updated!"
echo -e "please run \n$ $product.sh"
