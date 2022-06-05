#! /bin/bash

# this script is to install/update idea from tarball in ~/Downloads
# and create sym link so that user can start idea by typing command:
# idea.sh
# from anywhere

base_dir=$HOME/rmr_code_repo/rumaria-linux-script
path_linux_app=/mnt/d/linux
path_download=$HOME/Downloads

cd $path_download
file_tarball=$(ls idea*.tar.gz)

if [ -z "$file_tarball" ]; then
  echo "idea's tarball does not exist"
  download_url=$(grep -E "url.idea.dl" $base_dir/config | awk '{print $3}')
  echo "please download first, input url below"
  echo "(for reference purpose, pattern will be like $download_url)"
  read -p "input : " download_url
  wget "$download_url"
  if [ $? != 0 ]; then
    echo "trying to open the download page"
    echo "hopefully it will prompt the browser to download, but copy the url below because we want to download here instead for automation purpose of the next step"
    firefox $(grep -E "url.idea.page" $base_dir/config | awk '{print $3}')
    read -p "input : " download_url
    wget "$download_url"
  fi
  file_tarball=$(ls idea*.tar.gz)
  if [ -z "$file_tarball" ]; then
    echo "idea's tarball does not exist"
    exit 1
  fi
  # save new download url
  sed "s/url.idea.dl = .*/url.idea.dl = $download_url/" "$base_dir/config" >"$base_dir/config"
fi

# close running app
main_pid=$(ps -ef |
  grep --max-count=1 idea.*/jbr/bin/java |
  awk '{print $2}') # field 2 is pid
kill -9 $main_pid

cd $path_linux_app
cur_idea_dir=$(ls -d idea*)
echo "current idea dir : " $cur_idea_dir
# remove existing dir app if exist
if [ -n "$cur_idea_dir" ]; then
  rm -rf "$cur_idea_dir"
  while [ $? != 0 ]; do
    echo "trying to remove $cur_idea_dir again"
    rm -rf "$cur_idea_dir"
  done
  echo "successfully remove $cur_idea_dir"
fi

# extract tarball
tar xvf $path_download/$file_tarball

path_script=$(ls idea*/bin/idea.sh)

# create symbolic link
ln --force -s $path_linux_app/$path_script $base_dir/bin/idea.sh

trash-put $path_download/$file_tarball

echo "idea updated!"
echo -e "please run\n $ idea.sh"
