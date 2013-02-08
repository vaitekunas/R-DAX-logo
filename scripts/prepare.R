#################################
#
# R-DAX-logo
#
# NB: do not run this script individually. Run ../main.R instead
#
################################

# >>> Last check
if(!file.exists("data-src/INDEX.csv") || !file.exists("data-src/GDP.csv")){stop("Data missing. Cannot proceed!")}
# <<<

# >>>> Read files

    # >>> INDEX
    index <- data.frame(read.csv("data-src/INDEX.csv",sep=","))
    index <- index[c("Date","Adj.Close")] # You can't always have what you want ... but you might get what you need.
    index <- index[with(index, order(Date)),] # Sort by date, ascending
    index["Returns"] <- c(0,index[2:nrow(index),2] - index[1:(nrow(index)-1),2]) # First differences
    colnames(index) <- c("Date","Price","Returns")
    
    # -> Some descriptive stats
        par(mfrow=c(1,2))
        plot.ts(index["Returns"],main=paste(yahoo_index,"Returns, Variance growth"),ylab="Returns",xlab="Periods") # Stylized fact nr. 1: Variance tends to cluster. If this were a soundwave, it would sound like a screem.
        hist(index["Returns"]$Returns,main=paste(yahoo_index,"Returns, histogram"),ylab="Frequency",xlab="Returns")
        
        summary(index["Returns"])
        # summary output:     
        # Min.   :-523.980  
        # 1st Qu.: -24.300  
        # Median :   2.600  
        # Mean   :   1.092  Stylized fact nr. 2: mean returns (ok, an index is not "returns" per se, but close enough) are near zero.
        # 3rd Qu.:  30.793  
        # Max.   : 518.140  
        
        jarque.bera.test(index["Returns"]) # Stylized fact nr. 3: Returns are normally distributed
        # Jarque-Berra output:
        # data:  index["Returns"] 
        # X-squared = 0.375, df = 2, p-value = 0.829 
    # <-
    
    # <<<

    # >>> GDP
    gdp <- data.frame(read.csv("data-src/GDP.csv",sep=",")) # Read me
    gdp <- gdp[c("TIME","GEO","Value")] # Throw out the thrash
    gdp <- gdp[which(gdp["GEO"] == GDP_prefix & gdp["Value"]$Value != ":"),] # Focus on what's important
    gdp <- gdp[c("TIME","Value")] # We no longer need you
    colnames(gdp) <- c("Date","GDP")
    
    gdp["GDP"] <- gsub(" ", "", gdp["GDP"]$GDP) # Eurostat data has .. spaces
    gdp["GDP"] <- as.numeric(gdp["GDP"]$GDP)
    gdp["Date"] <- gsub("Q1", "-03-31", gdp["Date"]$Date) # Turn quarters into actual dates
    gdp["Date"] <- gsub("Q2", "-06-30", gdp["Date"]$Date) # --
    gdp["Date"] <- gsub("Q3", "-09-30", gdp["Date"]$Date) # --
    gdp["Date"] <- gsub("Q4", "-12-31", gdp["Date"]$Date) # --
    gdp["Date"] <- as.Date(gdp["Date"]$Date)

    gdp["Growth"] <-  c(0,gdp[2:nrow(gdp),"GDP"] - gdp[1:(nrow(gdp)-1),"GDP"])
    gdp["Growth_rate"] <-  c(0,round((gdp[2:nrow(gdp),"Growth"]/gdp[1:(nrow(gdp)-1),"GDP"])*100,2))
    gdp["Growth_qq"] <-  c(rep(0,4),gdp[5:nrow(gdp),"GDP"] - gdp[1:(nrow(gdp)-4),"GDP"]) # Growth quarter-wise (i.e. Q1 to Q1, etc)
    gdp["Growth_rate_qq"] <-  c(rep(0,4),round((gdp[5:nrow(gdp),"Growth_qq"]/gdp[1:(nrow(gdp)-4),"GDP"])*100,2)) # ( -- )
    #NB: *_qq variables don't make much sense, since the data is already seasonally adjusted

    gdp["Recession"] = 0
    for(i in 2:nrow(gdp)){
        if(gdp[i-1,"Growth_rate"] < 0 && gdp[i,"Growth_rate"] < 0){
            gdp[i,"Recession"] <- 1    
        }
    }

    # -> Some descriptive stats
        par(mfrow=c(1,1))
        cat(paste("There were",sum(gdp["Recession"]),"recession quarters in",GDP_prefix,"since",min(gdp["Date"]$Date)))
        # There were 5 recession quarters in DE since 1998-01-01
        
        summary(gdp["Growth_rate"])
        # summary output:    
        # Min.   :-3.8400  
        # 1st Qu.: 0.2000  
        # Median : 0.6000  
        # Mean   : 0.5502  
        # 3rd Qu.: 1.0000  
        # Max.   : 2.1600  
    # <-

    # <<<

# <<<<


