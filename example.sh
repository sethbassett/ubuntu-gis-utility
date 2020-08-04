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

source "$GIS_UTILS_DIR/init/init_docean.sh"

# Build GEOS-PROJ-GDAL-POSTGIS from Source
source "$GIS_UTILS_DIR/make/make-pg-11-postgis-3.sh"

# Install default packages
# source "$GIS_UTILS_DIR/apt/apt-pg-11-postgis-3.sh"



