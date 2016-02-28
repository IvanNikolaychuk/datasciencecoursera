appendInBeggining <-
        function(val,
                 charsExpected = 3,
                 appendage = 0) {
                charsNeeded = charsExpected - nchar(val)
                
                result = ""
                
                if (charsNeeded == 0) {
                        # nothing to do
                        return (paste(result, val, sep = ""))
                        
                }
                
                for (i in 1:charsNeeded) {
                        result <- paste(result, appendage , sep = "")
                }
                
                paste(result, val, sep = "")
        }