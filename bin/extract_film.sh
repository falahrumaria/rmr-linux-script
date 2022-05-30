echo "start extract rar"
rar_files=
if cd ~/Downloads/Compressed/; then
  rar_files=($(ls *.rar))
fi

for rar_file in ${rar_files[@]}; do
  if unrar e $rar_file; then
    rm $rar_file
  fi
done

# -q: question
if [ "$1" = "-q" ]; then
  play_film.bash
fi
