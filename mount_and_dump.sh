#!/bin/bash
### sudo fdisk -l

start_wireshark_dump() {
  # https://www.wireshark.org/docs/wsug_html_chunked/AppToolsdumpcap.html
  interfaces=$(sudo dumpcap -D)   # sudo dumpcap -D - for avaliable interfaces
  echo "Avilable interfaces: $interfaces"
  echo "Enter your choice: "
  read interface_choice
  sudo dumpcap -i $interface_choice -w "$1/$2/$3" -b filesize:30000 -b files:100    # Ring buffer for 100 files of 30mb each
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
    start_wireshark_dump $MOUNT_TO $DUMP_DIRECTORY $FILE_NAME
  else
    sudo mount -t ntfs $DIRECORY_TO_MOUNT $MOUNT_TO
    create_directory_and_files $MOUNT_TO $DUMP_DIRECTORY $FILE_NAME
    start_wireshark_dump $MOUNT_TO $DUMP_DIRECTORY $FILE_NAME
  fi
}

init
exit 0
