#################################
#
# R-DAX-logo
#
# NB: do not run this script individually. Run ../main.R instead
#
################################

# >>> Prepare final data frame (make it shiny)

    time_series <- lm(index["Returns"]$Returns~1)$resid # removing the mean. One way of doing it.
    tssq        <- time_series^2                        # squared residuals
    n           <- length(tssq)                         # number of observations
    cvar        <- rep(var(time_series),n)              # vector of to-be-estimated conditional variances
    
    for(i in 2:n){ # Fitted conditional variances via GARCH(1,1)
        cvar[i] <- var(time_series)*(1-beta-gamma)+tssq[i-1]*beta+cvar[i-1]*gamma 
    }
    
    alpha   <- 0.05                                  # significance level
    drd     <- c(2281:n)                             # which part of the dataset should be visualized
    m       <- max(drd)-min(drd)+1                   # true length of the visualization set
    y       <- time_series[drd]                      # part of the time series to be visualized
    yt      <- rep("positive",m)                     # all returns are presumed to be positive ...
    yt[which(y<0)] <- "negative"                     # ... until proven otherwise    
    CI      <- qnorm(1-(alpha)/2)*sqrt(cvar[drd])    # half of the 1-alpha% confidence interval width 
    ucvary  <- y[which(y-(mean(y)-CI) < 0)]          # negative values of y outside the 1-alpha% CI
    ucvarx  <- which(y-(mean(y)-CI) < 0)             # periods where negative values of y lie outside the 1-alpha% CI
    ocvary  <- y[which(y-(mean(y)+CI) > 0)]          # positive values of y outside the 1-alpha% CI
    ocvarx  <- which(y-(mean(y)+CI) > 0)             # periods where positive values of y lie outside the 1-alpha% CI
    out_val <- rep(0,m)
    out_val[c(ucvarx,ocvarx)] <- 1                   # number of periods that are actually outside CI. Should be close to alpha% 
    

    graph_data <- data.frame(matrix(NA,ncol=11,nrow=m))
    colnames(graph_data)            <- c("Periods","Date","Index","Recovery","Returns","Return_type","cVar","cSd","uCI","oCI","Outside")
    graph_data["Periods"]           <- c(1:m)
    graph_data["Date"]              <- index["Date"]$Date[drd]
    graph_data["Index"]             <- index["Price"]$Price[drd]
    graph_data["Recovery"]          <- index["req_growth"]$req_growth[drd]
    graph_data["Returns"]           <- y
    graph_data["Return_type"]       <- yt
    graph_data["cVar"]              <- cvar[drd]
    graph_data["cSd"]               <- sqrt(cvar[drd])
    graph_data["uCI"]               <- mean(y)-CI
    graph_data["oCI"]               <- mean(y)+CI
    graph_data["Outside"]           <- out_val

    graph_data_outside <- graph_data[graph_data["Outside"]$Outside==1,]
# <<<



