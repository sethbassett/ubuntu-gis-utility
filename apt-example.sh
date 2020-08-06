#!/bin/bash

# get location of script
GIS_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

### STEP 1: Cloud Configuration VM
source "$GIS_UTILS_DIR/init/init_docean.sh"

### STEP 2: Use apt-*.sh for precompiled binaries
source "$GIS_UTILS_DIR/pg-11-postgis-3/apt-pg-11-postgis-3.sh"

### STEP 3: Config Software
source "$GIS_UTILS_DIR/pg-11-postgis-3/config-pg-11-postgis-3.sh"







