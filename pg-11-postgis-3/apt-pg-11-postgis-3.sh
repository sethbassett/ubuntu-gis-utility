#!/bin/bash
##############################################################################
#####  INSTALL POSTGRESQL ####################################################
##############################################################################
# https://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS24UbuntuPGSQL10Apt

# ADD PostgreSQL APT REPOSITORY
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bionic-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

apt update

# install postgresql and create superuser
# do NOT install proj, geos, gdal, or postgis
# postgres
apt install -y \
  postgresql-11 \
  postgresql-server-dev-11 \
  postgresql-client-11

apt install -y \
  postgresql-11-postgis-3 \
  postgresql-11-postgis-3-scripts \
  postgresql-11-pgrouting
apt install -y \
 postgresql-11-ogr-fdw

echo 'export PATH=/usr/lib/postgresql/11/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile

sudo -u postgres createuser --superuser root
##############################################################################
##############################################################################
##############################################################################

##############################################################################
#####  INSTALL GDAL PYTHON BINDINGS###########################################
##############################################################################
apt install -y gdal-bin libgdal-dev python3.6-dev python3-pip
python3 -m pip install --upgrade pip


export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
GDAL_VERSION="$(ogrinfo --version | grep -oP '(?<=GDAL.)([0-9]\.[0-9]\.[0-9])')"

pip3 install GDAL==$GDAL_VERSION

##############################################################################
##############################################################################
##############################################################################

##############################################################################
#####  INSTALL psycopg2  #####################################################
##############################################################################
python3 -m pip install psycopg2


apt install -y postgresql-plpython3-11

