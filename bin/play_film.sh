#! /bin/bash

clear
folder="/mnt/d/film/watchlist/"
films=

if cd "${folder}"; then
	films=($(ls *.m{kv,p4}))
else
	exit 1
fi

echo -e "input number of corresponding file to play \n"
echo -e "from ${folder} \n"

for ((i = 0; i < ${#films[@]}; i += 1)); do
	echo -e "\t($((i + 1))) ${films[i]}"
done
echo

bundles=$(ls | grep _rmrscript_)
for bundle in $bundles; do
	echo -e "from ${folder}${bundle}/ \n"
	old_size=${#films[*]}
	films+=($(ls ${bundle}/))
	for ((i = ${old_size}; i < ${#films[*]}; i += 1)); do
		echo -e "\t($((i + 1))) ${films[i]}"
		films[${i}]="${bundle}/${films[i]}"
	done
	echo
done

echo
number=
while read -p "input: "; do
	if [ ${REPLY} = h ]; then
		((number--))
		echo "number is $number"
	elif [ ${REPLY} = l ]; then
		((number++))
		echo "number is $number"
	else
		number=${REPLY}
	fi
	smplayer -close-at-end ${films[$((number - 1))]} &
	#  vlc ${films[$((number - 1))]} &
	echo "input h for play previous, l for play next, or number of corresponding file"
done
