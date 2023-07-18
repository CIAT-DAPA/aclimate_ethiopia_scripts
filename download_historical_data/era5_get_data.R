library("remotes")

install_github("agrdatasci/ag5Tools", build_vignettes = TRUE, build = FALSE)
library(ag5Tools)

##Examples


## Download Solar Radiation ##




ag5Tools::ag5_download(variable = "solar_radiation_flux",
                       #statistic = "night_time_minimum",
                       day = "all",
                       month = "all",
                       year = 2021,
                       path = "D:/OneDrive - CGIAR/Desktop/solar_radiation_flux/" # Folder to save the data
)





## Download Tmin ##




ag5Tools::ag5_download(variable = "2m_temperature",
                       statistic = "night_time_minimum",
                       day = "all",
                       month = "all",
                       year = 2021,
                       path = "D:/OneDrive - CGIAR/Desktop/Tmin/" # Folder to save the data
)




## Download Tmax ##
ag5Tools::ag5_download(variable = "2m_temperature",
                       statistic = "day_time_maximum",
                       day = "all",
                       month = "all",
                       year = 2021,
                       path = "D:/OneDrive - CGIAR/Desktop/Tmax/" # Folder to save the data
)