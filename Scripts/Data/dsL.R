# remove all elements for a clean start
rm(list=ls(all=TRUE))


## @knitr LoadData
load("./Data/Raw/25281-0001-Data.rda")
load("./Data/Raw/29282-0001-Data.rda")

#load psych pkgmydata <- ds_03
library(Hmisc)
ds03 <- spss.get("./Data/Raw/04652-0001-Data.sav", use.value.labels=TRUE)



# General Hypotheses
# There is an association between sleep disturbance and cognition in that sleep disturbance predicts cognitive scores. (Regress Cognition on sleep disturbance)
# There is an association between sleep duration and cognition in that sleep duration predicts cognitive scores.  (Regress Cognition on sleep duration & sleepduration squared)
#       This association will be U-shaped in that lowest scores are associated with short and long sleep (replication of Ferrie et al.)
# Sleep duration and sleep disturbance together are better predictors of cognitive score compared to each predictor separately.
#                       (Regress Cognition on sleep disturbance, sleep duration & sleepduration squared)
 
# Pittsburgh Sleep Quality Inventory:
# Hypothesis 1: Individuals who rate poorer sleep quality have poorer cognition relative to individuals who rate higher sleep quality.
# Hypothesis 2: Individuals who regularly have greater amounts of sleep disturbances have poorer cognition relative to individuals who have lower amounts of sleep disturbances.
#     These could also be regressions, to keep with same analysis as above. 
#       Wherever you are just looking at the association between two variables, you could use correlation.

# On a daily level??
# Hypothesis 1: On average, individuals who rate higher difficulty getting to sleep have poorer cognition 
#                               relative to individuals who rate lower difficulty getting to sleep.
# Hypothesis 2: On average, individuals who report higher instances of having difficulty of getting back to sleep have poorer cognition 
#                               relative to individuals who report lower instances of having difficulty getting back to sleep.
# Hypothesis 3: On average, individuals who rate lower overall quality of sleep on the previous night have poorer cognition 
#                              relative to individuals who report higher overall quality of sleep on the previous night.

# For these, I think you were going to compute average for each person. Once you do this, you could just use regression again. 

# Try some of the following resources for Regression in R:

#   http://www.google.ca/webhp?nord=1&gws_rd=cr&ei=ZTn1VIOOCYHuoASLkYGoCg#nord=1&q=regression+in+R 
#   http://www.statmethods.net/stats/regression.html
#   

# Notes: Want to look for sex differences.
#   If you code sex as male=0 and female=1, you can include sex as another predictor in your regression
#              and the parameter estimate will equal the mean difference between men and women.
#   I tend to label such a variable "female" so I remember which is the reference group
#      (i.e., the ref group is male, so the estimate tells how much higher (or lower if it is negative) the women are)

# Something we have not talked about is that since older people tend to not sleep as well,
#                 you should probably also include age as a predictor in your regressions.
#  You might also want to look at the interaction between age and sleep disturbance (etc) in case poor sleep has a greater effect in older (or younger) adults
#  If you want to create an interaction term, you should "center" each variable first by subtracting the mean from each person's score
#        and then multiply the centered variables together






ds01 <- da25281.0001
ds02 <- da29282.0001
str(ds01)

ds0 <- merge(ds01,ds02,by="M2ID", all=TRUE)


# Object with MIDUS II participant variables from ds0.
MIDUS_pvars <- c('M2ID', 'B1PAGE_M2.x', 'B1PGENDER.x')

# Object with MIDUS II sleep variables from ds0.
MIDUS_sleepvars <- c( 'M2ID',
'B4S4',      'B4S5',      'B4S7',    
'B4S11A',   'B4S11B',     'B4S11C',    'B4S11D',    'B4S11E',    'B4S11F',    'B4S11G',      'B4S11H',    'B4S11I',    'B4S11J',
  
'B4AD17', 'B4AD27', 'B4AD37', 'B4AD47', 'B4AD57', 'B4AD67', 'B4AD77',

'B4AD110', 'B4AD210', 'B4AD310', 'B4AD410', 'B4AD510', 'B4AD610', 'B4AD710', 

'B4AD111', 'B4AD211', 'B4AD311', 'B4AD411', 'B4AD511', 'B4AD611', 'B4AD711',

'B4AD113',   'B4AD213',   'B4AD313',   'B4AD413',   'B4AD513',   'B4AD613',   'B4AD713',  

'B4AD120',  'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  


'B4AD18', 'B4AD18A', 'B4AD28', 'B4AD28A', 'B4AD38', 'B4AD38A', 'B4AD48', 'B4AD48A', 'B4AD58', 'B4AD58A', 'B4AD68', 'B4AD68A', 'B4AD78', 'B4AD78A',

'B4AD19', 'B4AD29', 'B4AD39', 'B4AD49', 'B4AD59', 'B4AD69', 'B4AD79',

'B4AD115',  'B4AD215',  'B4AD315',  'B4AD415',  'B4AD515',  'B4AD615',  'B4AD715', 
'B4AD115A', 'B4AD215A', 'B4AD315A', 'B4AD415A', 'B4AD515A', 'B4AD615A', 'B4AD715A')

# Object with MIDUS II cognitive variables from ds0.
MIDUS_cogvars <- c('M2ID', 'B3TCOMPZ3', 'B3TEMZ3', 'B3TEFZ3')


# Object with all MIDUS II variables of interest.
MIDUS_all <- c('M2ID', 'B1PAGE_M2.x', 'B1PGENDER.x', 
               'B4S4',      'B4S5',      'B4S7',    
               'B4S11A',   'B4S11B',     'B4S11C',    'B4S11D',    'B4S11E',    'B4S11F',    'B4S11G',      'B4S11H',    'B4S11I',    'B4S11J', 
'B4AD17', 'B4AD27', 'B4AD37', 'B4AD47', 'B4AD57', 'B4AD67', 'B4AD77',
  
'B4AD110', 'B4AD210', 'B4AD310', 'B4AD410', 'B4AD510', 'B4AD610', 'B4AD710', 
 
'B4AD111', 'B4AD211', 'B4AD311', 'B4AD411', 'B4AD511', 'B4AD611', 'B4AD711',

'B4AD113',   'B4AD213',   'B4AD313',   'B4AD413',   'B4AD513',   'B4AD613',   'B4AD713',  
  
'B4AD120',  'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  


'B4AD18', 'B4AD18A', 'B4AD28', 'B4AD28A', 'B4AD38', 'B4AD38A', 'B4AD48', 'B4AD48A', 'B4AD58', 'B4AD58A', 'B4AD68', 'B4AD68A', 'B4AD78', 'B4AD78A',

'B4AD19', 'B4AD29', 'B4AD39', 'B4AD49', 'B4AD59', 'B4AD69', 'B4AD79',

'B4AD115',  'B4AD215',  'B4AD315',  'B4AD415',  'B4AD515',  'B4AD615',  'B4AD715', 
'B4AD115A', 'B4AD215A', 'B4AD315A', 'B4AD415A', 'B4AD515A', 'B4AD615A', 'B4AD715A,

'B3TCOMPZ3', 'B3TEMZ3', 'B3TEFZ3')

#object with MIDUS daily sleep variables
MIDUS_sleepdaily <- c( 
  'M2ID',
  'B4AD17', 'B4AD27', 'B4AD37', 'B4AD47', 'B4AD57', 'B4AD67', 'B4AD77',
  
  'B4AD110', 'B4AD210', 'B4AD310', 'B4AD410', 'B4AD510', 'B4AD610', 'B4AD710', 
  
  'B4AD111', 'B4AD211', 'B4AD311', 'B4AD411', 'B4AD511', 'B4AD611', 'B4AD711',
  
  'B4AD113',   'B4AD213',   'B4AD313',   'B4AD413',   'B4AD513',   'B4AD613',   'B4AD713',  
  
  'B4AD120',  'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  
  
  
  'B4AD18', 'B4AD18A', 'B4AD28', 'B4AD28A', 'B4AD38', 'B4AD38A', 'B4AD48', 'B4AD48A', 'B4AD58', 'B4AD58A', 'B4AD68', 'B4AD68A', 'B4AD78', 'B4AD78A',
  
  'B4AD19', 'B4AD29', 'B4AD39', 'B4AD49', 'B4AD59', 'B4AD69', 'B4AD79',
  
  'B4AD115',  'B4AD215',  'B4AD315',  'B4AD415',  'B4AD515',  'B4AD615',  'B4AD715', 
  'B4AD115A', 'B4AD215A', 'B4AD315A', 'B4AD415A', 'B4AD515A', 'B4AD615A', 'B4AD715A')


# MIDUS_pvars codes:
# M2ID = Participant ID number
# B1PAGE_M2 = Age deterimined by subtracting DOB_Final from b1ipdate
# B1PGENDER = Gender
# B4ZAGE = Respondent age at P4 data collection (Biomarker project)

# MIDUS_cogvars codes:
# B3TCOMPZ3 = Z-score Brief Test of Adult Cognition by Telephone for complete sample (MIDUS + Milkwaukee)
# B3TEMZ3 = Z-score Episodic memory computer for complete sample (MIDUS + Milwaukee)
# B3TEFZ3 = Z-score executive functioning for complete sample (MIDUS + Milwaulkee)


#object with MIDUS II variables to control for
MIDUS_controls <- c('M2ID', 'B1PF8A', 'B1PB1', 'B1SBMI', 'B1SA11T', 'B1SA1', 'B1PA1', 'B1PA1', 'B1PA6A', 'B1SA11S')

##codes:
#race B1PF8A
#education B1PB1
#BMI - B1SBMI
#depression - B1SA11T
#health status - B1SA1
#physical health - B1PA1
#psychological health - B1PA1
#stroke - B1PA6A
#hypertension - B1SA11S

#Variables pulled out of ds0
dspvars <- ds0[MIDUS_pvars]
dscog <- ds0[MIDUS_cogvars]
dssleep <-ds0[MIDUS_sleepvars]
ds_ALL <-ds0[MIDUS_all]
dscontrol <- ds03[MIDUS_controls]


#ds0 is now all variables of interest
ds0 <- merge(ds_ALL,dscontrol,by="M2ID")

#Data set with daily variables
dsdaily1 <- ds0[MIDUS_sleepdaily]
dsdaily <- merge(dsdaily1,dscontrol,by="M2ID")

#ds0 with daily sleep variables dropped
MIDUS_sleepdaily <- names(ds0) %in% c(
  'B4AD17',    'B4AD27',    'B4AD37',    'B4AD47',    'B4AD57',    'B4AD67',    'B4AD77',  
  'B4AD110',   'B4AD210',   'B4AD310',   'B4AD410',   'B4AD510',   'B4AD610',   'B4AD710',  
  'B4AD113',   'B4AD213',   'B4AD313',   'B4AD413',   'B4AD513',   'B4AD613',   'B4AD713',  
  'B4AD117',   'B4AD217',   'B4AD317',   'B4AD417',   'B4AD517',   'B4AD617',   'B4AD717',   
  'B4AD120',  'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  
  'B4AD118',  'B4AD218',  'B4AD318',  'B4AD418',  'B4AD518',  'B4AD618',  'B4AD718', 
  'B4AD115',  'B4AD215',  'B4AD315',  'B4AD415',  'B4AD515',  'B4AD615',  'B4AD715', 
  'B4AD115A', 'B4AD215A', 'B4AD315A', 'B4AD415A', 'B4AD515A', 'B4AD615A', 'B4AD715A')
ds00 <- ds0[!MIDUS_sleepdaily]

#ds0 with PSQ sleep variables dropped
MIDUS_sleepPSQ <- names(ds0) %in% c(
  'B4S4', 'B4S5', 'B4S7', 'B4S11A', 'B4S11B', 'B4S11C', 'B4S11D',    
  'B4S11E', 'B4S11F', 'B4S11G', 'B4S11H', 'B4S11I', 'B4S11J')
ds0daily <- ds0[!MIDUS_sleepPSQ] 

# create new dataset without missing data 
ds00_nomissing <- na.omit(ds00)
ds0_nomissing <- na.omit(ds0)
ds0daily_nomissing <- na.omit(ds0daily)

dsdailydiary <- na.omit(dsdaily)

#Convert GENDER to numeric in ds00_nomissing
ds00_nomissing$GENDER[ds00_nomissing$B1PGENDER.x=="(1) MALE"] <- "1"
ds00_nomissing$GENDER[ds00_nomissing$B1PGENDER.x=="(2) FEMALE"] <- "2"
ds00_nomissing$GENDER = as.numeric(ds00_nomissing$GENDER)
#checks to see if it is numeric:
is.numeric(ds00_nomissing$GENDER)

#Convert Sleep Quality to numeric in ds00_nomissing
#Fairly, Good, Fairly Bad, Very Bad is condensed into "Bad" containing both groups
ds00_nomissing$SQUAL[ds00_nomissing$B4S5=="(1) 1=VERY GOOD"] <- "1"
ds00_nomissing$SQUAL[ds00_nomissing$B4S5=="(2) 2=FAIRLY GOOD"] <- "2"
ds00_nomissing$SQUAL[ds00_nomissing$B4S5=="(3) 3=FAIRLY BAD"] <- "2"
ds00_nomissing$SQUAL[ds00_nomissing$B4S5=="(4) 4=VERY BAD"] <- "2"
ds00_nomissing$SQUAL = as.numeric(ds00_nomissing$SQUAL)
#checks to see if it is numeric:
is.numeric(ds00_nomissing$SQUAL)

#Convert Sleep Disturbance to numeric in ds00_nomissing
ds00_nomissing$SDISA[ds00_nomissing$B4S11A=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISA[ds00_nomissing$B4S11A=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISA[ds00_nomissing$B4S11A=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISA[ds00_nomissing$B4S11A=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISA = as.numeric(ds00_nomissing$SDISA)

#####

ds00_nomissing$SDISB[ds00_nomissing$B4S11B=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISB[ds00_nomissing$B4S11B=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISB[ds00_nomissing$B4S11B=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISB[ds00_nomissing$B4S11B=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISB = as.numeric(ds00_nomissing$SDISB)

#####

ds00_nomissing$SDISC[ds00_nomissing$B4S11C=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISC[ds00_nomissing$B4S11C=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISC[ds00_nomissing$B4S11C=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISC[ds00_nomissing$B4S11C=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISC = as.numeric(ds00_nomissing$SDISC)


#####

ds00_nomissing$SDISD[ds00_nomissing$B4S11D=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISD[ds00_nomissing$B4S11D=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISD[ds00_nomissing$B4S11D=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISD[ds00_nomissing$B4S11D=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISD = as.numeric(ds00_nomissing$SDISD)

#####

ds00_nomissing$SDISE[ds00_nomissing$B4S11E=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISE[ds00_nomissing$B4S11E=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISE[ds00_nomissing$B4S11E=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISE[ds00_nomissing$B4S11E=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISE = as.numeric(ds00_nomissing$SDISE)

#####

ds00_nomissing$SDISF[ds00_nomissing$B4S11F=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISF[ds00_nomissing$B4S11F=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISF[ds00_nomissing$B4S11F=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISF[ds00_nomissing$B4S11F=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISF = as.numeric(ds00_nomissing$SDISF)

#####

ds00_nomissing$SDISG[ds00_nomissing$B4S11G=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISG[ds00_nomissing$B4S11G=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISG[ds00_nomissing$B4S11G=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISG[ds00_nomissing$B4S11G=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISG = as.numeric(ds00_nomissing$SDISG)

#####

ds00_nomissing$SDISH[ds00_nomissing$B4S11H=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISH[ds00_nomissing$B4S11H=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISH[ds00_nomissing$B4S11H=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISH[ds00_nomissing$B4S11H=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISH = as.numeric(ds00_nomissing$SDISH)

#####

ds00_nomissing$SDISI[ds00_nomissing$B4S11I=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISI[ds00_nomissing$B4S11I=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISI[ds00_nomissing$B4S11I=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISI[ds00_nomissing$B4S11I=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISI = as.numeric(ds00_nomissing$SDISI)

#####

ds00_nomissing$SDISJ[ds00_nomissing$B4S11J=="(1) 1=NOT DURING PAST MONTH"] <- "1"
ds00_nomissing$SDISJ[ds00_nomissing$B4S11J=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
ds00_nomissing$SDISJ[ds00_nomissing$B4S11J=="(3) 3=1-2 X WEEK"] <- "3"
ds00_nomissing$SDISJ[ds00_nomissing$B4S11J=="(4) 4=3+ WEEK"] <- "4"
ds00_nomissing$SDISJ = as.numeric(ds00_nomissing$SDISJ)

#Syntax to SUM Sleep Disturbance scores
ds00_nomissing$SDis <- ds00_nomissing$SDISA + ds00_nomissing$SDISB + ds00_nomissing$SDISC + ds00_nomissing$SDISD + ds00_nomissing$SDISE + ds00_nomissing$SDISF + ds00_nomissing$SDISG + ds00_nomissing$SDISH + ds00_nomissing$SDISI + ds00_nomissing$SDISJ


#Daily Sleep Diary Numeric Conversions

dsdailydiary$MED1[dsdailydiary$B4AD17=="(1) YES"] <- "1"
dsdailydiary$MED1[dsdailydiary$B4AD17=="(2) NO"] <- "2"
dsdailydiary$MED1 = as.numeric(dsdailydiary$MED1)

dsdailydiary$MED2[dsdailydiary$B4AD27=="(1) YES"] <- "1"
dsdailydiary$MED2[dsdailydiary$B4AD27=="(2) NO"] <- "2"
dsdailydiary$MED2 = as.numeric(dsdailydiary$MED2)

dsdailydiary$MED3[dsdailydiary$B4AD37=="(1) YES"] <- "1"
dsdailydiary$MED3[dsdailydiary$B4AD37=="(2) NO"] <- "2"
dsdailydiary$MED3 = as.numeric(dsdailydiary$MED3)

dsdailydiary$MED4[dsdailydiary$B4AD47=="(1) YES"] <- "1"
dsdailydiary$MED4[dsdailydiary$B4AD47=="(2) NO"] <- "2"
dsdailydiary$MED4 = as.numeric(dsdailydiary$MED4)

dsdailydiary$MED5[dsdailydiary$B4AD57=="(1) YES"] <- "1"
dsdailydiary$MED5[dsdailydiary$B4AD57=="(2) NO"] <- "2"
dsdailydiary$MED5 = as.numeric(dsdailydiary$MED5)

dsdailydiary$MED6[dsdailydiary$B4AD67=="(1) YES"] <- "1"
dsdailydiary$MED6[dsdailydiary$B4AD67=="(2) NO"] <- "2"
dsdailydiary$MED6 = as.numeric(dsdailydiary$MED6)

dsdailydiary$MED7[dsdailydiary$B4AD77=="(1) YES"] <- "1"
dsdailydiary$MED7[dsdailydiary$B4AD77=="(2) NO"] <- "2"
dsdailydiary$MED7 = as.numeric(dsdailydiary$MED7)

dsdailydiary$MED <- (dsdailydiary$MED1 + dsdailydiary$MED2 + dsdailydiary$MED3 + dsdailydiary$MED4 + dsdailydiary$MED5 + dsdailydiary$MED6 + dsdailydiary$MED7)/7

# I don't know the names of your actual variables, so I've just made some up below
# I am hoping you can edit these examples with your real variable names and get them to run

# Create squared Sleep Duration term to use in regression for curvilinear (quadratic) relationship with cognition
#  Get the mean SleepDuration, then subtract it from each person's score, then multiply the centered variables together


#drop outlier EF
ds_PSQ <- ds00_nomissing[ which(ds00_nomissing$B3TEFZ3 > -4.00), ]


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
attach(ds00_nomissing)
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
