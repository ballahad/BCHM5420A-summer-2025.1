# R Script for Class 8 AMR Data Analysis Example
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

#kable(head(tidy_phenotypic, 12), format = "markdown")


# Step 2: Pivot genotypic columns 
tidy_genotypic <- amr_genotypic_phenotypic_results %>%
  select(c(Accession, Amikacin:Streptomycin)) %>% # selecting the Accession (sample identifier) and the genotypic colums 
  pivot_longer(
    cols = c(Amikacin:Streptomycin),  # genotypic columns 
    names_to = "Drug_genotypic",
    values_to = "Genotype"
  )

#kable(head(tidy_genotypic, 12), format = "markdown")



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

#kable(head(tidy_phenotypic, 12), format = "markdown")

# 5. Join on Accession and Drug name
tidy_amr_results <- tidy_phenotypic %>%
  left_join(tidy_genotypic, by = c("Accession", "Drug" = "Drug_genotypic")) %>%
  select(Accession, Drug, Phenotype, Genotype)

#kable(head(tidy_amr_results, 12), format = "markdown")

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
      str_extract(Genotype, "\\((.*?)\\)") %>% str_remove_all("\\(|\\)"),  # regex - selecting portion between ()
      NA_character_
    )
  ) %>% select(-c(Genotype)) # remove genotype column now that we've replaced it


#kable(head(tidy_amr_results, 12), format = "markdown")


#print(tidy_amr_results)


# DataExplorer
#library(DataExplorer)
#create_report(tidy_amr_results)


# Step 7: remove results where no phenotypic data is present
filtered_amr_results <- tidy_amr_results %>%
  filter(!(is.na(Phenotype)))

# Step 8: classify results as TP,TN, FP or FN based on concordance with phenotypic result
filtered_amr_results_classified <- filtered_amr_results %>%
  mutate(prediction_outcome = case_when(
    Phenotype == "R" & !is.na(Gene) ~ "TP", # if Gene is NA, then no mutation was detected
    Phenotype == "S" & !is.na(Gene) ~ "FP", #
    Phenotype == "R" & is.na(Gene) ~ "FN",  #
    Phenotype == "S" & is.na(Gene) ~ "TN",  #
    TRUE ~ "ERROR"
  ))


# Step 9: summarize results of prediction outcomes per antibiotic
classification_summary <- filtered_amr_results_classified %>%
  count(Drug, prediction_outcome, name = "count")  %>%
  pivot_wider(
    names_from = prediction_outcome,
    values_from = count,
    values_fill = 0   # fill empty values with 0 
  )


# Step 10: calculate performance metrics and 95% confidence interval using binom.test() which uses the Clopper-Pearson method.
metrics_by_drug <- classification_summary %>%
  rowwise() %>%
  mutate(
    Sensitivity_val = if ((TP + FN) > 0) TP / (TP + FN) else NA,   # calculate sensitivity - checking to make sure denominator is not 0
    Specificity_val = if ((TN + FP) > 0) TN / (TN + FP) else NA,   # calculate specificity ect...
    PPV_val         = if ((TP + FP) > 0) TP / (TP + FP) else NA,
    NPV_val         = if ((TN + FN) > 0) TN / (TN + FN) else NA,
    Accuracy_val    = if ((TP + TN + FP + FN) > 0) (TP + TN) / (TP + TN + FP + FN) else NA,
    
    Sens_CI = list(if ((TP + FN) > 0) binom.test(TP, TP + FN)$conf.int else c(NA, NA)),  # calculating 95% confidence intervals 
    Spec_CI = list(if ((TN + FP) > 0) binom.test(TN, TN + FP)$conf.int else c(NA, NA)),
    PPV_CI  = list(if ((TP + FP) > 0) binom.test(TP, TP + FP)$conf.int else c(NA, NA)),
    NPV_CI  = list(if ((TN + FN) > 0) binom.test(TN, TN + FN)$conf.int else c(NA, NA)),
    Acc_CI  = list(if ((TP + TN + FP + FN) > 0) binom.test(TP + TN, TP + TN + FP + FN)$conf.int else c(NA, NA))
  ) %>%
  # formatting confidence intervals as a string to append with results for ease of reading 
  mutate(
    Sensitivity = if_else(
      is.na(Sensitivity_val),
      NA,
      paste0(
        round(Sensitivity_val * 100, 1), "% (",
        round(Sens_CI[1] * 100, 1), "%, ",
        round(Sens_CI[2] * 100, 1), "%)"
      )
    ),
    Specificity = if_else(
      is.na(Specificity_val),
      NA,
      paste0(
        round(Specificity_val * 100, 1), "% (",
        round(Spec_CI[1] * 100, 1), "%, ",
        round(Spec_CI[2] * 100, 1), "%)"
      )
    ),
    PPV = if_else(
      is.na(PPV_val),
      NA,
      paste0(
        round(PPV_val * 100, 1), "% (",
        round(PPV_CI[1] * 100, 1), "%, ",
        round(PPV_CI[2] * 100, 1), "%)"
      )
    ),
    NPV = if_else(
      is.na(NPV_val),
      NA,
      paste0(
        round(NPV_val * 100, 1), "% (",
        round(NPV_CI[1] * 100, 1), "%, ",
        round(NPV_CI[2] * 100, 1), "%)"
      )
    ),
    Accuracy = if_else(
      is.na(Accuracy_val),
      NA,
      paste0(
        round(Accuracy_val * 100, 1), "% (",
        round(Acc_CI[1] * 100, 1), "%, ",
        round(Acc_CI[2] * 100, 1), "%)"
      )
    )
  ) %>%
  select(Drug, TP, FP, FN, TN,
         Sensitivity, Specificity, PPV, NPV, Accuracy)


# print out results
kable(head(metrics_by_drug, 11), format = "markdown")
