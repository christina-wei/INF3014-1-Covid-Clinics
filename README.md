# Analysis of COVID-19 Clinics Across Toronto

## Overview of Paper

This paper analyzes the distribution of COVID-19 immunization clinics across Toronto. Specifically, it is looking at the relationship between the number of clinics, population, and income level for each ward.

## File Structure

The repo is structured as the following:

-   `input/data` contains the data sources used in analysis including raw and cleaned data.

-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.

-   `scripts` contains the R scripts used to simulate, download and clean data, as well as helper functions used in these routines.

## How to Run

1.  Run `scripts/00-download_data.R` to download raw data
2.  Run `scripts/01-data_cleaning.R` to generate cleaned data
3.  Run `outputs/paper/covid_clinic.qmd` to generate the PDF of the paper
