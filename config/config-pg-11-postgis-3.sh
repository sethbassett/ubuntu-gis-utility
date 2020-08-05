#!/bin/bash

CONFIG_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

systemctl stop postgresql

# backup existing configuration files
cp \
  /etc/postgresql/11/main/postgresql.conf \
  /etc/postgresql/11/main/postgresql.conf.bak

cp \
  /etc/postgresql/11/main/pg_hba.conf \
  /etc/postgresql/11/main/pg_hba.conf.bak

cp \
  /etc/postgresql/11/main/environment \
  /etc/postgresql/11/main/environment.bak

# overwrite with files from ubuntu-gis-utils/config/conf

cp \
  "$CONFIG_UTILS_DIR/conf/pg_environment" \
  /etc/postgresql/11/main/environment

cp \
  "$CONFIG_UTILS_DIR/conf/pg_hba.conf" \
  /etc/postgresql/11/main/pg_hba.conf

cp \
  "$CONFIG_UTILS_DIR/conf/postgresql.conf" \
  /etc/postgresql/11/main/postgresql.conf
  
# UFW allow postgres traffic
ufw allow 5432

# syntax to allow postgres traffic only from a range of ip
# ufw allow 5432 from xx.xx.xx.0/24

systemctl start postgresql

