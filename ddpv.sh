#!/bin/bash

###
# > Description:
# This script allows to easily run `dd` with `pv` pipe, resulting in a nice and accurate progress bar.
#
# I always use `dd` to write images to disks and I'm not satisfied by `status=progress` so I end up using `pv`
# Ocasionally I found myself puzzeled by what is the proper syntax for piping `dd .. | pv ..`
# So I finally decided to write a script for that!
#
# > License:	MIT License
# > Credit:		Max Grinberg (@codeswhite)
# > Date:		27.9.2021
##

# Parse arguments
if [[ "$#" -lt 2 ]]; then
	echo "[!] Expected file argument!"
	echo "[+] Usage: $(basename "$0") <image to write> <target block device> [blocksize]"
	exit 1
fi
_img_path=$1
_target_blk=$2

# Use default 10MB block size if no user input
_bs="10M"
if [ "$3" ]; then
	_bs=$3
	echo -e "\n[+] Using blocksize: $_bs\n"
fi

# Print source and target information
_fail=0

echo -e "\n[+] Image to write is:\n"
file "${_img_path}"

echo -e "\n[+] Target block device is:"
sudo fdisk -l "${_target_blk}" || _fail=1
file "${_target_blk}" | grep "block special" > /dev/null || _fail=1

# Are we good to go?
if (( "${_fail}" == 1 )); then
	echo "[!] Error: bad arguments!"
	exit 2
fi

echo -ne "\n[>>] Press [ENTER] to begin: "
read -r || exit 130

# Fun fact: `du -b` is x3.5 times faster than `wc -c`
_img_size=$(/usr/bin/du -b "${_img_path}")

echo -e "\n[+] Running..\n"
dd "if=$_img_path" "bs=$_bs" | pv --size "${_img_size}" | sudo dd iflag=fullblock "bs=$_bs" "of=$_target_blk" oflag=direct
