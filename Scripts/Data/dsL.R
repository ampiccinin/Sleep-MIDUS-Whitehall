# remove all elements for a clean start
rm(list=ls(all=TRUE))

## @knitr LoadData
load("./Data/Raw/25281-0001-Data.rda")
load("./Data/Raw/29282-0001-Data.rda")

ds01 <- da25281.0001
ds02 <- da29282.0001
str(ds01)

ds0 <- merge(ds01,ds02,by="M2ID")

myvars <- c("v1", "v2", "v3",...)
ds0Core <- mydata[myvars]