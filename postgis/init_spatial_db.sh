#!/bin/bash

##### Defaults ###############################################
DATABASE=postgis_template
TOPOLOGY=1
RASTERS=1
ADDITIONS=1
OGRFDW=1
TIGER=1
ADDSTD=1
##############################################################

##### Args ###################################################
while getopts dtrao option
do
  case "${option}"
  in
    d) DATABASE=${OPTARG};;
    t) TOPOLOGY=0;;
    r) RASTERS=0;;
    a) ADDITIONS=0;;
    o) OGRFDW=0;;
    g) TIGER=0;;
    z) ADDSTD=0;;
esac
done
##############################################################	


##### Main Code ##############################################
psql postgres -c "CREATE DATABASE $DATABASE;" 

psql -d $DATABASE -c "CREATE EXTENSION postgis;"

if [ $TOPOLOGY = 1 ]; then 
  psql -d $DATABASE -c "CREATE EXTENSION postgis_topology;"
fi 

if [ $RASTERS = 1 ]; then 
  psql -d $DATABASE -c "CREATE EXTENSION postgis_raster;"
fi 

if [ $ADDITIONS = 1 ]; then 
  #git clone https://github.com/pedrogit/postgisaddons
  wget  https://raw.githubusercontent.com/pedrogit/postgisaddons/master/postgis_addons.sql
  psql -d $DATABASE -f postgis_addons.sql
  rm postgis_addons.sql
fi 

if [ $OGRFDW = 1 ]; then 
  psql -d $DATABASE -c "CREATE EXTENSION ogr_fdw;"
fi 
##############################################################

if [ $TIGER = 1 ]; then
  psql -d $DATABASE -c "CREATE EXTENSION fuzzystrmatch"
  psql -d $DATABASE -c "CREATE EXTENSION postgis_tiger_geocoder;"
fi

if [ $ADDSTD = 1 ]; then
  psql -d $DATABASE -c "CREATE EXTENSION address_standardizer;"
fi
