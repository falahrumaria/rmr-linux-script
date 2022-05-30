#! /bin/bash

# this script is to install/update dbeaver from tarball in ~/Downloads
# and create sym link so that user can start dbeaver by typing command:
# dbeaver
# from anywhere

path_linux_app=/mnt/d/linux
path_download=$HOME/Downloads

cd $path_download
file_tarball=$(ls dbeaver*.tar.gz)

if [ -z "$file_tarball" ]; then
  echo "dbeaver's tarball does not exist"
  exit 1
fi

# close running app
main_process=($(ps -ef | grep --max-count=1 dbeaver/jre/bin/java))
kill -9 ${main_process[1]} # index 1 is pid

cd $path_linux_app
cur_dbeaver_dir=$(ls -d dbeaver*)
echo "current dbeaver dir : " $cur_dbeaver_dir
# remove existing dir app if exist
if [ -n "$cur_dbeaver_dir" ]; then
  rm -rf "$cur_dbeaver_dir"
fi

# extract tarball
tar xvf $path_download/$file_tarball

path_script=$(ls dbeaver*/dbeaver)

# back to home
cd
# create symbolic link
ln --force -s $path_linux_app/$path_script bin/dbeaver

trash-put $file_tarball

echo "dbeaver updated!"
echo -e "please run\n $ dbeaver"
