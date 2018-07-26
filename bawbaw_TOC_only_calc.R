library(readr)
library(tidyverse)
library(readxl)
library(knitr)
library(kableExtra)


bawbaw_TOC_50to59 <- read_table2(col_names = FALSE, "TOC_results/2018-07-02_Baw_Baw_50to59_diluted_1to20.txt", skip = 13)


newnames <- scan("50to59_sample_names", character(), quote = "") #replace "untitled" with sample names in 50to59
bawbaw_TOC_50to59$X3 <- newnames
bawbaw_TOC_50to59 %>%
  rename(`Sample name` = X3, `sample ID`=X4, `TOC mg/L` = X5, `TC mg/L` = X6, `IC mg/L` = X7) %>%
  select(`Sample name`:`IC mg/L`) %>%
  write_csv("TOC_results/2018-07-02_Baw_Baw_50to59_diluted_1to20_filtered_results.csv") # write raw results to csv file for printing in lab notebook

bawbaw_TOC_50to59$X3 <- gsub("m_SP.*", "", bawbaw_TOC_50to59$X3) # remove "_SP.*" from "summit" sample names to just give elevation.
bawbaw_TOC_50to59$X3 <- gsub("_SP.*", "", bawbaw_TOC_50to59$X3) # remove "_SP.*" from "summit" sample names to just give elevation.

bawbaw_TOC_60to97 <- read_table2(col_names = FALSE, "TOC_results/2018-07-04_Baw_Baw_60to97_diluted_1to20.txt", skip = 13)
bawbaw_TOC_60to97 %>%
  rename(`Sample name` = X3, `sample ID`=X4, `TOC mg/L` = X5, `TC mg/L` = X6, `IC mg/L` = X7) %>%
  select(`Sample name`:`IC mg/L`) %>%
  write_csv("TOC_results/2018-07-02_Baw_Baw_60to97_diluted_1to20_filtered_results.csv") # write raw results to csv file for printing in lab notebook


bawbaw_TOC_60to97 <- bawbaw_TOC_60to97[-c(4, 20), ] # delete 200SP2_... because they are duplicates (mislabelled?)
bawbaw_TOC_60to97$X3 <- gsub("m_SP.*", "", bawbaw_TOC_60to97$X3) # remove "_SP.*" from sample names to just give elevation.
bawbaw_TOC_60to97$X3 <- gsub("_SP.*", "", bawbaw_TOC_60to97$X3) # remove "_SP.*" from "summit" sample names to just give elevation.


bawbaw_TOC_means <- bind_rows(bawbaw_TOC_50to59, bawbaw_TOC_60to97) %>%
  rename(elevation = X3, TOC_mg_per_l = X5) %>%
  select(elevation, TOC_mg_per_l) %>%
  mutate(elevation=replace(elevation, elevation=="summit", "1500")) %>%
  mutate(TOC_mg_per_l_before_dilution = TOC_mg_per_l*20) %>% 
  mutate(mg_TOC_per_30ml = TOC_mg_per_l_before_dilution * 0.030) %>%
  mutate(ug_TOC_per_30ml = mg_TOC_per_30ml * 1000 ) %>% 
  mutate(ug_TOC_per_g_soil = ug_TOC_per_30ml / 3) %>% # calculate original concentration
  mutate_if(is.character, as.factor) %>% 
  group_by(elevation) %>% 
  summarise(mean_ug_TOC_per_g_soil = mean(ug_TOC_per_g_soil), sd = sd(ug_TOC_per_g_soil)) # %>% 

#bawbaw_TOC_means <- parse_factor()

elevation_levels <- c("200","300","500","600","800","900","1000","1100","1200","1300","1400","1500") # define factor levels for elevation, to be used with parse_factor

parse_factor(bawbaw_TOC_means$elevation, elevation_levels)


kable(bawbaw_TOC_means)%>%
  kable_styling(bootstrap_options = "striped", full_width = F)

# see http://www.sthda.com/english/wiki/ggplot2-error-bars-quick-start-guide-r-software-and-data-visualization
p<- ggplot(bawbaw_TOC_means, aes(x=elevation, y=mean_ug_TOC_per_g_soil)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_ug_TOC_per_g_soil-sd, ymax=mean_ug_TOC_per_g_soil+sd), width=.2,
                position=position_dodge(.9))

p
