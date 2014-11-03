# remove all elements for a clean start
rm(list=ls(all=TRUE))

## @knitr LoadData
load("./Data/Raw/25281-0001-Data.rda")
load("./Data/Raw/29282-0001-Data.rda")

ds01 <- da25281.0001
ds02 <- da29282.0001
str(ds01)