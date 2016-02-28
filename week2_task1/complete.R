complete <- function(directory, id = 1:332) {
        regions <- length(id)
        
        completeCases <- 0
        comleteFrame <- data.frame(id = numeric(regions), nobs = numeric(regions))
        
        for (index in 1:regions) {
                currentId = id[[index]]
                file = paste(appendInBeggining(currentId), "csv", sep = ".")
                path = paste(directory, file, sep = "/")
                
                data = read.csv(path)
                condition = !is.na(data["sulfate"]) & !is.na(data["nitrate"])
                completed = nrow(subset(data,condition))
                comleteFrame[index, 1] = currentId
                comleteFrame[index, 2] = completed
        }
        
        comleteFrame
}