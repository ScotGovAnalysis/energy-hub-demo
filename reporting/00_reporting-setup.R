# Name of file - 00_reporting-setup.R
# Data release - Scotland Energy Statistics Hub
# Description  - Load packages and set parameters for data processing code

# 0 - Load packages ----

library(here)
library(readr)
library(dplyr)
library(tidyr)
library(janitor)
library(stringr)
library(ggplot2)
library(sgplot)
library(gt)


# 1 - Knitr chunk options ----

knitr::opts_chunk$set(
  echo = FALSE
)


# 2 - Use sgplot ----

use_sgplot(base_size = 18, legend = "bottom")


### END OF SCRIPT ###
