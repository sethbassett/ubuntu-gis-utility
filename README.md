# ubuntu-gis-utility

A set of shell scripts for setting up and configuring FOSS-GIS in a cloud environment.  
  
These are the scripts I use when I want to automate setting up a resource for a personal project. They aren't intended to be (and I doubt they will every be) production ready software. Feel free to beg, borrow, and steal from my examples, but use at your own risk.  
 


# Usage  
  
Create a fresh Digital Ocean droplet running Ubuntu 18.04 and ssh into the shell:  
  
```  
git clone https://github.com/sethbassett/ubuntu-gis-utility

# Never do this unless the repo is trustworthy. Am I trustworthy?
chmod -R +x ubuntu-gis-utility/

# for build time: time source ubuntu-gis-utils/example.sh
source ubuntu-gis-utility/example.sh
```  

Build time of example.sh on 2020-08-05 was 94m46.688s on a 4 core droplet.

# WARNING!

The config script for PostgreSQL/PostGIS alters the pg_hba.conf file to accept all incoming connections, modifies the postgresql.conf file to listen for all incoming connections, and uses UFW to open port 5432 to all connections. The Shiny-Server config-r-shiny.sh script alters the Shiny-Server.conf file to change to Shiny-Server port to the standard HTTP port (port 80) and uses UFW to open port 80 to all connections. 

**THIS LEAVES YOUR VM WITH NO NETWORKING SECURITY POLICY AND IT IS BY DESIGN** This policy works well with AWS and Azure, where your network security will be handled at a higher level via the VPC (AWS) or APC (Azure) tools.  
 
It works less well on Digital Ocean, who only gives you the option to limit networking to machines within their data center; Digital Ocean expects you to handle your network security at the systems level. If you are deploying on digital ocean, you should modify the ```ufw allow (PORT)``` commands in the relevant config-*.sh scripts to read something like ```ufw allow (PORT) from xx.xx.xx.xx```, where xx.xx.xx.xx is the IP address or address range you want to allow to connect to your VM. 
 
# Contents  
```  
ubuntu-gis-utility/  
  | example.sh         : example meta script  
  | init/              : configure VM for cloud environment
  | pg-11-postgis-3/   : PostgreSQL 11, postgis 3
    | conf/            : PostgreSQL configuration templates
  | r-shiny/           : R and Shiny-Server
    | conf/            : Postgis configuration templates
  | postgis-utility/   : PostGIS post install utilities
```  
  
# Customization  

Customization is fairly straight forward. Pick and choose your scripts as needed and wrap them in your own bash script. The process chain for each piece of software is always the same:  
  1. source the init-*.sh for your cloud provider  
  2. source one of make-*.sh or apt-*.sh (but not both) for the software you want  
  3. source config-*.sh for the software you want  
  4. source any optional scripts you want  
  
So to configure a machine with PostgreSQL 11 and PostGIS 3 from the pre-compiled binaries in the PostgreSQL repository, you would create a bash script like this: 

```
#!/bin/bash

# get location of script
GIS_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

### STEP 1: Cloud Configuration VM
source "$GIS_UTILS_DIR/init/init_docean.sh"

### STEP 2: Use apt-*.sh for precompiled binaries
source "$GIS_UTILS_DIR/pg-11-postgis-3/apt-pg-11-postgis-3.sh"

### STEP 3: Config Software
source "$GIS_UTILS_DIR/pg-11-postgis-3/config-pg-11-postgis-3.sh"

```




  

