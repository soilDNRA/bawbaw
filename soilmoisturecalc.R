library(readr)
Baw_Baw_soil_moisture <- read_csv("2018-04-23_Baw_Baw_soil_moisture.csv")
Baw_Baw_soil_moisture$soil_moist_g <- Baw_Baw_soil_moisture$trayandsoil_moist_g - Baw_Baw_soil_moisture$tray_weight_g
Baw_Baw_soil_moisture2 <- na.omit(Baw_Baw_soil_moisture) 
Baw_Baw_soil_moisture2$soil_dry_g <- Baw_Baw_soil_moisture2$trayandsoil_dry_g - Baw_Baw_soil_moisture2$tray_weight_g
bawbawmoisturemeans <- aggregate(Baw_Baw_soil_moisture2[, 6:7], list(Baw_Baw_soil_moisture2$contents), mean)
