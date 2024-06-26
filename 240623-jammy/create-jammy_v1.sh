#!/bin/bash

# Ensure that VirtualBox is installed
if ! command -v VBoxManage &> /dev/null
then
    echo "VirtualBox is not installed. Please install VirtualBox first."
    exit
fi


# Check if the *.vdi file already exists and remove it
if [ -f "$VM_FILE" ]; then
    rm "$VM_FILE"
fi


VM_NAME="jammy-lab1"
OS_TYPE="Ubuntu_64"
VM_ISO="/opt/ARCHIVES/Ubuntu/ubuntu-22.04.4-live-server-amd64.iso"
VM_HDD_SIZE=20000  # 20GB
VM_RAM=2500  # in MB
VM_VRAM=64  # in MB
VM_CPU=2
VM_FILE="$PWD/$VM_NAME.vdi"

VBoxManage createvm --name $VM_NAME --ostype $OS_TYPE --register
VBoxManage createhd --filename $VM_FILE --size $VM_HDD_SIZE --format VDI

VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM_FILE
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium $VM_ISO
VBoxManage modifyvm $VM_NAME --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Add memory and CPU
VBoxManage modifyvm "$VM_NAME" --memory $VM_RAM --cpus "$VM_CPU"

# Add network adapters
VBoxManage modifyvm "$VM_NAME" --nic1 nat
VBoxManage modifyvm "$VM_NAME" --nic2 hostonly --hostonlyadapter2 "vboxnet0"
VBoxManage modifyvm "$VM_NAME" --nicpromisc2 allow-all
# VBoxManage modifyvm "$VM_NAME" --nicproperty2 "ip=192.168.56.9"

# Disable audio and serial ports
VBoxManage modifyvm "$VM_NAME" --audio none
VBoxManage modifyvm "$VM_NAME" --uart1 off

# Enable USB2/USB3 controllers
VBoxManage modifyvm "$VM_NAME" --usbehci on
# VBoxManage modifyvm "$VM_NAME" --usbxhci on

# Configure display settings
VBoxManage modifyvm "$VM_NAME" --vram $VM_VRAM
VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga
# VBoxManage modifyvm "$VM_NAME" --monitorcount 1

# Start the VM
VBoxManage startvm "$VM_NAME" --type gui

# You can use a scale for example 0.8
# VBoxManage setextradata "$VM_NAME" GUI/ScaleFactor 1

# Bidirectional clipboard
# VBoxManage controlvm "$VM_NAME" clipboard mode bidirectional