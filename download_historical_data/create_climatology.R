root_path = "D:/OneDrive - CGIAR/Desktop/ethiofalla/"
csv_path = "D:/OneDrive - CGIAR/Desktop/ethiofalla/names.csv"
#csv_path = paste(root_path,"Municipalities_Soybean_Region.csv",sep="")

csv <- read.csv(file =csv_path)
range <- 1:nrow(csv)
filenames = c("T.Max","T.Min","Prec","S.Rad")

year_diff = 2021-1981

year_range <- 1:year_diff

replaceName <- function(prefix) {
  
  folder_name = switch(  
    prefix,  
    "Prec"="prec",  
    "S.Rad"="sol_rad",  
    "T.Max"="t_max",  
    "T.Min"="t_min")  
}

createClimatology <- function(){
  
  climatology = data.frame(measure=character(),month = character())
  for (x in range) {
    name <- gsub(" ", "", csv[x,3])
    climatology[name] = character()
  }
  
  
  for (filename in filenames) {
    output_file_name = paste("/",filename,sep="")
    output_path = paste(paste(root_path,filename,sep=""),paste(output_file_name,".Import-Historical-Climate.csv",sep="" ),sep="")
    
    data = read.csv(file =output_path,header=T)
    all_month = matrix(0,12,nrow(csv)+2)
    data_matrix = data.frame()
    count = 1
    for (year in year_range) {
      for (month in 1:12) {
        all_month[month,1] = replaceName(filename)
        all_month[month,2] = as.numeric(month)
        for (coord in range) {
          if(!is.na(data[count,coord+2])){
            all_month[month,coord+2] = data[count,coord+2] + as.double(all_month[month,coord+2])
          }
        }
        count = count + 1
      }
      
    }
    for (row in 1:nrow(all_month)) {
      for (col in 3:ncol(all_month)) {
        all_month[row,col] =  as.double(all_month[row,col]) / year_diff
      }
    }
    data_matrix = as.data.frame(all_month)
    climatology = rbind(climatology, data_matrix)
    cat("Done: ")
    cat(filename)
    cat("\n")
    cat("\n")
    
  }
  
  array = c()
  
  for (coor in 1:nrow(csv)) {
    array = c(array,gsub(" ", "", csv [coor,3]))
  }
  
  names(climatology)[1:ncol(climatology)] = c( "measure", "month",array)
  
  
  write.table(climatology,paste(root_path,"Import-Climatology.csv",sep = ""), row.names = FALSE, sep=",")
}

createClimatology()
