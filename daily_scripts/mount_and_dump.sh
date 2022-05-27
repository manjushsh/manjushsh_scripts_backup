#!/bin/bash
### sudo fdisk -l

DIRECORY_TO_MOUNT="/dev/sda7"
DUMP_DIRECTORY="wirelogs"
MOUNT_TO="/media/Hosted"

start_wireshark_dump(){
  # sudo dumpcap -D - for avaliable interfaces
  sudo dumpcap -i 2 -w "$1/$2/ms_netcap.pcapng" -b filesize:30000 -b files:100
  # Ring buffer for 100 files of 30mb each
}

if mountpoint -q $DIRECORY_TO_MOUNT; then
  echo "Directory is already mounted!"
  start_wireshark_dump $MOUNT_TO $DUMP_DIRECTORY
else
  sudo mount -t ntfs $DIRECORY_TO_MOUNT $MOUNT_TO
  start_wireshark_dump $MOUNT_TO $DUMP_DIRECTORY
fi

exit 0
