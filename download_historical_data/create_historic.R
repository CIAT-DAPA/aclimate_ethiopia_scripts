variable = "Prec"
root_path = "D:/CIAT/guatemala_marzo_1/"
output_file_name = paste("/",variable,sep="")
coordinates = read.table(paste(root_path,"coordinates_guatemala.csv",sep=""), head=T, sep=",")
#coordinates = read.table("D:/CIAT/dataR/agera5/angola/new_angola/test/names.csv", head=T, sep=",")
range <- 1:nrow(coordinates)
output_path = paste(paste(root_path,variable,sep=""),paste(output_file_name,".data.observed.csv",sep="" ),sep="")
#Create Final data concatenate all files

regex = "^.*.data.observed.*.csv$" 
concatAllData <- function(){
  filenames <- list.files(paste(root_path,variable,sep=""), pattern=regex, full.names=TRUE)
  
  dataset <- data.frame()
  
  
  for (i in range) {
    name <- gsub(" ", "", coordinates[i,3])
    dataset[name] = character()
  }
  
  for (file in filenames) {
    csv <- read.csv(file =file,header=T, row.names=1)
    
    dataset = rbind(dataset, csv)
  }
  
  
  write.table(dataset,output_path, row.names = TRUE, sep=",", col.names=NA)
}

concatAllData()



# Create Historical Climate

createHistoricalCliamte <- function(end_year,start_year) {
  final_dataset = read.csv(file =output_path,header=T, row.names=1, sep=",")
  
  historical_climate = data.frame(year=character(),month = character())
  for (x in range) {
    name <- gsub(" ", "", coordinates[x,3])
    historical_climate[name] = character()
  }
  
  year_diff = end_year-start_year

  year_range <- 1:year_diff
  for (year in year_range) {
    count_year = year+(start_year-1)
    for (month in 1:12) {
      list = rep(0, nrow(coordinates)+2) 
      list[1] = as.numeric(count_year)
      list[2] = as.numeric(month)
      
      day_count = 0 
      for (day in 1:31) {
        for (coord in 1:nrow(coordinates)) {
          if(!is.na(final_dataset[paste0(month,"/",day,"/",count_year),coord])){

            list[coord+2] = final_dataset[paste0(month,"/",day,"/",count_year),coord] + list[[coord+2]]
          }
        }
        if(!is.na(final_dataset[paste0(month,"/",day,"/",count_year),1])){
          day_count = day_count + 1
        }
      }
      if(variable != "Prec"){
        for (coord2 in 1:nrow(coordinates)) {
          list[coord2+2] = list[[coord2+2]] / day_count
        }
      }
      
      historical_climate = rbind(historical_climate, list)
    }
    cat(count_year)
    cat("\n")
  }
  
  array = c()
  
  for (coor in 1:nrow(coordinates)) {
    array = c(array,gsub(" ", "", coordinates [coor,3]))
  }
  names(historical_climate)[1:(nrow(coordinates)+2)] = c( "year", "month",array)
  
  
  
  write.table(historical_climate,paste(paste(root_path,variable,sep=""),paste(output_file_name,".Import-Historical-Climate.csv",sep="" ),sep = ""), row.names = FALSE, sep=",")
  
}



#Un Año final mas al deseado
createHistoricalCliamte(2023,2014)