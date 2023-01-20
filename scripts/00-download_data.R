#### Preamble ####
# Purpose: Download dataset of Covid19 clinics across Toronto, and the corresonding ward population
# Author: Christina Wei
# Date: 19 January 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Prerequisites: none
# Datasets:
  # Covid clinic information from https://open.toronto.ca/dataset/covid-19-immunization-clinics/
  # Ward information from https://open.toronto.ca/dataset/city-wards/
  # Ward population from https://open.toronto.ca/dataset/ward-profiles-2018-25-ward-model/

#### Workspace setup #### 

library(tidyverse)
source("scripts/02-helper_functions.R")

#### Download and write Covid clinic data ####

# download data
raw_clinic_data = download_data_from_opendatatoronto(
  package_id = "d3f21fec-a80d-4f29-b298-1d0660a0e55d",
  resource_id = "00ebee09-a602-4f82-978b-ad0a40f3846f"
)

# write data
write_csv (
  x = raw_clinic_data,
  file = "inputs/data/raw_clinic_data.csv"
)


#### Download and write ward name data ####

raw_ward_data = download_data_from_opendatatoronto(
  package_id = "5e7a8234-f805-43ac-820f-03d7c360b588",
  resource_id = "7672dac5-b383-4d7c-90ec-291dc69d37bf"
)

# write data
write_csv (
  x = raw_ward_data,
  file = "inputs/data/raw_ward_data.csv"
)


#### Download and write ward population data ####

raw_ward_population_data = download_data_from_opendatatoronto (
  package_id = "ward-profiles-2018-25-ward-model",
  resource_id = "9ec6c37a-a388-4e45-9e6f-da6284952069"
)

# write data for the first tab: "2016 Census One Variable"
write_csv (
  x = as.data.frame(raw_ward_population_data[1]),
  file = "inputs/data/raw_ward_population_data.csv"
)
