#!/bin/bash
### sudo fdisk -l

start_wireshark_dump() {
  # sudo dumpcap -D - for avaliable interfaces
  # https://www.wireshark.org/docs/wsug_html_chunked/AppToolsdumpcap.html
  sudo dumpcap -i 2 -w "$1/$2/ms_netcap.pcapng" -b filesize:30000 -b files:100
  # Ring buffer for files of 100 30mb files
}

create_directory_and_files() {
  mkdir -p "$1/$2"
  touch "$1/$2/$3"
}

init() {

  # Declarations
  DIRECORY_TO_MOUNT="/dev/sda7"
  MOUNT_TO="/media/Hosted"
  DUMP_DIRECTORY="wsharkcaptures"
  FILE_NAME="ms_wsharkpc.pcapng"

  if montpoint -q $DIRECORY_TO_MOUNT; then
    echo "Directory is already mounted!"
    create_directory_and_files $MOUNT_TO $DUMP_DIRECTORY $FILE_NAME
    start_wireshark_dump $MOUNT_TO $DUMP_DIRECTORY
  else
    sudo mount -t ntfs $DIRECORY_TO_MOUNT $MOUNT_TO
    create_directory_and_files $MOUNT_TO $DUMP_DIRECTORY $FILE_NAME
    start_wireshark_dump $MOUNT_TO $DUMP_DIRECTORY
  fi
}

init
exit 0
