# energy-hub-demo

Demo of code to reproduce content of the [Electricity Generation page](https://scotland.shinyapps.io/Energy/?Section=RenLowCarbon&Subsection=RenElec&Chart=ElecGen) of the [Scottish Energy Statistics Hub](https://scotland.shinyapps.io/Energy).

To run: 

1. Download the Excel file from this [DESNZ data release](https://www.gov.uk/government/statistics/energy-trends-december-2024-special-feature-article-electricity-generation-and-supply-in-scotland-wales-northern-ireland-and-england-2019-to-20) and save to the `data/raw/` directory as `elec_gen.xlsx`.

2. Run the `processing/elec_gen.R` script. This will create a processed data file saved to `data/processed/`. 

3. Knit the `reporting/elec_gen.Rmd` script. This will create an html output saved to `reporting/`.

Note that this is not a complete process. There are various improvements that should be made, however it is intended as a simple proof of concept.