library(readr)
library(tidyverse)


bawbaw_TOC_50to59 <- read_table2(col_names = FALSE, "TOC_results/2018-07-02_Baw_Baw_50to59_diluted_1to20.txt", skip = 13)
bawbaw_TOC_60to97 <- read_table2(col_names = FALSE, "TOC_results/2018-07-04_Baw_Baw_60to97_diluted_1to20.txt", skip = 13)
bawbaw_TOC_50to97 <- bind_rows(bawbaw_TOC_50to59, bawbaw_TOC_60to97)
bawbaw_TOC <- bawbaw_TOC_50to97 %>% 
  select(X3,X4,X5) %>% 
  mutate(X5 = X5*20) # calculate original concentration
#  rename(X3 = "sample_name", X4 = "sample_ID", X5="result_TOC_mgperlitre")
rename(bawbaw_TOC, sample_name = X3, sample_ID = X4, TOC_mg_per_l = X5)


# see https://stackoverflow.com/questions/40659005/using-readr-want-to-use-col-only-option
# tt <- read_csv("outcome-of-care-measures.csv", col_types = cols_only(Hospital 30-Day Death (Mortality) Rates from Heart Attack=col_character()), n_max = 10)
