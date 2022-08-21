#!/bin/bash

SFTP_USER_GROUP="sftp"
SSH_CONFIG="# Config for SFTP Server
Match group $SFTP_USER_GROUP
ChrootDirectory /home
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp"

install_dependenies() {
    sudo apt install ssh
}

config_ssh() {
    if grep -Fxq "$SSH_CONFIG" /etc/ssh/sshd_config; then
        echo "Config is already added."
    else
        echo "$SSH_CONFIG" | sudo tee -a /etc/ssh/sshd_config
        sudo systemctl restart ssh
    fi
    create_sftp_user
}

create_sftp_user() {
    sudo addgroup $SFTP_USER_GROUP
    echo "Enter Username you want for SFTP user (Without space and special characters): "
    read username
    sudo useradd -m $username -g $SFTP_USER_GROUP
    echo "Set Password for $username: "
    sudo passwd "$username"
    sudo chmod 700 /home/$username/
    sftp $username@127.0.0.1
}

init() {
    install_dependenies
    config_ssh
}

init
exit 0
