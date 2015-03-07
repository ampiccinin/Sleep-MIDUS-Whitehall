# remove all elements for a clean start
rm(list=ls(all=TRUE))


# load the data from a previously saved RDS
ds00 <- readRDS(file="./Data/Derived/ds00.rds")
ds0 <- readRDS(file="./Data/Derived/ds0.rds")

#ds0 with PSQ sleep variables dropped
MIDUS_sleepPSQ <- names(ds0) %in% c(
  'B4S4', 'B4S5', 'B4S7', 'B4S11A', 'B4S11B', 'B4S11C', 'B4S11D',    
  'B4S11E', 'B4S11F', 'B4S11G', 'B4S11H', 'B4S11I', 'B4S11J')
ds0daily <- ds0[!MIDUS_sleepPSQ] 

# create new dataset without missing data 
# ds00_nomissing <- na.omit(ds00)
# ds0_nomissing <- na.omit(ds0)
# ds0daily_nomissing <- na.omit(ds0daily)

# rename for brevity of reference
ds00nm <- na.omit(ds00)
ds0m <- na.omit(ds0)
ds0dnm <- na.omit(ds0daily)

### Before creating factors, MAKE SURE TO RENAME THE VARIABLES WITH DESCRIPTIVE NAMES

# ds00nm$GENDER[ds00nm$B1PGENDER.x=="(1) MALE"] <- "1"
# ds00nm$GENDER[ds00nm$B1PGENDER.x=="(2) FEMALE"] <- "2"
# ds00nm$GENDER = as.numeric(ds00nm$GENDER)



# create levels (numerical values) and labels (character strings)
femaleLevels<- c(0, 1) 
femaleLabels<-c("(1) MALE", 
                "(2) FEMALE")
varlist<- c("B1PGENDER.x") # 
# cycle through variables to which these labels should be applied, in this case only one
for(i in varlist){
  ds00nm[ , paste0(i,"F") ]<-ordered(ds00nm[,i], # create a new column  which name is = old name + F (for FACTOR)
             levels = femaleLevels,
             labels = femaleLabels)
}
# Examine the newly created variable
str(ds00nm$B1PGENDER.xF)
levels(ds00nm$B1PGENDER.xF)

#checks to see if it is numeric:
is.numeric(ds00nm$GENDER)

#Convert Sleep Quality to numeric in ds00nm
#Fairly, Good, Fairly Bad, Very Bad is condensed into "Bad" containing both groups
ds00nm$SQUAL[ds00nm$B4S5=="(1) 1=VERY GOOD"] <- "1"
ds00nm$SQUAL[ds00nm$B4S5=="(2) 2=FAIRLY GOOD"] <- "2"
ds00nm$SQUAL[ds00nm$B4S5=="(3) 3=FAIRLY BAD"] <- "2"
ds00nm$SQUAL[ds00nm$B4S5=="(4) 4=VERY BAD"] <- "2"
ds00nm$SQUAL = as.numeric(ds00nm$SQUAL)
#checks to see if it is numeric:
is.numeric(ds00nm$SQUAL)


# create levels (numerical values) and labels (character strings) for this type of response
often4Levels<- c(1,2,3,4) 
often4Labels<-c("(1) 1=NOT DURING PAST MONTH",
                "(2) 2=LESS THAN 1 X WEEK",
                "(3) 3=1-2 X WEEK",
                "(4) 4=3+ WEEK")
varlist<- c("B4S11A", "B4S11B",  "B4S11D", "B4S11E", "B4S11F" , "B4S11G",  "B4S11H",  "B4S11I", "B4S11J" ) # these should be replaced by descriptive names. rename prior to converting.
# cycle through variables to which these labels should be applied, in this case only one
for(i in varlist){
  ds00nm[ , paste0(i,"F") ]<-ordered(ds00nm[,i], # create a new column  which name is = old name + F (for FACTOR)
                                     levels = often4Levels,
                                     labels = often4Labels)
}

# 
# 
# #Convert Sleep Disturbance to numeric in ds00nm
# ds00nm$SDISA[ds00nm$B4S11A=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISA[ds00nm$B4S11A=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISA[ds00nm$B4S11A=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISA[ds00nm$B4S11A=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISA = as.numeric(ds00nm$SDISA)
# 
# ##### 
# 
# ds00nm$SDISB[ds00nm$B4S11B=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISB[ds00nm$B4S11B=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISB[ds00nm$B4S11B=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISB[ds00nm$B4S11B=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISB = as.numeric(ds00nm$SDISB)
#  
# ##### 
# 
# ds00nm$SDISC[ds00nm$B4S11C=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISC[ds00nm$B4S11C=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISC[ds00nm$B4S11C=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISC[ds00nm$B4S11C=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISC = as.numeric(ds00nm$SDISC)
# 
# 
# #####
# 
# ds00nm$SDISD[ds00nm$B4S11D=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISD[ds00nm$B4S11D=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISD[ds00nm$B4S11D=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISD[ds00nm$B4S11D=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISD = as.numeric(ds00nm$SDISD)
# 
# ##### 
# 
# ds00nm$SDISE[ds00nm$B4S11E=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISE[ds00nm$B4S11E=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISE[ds00nm$B4S11E=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISE[ds00nm$B4S11E=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISE = as.numeric(ds00nm$SDISE)
# 
# ##### 
# 
# ds00nm$SDISF[ds00nm$B4S11F=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISF[ds00nm$B4S11F=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISF[ds00nm$B4S11F=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISF[ds00nm$B4S11F=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISF = as.numeric(ds00nm$SDISF)
#" "
# #####  
#  
# ds00nm$SDISG[ds00nm$B4S11G=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISG[ds00nm$B4S11G=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISG[ds00nm$B4S11G=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISG[ds00nm$B4S11G=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISG = as.numeric(ds00nm$SDISG)
# 
# ##### 
# 
# ds00nm$SDISH[ds00nm$B4S11H=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISH[ds00nm$B4S11H=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISH[ds00nm$B4S11H=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISH[ds00nm$B4S11H=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISH = as.numeric(ds00nm$SDISH)
# 
# #####
# 
# ds00nm$SDISI[ds00nm$B4S11I=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISI[ds00nm$B4S11I=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISI[ds00nm$B4S11I=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISI[ds00nm$B4S11I=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISI = as.numeric(ds00nm$SDISI)
# 
# #####
# 
# ds00nm$SDISJ[ds00nm$B4S11J=="(1) 1=NOT DURING PAST MONTH"] <- "1"
# ds00nm$SDISJ[ds00nm$B4S11J=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
# ds00nm$SDISJ[ds00nm$B4S11J=="(3) 3=1-2 X WEEK"] <- "3"
# ds00nm$SDISJ[ds00nm$B4S11J=="(4) 4=3+ WEEK"] <- "4"
# ds00nm$SDISJ = as.numeric(ds00nm$SDISJ)

#checks to see if it is numeric:
#switch SDIS_ to letter of choice
is.numeric(ds00nm$SDISA)


#Syntax to SUM Sleep Disturbance scores
ds00nm$SDis <- ds00nm$SDISA + ds00nm$SDISB + ds00nm$SDISC + ds00nm$SDISD + ds00nm$SDISE + ds00nm$SDISF + ds00nm$SDISG + ds00nm$SDISH + ds00nm$SDISI + ds00nm$SDISJ


# I don't know the names of your actual variables, so I've just made some up below
# I am hoping you can edit these examples with your real variable names and get them to run

# Create squared Sleep Duration term to use in regression for curvilinear (quadratic) relationship with cognition
#  Get the mean SleepDuration, then subtract it from each person's score, then multiply the centered variables together


#drop outlier EF
ds_PSQ <- ds00nm[ which(ds00nm$B3TEFZ3 > -4.00), ]


ds_PSQ$DurationC <- ds_PSQ$B4S4 - 6.888
ds_PSQ$Duration2 <- ds_PSQ$DurationC * ds_PSQ$DurationC


########## DESCRIPTIVE STATISTICS

##Run descriptive stats on ds00 (dataset with daily sleep variables dropped)

#with psych pkg
library(psych)
describe(ds_PSQ)

library(psych)
describe(ds0daily_nomissing)


# For Correlations, see: http://www.statmethods.net/stats/correlations.html


# GRAPHICAL look at data

# Basic Scatterplot Matrix - so you can scan them all quickly
pairs(~B3TEMZ3+B3TEFZ3+SDis+B4S4+DurationC+Duration2,data=ds_PSQ, 
      main="Scatterplot Matrix")

# what is the id of the person with a potential outlier?
ds <- ds_PSQ[order(ds_PSQ$B4S4,decreasing=T),]
head(ds)

# If you want to highlight just one Simple Scatterplot
attach(ds00nm)
plot(B3TEMZ3, SDis, main="Scatterplot of Cognition by Sleep Disturbance", 
     xlab="Sleep Quality", ylab="Cognitive Variable ", pch=19)

# you can add  fit lines to your scatterplot with:
abline(lm(B3TEMZ3~SDis), col="red") # regression line (y~x) 

# If you want to make visually stunning graphs for your poster
# you can try playing around with ggplot2: see  http://www.cookbook-r.com/Graphs/ 
# but lets get the basics done first.

# Multiple Linear Regression for Memory 
fit <- lm(B3TEMZ3 ~ SDis + DurationC + Duration2, data=ds)
summary(fit) # show results
# Other useful functions 
coefficients(fit) # model coefficients
confint(fit, level=0.95) # CIs for model parameters 
fitted(fit) # predicted values
residuals(fit) # residuals
anova(fit) # anova table 
vcov(fit) # covariance matrix for model parameters 
influence(fit) # regression diagnostics
# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fit)


# Multiple Linear Regression for EF 
fit <- lm(B3TEFZ3 ~ SDis + DurationC + Duration2, data=ds)
summary(fit) # show results
# Other useful functions 
coefficients(fit) # model coefficients
confint(fit, level=0.95) # CIs for model parameters 
fitted(fit) # predicted values
residuals(fit) # residuals
anova(fit) # anova table 
vcov(fit) # covariance matrix for model parameters 
influence(fit) # regression diagnostics
# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fit)


##LINEAR REGRESSION MODELS

B4S5 <- c("B4S5")
Squal <- as.numeric(levels(B4S5))[B4S5]

# Pittsburgh Sleep Quality Inventory:
# Hypothesis 1: Individuals who rate poorer sleep quality have poorer cognition relative to individuals who rate higher sleep quality.

#memory
fit_h1_1 <- lm(B3TEMZ3 ~ SQUAL, data=ds_PSQ)
summary(fit_h1_1) # show results

#EF
fit_h1_2 <- lm(B3TEFZ3 ~ SQUAL, data=ds_PSQ)
summary(fit_h1_2) # show results

# Hypothesis 2: There is an association between sleep duration and cognition in that sleep duration predicts cognitive scores.

#memory
fit_h2_1 <- lm(B3TEMZ3 ~ DurationC + Duration2, data=ds_PSQ)
summary(fit_h2_1) # show results

#EF
fit_h2_2 <- lm(B3TEFZ3 ~ Sdur1 + Sdur, data=ds_PSQ)
summary(fit_h2_2) # show results

# Hypothesis 3: There is an association between sleep disturbance and cognition in that sleep disturbance predicts cognitive scores.

#memory
fit_h3_1 <- lm(B3TEMZ3 ~ SDis, data=ds_PSQ)
summary(fit_h3_1) # show results

#EF
fit_h3_2 <- lm(B3TEFZ3 ~ SDis, data=ds_PSQ)
summary(fit_h3_2) # show results


#Hypothesis 4: Sleep duration and sleep disturbance together are better predictors of cognitive score compared to each predictor separately.

#memory
fit_h4_1 <- lm(B3TEMZ3 ~ SDis + Sdur1 + Sdur, data=ds_PSQ)
summary(fit_h4_1) # show results

#EF
fit_h4_2 <- lm(B3TEFZ3 ~ SDis + Sdur1 + Sdur, data=ds_PSQ)
summary(fit_h4_2) # show results

#                       (Regress Cognition on sleep disturbance, sleep duration & sleepduration squared)
