#!/bin/bash


# get root location of sript
GIS_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

chmod -R +x $GIS_UTILS_DIR

##############################################################################
##### SET SCRIPT VARIABLES ###################################################
# Path to Unpack Source
SRCPATH=/usr/local/src
mkdir -- "$SRCPATH"
# Where to Build Software
BUILDPATH=/usr/local

# Number of jobs for compiling source
NJOBS=4

# Name of directory for logs, built on $HOME/$LOGPATH/file.log
LOGPATH="$GIS_UTILS_DIR/sh_logs"
mkdir -- "$LOGPATH"
##############################################################################
##############################################################################


### STEP 1: Cloud Configuration VM
source "$GIS_UTILS_DIR/init/init_docean.sh"


### STEP 2: Install or make software stack

# Install default binaries
#source "$GIS_UTILS_DIR/apt/apt-pg-11-postgis-3.sh"

# Build GEOS-PROJ-GDAL-POSTGIS binaries from Source
source "$GIS_UTILS_DIR/make/make-pg-11-postgis-3.sh"


### STEP 3: Config Software
source "$GIS_UTILS_DIR/config/config-pg-11-postgis-3.sh"


### STEP 4: (Optional) Create spatial database template
### USE "CREATE DATABASE my_db WITH TEMPLATE postgis_template;"
source "$GIS_UTILS_DIR/postgis/create_postgis_template.sh"


### STEP 5: (REQUIRED) modify your password for postgresql login like so
# sudo -u postgres createuser -s my_name_here --interactive






