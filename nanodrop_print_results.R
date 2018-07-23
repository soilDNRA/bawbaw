library(readr)
library(tidyverse)
library(readxl)
library(knitr)
library(formattable)
library(kableExtra)

nanodrop <- read_csv("nanodrop/2018-07-19_nanodrop_report.csv") %>% 
  select(`Sample ID`,`Nucleic Acid Conc.`, `260/280`, `260/230`) %>% 
  rename(`DNA conc. (ng/μl)` = `Nucleic Acid Conc.`) %>% 
  mutate(`260/280` = ifelse(`260/280` < 1.80,
                       cell_spec(`260/280`, "html", color = "red", bold = T),
                       cell_spec(`260/280`, "html", color = "green")),
          `260/230` = ifelse(`260/230` < 1.80,
                            cell_spec(`260/230`, "html", color = "red", bold = T),
                            cell_spec(`260/230`, "html", color = "green")))  %>%
    kable("html", caption = "Title of the table",escape = F) %>%
    kable_styling(full_width = F) %>% # see http://haozhu233.github.io/kableExtra/use_kableExtra_with_formattable.html
    save_kable(file = "nanodrop_results.html", self_contained = T)
# 
# 
# formattable(nanodrop, list(
#   `260/230` = color_tile("red","green"),
#   `DNA conc. (ng/μl)` = color_bar("lightblue")))
# 
