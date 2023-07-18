
root_path = "D:/CIAT/guatemala_marzo_1/" # CHANGE THIS Path for save information
csv_path = paste(root_path,"coordinates_guatemala.csv",sep="") # CHANGE THIS CSV format Lon,Lat,Name(Municipality)

## START GET data with CSV of coordinates ##


library("remotes")

install_github("ropensci/chirps", build_vignettes = TRUE, build = FALSE)
library("chirps")


getPresipitationData <- function(csv_path) {
  csv <- read.csv(file =csv_path)
  range <- 1:nrow(csv)
  vec_lat <- c()
  vec_long <- c()
  
  for (i in range) {
    latd <- csv[[2]][i]
    long <- csv[[1]][i]
    vec_lat <- c(vec_lat,latd)
    vec_long <- c(vec_long,long)
    
  }
  lonlat <- data.frame(lon = vec_long, lat = vec_lat)
  dates <- c("1981-01-01", "1981-12-31") # CHANGE THIS DATES
  data <- get_chirps(lonlat, dates, server = "ClimateSERV" )
  
  data
}
chirps_data = getPresipitationData(csv_path)

## END GET data with CSV of coordinates ##


#Create Final format for import data



createFinalFileFromChirps <- function(chirps_data){
  csv_names <- read.csv(file =csv_path)
  range <- 1:nrow(csv_names)
  frame_rows = chirps_data[chirps_data$id == 1, ]
  dataset = data.frame(matrix(NA, nrow =nrow(frame_rows) , ncol = nrow(csv_names)))
  
  
  for (row in range) {
    new_data = chirps_data[chirps_data$id == row, ]
    if(row == 1){
      rownames(dataset) = format(strptime(as.character(new_data$date), "%Y-%m-%d"),"%m/%d/%Y" )
    }
    dataset[row] = new_data$chirps
  }
  array = c()
  
  for (coor in 1:nrow(csv_names)) {
    array = c(array,gsub(" ", "", csv_names [coor,3]))
  }
  
  names(dataset)[1:nrow(csv_names)] = array
  
  
  variable = "Prec"
  output_file_name = paste("/",variable,sep="")
  output_path = paste(paste(root_path,variable,sep=""),paste(output_file_name,".data.observed.csv",sep="" ),sep="")
  write.table(dataset,output_path, row.names = TRUE, sep=",", col.names=NA)
}

createFinalFileFromChirps(chirps_data)

