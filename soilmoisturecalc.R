# see http://www.cfr.washington.edu/Classes.esrm.410/Moisture.htm for info
library(readr)
Baw_Baw_soil_moisture <- read_csv("Baw_Baw_soil_moisture_subplots.csv")

Baw_Baw_soil_moisture2 <- na.omit(Baw_Baw_soil_moisture)
Baw_Baw_soil_moisture2$soil_moist_g <- Baw_Baw_soil_moisture2$trayandsoil_moist_g - Baw_Baw_soil_moisture2$tray_weight_g
Baw_Baw_soil_moisture2$soil_dry_g <- Baw_Baw_soil_moisture2$trayandsoil_dry_g - Baw_Baw_soil_moisture2$tray_weight_g
Baw_Baw_soil_moisture2$moisture_g <- Baw_Baw_soil_moisture2$soil_moist_g - Baw_Baw_soil_moisture2$soil_dry_g
Baw_Baw_soil_moisture2$moisture_percent <- (Baw_Baw_soil_moisture2$moisture_g*100)/Baw_Baw_soil_moisture2$soil_dry_g
Baw_Baw_soil_moisture2$wd <- (Baw_Baw_soil_moisture2$soil_moist_g - Baw_Baw_soil_moisture2$soil_dry_g) / Baw_Baw_soil_moisture2$soil_dry_g
Baw_Baw_soil_moisture2$moist_3_g_OD_equivalent <- 3 * (1 + Baw_Baw_soil_moisture2$wd)
Baw_Baw_soil_moisture2$moist_10_g_OD_equivalent <- 10 * (1 + Baw_Baw_soil_moisture2$wd)
bawbawmoisturemeans <- aggregate(Baw_Baw_soil_moisture2[, 11:12], list(Baw_Baw_soil_moisture2$contents), mean)
bawbaw_summary <- Baw_Baw_soil_moisture2[, c("site_subplot","moist_3_g_OD_equivalent","moist_10_g_OD_equivalent")]