#!/bin/bash

date_time=$(date +%d_%m_%Y_%H_%M_%S)

start_zip() {
    zip --password $1 "$date_time.zip" $2
}

take_file_and_password() {
    echo "Enter Path: "
    read folder_or_file_path

    echo "Enter Password: "
    read password

    if [[$1 == "file"]]; then
        start_zip $password $folder_or_file_path
    else
        start_zip $password "$folder_or_file_path/*"
    fi

}

open_menu() {
    PS3='Please enter your choice: '
    options=("Single File" "All files in folder" "Quit")
    select opt in "${options[@]}"; do
        case $opt in
        "Single File")
            take_file_and_password "file"
            ;;
        "All files in folder")
            take_file_and_password "folder"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY" ;;
        esac
    done
}

# zip --password $password "$date_time.zip" $folder_path/*
open_menu
