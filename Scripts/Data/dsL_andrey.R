# remove all elements for a clean start
rm(list=ls(all=TRUE))


#install psyc package
# install.packages("ctv")
# install.packages("psych")
# install.packages("foreign")
# install.packages("Hmisc")


library(foreign)
library(Hmisc)
library(foreign)
library(ctv)
library(psych)

#load psych pkgmydata <- ds_03


task.views("Psychometrics")



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

## @knitr LoadData
load("./Data/Raw/25281-0001-Data.rda")
load("./Data/Raw/29282-0001-Data.rda")
ds01 <- da25281.0001
ds02 <- da29282.0001

ds03 <- spss.get("./Data/Raw/04652-0001-Data.sav", use.value.labels=TRUE)

str(ds01)

ds0 <- merge(ds01,ds02,by="M2ID", all=TRUE)


# Object with MIDUS II participant variables from ds0.
MIDUS_pvars <- c('M2ID', 'B1PAGE_M2.x', 'B1PGENDER.x')

# Object with MIDUS II sleep variables from ds0.
MIDUS_sleepvars <- c( 'M2ID',
  'B4S4',      'B4S5',      'B4S7',    
  'B4S11A',   'B4S11B',     'B4S11C',    'B4S11D',    'B4S11E',    'B4S11F',    'B4S11G',      'B4S11H',    'B4S11I',    'B4S11J', 
  'B4AD17',    'B4AD27',    'B4AD37',    'B4AD47',    'B4AD57',    'B4AD67',    'B4AD77',  
  'B4AD110',   'B4AD210',   'B4AD310',   'B4AD410',   'B4AD510',   'B4AD610',   'B4AD710',  
  'B4AD113',   'B4AD213',   'B4AD313',   'B4AD413',   'B4AD513',   'B4AD613',   'B4AD713',  
  'B4AD117',   'B4AD217',   'B4AD317',   'B4AD417',   'B4AD517',   'B4AD617',   'B4AD717',   
  'B4AD120',  'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  
  'B4AD118',  'B4AD218',  'B4AD318',  'B4AD418',  'B4AD518',  'B4AD618',  'B4AD718', 
  'B4AD115',  'B4AD215',  'B4AD315',  'B4AD415',  'B4AD515',  'B4AD615',  'B4AD715', 
  'B4AD115A', 'B4AD215A', 'B4AD315A', 'B4AD415A', 'B4AD515A', 'B4AD615A', 'B4AD715A')

# Object with MIDUS II cognitive variables from ds0.
MIDUS_cogvars <- c('M2ID', 'B3TCOMPZ3', 'B3TEMZ3', 'B3TEFZ3')


# Object with all MIDUS II variables of interest.
MIDUS_all <- c('M2ID', 'B1PAGE_M2.x', 'B1PGENDER.x', 
               'B4S4',      'B4S5',      'B4S7',    
               'B4S11A',   'B4S11B',     'B4S11C',    'B4S11D',    'B4S11E',    'B4S11F',    'B4S11G',      'B4S11H',    'B4S11I',    'B4S11J', 
               'B4AD17',    'B4AD27',    'B4AD37',    'B4AD47',    'B4AD57',    'B4AD67',    'B4AD77',  
               'B4AD110',   'B4AD210',   'B4AD310',   'B4AD410',   'B4AD510',   'B4AD610',   'B4AD710',  
               'B4AD113',   'B4AD213',   'B4AD313',   'B4AD413',   'B4AD513',   'B4AD613',   'B4AD713',  
               'B4AD117',   'B4AD217',   'B4AD317',   'B4AD417',   'B4AD517',   'B4AD617',   'B4AD717',   
               'B4AD120',  'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  
               'B4AD118',  'B4AD218',  'B4AD318',  'B4AD418',  'B4AD518',  'B4AD618',  'B4AD718', 
               'B4AD115',  'B4AD215',  'B4AD315',  'B4AD415',  'B4AD515',  'B4AD615',  'B4AD715', 
               'B4AD115A', 'B4AD215A', 'B4AD315A', 'B4AD415A', 'B4AD515A', 'B4AD615A', 'B4AD715A', 'B3TCOMPZ3', 'B3TEMZ3', 'B3TEFZ3')

#object with MIDUS daily sleep variables
MIDUS_sleepdaily <- c(
  'B4AD17',    'B4AD27',    'B4AD37',    'B4AD47',    'B4AD57',    'B4AD67',    'B4AD77',  
'B4AD110',   'B4AD210',   'B4AD310',   'B4AD410',   'B4AD510',   'B4AD610',   'B4AD710',  
'B4AD113',   'B4AD213',   'B4AD313',   'B4AD413',   'B4AD513',   'B4AD613',   'B4AD713',  
'B4AD117',   'B4AD217',   'B4AD317',   'B4AD417',   'B4AD517',   'B4AD617',   'B4AD717',   
'B4AD120',  'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  
'B4AD118',  'B4AD218',  'B4AD318',  'B4AD418',  'B4AD518',  'B4AD618',  'B4AD718', 
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

# save the data as RDS for quicker loading in the future
saveRDS(ds00,"./Data/Derived/ds00.rds", compress = "xz")
saveRDS(ds0,"./Data/Derived/ds0.rds", compress = "xz")

