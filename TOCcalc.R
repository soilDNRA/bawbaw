library(readr)
library(tidyverse)



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

bawbaw_TOC$elevation <- gsub("_SP.", "", bawbaw_TOC$X3)
bawbaw_TOC %>% 
  group_by(elevation) %>% 
  summarise(avg_TOC = mean(X5),
            total = n())

# arranged_TOC <- bawbaw_TOC %>% arrange(elevation) # to view data by elevation
