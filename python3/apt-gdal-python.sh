#!/bin/bash

# Add ubuntu gis repo 
add-apt-repository ppa:ubuntugis/ppa
apt update
apt install -y python3.6-dev python3-pip gdal-bin libgdal-dev
pip3 install --upgrade pip

export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal

GDAL_VERSION="$(ogrinfo --version | grep -oP '(?<=GDAL.)([0-9]\.[0-9]\.[0-9])')"

pip3 install GDAL==$GDAL_VERSION
