#!/bin/bash

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bionic-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -


sudo apt install -y postgresql-11 
sudo apt install -y postgresql-11 postgresql-server-dev-11 postgresql-client-11
sudo apt install -y postgresql-11-postgis-3 postgresql-11-postgis-3-scripts postgis

sudo -u postgres createuser --superuser root

sudo apt install -y postgresql-11-ogr-fdw
