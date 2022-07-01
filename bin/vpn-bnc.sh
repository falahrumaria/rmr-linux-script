#!/bin/bash

# bnc specific script

if ! test "$1"; then
	if nmcli --ask con down BNC; then
		exit
	fi
	nmcli --ask con down BNC_1
	sleep 1
	nmcli --ask con up BNC
	exit
fi

if test "$1" = "1"; then
	if nmcli --ask con down BNC_1; then
		exit
	fi
	nmcli --ask con down BNC
	sleep 1
	nmcli --ask con up BNC_1
	exit
fi

echo "wrong argument!"