pollutantmean <- function(directory, pollutant, id = 1:332) {
        regions <- length(id)
        
        sumOfAvg <- 0
        measurements <- 0
        
        for (index in 1:regions) {
                currentId = id[[index]]
                file = paste(appendInBeggining(currentId), "csv", sep = ".")
                path = paste(directory, file, sep = "/")
                
                data = read.csv(path)
                pollutantData = data[pollutant]
                
                clearedPollutantData = pollutantData[!is.na(pollutantData)]
                
                measurements <-
                        measurements + length(clearedPollutantData)
                
                sumOfAvg = sumOfAvg + sum(clearedPollutantData)
        }
        
        sumOfAvg / measurements
}