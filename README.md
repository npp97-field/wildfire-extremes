# Spatiotemporal modeling of wildfire extremes

[![Docker Automated build](https://img.shields.io/docker/automated/mbjoseph/wildfire-extremes.svg)](https://hub.docker.com/r/mbjoseph/wildfire-extremes/)
[![Docker Build Status](https://img.shields.io/docker/build/mbjoseph/wildfire-extremes.svg)](https://hub.docker.com/r/mbjoseph/wildfire-extremes/)
[![DOI](https://zenodo.org/badge/64492265.svg)](https://zenodo.org/badge/latestdoi/64492265)

This repository contains code to build spatiotemporal models of wildfire extremes in the contiguous United States. 

## Hardware requirements

We recommend at least 4 physical CPUs and 30 GB of RAM. 

## Reproducing the analysis

### Spinning up the computational environment

We have provided a Docker container that bundles up the software dependencies 
for this project, and provides an RStudio server instance that can be used in a 
web browser. 
To launch the container, run the following:

```bash
docker run -d -p 8787:8787 mbjoseph/wildfire-extremes
```

Then, navigate to port 8787 on a web browser (e.g., `localhost:8787`, or 
`<Insert EC2 IP addres heres>:8787` if running on AWS) and log in 
with username `rstudio`, password `rstudio`. 

### Optional: creating an RStudio project

If you plan to interact much with the code, you may want to create an RStudio 
project. 
To do so, after connecting to your RStudio server, choose 
File > New Project..., then select "Existing Directory" > Browse..., and 
choose wildfire-extremes, and finally click Create Project. 
This will create and then open a project associated with this repository.

### Running the analysis

To run everything, you can type the following command from a terminal 
(e.g., the terminal pane in RStudio server): 

```
make
```

This takes ~3-4 days on a machine with 4 cores, assuming that you're making
everything from scratch. 
Fitting the models takes the longest due to data volume and parameter 
dimensionality. 

## Overview of workflow

### 1. Data processing 

We define targets for the input data to the models in the Makefile as follows: 

- `data/processed/ecoregion_summaries.csv`: Summaries of climate data for every 
EPA level 3 ecoregion for each month from 1984-2015. 

- `data/processed/housing_density.csv`: Summary of housing density for each 
ecoregion, each month. 

- `data/processed/stan_d.rds`: A serialized rds object that bundles all input 
data for the model fitting step.

We also generate some ancillary data to be used downstream in the analysis of 
model results, including `data/processed/mtbs.rds` and 
`data/processed/ecoregions.rds`.


### 2. Model training and evaluation

Once the serialized model input data (`data/processed/stan_d.rds`) exist, then
all of the models can be fit. 
These include burn area models and wildfire count models, all of which have
the suffix `_fit.rds`, e.g., `nb_fit.rds`, `ba_gamma_fit.rds`.
Each model fit object corresponds to a separate target in the Makefile. 

With these model fits, a set of figures and tables (`figs` and `tables` in
the Makefile) are generated. 
These are passed into the manuscript in the next step.

### 3. Manuscript generation

The manuscript `main.pdf` is generated from the `main.Rmd` file, and all of the 
tables and figures. 
The source code for the manuscript is an R Markdown document, which dynamically 
inserts the figures, tables, and summary statistics into the paper in an 
automated way. 
