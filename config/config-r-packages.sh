#!/bin/bash

# R's sf PACKAGE IS SPECIAL 
# It uses gdal 
# make sure $GDAL_DATA is set and gdal-config directory is on $PATH


# use the following if GDAL is compiled from source
# comment out if using standard gdal-bin binary
sudo ln -s /usr/local/bin/gdal-config /bin/gdal-config

# sf requires libudunits2-dev
sudo apt install -y libudunits2-dev
sudo su - \
  -c "R -e \"install.packages(c('sf'), repos='https://cran.rstudio.com/')\""

# Shiny packages
sudo su - \
-c "R -e \"install.packages(c('shinydashboard','shinyWidgets','shinythemes','DT', 'htmlwidgets'), repos='https://cran.rstudio.com/')\""

# Database packages
sudo su - \
-c "R -e \"install.packages(c('pool','rpostgis','RPostgres','DBI'), repos='https://cran.rstudio.com/')\""

# graph network packages
# sudo su - \
# -c "R -e \"install.packages(c('igraph','visNetwork'), repos='https://cran.rstudio.com/')\""

# data manipulation packages
sudo su - \
-c "R -e \"install.packages(c('scales','dplyr'), repos='https://cran.rstudio.com/')\""

# plotting packages
sudo su - \
-c "R -e \"install.packages(c('wesanderson','ggplot2','ggthemes', 'RColorBrewer', 'plotly'), repos='https://cran.rstudio.com/')\""

# spatial packages
sudo su - \
-c "R -e \"install.packages(c('leaflet','leaflet.extras'), repos='https://cran.rstudio.com/')\""


