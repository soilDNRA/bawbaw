library(readr)
library(tidyverse)
library(readxl)


bawbaw_TOC_50to59 <- read_table2(col_names = FALSE, "TOC_results/2018-07-02_Baw_Baw_50to59_diluted_1to20.txt", skip = 13)
newnames <- scan("50to59_sample_names", character(), quote = "") #replace "untitled" with sample names in 50to59
bawbaw_TOC_50to59$X3 <- newnames

bawbaw_TOC_60to97 <- read_table2(col_names = FALSE, "TOC_results/2018-07-04_Baw_Baw_60to97_diluted_1to20.txt", skip = 13)
bawbaw_TOC_50to97 <- bind_rows(bawbaw_TOC_50to59, bawbaw_TOC_60to97)
bawbaw_TOC <- bawbaw_TOC_50to97 %>% 
  select(X3,X4,X5) %>% 
  mutate(X5 = X5*20) # calculate original concentration

rename(bawbaw_TOC, sample_name = X3, sample_ID = X4, TOC_mg_per_l = X5)

bawbaw_TOC$X3 <- gsub("_HWC_diluted1to20", "", bawbaw_TOC$X3) # remove "_HWC_diluted1to20" from sample names

bawbaw_TOC$elevation <- gsub("_SP.", "", bawbaw_TOC$X3) # remove "_SP." from sample names to just give elevation.

# replace "summit" with "1500m"
bawbaw_TOC <- bawbaw_TOC %>%
  mutate(elevation=replace(elevation, elevation=="summit", "1500m")) %>%
  as.data.frame()

bawbaw_TOC_means <- bawbaw_TOC %>% 
  group_by(elevation) %>% 
  summarise(avg_TOC = mean(X5))

#calculate HWC micrograms C per gram of soil.
bawbaw_TOC_means <- bawbaw_TOC_means %>% 
  mutate(avg_mg_TOC_per_30ml = avg_TOC * 0.030) %>%
  mutate(avg_ug_TOC_per_30ml = avg_mg_TOC_per_30ml * 1000 ) %>% 
  mutate(avg_ug_TOC_per_g_soil = avg_ug_TOC_per_30ml / 3)


bawbaw_mineral_N <- read_excel("18. 3422 Eric 180704 - SFA Report 18.07.10.xls", 
                                                       skip = 14) #read KCl data

bawbaw_mineral_N <- rename(bawbaw_mineral_N, nitrate = `N-Nitrate (mg/L)`) #rename column to make it easier to type!
bawbaw_mineral_N <- rename(bawbaw_mineral_N, ammonium = `N-Ammonium (mg/L)`) #rename column to make it easier to type!

# N.B.!! first need to convert <0.2 to 0.2

bawbaw_mineral_N[bawbaw_mineral_N=="<0.2"] <- 0.2

bawbaw_mineral_N <- bawbaw_mineral_N %>%
  select(sample, nitrate, ammonium) #just keep the necessary data columns

bawbaw_mineral_N <- bawbaw_mineral_N %>% filter(sample != "blank") # remove blank samples

bawbaw_mineral_N$elevation <- gsub("SP.", "", bawbaw_mineral_N$sample) # remove "SP." from sample names to just give elevation.

# convert from character to numeric data
bawbaw_mineral_N$nitrate <- as.numeric(bawbaw_mineral_N$nitrate)
bawbaw_mineral_N$ammonium <- as.numeric(bawbaw_mineral_N$ammonium)

# calculate means for nitrate and ammonium using dplyr
bawbaw_mineral_N_means <- bawbaw_mineral_N %>% 
  group_by(elevation) %>% 
  summarise_at(c("nitrate", "ammonium"), mean)

# replace "summit" with "1500m"
bawbaw_mineral_N_means <- bawbaw_mineral_N_means %>%
  mutate(elevation=replace(elevation, elevation=="summit", "1500")) %>%
  as.data.frame()

# add "m" to elevations (so that they match up with TOC data) https://stackoverflow.com/questions/36302300/adding-the-degree-symbol-at-the-end-of-each-vector-element-in-r
bawbaw_mineral_N_means$elevation <- paste0(bawbaw_mineral_N_means$elevation,"m")

# calculate C/NO3- ratio

bawbaw_C_nitrate_ratio <- 


# arranged_TOC <- bawbaw_TOC %>% arrange(elevation) # to view data by elevation
