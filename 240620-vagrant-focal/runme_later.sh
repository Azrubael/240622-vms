#!/bin/bash

VBoxManage startvm test-bootcamp-linux-vm --type headless
sleep 15
vagrant ssh