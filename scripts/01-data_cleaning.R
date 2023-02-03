#### Preamble ####
# Purpose: Clean covid clinic, ward info, and ward profile data and combine into one dataset
# Author: Christina Wei
# Data: 19 January 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # 00-download_data.R


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

raw_ward_profile_data = 
  read_csv(
    file = "inputs/data/raw_ward_profile_data.csv",
    show_col_types = FALSE
  )


#### Data cleaning ####

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
    ward_name
  )

# simplify the types of clinics
# referenced code from https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html
cleaned_clinic_data = 
  cleaned_clinic_data |>
  mutate(
    location_type = 
      recode(
        location_type,
        "City-operated Immunization Clinic" = "City",
        "Hospital Immunization Clinic" = "Hospital",
        "Pharmacy Immunization Site" = "Pharmacy"
      ),
  )

# remove working variables from workspace
rm(raw_clinic_data)

## Ward data ##

# select ward code and name, rename columns, and make code numeric
# referenced code from https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html
cleaned_ward_data = 
  raw_ward_data |>
  clean_names() |>
  select(
    area_short_code,
    area_name
  ) |>
  rename(
    ward_code = area_short_code,
    ward_name = area_name
  ) |>
  mutate(
    ward_code = as.numeric(ward_code)
  )

cleaned_ward_data =
  cleaned_ward_data |>
  add_row(ward_code = 00, ward_name = NA)

# remove working variables from workspace
rm(raw_ward_data)

## Ward profile data ##

# population
# select row 18 in data where it has the total population numbers
# transpose the table to make the rows and columns match ward data
ward_population_vector = 
  transpose((raw_ward_profile_data[18,]))[[1]] |>
  as.numeric()

# select the relevant items only
ward_population_vector = 
  ward_population_vector[3:length(ward_population_vector)]

# income
# select row 1249 in data where it has the average total income of households
# transpose the table to make the rows and columns match ward data
ward_income_vector = 
  transpose((raw_ward_profile_data[1249,]))[[1]] |>
  as.numeric()

# select the relevant items only
ward_income_vector =
  ward_income_vector[3:length(ward_income_vector)]

# create table with ward code, population and income
merge_ward_profile_data = tibble(
  ward_code = c(1:length(ward_population_vector)),
  population = ward_population_vector,
  income = ward_income_vector
)

# combine ward code, name, population, and income into one table
cleaned_ward_data =
  left_join(
    cleaned_ward_data,
    merge_ward_profile_data,
    by = "ward_code",
  )

# remove working variables from workspace
rm(ward_population_vector)
rm(ward_income_vector)
rm(raw_ward_profile_data)
rm(merge_ward_profile_data)


#### Calculate statistics per ward ####

# summarize clinic data by number of clinics per ward
summarized_clinic_data = 
  cleaned_clinic_data |>
  group_by(ward_name) |>
  count(ward_name) |>
  rename( "num_clinics" = "n")

# combine summarized clinic data with ward population and income
summarized_clinic_data = 
  merge(
    summarized_clinic_data,
    cleaned_ward_data,
    by = "ward_name"
  )

# remove working variables from workspace
rm(cleaned_ward_data)


#### Data validation ####

## cleaned_clinic_data

# data types
class(cleaned_clinic_data$ward_name) == "character"
class(cleaned_clinic_data$location_type) == "character"

# data values
length(unique(cleaned_clinic_data$ward_name)) == 26 # 25 wards + 1 NA
unique(cleaned_clinic_data$location_type) == c("City", "Hospital", "Pharmacy")

## summarized_clinic_data

# data types
class(summarized_clinic_data$ward_name) == "character"
class(summarized_clinic_data$ward_code) == "numeric"
class(summarized_clinic_data$population) == "numeric"
class(summarized_clinic_data$income) == "numeric"
class(summarized_clinic_data$num_clinics) == "integer"

# data values
min(summarized_clinic_data$ward_code) == 0 #smaller ward code is 0 (for NA)
max(summarized_clinic_data$ward_code) == 25 #largest ward code is 25
min(summarized_clinic_data$population, na.rm = TRUE) > 0 #population greater than 0
max(summarized_clinic_data$population, na.rm = TRUE) < 1000000 #population less than 1 million
min(summarized_clinic_data$income, na.rm = TRUE) > 0 #income greater than 0
max(summarized_clinic_data$income, na.rm = TRUE) < 1000000 #income less than 1 million
min(summarized_clinic_data$num_clinics, na.rm = TRUE) > 0 #number of clincis greater than 0
max(summarized_clinic_data$num_clinics, na.rm = TRUE) < 1000 #number of clinics less than 1000


#### Write cleaned dataset to file ####

write_csv(
  x = cleaned_clinic_data,
  file = "inputs/data/cleaned_clinic_data.csv"
)

write_csv(
  x = summarized_clinic_data,
  file = "inputs/data/summarized_clinic_data.csv"
)

