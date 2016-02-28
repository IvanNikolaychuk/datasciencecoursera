corr <- function(directory, threshold = 0) {
        files = list.files(directory)
        
        correlation = numeric()
        
        
        for (i in 1:length(files)) {
                file = files[i]
                path = paste(directory, file, sep = "/")
                
                data = read.csv(path)
      
                condition = !is.na(data["sulfate"]) &
                        !is.na(data["nitrate"])
                validMesures = subset(data, condition)
                
                if (nrow(validMesures) > threshold) {
                        correlation <-
                                c(correlation,
                                  cor(validMesures["sulfate"], validMesures["nitrate"]))
                }
                
        }
        
        correlation
        
}
