# Name of file - elec_gen.R
# Data release - Scotland Energy Statistics Hub
# Description  - Process electricity generation data

# TO DO
# - Check recoding of values to 0 or NA
# - When should values be rounded? (Affects value of 'Low Carbon')
# - Can more checks be put in place to validate input data format?


# 0 - Run setup script ----

source(here::here("processing", "00_processing-setup.R"))


# 1 - Read in data ----

elec_gen <- 
  read_xlsx(
    here("data", "raw", "elec_gen.xlsx"),
    sheet = "Electricity generation by fuel",
    range = cell_rows(c(5, 42)),
    na = c("", "[x]")
  ) %>%
  clean_names()


# 2 - Clean and restructure data ----

elec_gen <- 
  elec_gen %>%
  filter(generator_type == "All generating companies") %>%
  select(-generator_type) %>%
  pivot_longer(cols = !fuel) %>%
  separate_wider_regex(name,
                       c("x", year = "\\d{4}", "_", region = ".*")) %>%
  mutate(year = as.numeric(year),
         value = replace_na(value, 0))

# Recode region
elec_gen <-
  elec_gen %>%
  mutate(
    region = to_title_case(region),
    region = case_when(
      region %in% c("England", "Wales") ~ "England & Wales",
      .default = region
    )
  ) %>%
  filter(region %in% c("Scotland", "England & Wales"))

# Recode fuel
elec_gen <-
  elec_gen %>%
  mutate(
    fuel = str_remove_all(fuel, "\\s?\\[.*\\]\\s?"),
    fuel = case_match(
      fuel,
      "Hydro natural flow" ~ "Hydro",
      "Shoreline wave and tidal" ~ "Wave / Tidal",
      "Solar" ~ "Solar PV",
      "Bioenergy" ~ "Bioenergy and Waste",
      "Pumped storage" ~ "Pumped Hydro",
      "Other fuels" ~ "Other",
      "Total all generating companies" ~ "Total",
      .default = fuel
    ),
    fuel = str_to_title(fuel) %>%
      str_replace("Pv", "PV") %>%
      str_replace("And", "and")
  ) %>%
  filter(fuel != "Battery Storage")
  

# 3 - Add Low Carbon summary rows ----

elec_gen <- 
  elec_gen %>%
  bind_rows(
    elec_gen %>%
      filter(fuel %in% c("Renewables", "Nuclear", "Pumped Hydro")) %>%
      mutate(fuel = "Low Carbon")
  )


# 4 - Convert region and fuel columns to factors ----

fuel_order <-
  imap(fuel_types, c) %>%
  list_c() %>%
  c("Other", "Total")

elec_gen <-
  elec_gen %>%
  mutate(fuel = factor(fuel, fuel_order),
         region = factor(region, c("Scotland", "England & Wales")))


# 5 - Summarise data by year, region and fuel ----

elec_gen <-
  elec_gen %>%
  group_by(year, region, fuel) %>%
  summarise(value = sum(value, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(summary = 
           fuel %in% c("Total", "Renewables", "Low Carbon", "Fossil Fuels"))


# 6 - Add proportion column ----

elec_gen <-
  elec_gen %>%
  group_by(year, region) %>%
  mutate(prop = value / value[fuel == "Total"]) %>%
  ungroup()


# 7 - Save data ----

write_rds(
  elec_gen,
  here("data", "processed", "elec_gen.rds")
)


### END OF SCRIPT ###
