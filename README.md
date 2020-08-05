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
  

