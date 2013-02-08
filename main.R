#################################
#
# R-DAX-logo
#
################################

# >>> Change this path to where your main.R file is located
# NB: if you are on a windows machine, replace backslashes with forwardslashes.
setwd("C:/Users/mindow/Dropbox/code/R-DAX-logo") # git AND dropbox. I know, I know...
# <<<

# >>> Initialize (load libraries, download data)
source("scripts/init.R")
# <<<

# >>> Prepare data (data frames "index" and "gdp")
source("scripts/prepare.R")
# <<<

# >>> Estimate GARCH(1,1) for the returns series
source("scripts/garch.R")
# <<<

# >>> Find periods of recovering growth (see explanation in scripts/rec_growth.R)
source("scripts/req_growth.R")
# <<<

# >>> Prepare final data frame (ggplot-friendly)
source("scripts/prepare_final.R")
# <<<

# >>> Paint me like one of your french models
source("configs/ggplot_config.R") 
source("scripts/artsy.R")
# <<<
