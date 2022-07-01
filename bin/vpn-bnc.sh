#!/bin/bash

# bnc specific script

if ! test "$1"; then
    ! nmcli --ask con down BNC 2> /dev/null || exit
    ! nmcli --ask con down BNC_1 2> /dev/null || sleep 1
    nmcli --ask con up BNC
    exit
fi

! nmcli --ask con down BNC_1 2> /dev/null || exit
! nmcli --ask con down BNC 2> /dev/null || sleep 1
nmcli --ask con up BNC_1
exit

echo "wrong argument!"
