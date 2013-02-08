#################################
#
# R-DAX-logo
#
# NB: do not run this script individually. Run ../main.R instead
#
# Customizations:
# - you can change the index (default = DAX) by selecting some other ticker from finance.yahoo.com
# - you can change the country prefix if you like. This is a list of all possible prefixes:
################################


# >>> Check if all required libraries are installed
req_packages = c("ggplot2", "timeSeries", "tseries", "grDevices","mFilter")
for(i in 1:length(req_packages)){
    if(req_packages[i] %in% rownames(installed.packages()) == FALSE){
        install.packages(req_packages[i],repos='http://cran.us.r-project.org')
    }
    library(package = req_packages[i],character.only = TRUE)
}
# <<<

# >>> Change these variables if you are interested in other indices/countries
yahoo_index <- "GDAXI" # drop the ^
GDP_prefix  <- "DE"
# <<<

# >>> Check if you need to download data
if (!file.exists("data-src/INDEX.csv")){
    d <- as.numeric(format(Sys.time(),"%m"))-1;
    e <- as.numeric(format(Sys.Date(),"%d"))
    f <- as.numeric(format(Sys.Date(),"%Y"))
    link <- paste("http://ichart.finance.yahoo.com/table.csv?s=%5E",yahoo_index,"&d=",d,"&e=",e,"&f=",f,"&ignore=.csv",sep="")
    download.file(link,"data-src/INDEX.csv")
}
if (!file.exists("data-src/GDP.csv")){
    link = "http://vaitekunas.com/wp-content/uploads/2013/02/GDP.csv" # I don't really want to learn eurostat API just for this one file.
    download.file(link,"data-src/GDP.csv")
}
# <<<
