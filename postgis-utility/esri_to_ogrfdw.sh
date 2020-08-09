#!/bin/bash

#https://idpgis.ncep.noaa.gov/arcgis/rest/services/NWS_Forecasts_Guidance_Warnings/NHC_Atl_trop_cyclones/MapServer/1/query?where=obj$

OPTIND=1

SOURCE=
SCHEMA=
TABLE=

while getopts "s:n:t:" flag
do
    case "$flag" in
        s) SOURCE=$OPTARG;;
        n) SCHEMA=$OPTARG;;
        t) TABLE=$OPTARG;;
    esac
done
shift "$((OPTIND-1))"

FDW=`ogr_fdw_info -s "$SOURCE" -l "OGRGeoJSON"`
SERVER=`echo ${SCHEMA}_${TABLE}_server`
SQL=`echo $FDW | \
  sed "s/myserver/$SERVER/g" | \
  sed "s/ogrgeojson/$SCHEMA.$TABLE/g" | \
  sed "s/varchar([0-9]*)/varchar/g"`

echo $SQL

