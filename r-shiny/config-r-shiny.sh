#!/bin/bash

CONFIG_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

systemctl stop shiny-server 

cp \
  /etc/shiny-server/shiny-server.conf \
  /etc/shiny-server/shiny-server.conf.bak

# this conf file changes the shiny port to port 80  
cp \
  "$CONFIG_UTILS_DIR/conf/shiny-server.conf" \
  /etc/shiny-server/shiny-server.conf


ufw allow 80


# To remove the default apps and automatically deploy your own apps
#   sudo rm -rf /srv/shiny-server/

# To deploy an app.. 
#   mkdir /srv/shiny-server/someapp
#   git clone https://www.github.com/someuser/someapp /srv/shiny-server/someapp


systemctl start shiny-server


