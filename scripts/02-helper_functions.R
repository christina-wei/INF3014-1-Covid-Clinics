#### Preamble ####
# Purpose: Collection of helper functions
# Author: Christina Wei
# Date: 19 January 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workspace setup ####

library(opendatatoronto)

## Function to retrieve data from opendatatoronto
download_data_from_opendatatoronto = function(package_id, resource_id) {

  raw_data = 
    list_package_resources(package_id) |> # get resources for the package_id
    filter (id == resource_id) |> # filter by resource_id
    get_resource() #download data
}
