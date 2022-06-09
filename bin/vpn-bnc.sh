#!/bin/bash

# bnc specific script

if [ -z $1 ]; then
	if nmcli --ask con down BNC; then
		exit
	fi
	nmcli --ask con down BNC_1
	nmcli --ask con up BNC
	exit
fi

if [ $1 = "1" ]; then
	if nmcli --ask con down BNC_1; then
		exit
	fi
	nmcli --ask con down BNC
	nmcli --ask con up BNC_1
	exit
fi

echo "wrong argument!"