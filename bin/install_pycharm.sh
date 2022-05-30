#! /bin/bash

# this script is to install/update pycharm from tarball in ~/Downloads
# and create sym link so that user can start pycharm by typing command:
# pycharm.sh
# from anywhere

path_linux_app=/mnt/d/linux
path_download=$HOME/Downloads

cd $path_download
file_tarball=$(ls pycharm*.tar.gz)

if [ -z "$file_tarball" ]; then
  echo "pycharm's tarball does not exist"
  exit 1
fi

# close running app
main_process=($(ps -ef | grep --max-count=1 pycharm.*/jbr/bin/java))
kill -9 ${main_process[1]} # index 1 is pid

cd $path_linux_app
cur_pycharm_dir=$(ls -d pycharm*)
echo "current pycharm dir : " $cur_pycharm_dir
# remove existing dir app if exist
if [ -n "$cur_pycharm_dir" ]; then
  rm -rf "$cur_pycharm_dir"
fi

# extract tarball
tar xvf $path_download/$file_tarball

path_script=$(ls pycharm*/bin/pycharm.sh)

# back to home
cd
# create symbolic link
ln --force -s $path_linux_app/$path_script bin/pycharm.sh

trash-put $file_tarball

echo "pycharm updated!"
echo -e "please run\n $ pycharm.sh"
