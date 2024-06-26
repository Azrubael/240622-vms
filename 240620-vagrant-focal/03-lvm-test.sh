#!/bin/bash

# Create a physical volume on the available disk "vm-test-lvm"
sudo pvcreate /dev/sdc

# Create a volume group 'student'
sudo vgcreate student /dev/sdc

# Create a logical volume 'student' with size of about 50% of free space and with a file system ext4
sudo lvcreate -n student -l 50%FREE student
sudo mkfs.ext4 /dev/student/student

# Mount the logical volume 'student' to /lvm/student using UUID
sudo mkdir -p /lvm/student
sudo mount UUID="$(sudo blkid -s UUID -o value /dev/student/student)" /lvm/student

# Make the mount permanent by adding an entry to /etc/fstab
echo "UUID=$(sudo blkid -s UUID -o value /dev/student/student) /lvm/student ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Check the results
lsblk | grep student-student
echo ""
read -n 1 -s -r -p "Press a whitespace to start tests >>>"
echo ""
lvdisplay