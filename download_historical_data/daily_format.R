
root_path = "D:/CIAT/guatemala_marzo_1/"
coordinates = read.table("D:/CIAT/guatemala_marzo_1/coordinates_guatemala.csv", head=T, sep=",")
#coordinates = read.table(paste(root_path,"Municipalities_Soybean_Region.csv",sep=""), head=T, sep=",")
range <- 1:nrow(coordinates)
filenames = c("T.Max","T.Min","Prec","S.Rad")
ranges = read.csv(file =paste(paste(root_path,filenames[[1]],sep=""),paste(paste("/",filenames[[1]],sep=""),".data.observed.csv",sep="" ),sep=""),header=T, row.names=1)
list = list()
date = list()
rows = nrow(ranges)
cols = ncol(ranges)
replaceName <- function(prefix) {
  
  folder_name = switch(  
    prefix,  
    "Prec"="prec",  
    "S.Rad"="sol_rad",  
    "T.Max"="t_max",  
    "T.Min"="t_min")  
}

for (station in range) {
  new_csv = data.frame()[1:rows, 7]
  for (filename in filenames) {
    output_file_name = paste("/",filename,sep="")
    output_path = paste(paste(root_path,filename,sep=""),paste(output_file_name,".data.observed.csv",sep="" ),sep="")
    dataset = read.csv(file =output_path,header=T, row.names=1)
    
    split_dataset = dataset[1:rows,]
    if(filename == "T.Max"){
      new_csv$day = as.numeric(format(strptime(as.character(row.names(split_dataset)), "%m/%d/%Y"),"%d" ))
      new_csv$month = as.numeric(format(strptime(as.character(row.names(split_dataset)), "%m/%d/%Y"),"%m" ))
      new_csv$year = as.numeric(format(strptime(as.character(row.names(split_dataset)), "%m/%d/%Y"),"%Y" ))
    }
    new_csv[replaceName(filename)] = cbind(split_dataset[1])
    
  }
  output_file_name = paste("/",coordinates[station,3],sep="")

  dir.create(paste(root_path,"daily",sep=""), showWarnings = FALSE)
  
  write.table(new_csv,paste(paste(root_path,"daily",sep=""),paste(output_file_name,"_daily.csv",sep="" ),sep = ""), row.names = FALSE, sep=",")
  cat("Done: ")
  cat(coordinates[station,3])
  cat("\n")
  cat("\n")
}


