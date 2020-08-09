#!/bin/bash


# get root location of sript
GIS_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

##############################################################################
##### SET SCRIPT VARIABLES ###################################################

# These are only necessary for making software, not for downloading from apt

# Path to Unpack Source
SRCPATH=/usr/local/src
mkdir -- "$SRCPATH"
# Where to Build Software
BUILDPATH=/usr/local

# Number of jobs for compiling source
NJOBS=4

# Name of directory for logs, built on $HOME/$LOGPATH/file.log
LOGPATH="$GIS_UTILS_DIR/shlogs"
mkdir -- "$LOGPATH"
##############################################################################
##############################################################################


### STEP 1: Cloud Configuration VM
source "$GIS_UTILS_DIR/init/init_docean.sh"

### STEP 2: Install or make software stack
### You should use ONE OF make-* or apt-* for the software stack

# Build GEOS-PROJ-GDAL-POSTGIS binaries from Source
source "$GIS_UTILS_DIR/pg-11-postgis-3/make-pg-11-postgis-3.sh"


### STEP 3: Config Software
source "$GIS_UTILS_DIR/pg-11-postgis-3/config-pg-11-postgis-3.sh"

### STEP 4: (Optional) Create spatial database template with postgis-utils script
### USE "CREATE DATABASE my_db WITH TEMPLATE postgis_template;"
source "$GIS_UTILS_DIR/postgis-utility/create_postgis_template.sh"


### STEP 5: (REQUIRED) add a user with remote login rights like so
echo "Before you go don't forget to add a superuser account with login rights on the postgres server!"
echo "Example:"
echo "  sudo -u postgres createuser -s -P my_name_here"

### Additional software installations

# These follow the same apt/make --> config process
# R compiles all its packages at install time
# Compiling R and then having R compile its internal packages can take a while
source "$GIS_UTILS_DIR/r-shiny/make-r-shiny.sh"
source "$GIS_UTILS_DIR/r-shiny/config-r-shiny.sh"

# install your favorite R packages
source "$GIS_UTILS_DIR/r-shiny/config-r-packages.sh"







