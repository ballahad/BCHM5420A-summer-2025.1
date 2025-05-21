# R Script for Class 5 Data Cleaning Example
#install.packages(c('readr', 'knitr', 'tidyverse', 'DataExplorer')) # can comment this out after installing packages
library(readr)
library(knitr)
library(tidyverse)
amr_genotypic_phenotypic_results <- read_csv('BCHM5420A-summer-2025-dev/resources/class5_amr_data_cleaning_example.csv') # update path if needed


## Step 1: Pivot the phenotypic columns

tidy_phenotypic <- amr_genotypic_phenotypic_results %>% 
  select(c(Accession, AMK: S)) %>% # select only the accession (sample identifier) and phenotypic columns 
  pivot_longer(
    cols = c(AMK: S),   # phenotypic columns
    names_to = "Drug_phenotypic",
    values_to = "Phenotype"
  )

kable(head(tidy_phenotypic, 12), format = "markdown")


# Step 2: Pivot genotypic columns 
tidy_genotypic <- amr_genotypic_phenotypic_results %>%
  select(c(Accession, Amikacin:Streptomycin)) %>% # selecting the Accession (sample identifier) and the genotypic colums 
  pivot_longer(
    cols = c(Amikacin:Streptomycin),  # genotypic columns 
    names_to = "Drug_genotypic",
    values_to = "Genotype"
  )

kable(head(tidy_genotypic, 12), format = "markdown")



# Step 3: Create a vector to map phenotypic col names to genotypic column names
mapping <- c(
  AMK = "Amikacin",
  CAPREO = "Capreomycin",
  E = "Ethambutol",
  ETHI = "Ethionamide",
  MXF = "Moxifloxacin",
  I = "Isoniazid",
  KANA = "Kanamycin",
  OFLO = "Ofloxacin",
  PAS = "Para-aminosalicylic acid",
  PZA = "Pyrazinamide",
  R = "Rifampicin",
  S = "Streptomycin"
)

# 4. Add full drug names to phen_long for join
tidy_phenotypic <- tidy_phenotypic %>%
  mutate(Drug = mapping[Drug_phenotypic])

kable(head(tidy_phenotypic, 12), format = "markdown")

# 5. Join on Accession and Drug name
tidy_amr_results <- tidy_phenotypic %>%
  left_join(tidy_genotypic, by = c("Accession", "Drug" = "Drug_genotypic")) %>%
  select(Accession, Drug, Phenotype, Genotype)

kable(head(tidy_amr_results, 12), format = "markdown")

# 6. Break apart genotypic results
tidy_amr_results <- tidy_amr_results %>%
  mutate(Genotype = na_if(Genotype, "No mutation detected"))


# Only split rows where Genotype is not NA
tidy_amr_results <- tidy_amr_results %>%
  mutate(
    Gene = if_else(!is.na(Genotype), word(Genotype, 1), NA_character_), # 1
    Mutation = if_else(!is.na(Genotype), word(Genotype, 2), NA_character_),
    Allele_Fraction = if_else(
      !is.na(Genotype),
      str_extract(Genotype, "\\((.*?)\\)") %>% str_remove_all("()"),  # regex - selecting portion between ()
      NA_character_
    )
  ) %>% select(-c(Genotype)) # remove genotype column now that we've replaced it


kable(head(tidy_amr_results, 12), format = "markdown")



# DataExplorer
library(DataExplorer)
create_report(tidy_amr_results)
