#### Preamble ####
# Purpose: Clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Christina Wei
# Data: 19 January 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!
# - Change these to yours


#### Workspace setup ####

library(tidyverse)
library(janitor)


#### Read in raw data ####

raw_clinic_data = 
  read_csv(
    file = "inputs/data/raw_clinic_data.csv",
    show_col_types = FALSE
  )

raw_ward_data = 
  read_csv(
    file = "inputs/data/raw_ward_data.csv",
    show_col_types = FALSE
  )

raw_ward_population_data = 
  read_csv(
    file = "inputs/data/raw_ward_population_data.csv",
    show_col_types = FALSE
  )


#### Basic cleaning ####

## Clinic data ##

# make the names snake case
cleaned_clinic_data = clean_names(raw_clinic_data)

# select the rows of interest
cleaned_clinic_data = 
  cleaned_clinic_data |>
  select(
    location_id,
    location_name,
    location_type,
    date_added,
    geometry,
    ward_name
  )

# simplify the types of clinics
cleaned_clinic_data = 
  cleaned_clinic_data |>
  mutate(
    location_type = 
      recode(
        location_type,
        "City-operated Immunization Clinic" = "City",
        "Hospital Immunization Clinic" = "Hospital",
        "Pharmacy Immunization Site" = "Pharmacy"
      )
  )

rm(raw_clinic_data) #remove raw data from environment

## Ward data ##

# select ward code and name, rename columns, and make code numeric
cleaned_ward_data = 
  cleaned_ward_data |>
  select(
    area_short_code,
    area_name
  ) |>
  rename(
    ward_code = area_short_code,
    ward_name = area_name
  )
  mutate(
    ward_code = as.numeric(ward_code)
  )

rm(raw_ward_data)

## Ward population ##

# select row 18 in data where it has the total population numbers
# transpose the table to make the rows and columns match ward data
word_population_vector = 
  transpose((raw_ward_population_data[18,]))[[1]] |>
  as.numeric()
  
word_population_vector = 
  word_population_vector[3:length(word_population_vector)]

cleaned_ward_population_data = tibble(
  ward_code = c(1:length(word_population_vector)),
  ward_population = word_population_vector
)

rm(word_population_vector)
rm(raw_ward_population_data)


#### Merge datasets together ####

combined_ward_data = merge(cleaned_ward_data, cleaned_ward_population_data, by="ward_code")
combined_clinic_data = merge(combined_ward_data, cleaned_clinic_data, by="ward_name")


#### Write cleaned dataset to file ####

write_csv(
  x = combined_clinic_data,
  file = "inputs/data/cleaned_clinic_data_combined.csv"
)

