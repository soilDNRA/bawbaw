library(readr)
library(tidyverse)
library(readxl)
library(knitr)


bawbaw_TOC_50to59 <- read_table2(col_names = FALSE, "TOC_results/2018-07-02_Baw_Baw_50to59_diluted_1to20.txt", skip = 13)
newnames <- scan("50to59_sample_names", character(), quote = "") #replace "untitled" with sample names in 50to59
bawbaw_TOC_50to59$X3 <- newnames
bawbaw_TOC_50to59$X3 <- gsub("m_SP.*", "", bawbaw_TOC_50to59$X3) # remove "_SP.*" from "summit" sample names to just give elevation.
bawbaw_TOC_50to59$X3 <- gsub("_SP.*", "", bawbaw_TOC_50to59$X3) # remove "_SP.*" from "summit" sample names to just give elevation.

bawbaw_TOC_60to97 <- read_table2(col_names = FALSE, "TOC_results/2018-07-04_Baw_Baw_60to97_diluted_1to20.txt", skip = 13)
bawbaw_TOC_60to97 <- bawbaw_TOC_60to97[-c(4, 20), ] # delete 200SP2_... because they are duplicates (mislabelled?)
bawbaw_TOC_60to97$X3 <- gsub("m_SP.*", "", bawbaw_TOC_60to97$X3) # remove "_SP.*" from sample names to just give elevation.
bawbaw_TOC_60to97$X3 <- gsub("_SP.*", "", bawbaw_TOC_60to97$X3) # remove "_SP.*" from "summit" sample names to just give elevation.


bawbaw_TOC_means <- bind_rows(bawbaw_TOC_50to59, bawbaw_TOC_60to97) %>%
  rename(elevation = X3, sample_ID = X4, TOC_mg_per_l = X5) %>%
  select(elevation, sample_ID, TOC_mg_per_l) %>%
  mutate(elevation=replace(elevation, elevation=="summit", "1500")) %>%
  mutate(TOC_mg_per_l_before_dilution = TOC_mg_per_l*20) %>% 
  mutate(mg_TOC_per_30ml = TOC_mg_per_l_before_dilution * 0.030) %>%
  mutate(ug_TOC_per_30ml = mg_TOC_per_30ml * 1000 ) %>% 
  mutate(ug_TOC_per_g_soil = ug_TOC_per_30ml / 3) %>% # calculate original concentration
  group_by(elevation) %>% 
  summarise(mean_ug_TOC_per_g_soil = mean(ug_TOC_per_g_soil))

# read mineral N data

bawbaw_mineral_N <- read_excel("18. 3422 Eric 180704 - SFA Report 18.07.10.xls", 
                                                       skip = 14) #read KCl data

bawbaw_mineral_N[bawbaw_mineral_N=="<0.2"] <- 0.2 # N.B.!! first need to convert <0.2 to 0.2
bawbaw_mineral_N$sample <- gsub("SP.", "", bawbaw_mineral_N$sample) # remove "SP." from sample names to just give elevation.

bawbaw_mineral_N_means <- bawbaw_mineral_N %>%
  rename(elevation = sample, nitrate = `N-Nitrate (mg/L)`, ammonium = `N-Ammonium (mg/L)`) %>% #rename column to make it easier to type!
  select(elevation, nitrate, ammonium) %>% #just keep the necessary data columns
  filter(elevation != "blank") %>% # remove blank samples
  mutate(nitrate = as.numeric(nitrate)) %>% # convert from character to numeric data
  mutate(ammonium = as.numeric(ammonium)) %>% # convert from character to numeric data
  mutate(elevation =replace(elevation, elevation=="summit", "1500")) %>% # replace "summit" with "1500"
  mutate(total_NO3_in_extract_mg = nitrate * 0.1,
             total_NO3_in_extract_ug = total_NO3_in_extract_mg * 1000,
             total_NO3_per_g_soil_ug = total_NO3_in_extract_ug / 10) %>% # calculate mean for nitrate
  mutate(total_NH4_in_extract_mg = ammonium * 0.1,
         total_NH4_in_extract_ug = total_NH4_in_extract_mg * 1000,
         total_NH4_per_g_soil_ug = total_NH4_in_extract_ug / 10) %>% # calculate mean for ammonium
  group_by(elevation) %>% 
  summarise_at(c("total_NO3_per_g_soil_ug", "total_NH4_per_g_soil_ug"), mean)


# calculate C/NO3- ratio and C/mineral-N ratio
combined_NC_means <- bind_cols(bawbaw_mineral_N_means, bawbaw_TOC_means)
combined_NC_means <- combined_NC_means %>% select(-elevation1) %>% #remove extra elevation column
  mutate(C_nitrate_ratio = mean_ug_TOC_per_g_soil / total_NO3_per_g_soil_ug,
                                                  C_mineral_N_ratio = mean_ug_TOC_per_g_soil / (total_NO3_per_g_soil_ug + total_NH4_per_g_soil_ug))

# write .rds and .csv and .tsv file with data
write_rds(combined_NC_means,"combined_NC_means.rds")
write_csv(combined_NC_means,"combined_NC_means.csv")
write_tsv(combined_NC_means,"combined_NC_means.tsv")

#print see https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html
combined_NC_means2 <- combined_NC_means
combined_NC_means2$C_nitrate_ratio <- round(combined_NC_means2$C_nitrate_ratio, 2)
combined_NC_means2$C_mineral_N_ratio <- round(combined_NC_means2$C_mineral_N_ratio, 2)
combined_NC_means2 <- combined_NC_means2 %>%
  mutate(elevation = factor(elevation, levels = c("200", "300", "500", "600", "800", "900", "1000", "1100","1200", "1300", "1400","1500"))) %>% 
  arrange(elevation) %>% 
  select(elevation, C_nitrate_ratio, C_mineral_N_ratio) 
names(combined_NC_means2) <- c("Elevation", "HWC/nitrate-N", "HWC/mineral-N")
kable(combined_NC_means2) %>%
  kable_styling(bootstrap_options = "striped", full_width = F) %>%
  save_kable(file = "HWC_N_ratios.html", self_contained = T)

