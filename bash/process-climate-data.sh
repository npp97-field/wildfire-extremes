#!/bin/bash

# download the data from remote server
source metdata_wget.sh

# execute R script to produce monthly GeoTIFFs
Rscript --vanilla R/aggregate-climate-data.R

# push GeoTIFFS to AWS S3

# create ecoregion summaries for each file

# push ecoregion summary csv files to AWS S3