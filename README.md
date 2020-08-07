# ubuntu-gis-utility

A set of shell scripts for setting up and configuring FOSS-GIS in a cloud environment.  
  
These are the scripts I use to automate setting up a FOSS-GIS resource in the cloud. They also serve as my private library of well commented reference scripts that detail both the general process and the specific steps needed to set up each piece of software on Linux 18.04.  

By design, the networking security policy will be set to enable UFW and allow all incoming connections on ports 22 and 873 and deny all others - see WARNING section below for more details.    


# Contents  
```  
ubuntu-gis-utility/  
  | apt-example.sh     : example wrapper script for installing standard binaries  
  | make-example.sh    : example wrapper for installing from source  
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

## Using apt-\*.sh vs make-\*.sh

Alternately, you can use ```source ubuntu-gis-utility/make-example.sh``` to compile GEOS, PROJ, GDAL, and PostGIS from source.  
  
Using apt fetches precompiled binaries for your ubuntu distribution. This has some advantages - it's relatively quick and relatively robust. The disadvantage is that the official precompiled binaries in the official repositories can be months or years behind the current versions of the software you wanted.  

Using make to compile a piece of software from source takes significantly longer and is more prone to breakage - but it has some definite advantages, particularly for PostGIS. By compiling PostGIS and its major dependencies yourself, PostGIS will use GEOS 3.8.1, PROJ 6.3.2, and GDAL 3.1.2 for its backend libraries. This is significantly ahead of the official binaries at the time of writing this readme (2020-08-06). This means that PostGIS will offer you more functionality and better optimization than the default binaries you get from apt.  

Note that if you compile GDAL and GEOS from source and plan on using R's *sf* package on the same machine, you'll need to compile R from source as well - otherwise *sf* won't recognize the update versions of GDAL and GEOS you have compiled.

# WARNING!

**BY DESIGN, AN INSTANCE CONFIGURED WITH THESE SCRIPTS WILL ACCEPT ALL INCOMING CONNECTIONS ON PORTS 22, 873 AND ON ANY OF THE RELEVANT PORTS USED BY THE SOFTWARE YOU INSTALL. TRAFFIC TO ALL OTHER PORTS WILL BE REJECTED**  

This is a compromise solution that is sandwiched between best practices, modularity, and getting it done quickly and with minimum fuss so I can get on with doing GIS.  
  
For the GIS users that might be tentatively exploring the outer reaches of computer geekery:  

Cloud based environments like AWS, Azure and Digital Ocean expect you to handle your network security policy with their high-level network security tools:  
  + AWS' Virtual Private Cloud (VPC)  
  + Azure's Azure Private Cloud (APC)  
  + Or Digital Ocean's Virtual Private Cloud (VPC)  
  
Typically, you want to entirely disable local the security policy on your VM and manage your network security policy exclusively through these tools.  

However, the whole idea behind this set of utilities is that they let you skip the linux and networking background and jump straight into deploying working FOSS-GIS software in the cloud. The idea that someone might jump in and start spinning up VMs with *no* security gives me hives.  

The compromise solution is to assume the average GIS professional knows nothing about managing network security policy. The default security policy that I implemented is to enable UFW and open ports 22 and 873 so you can use ssh and rsync right off the bat. All other ports are only whitelisted when you call the relevant config-\*.sh script after installing a particular piece of software.  
  
This is a reasonably safe compromise for a novice user - not perfect, but at least the VM won't be accepting all incoming connections on all ports if you don't know how to set up a VPC/APC security policy. If you manually install additional software on top of these scripts, you will need to add the relevant ports to UFW yourself.  

If you do know how to use a VPC/APC security policy, my apologies. Simply add in ```ufw disable``` as your final bash command and move on.  

## How config-\*.sh scripts modify the network settings  

The init-\*.sh set of scripts enables UFW on the host machine and sets the following policies:  
  + enable port 22 (ssh) in UFW for all  
  + enable port 873 (rsync) in UFW for all  
  
Additionally, each config-\*.sh script makes changes to the base networking configuration of the software it is installing and the UFW policy as follows:  
  + config-pg-11-postgis-3.sh  
    + copies the template postgresql.conf file which sets listen_address="*"  
    + copies the template pg_hba.conf file, which accepts all incoming connections (0.0.0.0/0)  
    + enables port 5432 (postgres) in UFW for all connections  
  + config-r-shiny.sh  
    + copies the template shiny-server.conf, which sets shiny to listen on port 80 (instead of the default 3838)  
    + enables port 80 (http) in UFW for all connections  

Note these settings are not 'best practices' - they are designed to get you up and running in a secure manner as quickly as possible. 

# Customization  

Customization is fairly straight forward. Pick and choose your scripts as needed and wrap them in your own bash script. The process chain is always the same:  
  1. source the init-*.sh for your cloud provider. This updates the OS on your VM to the latest version before you begin to install software on top of it.  
  2. source **one of** make-*.sh or apt-*.sh (but not both) for the software you want  
  3. (optional) source config-*.sh for the software if you want to alter the default configuration  
  4. (optional) source any additional utility scripts  

## Example Wrapper  
 
Putting it all together, say you want to intall R 4.x and Shiny-Server, but leave Shiny-Server in its default configuration.  
  
In this case, you would save the following bash script as myscript.sh:  
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

Next ```chmod +x myscript.sh`` in the terminal to allow the shell to execute it, then ```source myscript.sh``` and you're off to the races. 

  

