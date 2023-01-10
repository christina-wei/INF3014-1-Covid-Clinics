#### Preamble ####
# Purpose: Simulate dataset of Covid19 clinics across Toronto
# Author: Christina Wei
# Data: 9 January 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT

#### Data Expectations ####
# Number of clinics matching population density in the city
# Expect different types of clinics, like city-run, hospital, pharmacy, pop-ups
# Opening date should be a valid date before today
# columns: clinic_id, district, type, opening_date

#### Workspace setup ####
library(tidyverse)

#### Start simulation ####

## Assumptions

# Fictional district, population, and clinic type
sim_district = c("District1", "District2", "District3", "District4")
sim_population = c(100000, 150000, 20000, 50000)
sim_type = c("City", "Hopsital", "Pharmacy", "Pop-up")

# Probabilities used for sampling
prob_district = sim_population / sum(sim_population)
prob_type = c(0.2, 0.2, 0.5, 0.1)


## Creating simulated data

set.seed(311) #random seed
num_observations = 100

simulated_data = 
  data.frame(
    clinic_id = c(1:num_observations),
    district = sample(x = sim_district, 
                      size = num_observations,
                      replace = TRUE,
                      prob = prob_district),
    type = sample(x = sim_type,
                  size = num_observations,
                  replace = TRUE,
                  prob = prob_type),
    opening_date = as.Date("2023-01-01") #static date as placeholder
  )

## Create graphs of simulated data

# Bar graph of district distribution
simulated_data |> 
  ggplot(aes(x = district)) +
  geom_bar()

# Bar graph of district distribution
simulated_data |> 
  ggplot(aes(x = type)) +
  geom_bar()

# Stacked barchart 
simulated_data |> 
  ggplot(aes(fill=type, x = district)) +
  geom_bar(position="dodge")
  #geom_bar(position="stack")