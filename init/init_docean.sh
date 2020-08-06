#!/bin/sh
# modified from 
# https://www.digitalocean.com/community/tutorials/automating-initial-server-setup-with-ubuntu-18-04


########################
### SCRIPT VARIABLES ###
########################

# Name of the user to create and grant sudo privileges
USERNAME=gis

# Whether to copy over the root user's `authorized_keys` file to the new sudo
# user.
COPY_AUTHORIZED_KEYS_FROM_ROOT=true

# Additional public keys to add to the new sudo user
# OTHER_PUBLIC_KEYS_TO_ADD=(
#     "ssh-rsa AAAAB..."
#     "ssh-rsa AAAAB..."
# )
OTHER_PUBLIC_KEYS_TO_ADD=(
)

# directoy of where this script ran from
INIT_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# where to write logs to
LOGPATH="$INIT_UTILS_DIR/shlogs"
mkdir -- "$LOGPATH"


##############################################################################
##### update/upgrade os after first boot #####################################
##############################################################################
echo "Performing intial update of OS"
apt update -y > /dev/null 2>&1

##### Below Prevents issue with GRUB prompt when running this script ###########
# Digital Ocean | Ubuntu 18.04.4 LTS
# https://www.digitalocean.com/community/questions/ubuntu-new-boot-grub-menu-lst-after-apt-get-upgrade?answer=45153

rm /boot/grub/menu.lst
sudo update-grub-legacy-ec2 -y > /dev/null 2>&1
apt upgrade -y > "$LOGPATH/apt.log" 2>&1
##############################################################################
##############################################################################


##############################################################################
##### create sudoer user #####################################################
##############################################################################
echo "Creating sudoer user $USERNAME"

# Add sudo user and grant privileges
useradd --create-home --shell "/bin/bash" --groups sudo "${USERNAME}"

# Check whether the root account has a real password set
encrypted_root_pw="$(grep root /etc/shadow | cut --delimiter=: --fields=2)"

if [ "${encrypted_root_pw}" != "*" ]; then
    # Transfer auto-generated root password to user if present
    # and lock the root account to password-based access
    echo "${USERNAME}:${encrypted_root_pw}" | chpasswd --encrypted
    passwd --lock root
else
    # Delete invalid password for user if using keys so that a new password
    # can be set without providing a previous value
    passwd --delete "${USERNAME}"
fi

# Expire the sudo user's password immediately to force a change
chage --lastday 0 "${USERNAME}"

# Create SSH directory for sudo user
home_directory="$(eval echo ~${USERNAME})"
mkdir --parents "${home_directory}/.ssh"

# Copy `authorized_keys` file from root if requested
if [ "${COPY_AUTHORIZED_KEYS_FROM_ROOT}" = true ]; then
    cp /root/.ssh/authorized_keys "${home_directory}/.ssh"
fi

# Add additional provided public keys
for pub_key in "${OTHER_PUBLIC_KEYS_TO_ADD[@]}"; do
    echo "${pub_key}" >> "${home_directory}/.ssh/authorized_keys"
done

# Adjust SSH configuration ownership and permissions
chmod 0700 "${home_directory}/.ssh"
chmod 0600 "${home_directory}/.ssh/authorized_keys"
chown --recursive "${USERNAME}":"${USERNAME}" "${home_directory}/.ssh"

# Disable root SSH login with password
sed --in-place 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
if sshd -t -q; then
    systemctl restart sshd
fi
##############################################################################
##############################################################################
##############################################################################

##############################################################################
##### UFW Policy  ###########################################################
##############################################################################
# Add exception for SSH AND RYSNC enable UFW firewall
ufw allow ssh
ufw allow 873
# alternate form: 
# ufw allow from 15.15.15.0/24 to any port 873
ufw --force enable
##############################################################################
##############################################################################
##############################################################################





