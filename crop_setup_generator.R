### Crop setup generator - DSSAT Aclimate - EDACaP
# Author: Rodriguez-Espinoza J. Mesa-Diez J.
# https://github.com/jrodriguez88/
# 2022

library(tidyverse)
library(data.table)
library(raster)
library(jsonlite)
library(sf)


### Weather stations EDACaP - 

#Base URL
json_url <- "https://webapi.aclimate.org/api/Geographic/61e59d829d5d2486e18d2ea9/json"

json_raw <- jsonlite::fromJSON(json_url)
#glimpse(json_raw)

## Raw data - EDACaP json
raw_tb <- json_raw %>% tibble() 

# Regions Ethiopia
regions <- raw_tb$municipalities %>% map(tibble) %>% set_names(raw_tb$name) %>% 
  bind_rows(.id = "region") %>% rename(id_region = id, name_region = name)


### table of edacap weather stations
edacap_stations <- raw_tb$municipalities %>% map(tibble) %>% bind_rows() %>% pull(weather_stations) %>% 
  set_names(regions$id_region) %>% map(tibble) %>% bind_rows(.id = "id_region") %>% 
  dplyr::select(-ranges) %>% 
  right_join(regions %>% dplyr::select(-weather_stations)) %>% drop_na()


### table of soils
soil_file <- "base_data/soil/SOIL.SOL"
raw_file <- soil_file %>% read_lines()
target_line <- raw_file %>% str_detect(pattern = "@SITE") %>% which()

id_soil <- raw_file[target_line -1 ] %>% map(~str_split(.x, pattern = " ")) %>% 
  map(~.x %>% map_chr(1)) %>% map_chr(1) %>%  enframe(name = NULL, value = "id_soil")

id_info <- target_line %>% map(~fread(soil_file, skip = .x, nrows = 1)) #%>% 
#                                 dplyr::select(V1:V5)  %>% 
#                                 mutate(across(.fns = as.character))) %>% 
#  bind_rows() %>% set_names(c("site", "country", "lat", "lon", "scs"))

## set to extract soil data from SOIL.SOL
nlines <- c((target_line-1) %>% diff, (length(raw_file)+1) - (tail(target_line, 1)-1)) 
leng_tb <- id_info %>% map_dbl(length)


# List of EDACaP Soils
list_soils <-  map2((target_line-2), (nlines-1), ~read_lines(file = soil_file, skip = .x, n_max = .y))


## Discard wrong format 
discard <- c(which(leng_tb >7), igual5 <- which(leng_tb  == 5))

which(leng_tb == 7)
id_info[which(leng_tb == 7)] <- id_info[which(leng_tb == 7)] %>% map(~.x %>% dplyr::select(-V7))

id_info[discard] <- list(tibble(V1=NA, V2 =NA, V3 =NA, V4=NA, V5=NA, V6=NA))


##Extract by variable

site <- id_info %>% map_chr(~.x$V1 %>% as.character)
country <- id_info %>% map_chr(~.x$V2 %>% as.character)
lat <- id_info %>% map_chr(~.x$V3 %>% as.character)
lon <- id_info %>% map_chr(~.x$V4 %>% as.character)
scs <- id_info %>% map_chr(~.x$V5 %>% as.character)
other <- id_info %>% map(~.x %>% dplyr::select(-c(V1:V5)) %>% 
                           mutate(across(.fns = as.character))) %>% bind_rows()

soils_edacap1 <- tibble(site, country, lat, lon, scs, other = other$V6) %>% 
  mutate(soil_name = paste(scs, other))

### table of edacap soils
edacap_soils <- bind_cols(id_soil, soils_edacap1) %>% 
  mutate(across(.cols = c(lat, lon), .fns = as.numeric))

### Transform to Spatial Points --- 
sp_wth <- SpatialPoints(dplyr::select(edacap_stations, longitude, latitude))
sp_soil <- SpatialPoints(dplyr::select(drop_na(edacap_soils), lon, lat))

### Calculate minimum Euclidean distance
nearest_soil <- apply(gDistance(sp_soil, sp_wth,  byid = TRUE), 1, which.min)
edacap_env_set1 <- edacap_stations %>% bind_cols(edacap_soils %>% slice(nearest_soil))



##############################
### Crops and Cultivars
crop <- "wheat"
cultivar <- list(tibble(cultivar = list(c("999991","MINIMA"), c("999992","MAXIMA"), c("DFAULT", "DEFAULT"))))


### Base data ---Shared to Steven --  Final selected soils ---classify by name -- 12 classes
base_data  <- edacap_env_set1 %>% dplyr::select(id, latitude, longitude, id_soil, soil_name) %>% 
  mutate(crop = "Wheat") #%>% write_csv(file = "set_base_edacap.csv")



### Final settings for Wheat crop

soil_final <- list_soils %>% set_names(pull(id_soil)) %>% 
  enframe(name = "id_soil", value = "data_soil")

cultivar_list <- list(
  tibble(cultivar = list(
    c("999991","MINIMA"), 
    c("999992","MAXIMA"), 
    c("DFAULT", "DEFAULT"))) %>% 
    mutate(cultivar_name = c("Low maturity", "High maturity", "Medium maturity")))  ## Check names



## Info Shared by Steven -- Platform's ID's
#Soil
id_soil_final <- read_csv("base_data/setups/id_soils.csv")
#Cultivar
id_cultivar_final <- read_csv("base_data/setups/id_cutivars.csv")

### Suggested order ID's names 
#// 0 = Weather station
#// 1 = Cultivar
#// 2 = Soil
#// 3 = Days


## Calculate elevation - AgroClimR-2022
#https://github.com/jrodriguez88/agroclimR
#function to get elevation from # https://www.opentopodata.org/#public-api
# lan & lon in decimal degrees
# dataset c("aster30m", "strm30", "mapzen", ...)

get_elevation <- function(lat, lon, dataset = "aster30m"){
  
  elev_raw <- fromJSON(
    paste0("https://api.opentopodata.org/v1/", dataset, "?locations=", lat, ",", lon)
  )
  
  return(elev_raw$results$elevation)
  
  
}


base2 <- base_data %>% left_join(id_soil_final) %>% left_join(soil_final) %>% mutate(cultivar = cultivar_list) %>%
  mutate(elevetion = map2(latitude, longitude, ~get_elevation(.x, .y)))

planting_details_file <- read_csv("base_data/setups/planting_details.csv")



#######

###Function to create coordinate data frame - 

cordinate_tb <- function(lat, lon, elev, id_soil, cultivar){
  
  var <- cultivar[1]
  var_name <- cultivar[2]
  
  tibble(name = c("lat", "long", "elev", "id_soil", "var_cul", "cul_name"),
         value = c(lat, lon, elev, id_soil, var, var_name))
  
}

### Final dataframe setups
set_final_edacap_wheat <- base2 %>% unnest(elevetion) %>% rename(elevation =  elevetion) %>% unnest(cultivar) %>% 
  left_join(id_cultivar_final) %>%
  mutate(id_set = paste(id, id_cultivar_final, id_soil_final, 3, sep = "_"),
         path_folder = paste0("edacap_set/", id_set)) %>%
  mutate(pd_file = pmap(list(latitude, longitude, elevation, id_soil, cultivar), .f = cordinate_tb))


tt <- set_final_edacap_wheat  

gen_files <- list.files("base_data/crop/", full.names = T, pattern = "ECO|SPE|CUL")
setting_files <- list.files("base_data/setups/", full.names = T, pattern = "planting_details.csv")

# soil_files <- list.files(dir_inputs_soil, full.names = T, pattern = ".SOL$")

dir.create("edacap_set/")  
map(tt$path_folder, dir.create)    

map(tt$path_folder, ~file.copy(c(gen_files, setting_files), .x))

map2(tt$data_soil, tt$path_folder, ~write_file(x = .x, file = paste0(.y, "/SOIL.SOL")))

map2(tt$data_soil, tt$path_folder, ~write_lines(x = .x, file = paste0(.y, "/SOIL.SOL")))

map2(tt$pd_file, tt$path_folder, ~write_csv(x = .x, file = paste0(.y, "/coordenadas.csv")))








