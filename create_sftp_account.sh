#!/bin/bash

install_dependenies() {
    sudo apt install ssh
}

config_ssh() {
    config = '# Config for SFTP Server
Match group sftp
ChrootDirectory /home
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp'
    if grep -Fxq "$config" /Desktop/test; then
        echo "Config is already added."
    else
        echo config | sudo tee -a /Desktop/test
    fi
    sudo systemctl restart ssh
    create_sftp_user
}

create_sftp_user() {
    sudo addgroup sftp
    echo "Enter Username you want for sftp user: "
    read username
    echo "Enter Password for $username: "
    read password
    # sudo useradd -m "$username" -g sftp
    config_ssh
}

init() {
    config_ssh
}

init
exit 0
