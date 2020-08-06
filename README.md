# ubuntu-gis-utility

A set of shell scripts for setting up and configuring FOSS-GIS in a cloud environment.  
  
These are the scripts I use to automate setting up a FOSS-GIS resource in the cloud. They also serve as my private library of well commented reference scripts that detail both the general process and the specific steps needed to set up each piece of software on Linux 18.04.  

By design, the networking security policy will be set to allow all incoming connections - see WARNING section below for more details.  


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


# Usage  
  
Create a fresh Digital Ocean droplet running Ubuntu 18.04 and preloaded with your ssh key. Then ssh into the VM shell:  
  
```  
git clone https://github.com/sethbassett/ubuntu-gis-utility

# Never do this unless a repo is trustworthy. Am I trustworthy?
chmod -R +x ubuntu-gis-utility/

# for build times use "time source ubuntu-gis-utils/apt-example.sh"
source ubuntu-gis-utility/apt-example.sh
```  

(Note this will set up a user named "gis" with the same ssh keys as root; you will be asked for a sudoer password when you log in as the user).

## Using apt-*.sh vs make-*.sh

Alternately, you can use ```source ubuntu-gis-utility/make-example.sh``` to compile GEOS, PROJ, GDAL, and PostGIS from source.  
  
Using apt fetches precompiled binaries for your ubuntu distribution. This has some advantages - it's relatively quick and relatively robust. The disadvantage is that the official precompiled binaries in the official repositories can be months or years behind the current versions of the software you wanted.  

Using make to compile a piece of software from source takes significantly longer and is more prone to breakage - but it has some definite advantages, particularly for PostGIS. By compiling PostGIS and its major dependencies (GEOS/PROJ/GDAL) yourself, PostGIS will be using GEOS 3.8.1, PROJ 6.3.2, and GDAL 3.1.2 for its backend libraries. This means that PostGIS will offer you more functionality and better optimization than the default binaries you get from apt.  

Note that if you compile GDAL and GEOS from source and plan on using R's *sf* package on the same machine, you'll need to compile R from source as well - otherwise *sf* won't recognize the update versions of GDAL and GEOS you have compiled.

# WARNING!

The config script for PostgreSQL/PostGIS alters the pg_hba.conf file to accept all incoming connections, modifies the postgresql.conf file to listen for all incoming connections, and uses UFW to open port 5432 to all connections.  

The Shiny-Server config-r-shiny.sh script alters the Shiny-Server.conf file to change to Shiny-Server port to the standard HTTP port (port 80) and uses UFW to open port 80 to all connections.  

**BY DESIGN THIS WILL LEAVE YOUR NEW VM WITH NO NETWORKING SECURITY POLICY AT THE SYSTEMS LEVEL**  
  
This works well with AWS and Azure, where your network security policy will be handled via AWS' Virtual Private Cloud (VPC) or Azure's Azure Private Cloud (APC) network security toolsets.  
 
If you are deploying to Digital Ocean, however, this is problematic. Digital Ocean expects you to handle your network security at the systems level and only allows gives you the ability to limit connections to your machine to IP addresses within the same Digital Ocean data center.  

If you are deploying on digital ocean, you should modify the ```ufw allow (PORT)``` commands in the relevant config-*.sh scripts to read something like ```ufw allow (PORT) from xx.xx.xx.xx```, where xx.xx.xx.xx is the IP address or block you want to whitelist to connect to your VM. 
 
# Customization  

Customization is fairly straight forward. Pick and choose your scripts as needed and wrap them in your own bash script. The process chain is always the same:  
  1. source the init-*.sh for your cloud provider  
  2. source **one of** make-*.sh or apt-*.sh (but not both) for the software you want  
  3. (optional) source config-*.sh for the software if you want to alter the default configuration  
  4. (optional) source any additional utility scripts  
  
If you want to intall R 4.x and Shiny-Server but leave Shiny-Server in its default configuration, you would save the following as myscript.sh:  
```  
#!/bin/bash

# get location of script
GIS_UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

### STEP 1: Cloud Configuration VM
source "$GIS_UTILS_DIR/init/init_docean.sh"

### STEP 2: Use apt-*.sh for precompiled binaries
source "$GIS_UTILS_DIR/r-shiny/apt-r-shiny.sh"

# leave off invoking r-shiny/config-r-shiny.sh, open the default shiny port with ufw
ufw allow 3838
```

Then ```chmod +x myscript.sh`` and ```source myscript.sh``` and you're off to the races. 

  

