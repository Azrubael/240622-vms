#!/bin/bash

apt-get update
apt-get install -y mc

# Update the hostname file
NEW_HOSTNAME="student"
sudo echo "$NEW_HOSTNAME" | sudo tee /etc/hostname > /dev/null

# Update the hosts file
sudo sed -i "s/127.0.0.1.*/127.0.0.1\t$NEW_HOSTNAME/" /etc/hosts

# Apply the new hostname
sudo hostnamectl set-hostname $NEW_HOSTNAME

# Restart the networking service
sudo systemctl restart systemd-networkd

