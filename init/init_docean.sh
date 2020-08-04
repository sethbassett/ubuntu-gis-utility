#!/bin/sh

##############################################################################
##### update/upgrade os after first boot #####################################
sudo apt update -y 

##### Below Prevents issue with GRUB prompt when running this script ###########
# Digital Ocean | Ubuntu 18.04.4 LTS
# https://www.digitalocean.com/community/questions/ubuntu-new-boot-grub-menu-lst-after-apt-get-upgrade?answer=45153

sudo rm /boot/grub/menu.lst
sudo update-grub-legacy-ec2 -y
sudo apt upgrade -y
##############################################################################
##############################################################################

