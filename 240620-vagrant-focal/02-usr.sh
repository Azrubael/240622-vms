#!/bin/bash

# Create a new user 'student' with User ID 1040, Primary group 'student_group' (Group ID 1050), Home directory '/home/student_home', and Supplementary group 'cdrom'
sudo groupadd -g 1050 student_group
sudo useradd -u 1040 -g 1050 -G cdrom -d /home/student_home -m -s /bin/bash student

# Set the user 'student' password
sudo passwd student

echo ""
read -n 1 -s -r -p "Press a whitespace to start tests >>>"
echo ""
echo "Test 1:     id student"
id student

echo "Test 2:     getent passwd student | cut -d: -f6"
getent passwd student | cut -d: -f6

echo ""
echo "Test 3:     su student"
su student

echo ""
echo "Test 4:     whoami"
whoami

echo ""
echo 'Test 5:     echo $HOME'
echo $HOME
