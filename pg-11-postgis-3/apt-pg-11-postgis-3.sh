#!/bin/bash
##############################################################################
#####  INSTALL POSTGRESQL ####################################################
##############################################################################
# https://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS24UbuntuPGSQL10Apt

# ADD APT REPOSITORY
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


sudo -u postgres createuser --superuser root
##############################################################################
##############################################################################
##############################################################################
