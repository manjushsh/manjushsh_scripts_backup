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
    if grep -Fxq "$config" /etc/ssh/sshd_config; then
        echo "Config is already added."
    else
        echo config | sudo tee -a /etc/ssh/sshd_config
    fi
    sudo systemctl restart ssh
    create_sftp_user
}

create_sftp_user() {
    sudo addgroup sftp
    echo "Enter Username you want for SFTP user: "
    read username
    sudo useradd -m $username -g sftp
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
