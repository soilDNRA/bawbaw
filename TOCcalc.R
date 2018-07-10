library(readr)
library(tidyverse)

bawbaw_TOC_50to59 <- read_table2(col_names = FALSE, "TOC_results/2018-07-02_Baw_Baw_50to59_diluted_1to20.txt", skip = 13)

# see https://stackoverflow.com/questions/40659005/using-readr-want-to-use-col-only-option
# tt <- read_csv("outcome-of-care-measures.csv", col_types = cols_only(Hospital 30-Day Death (Mortality) Rates from Heart Attack=col_character()), n_max = 10)
