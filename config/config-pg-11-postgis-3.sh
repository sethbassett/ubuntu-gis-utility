#!/bin/bash


systemctl stop postgresql

cp \
  /etc/postgresql/11/main/postgresql.conf \
  /etc/postgresql/11/main/postgresql.conf.bak

cp \
  /etc/postgresql/11/main/pg_hba.conf \
  /etc/postgresql/11/main/pg_hba.conf.bak

cp \
  /etc/postgresql/11/main/environment \
  /etc/postgresql/11/main/environment.bak

cp \
  ~/ubuntu-gis-utility/config/conf/pg_environment \
  /etc/postgresql/11/main/environment

cp \
  ~/ubuntu-gis-utility/config/conf/pg_hba.conf \
  /etc/postgresql/11/main/pg_hba.conf

cp \
  ~/ubuntu-gis-utility/config/conf/postgresql.conf \
  /etc/postgresql/11/main/postgresql.conf
  
#ufw allow 5432

systemctl start postgresql

