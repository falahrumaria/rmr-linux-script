#! /bin/bash

# this script is to install/update idea from tarball in ~/Downloads
# and create sym link so that user can start idea by typing command:
# idea.sh
# from anywhere

path_linux_app=/mnt/d/linux
path_download=$HOME/Downloads

cd $path_download
file_tarball=$(ls idea*.tar.gz)

if [ -z "$file_tarball" ]; then
  echo "idea's tarball does not exist"
  exit 1
fi

# close running app
main_process=($(ps -ef | grep --max-count=1 idea.*/jbr/bin/java))
kill -9 ${main_process[1]} # index 1 is pid

cd $path_linux_app
cur_idea_dir=$(ls -d idea*)
echo "current idea dir : " $cur_idea_dir
# remove existing dir app if exist
if [ -n "$cur_idea_dir" ]; then
  rm -rf "$cur_idea_dir"
fi

# extract tarball
tar xvf $path_download/$file_tarball

path_script=$(ls idea*/bin/idea.sh)

# back to home
cd
# create symbolic link
ln --force -s $path_linux_app/$path_script bin/idea.sh

trash-put $file_tarball

echo "idea updated!"
echo -e "please run\n $ idea.sh"
