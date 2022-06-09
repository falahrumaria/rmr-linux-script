#!/bin/bash

nmcli --ask con down BNC
if [ $? != 0 ]; then
	nmcli --ask con down BNC_1
fi
if [ $? == 0 ]; then
    exit
fi

nmcli --ask con up BNC
