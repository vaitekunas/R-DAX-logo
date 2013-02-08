#################################
#
# R-DAX-logo
#
# NB: do not run this script individually. Run ../main.R instead
#
################################

# >>> GARCH(p,q) function
garch <- function(time_series,b,g,k){ # GARCH(b,g)
    # b = number of lagged squared residuals
    # g = number of lagged conditional variances
    
    time_series <- lm(time_series~1)$resid  # removing the mean of the time series
    beta        <- rep(0,times = b)         # parameters for the lagged residuals
    gamma       <- rep(0,times = g)         # parameters for the lagged variances
    uvar        <- var(time_series)         # Variance targetting (unconditional long-term variance)
    
    # >> there's a fine line, between a minimum and a maximum. (econometric jokes:D See, a minus ("-") can be seen as a short line, and if you put a minus before mini... oh forget it)
    MaxLik <- function(time_series,b,g,parameters,uvar){ # Maximum-Likelihood function
        
        # -- Separate parameters
        beta    <- parameters[1:b]
        gamma   <- parameters[(b+1):length(parameters)]
        # --
        
        if(any(c(beta,gamma) < 0) | beta+gamma>=1) return(Inf) # Either negative variance or unit-roots. Iz baad, real bad.
        
        # -- Generating some important variables
        n    <- length(time_series)             # number of observations
        tssq <- time_series^2                   # squared residuals
        cvar <- rep(var(time_series),times=n)   # conditional variances. All starting values are equal to the estimated unconditional variance
        # --
        
        # -- Likelihood!
        for(i in (max(b,g)+1):n){ 
            cvar[i] <- uvar*(1-sum(beta)-sum(gamma)) + tssq[(i-b):(i-1)]%*%beta + cvar[(i-g):(i-1)]%*%gamma
        }
        
        log_likelihood <- sum(-0.5*(log(2*pi)+log(cvar[2:n])+tssq[2:n]/cvar[2:n])) # constant could be omitted
        # --
        
        return(-log_likelihood)    
    }
    # <<
    
    optimum <- nlm(f=MaxLik, p=c(beta,gamma), hessian=TRUE, print.level=1, iterlim=250, 
                   time_series=time_series, b=b, g=g, uvar=uvar)                      
    
    optimum$estimate # return estimated parameters    
}
# <<< 

# >>> Estimating GARCH(1,1)
    b           <- 1
    g           <- 1
    time_series <- index["Returns"]$Returns
    
    estimates   <- garch(time_series=time_series,b=b,g=g)
    beta        <- estimates[1]
    gamma       <- estimates[2]
# <<<

