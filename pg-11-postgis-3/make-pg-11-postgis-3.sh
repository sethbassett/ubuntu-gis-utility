#!/bin/sh

#set -e

echo "START make-pg-11-postgis-3"


##############################################################################
##### SOFTWARE SOURCES #######################################################
##############################################################################

##### geos-3.8.1 ##########################
GEOSFILE=geos-3.8.1.tar.bz2
GEOSURL=http://download.osgeo.org/geos
###########################################

### PROJ4 v6.3.2  #########################
PROJFILE=proj-6.3.2.tar.gz
PROJURL=https://download.osgeo.org/proj
###########################################

#### GDAL 3.1.2 ###########################
GDALFILE=gdal-3.1.2.tar.gz
GDALURL=https://github.com/OSGeo/gdal/releases/download/v3.1.2
###########################################

#### POSTGIS ##############################
POSTFILE=postgis-3.0.1.tar.gz
POSTURL=https://download.osgeo.org/postgis/source
###########################################

##############################################################################
##############################################################################
##############################################################################


##############################################################################
##### CHECK ENVIORNMENT VARIABLES#############################################
##############################################################################

# get root location of this script
GIS_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# this checks to see if necessary environment variables have been set in the shell
# if not, then it sets them

[[ -z "$SRCPATH" ]] && \
  SRCPATH=/usr/local/scr || \
  echo "SRCPATH WAS ALREADY SET TO $SRCPATH"

mkdir -- "$SRCPATH"
chown $USER "$SRCPATH"
chmod u+rwx "$SRCPATH"

[[ -z "$BUILDPATH" ]] && \
  BUILDPATH=/usr/local || \
  echo "BUILDPATH WAS ALREADY SET TO $BUILDPATH"

LOGPATH="$GIS_UTILS_DIR/shlogs"
mkdir -- "$LOGPATH"

[[ -z "$NJOBS" ]] && \
  NJOBS=4 || \
  echo "JOBS IS SET TO $NJOBS"
##############################################################################
##############################################################################
##############################################################################


  
##############################################################################
##### SET ENVIRONMENT PATHS ##################################################
##############################################################################
echo 'export LD_LIBRARY_PATH=$BUILDPATH/lib:$LD_LIBRARY_PATH' >> ~/.bash_profile
echo 'export PATH=$BUILDPATH/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
##############################################################################
##############################################################################
##############################################################################


##############################################################################
#####  INSTALL DEPENDENCIES  #################################################
##############################################################################

apt update

apt install -y --fix-missing --no-install-recommends \
  software-properties-common build-essential ca-certificates \
  git make cmake wget unzip libtool automake \
  zlib1g-dev libsqlite3-dev pkg-config sqlite3 libcurl4-gnutls-dev \
  libtiff5-dev cmake checkinstall
  
# PROJ Dependencies
apt install -y --fix-missing --no-install-recommends \
  libsqlite3-0 libtiff5 libcurl4 \
  wget curl unzip ca-certificates
  
# GDAL Build Environment
apt install -y --fix-missing --no-install-recommends \
  libcharls-dev libopenjp2-7-dev libcairo2-dev \
  python3-dev python3-numpy \
  libpng-dev libjpeg-dev libgif-dev liblzma-dev libgeos-dev \
  curl libxml2-dev libexpat-dev libxerces-c-dev \
  libnetcdf-dev libpoppler-dev libpoppler-private-dev \
  libspatialite-dev swig libhdf4-alt-dev libhdf5-serial-dev \
  libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev \
  liblcms2-2 libpcre3-dev libcrypto++-dev libdap-dev libfyba-dev \
  libkml-dev libmysqlclient-dev libogdi-dev \
  libcfitsio-dev openjdk-8-jdk libzstd-dev \
  libpq-dev libssl-dev libboost-dev \
  autoconf automake bash-completion libarmadillo-dev \
  libopenexr-dev libheif-dev

# GDAL compile time dependencies
apt install -y \
  libcharls2 libopenjp2-7 libcairo2 python3-numpy \
  libpng16-16 libjpeg-turbo8 libgif7 liblzma5 libgeos-3.8.0 libgeos-c1v5 \
  libxml2 libexpat1 \
  libxerces-c3.2 libnetcdf-c++4 netcdf-bin libpoppler97 libspatialite7 gpsbabel \
  libhdf4-0-alt libhdf5-103 libhdf5-cpp-103 poppler-utils libfreexl1 unixodbc libwebp6 \
  libepsilon1 liblcms2-2 libpcre3 libcrypto++6 libdap25 libdapclient6v5 libfyba0 \
  libkmlbase1 libkmlconvenience1 libkmldom1 libkmlengine1 libkmlregionator1 libkmlxsd1 \
  libmysqlclient21 libogdi4.1 libcfitsio8 openjdk-8-jre \
  libzstd1 bash bash-completion libpq5 libssl1.1 \
  libarmadillo9 libpython3.8 libopenexr24 libheif1 \
  python-is-python3
  
# jason-c compile time dependencies
apt install -y libjson-c-dev

# POSTGIS compile time dependencies
apt install -y \
  xsltproc xmlto

##############################################################################
##############################################################################
##############################################################################


##############################################################################
#####  INSTALL POSTGRESQL ####################################################
##############################################################################
# ADD APT REPOSITORY
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bionic-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

apt update

# install postgresql and create superuser
# do NOT install proj, geos, gdal, or postgis
apt install -y postgresql-11 postgresql-server-dev-11 postgresql-client-11
apt install -y libpq-dev libxml2-dev libxml2-utils

# add user for digital ocean root
sudo -u postgres createuser -s root
##############################################################################
##############################################################################
##############################################################################


##############################################################################
#####  MAKE GEOS #############################################################
##############################################################################
echo "Making ${GEOSFILE%.tar.bz2} FROM $GEOSURL" 

cd -- "$SRCPATH"
wget "$GEOSURL/$GEOSFILE"
bzip2 -d geos-3.8.1.tar.bz2  
tar -xf "/$SRCPATH/${GEOSFILE%.bz2}"

cd -- "/$SRCPATH/${GEOSFILE%.tar.bz2}"

echo "Compiling ${GEOSFILE%.tar.bz2}"
./configure 
make -j $NJOBS > "$LOGPATH/geos.make.stdout" 2> "$LOGPATH/geos.make.stderr"
make check > "$LOGPATH/geos.check.stdout" 2> "$LOGPATH/geos.make.stderr"
make install > "$LOGPATH/geos.install.stdout" 2> "$LOGPATH/geos.install.stderr"
cd -- "$SRCPATH"
##############################################################################
##############################################################################
##############################################################################



##############################################################################
#####  MAKE PROJ  ############################################################
##############################################################################
echo "Making ${PROJFILE%.tar.gz} from $PROJURL" 

cd -- "$SRCPATH"

wget "$PROJURL/$PROJFILE"
tar -xzvf "/$SRCPATH/$PROJFILE"

export PROJ_NETWORK=ON

cd -- "/$SRCPATH/${PROJFILE%.tar.gz}"

./configure

make -j $NJOBS > "$LOGPATH/proj.make.stdout" 2> "$LOGPATH/proj.make.stderr"
make check > "$LOGPATH/proj.check.stdout" 2> "$LOGPATH/proj.check.stderr"
make install > "$LOGPATH/proj.install.stdout" 2> "$LOGPATH/proj.install.stderr"
##############################################################################
##############################################################################
##############################################################################

##############################################################################
#####  MAKE GDAL #############################################################

#####  DOCS  #################################################################
# http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#gdal
# above is slightly outdated but a good resource

# Main GDAL Documentation 
# https://gdal.org/gdal.pdf

# Main GDAL Page
# https://gdal.org/download.html

# BUILD HINTS
# https://trac.osgeo.org/gdal/wiki/BuildHints

# GDAL Docker Page
# https://github.com/OSGeo/gdal/tree/master/gdal/docker
##############################################################################
echo "Making ${GDALFILE%.tar.gz} from $GDALURL" 
cd -- "$SRCPATH"
wget "$GDALURL/$GDALFILE"
tar -xzvf "$SRCPATH/$GDALFILE"

cd -- "/$SRCPATH/${GDALFILE%.tar.gz}"
./configure 

make -j $NJOBS | tee "$LOGPATH/gdal.make.log"
make check | tee "$LOGPATH/gdal.check.log"
make install | tee "$LOGPATH/gdal.install.log"

echo 'export GDAL_DATA=$BUILDPATH/share/gdal' >> ~/.bash_profile
source ~/.bash_profile
##############################################################################
##############################################################################
##############################################################################



##############################################################################
#####  MAKE JSON-C  #########################################################
##############################################################################
echo "Making json-c from https://github.com/json-c/json-c.git" 
cd -- "/$SRCPATH"

git clone https://github.com/json-c/json-c.git

mkdir json-c-build
cd -- "json-c-build"

cmake ../json-c   # See CMake section below for custom arguments

make -j $NJOBS > "$LOGPATH/json-c.make.stdout" 2> "$LOGPATH/json-c.make.stderr"
make check > "$LOGPATH/json-c.check.stdout" 2> "$LOGPATH/json-c.check.stderr"
make install > "$LOGPATH/json-c.install.stdout" 2> "$LOGPATH/json-c.install.stderr"
##############################################################################
##############################################################################
##############################################################################



##############################################################################
#####  MAKE POSTGIS  #########################################################
##############################################################################
echo "Making ${POSTFILE%.tar.gz} from $POSTURL"

cd -- "/$SRCPATH"
wget "$POSTURL/$POSTFILE" -O "/$SRCPATH/$POSTFILE"
tar -xzvf "/$SRCPATH/$POSTFILE"

cd -- "/$SRCPATH/${POSTFILE%.tar.gz}"
LDFLAGS=-lstdc++ ./configure \
   --with-raster \
   --with-gdalconfig=/usr/local/bin/gdal-config

make -j $NJOBS > "$LOGPATH/postgis.make.stdout" 2> "$LOGPATH/postgis.make.stderr"
make check > "$LOGPATH/postgis.check.stdout" 2> "$LOGPATH/postgis.check.stderr"
make install > "$LOGPATH/postgis.install.stdout" 2> "$LOGPATH/postgis.install.stderr"
cd -- "$SRCPATH"

#OGR_FDW Support
apt install -y postgresql-11-ogr-fdw
##############################################################################
##############################################################################
##############################################################################



##############################################################################
#####  FINAL SQL TEST  #######################################################
##############################################################################
cd --"$HOME"

psql postgres -c "CREATE DATABASE test;" | tee "$LOGPATH/postgis.final.log"
psql postgres -c "ALTER DATABASE test SET postgis.gdal_datapath TO '/usr/local/share/gdal';"
psql postgres -c "ALTER DATABASE test SET postgis.gdal_enabled_drivers = 'ENABLE_ALL';"
psql postgres -c "ALTER DATABASE test SET postgis.enable_outdb_rasters TO True;"
psql test -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology; CREATE EXTENSION postgis_raster;" | tee -a "$LOGPATH/postgis.final.log"
psql test -c "SELECT Postgis_Full_Version();" | tee -a "$LOGPATH/postgis.final.log"
psql test -c "SELECT long_name, can_read, can_write FROM (SELECT (ST_GDALDrivers()).*) as foo ORDER BY long_name;" | tee "$LOGPATH/postgis.gdal_drivers.log"
psql postgres -c "DROP DATABASE test;" | tee -a "$LOGPATH/postgis.final.log"
##############################################################################
##############################################################################
##############################################################################

