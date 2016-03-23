## This method is designed to cache data that we read, so as to reduce time for reading the same data several times.
## This type of cache wasn't designed to be flexible: you can't put in it everything you want.
## The only way for you to update cache - is to call {updateTrainingLables} function, that
## will simply grab data from the hardcoded file in downloaded stcructure.
## As we have fixed folder structure in our assignment, I consider this type of cache to be enough.
##
## Note: If you do change anything in a downloaded folder structure, don't use this cache.
## This should also be called after downloading all assignment data, as {pathToToTestFolder} variable,
## (that is initialized only after downloading data) is used here.
getTestFolderCache <- function() {
        trainingLables <- NULL
        trainingSet <- NULL
        trainingSubject <- NULL
        
        pathToToTestFolder <-
                paste(pathToResearchData, 'test', sep = '/')
        
        getTrainingLables <- function() {
                if (is.null(trainingLables)) {
                        print("Reading data, pushing it to cache..")
                        updateTrainingLables()
                }
                invisible(trainingLables)
                
        }
        
        
        ## Designed to read data from y_test.txt (that stands for training lables)
        ## and push this data into cache.
        ## NOTE: every method call updates cache with table you read.
        updateTrainingLables <- function() {
                trainingLables <<-
                        read.table(paste(pathToToTestFolder, 'y_test.txt',  sep = '/'))
              
        }
        
        getTrainingSet <- function() {
                if (is.null(trainingSet)) {
                        print("Reading data, pushing it to cache..")
                        updateTrainingSet()
                }
                invisible(trainingSet)
                
        }
        

        updateTrainingSet <- function() {
                trainingSet <<-
                        read.table(paste(pathToToTestFolder, 'x_test.txt',  sep = '/'), encoding = getOption("encoding"))
        }
        
        
        getTrainingSubject <- function() {
                if (is.null(trainingSubject)) {
                        print("Reading data, pushing it to cache..")
                        updateTrainingSubject()
                }
                invisible(trainingSubject)
                
        }
        

        updateTrainingSubject <- function() {
                print(paste(pathToToTestFolder, 'subject_test.txt',  sep = '/'))
                trainingSubject <<-
                        read.table(paste(pathToToTestFolder, 'subject_test.txt',  sep = '/'), encoding = getOption("encoding"))
        }
        
        list(getTrainingLables = getTrainingLables,
             updateTrainingLables = updateTrainingLables, 
             getTrainingSet = getTrainingSet,
             updateTrainingSet = updateTrainingSet,
             getTrainingSubject = getTrainingSubject,
             updateTrainingSubject = updateTrainingSubject)
}

## Same as {testFolderCache}, but for traing folder.
## This kind of design is bad: {trainFolderCache} and {testFolderCache}
## have a lot of common things, and it's better to unify them.
## But deadline is too close :)
## Don't repeat this kind of design anyway.
getTrainFolderCache <- function() {
        trainingLables <- NULL
        trainingSet <- NULL
        trainingSubject <- NULL
        
        pathToToTrainFolder <-
                paste(pathToResearchData, 'train', sep = '/')
        
        getTrainingLables <- function() {
                if (is.null(trainingLables)) {
                        print("Reading data, pushing it to cache..")
                        updateTrainingLables()
                }
                invisible(trainingLables)
                
        }
        
        updateTrainingLables <- function() {
                trainingLables <<-
                        read.table(paste(pathToToTrainFolder, 'y_train.txt',  sep = '/'), encoding = getOption("encoding"))
        }
        
        
        getTrainingSet <- function() {
                if (is.null(trainingSet)) {
                        print("Reading data, pushing it to cache..")
                        updateTrainingSet()
                }
                invisible(trainingSet)
                
        }
        
        updateTrainingSet <- function() {
                trainingSet <<-
                        read.table(paste(pathToToTrainFolder, 'x_train.txt',  sep = '/'))
        }
        
        
        getTrainingSubject <- function() {
                if (is.null(trainingSubject)) {
                        print("Reading data, pushing it to cache..")
                        updateTrainingSubject()
                }
                invisible(trainingSubject)
                
        }
        
        
        updateTrainingSubject <- function() {
                
                trainingSubject <<-
                        read.table(paste(pathToToTrainFolder, 'subject_train.txt',  sep = '/'), encoding = getOption("encoding"))
        }
        
        list(getTrainingLables = getTrainingLables,
             updateTrainingLables = updateTrainingLables, 
             getTrainingSet = getTrainingSet,
             updateTrainingSet = updateTrainingSet,
             getTrainingSubject = getTrainingSubject,
             updateTrainingSubject = updateTrainingSubject)
}