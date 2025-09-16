# Name of file - 00_processing-setup.R
# Data release - Scotland Energy Statistics Hub
# Description  - Load packages and set parameters for data processing code

# 0 - Load packages ----

library(here)
library(dplyr)
library(readxl)
library(janitor)
library(tidyr)
library(stringr)
library(snakecase)
library(readr)
library(purrr)
library(tools)
library(cli)


# 1 - Load lookups ----

walk(list.files(here("lookups"), pattern = "\\.R$", full.names = TRUE),
     source)


### END OF SCRIPT ###
