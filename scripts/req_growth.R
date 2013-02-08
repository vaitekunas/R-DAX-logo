#################################
#
# R-DAX-logo
#
# NB: do not run this script individually. Run ../main.R instead
#
################################

# Definition of recovering growth:
#
# Recovering growth, is such a development of a time series, where current position is higher than the previous
# maximum. If such a point is not reached, time series is in recovering growth or recessive decline.
# 
# e.g.: the DAX index reached 2074.4 points on 1993-10-25 it was in recovering decline until 1993-11-02 
# when it reached 2095.6 points, surpasing previous maximum. 
# Currently, the DAX is in recovering growth since 2007-07-16 (8105.69 points VS 7583.39 (2013-02-07))

# >>> Main function
recovering_growth <- function(price_vec){
    growth = rep(0,times=length(price_vec))
    current_max = 0
    for(i in 1:length(price_vec)){
        if(price_vec[i] >= current_max){
            current_max <- price_vec[i]
            growth[i] = 1
        }
    }
    
    growth # return growth vector
}
# <<<

# >>> Generating variables
index["req_growth"] <- recovering_growth(index["Price"]$Price)
gdp["req_growth"]   <- recovering_growth(gdp["GDP"]$GDP)
# <<<
