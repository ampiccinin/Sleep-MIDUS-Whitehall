# remove all elements for a clean start
rm(list=ls(all=TRUE))

#####LOADING DATA#####

## @knitr LoadData
data_BIOMARKER <- load("./Data/Raw/data_BIOMARKER.rda")
data_COGNITION <- load("./Data/Raw/data_COGNITIVE.rda")
data_BIOMARKER <- da29282.0001
data_COGNITION<- da25281.0001

#Load data with control variables
library(Hmisc)
library(foreign)
data_CONTROLS <- spss.get("./Data/Raw/04652-0001-Data.sav", use.value.labels=TRUE)

d0 <- merge(data_BIOMARKER,data_COGNITION,by="M2ID", all=TRUE)
MIDUS <- merge(d0,data_CONTROLS,by="M2ID", all=TRUE)


#####VARIABLES#####

#Object with MIDUS II participant variables (ID, age, gender)
MIDUS_pvars <- c('M2ID', 'B1PAGE_M2.x', 'B1PGENDER.x')

#Object with MIDUS II cognitive variables (episodic memory, EF)
MIDUS_cogvars <- c('M2ID', 'B3TEMZ3', 'B3TEFZ3')

#Object with MIDUS II variables to control for
MIDUS_controls <- c('M2ID', 'B1PB1', 'B1SA11T', 'B1SA1', 'B1PA1', 'B1PA2')

##codes:
#education B1PB1
#depression - B1SA11T
#health status - B1SA1
#physical health - B1PA1
#psychological health - B1PA2

#Object with MIDUS II participant, cognitive, and control variables
MIDUSvars <- c(
  'M2ID',    'B1PAGE_M2.x', 'B1PGENDER.x',
  'B3TEMZ3', 'B3TEFZ3',
  'B1PB1',   'B1SA11T', 'B1SA1', 'B1PA1', 'B1PA2')

#Object with MIDUS II PSQ variables (for MIDUS_PSQ)
MIDUS_PSQ <- c(
  'M2ID',
  'B4S4',   'B4S5',   'B4S7',    
  'B4S11A', 'B4S11B', 'B4S11C', 'B4S11D', 'B4S11E',
  'B4S11F', 'B4S11G', 'B4S11H', 'B4S11I', 'B4S11J')

#object with MIDUS daily sleep variables
MIDUS_sleepdaily <- c( 
  'M2ID',
  ## Sleep medications (item 7, MED):
  'B4AD17',  'B4AD27', 'B4AD37', 'B4AD47', 'B4AD57', 'B4AD67', 'B4AD77',
  
  ## Sleep difficulty (item 10, SDIFF)
  'B4AD110', 'B4AD210', 'B4AD310', 'B4AD410', 'B4AD510', 'B4AD610', 'B4AD710', 
  
  ## No. times woke last night (item 11, WAKE)
  'B4AD111', 'B4AD211', 'B4AD311', 'B4AD411', 'B4AD511', 'B4AD611', 'B4AD711',
  
  ## Trouble getting back to sleep if woke (item 13, TRSLEEP)
  'B4AD113', 'B4AD213', 'B4AD313', 'B4AD413', 'B4AD513', 'B4AD613', 'B4AD713',
  
  ## Overall sleep quality (item 20, DSSQUAL)
  'B4AD120', 'B4AD220',  'B4AD320',  'B4AD420',  'B4AD520',  'B4AD620',  'B4AD720',  
  
  ## Sleep start time (item 18)
  'B4AD18',  'B4AD28',  'B4AD38',  'B4AD48',  'B4AD58',  'B4AD68',  'B4AD78', 
  'B4AD18A', 'B4AD28A', 'B4AD38A', 'B4AD48A', 'B4AD58A', 'B4AD68A', 'B4AD78A',
  
  ## Minutes to sleep (item 19)
  'B4AD19', 'B4AD29', 'B4AD39', 'B4AD49', 'B4AD59', 'B4AD69', 'B4AD79',
  
  ## Sleep end time (item 15)
  'B4AD115',  'B4AD215',  'B4AD315',  'B4AD415',  'B4AD515',  'B4AD615',  'B4AD715', 
  'B4AD115A', 'B4AD215A', 'B4AD315A', 'B4AD415A', 'B4AD515A', 'B4AD615A', 'B4AD715A')

#Variables pulled out of MIDUS
d_MIDUS <- MIDUS[MIDUSvars]
d_MIDUS_PSQ<- MIDUS[MIDUS_PSQ]
d_MIDUS_sleepdaily <-MIDUS[MIDUS_sleepdaily]

#####DATA SETS#####
d0_MIDUS_PSQ <- merge(d_MIDUS,d_MIDUS_PSQ,by="M2ID")
d0_MIDUS_sleepdaily<- merge(d_MIDUS,d_MIDUS_sleepdaily,by="M2ID")

#Create new dataset without missing data 
d0_PSQ <- na.omit(d0_MIDUS_PSQ)
d0_sleepdaily <- na.omit(d0_MIDUS_sleepdaily)



#####CONVERTING FACTOR TO NUMERIC IN d0_PSQ#####

#Convert GENDER to numeric in d0_PSQ
d0_PSQ$GENDER[d0_PSQ$B1PGENDER.x=="(1) MALE"] <- "1"
d0_PSQ$GENDER[d0_PSQ$B1PGENDER.x=="(2) FEMALE"] <- "2"
d0_PSQ$GENDER = as.numeric(d0_PSQ$GENDER)
#checks to see if it is numeric:
is.numeric(d0_PSQ$GENDER)

#Convert Sleep Quality to numeric in d0_PSQ
#Fairly, Good, Fairly Bad, Very Bad is condensed into "Bad" containing both groups
d0_PSQ$SQUAL[d0_PSQ$B4S5=="(1) 1=VERY GOOD"] <- "1"
d0_PSQ$SQUAL[d0_PSQ$B4S5=="(2) 2=FAIRLY GOOD"] <- "2"
d0_PSQ$SQUAL[d0_PSQ$B4S5=="(3) 3=FAIRLY BAD"] <- "2"
d0_PSQ$SQUAL[d0_PSQ$B4S5=="(4) 4=VERY BAD"] <- "2"
d0_PSQ$SQUAL = as.numeric(d0_PSQ$SQUAL)
#checks to see if it is numeric:
is.numeric(d0_PSQ$SQUAL)

#Convert Sleep Disturbance to numeric in d0_PSQ
d0_PSQ$SDISA[d0_PSQ$B4S11A=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISA[d0_PSQ$B4S11A=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISA[d0_PSQ$B4S11A=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISA[d0_PSQ$B4S11A=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISA = as.numeric(d0_PSQ$SDISA)

#####

d0_PSQ$SDISB[d0_PSQ$B4S11B=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISB[d0_PSQ$B4S11B=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISB[d0_PSQ$B4S11B=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISB[d0_PSQ$B4S11B=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISB = as.numeric(d0_PSQ$SDISB)

#####

d0_PSQ$SDISC[d0_PSQ$B4S11C=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISC[d0_PSQ$B4S11C=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISC[d0_PSQ$B4S11C=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISC[d0_PSQ$B4S11C=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISC = as.numeric(d0_PSQ$SDISC)


#####

d0_PSQ$SDISD[d0_PSQ$B4S11D=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISD[d0_PSQ$B4S11D=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISD[d0_PSQ$B4S11D=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISD[d0_PSQ$B4S11D=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISD = as.numeric(d0_PSQ$SDISD)

#####

d0_PSQ$SDISE[d0_PSQ$B4S11E=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISE[d0_PSQ$B4S11E=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISE[d0_PSQ$B4S11E=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISE[d0_PSQ$B4S11E=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISE = as.numeric(d0_PSQ$SDISE)

#####

d0_PSQ$SDISF[d0_PSQ$B4S11F=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISF[d0_PSQ$B4S11F=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISF[d0_PSQ$B4S11F=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISF[d0_PSQ$B4S11F=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISF = as.numeric(d0_PSQ$SDISF)

#####

d0_PSQ$SDISG[d0_PSQ$B4S11G=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISG[d0_PSQ$B4S11G=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISG[d0_PSQ$B4S11G=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISG[d0_PSQ$B4S11G=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISG = as.numeric(d0_PSQ$SDISG)

#####

d0_PSQ$SDISH[d0_PSQ$B4S11H=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISH[d0_PSQ$B4S11H=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISH[d0_PSQ$B4S11H=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISH[d0_PSQ$B4S11H=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISH = as.numeric(d0_PSQ$SDISH)

#####

d0_PSQ$SDISI[d0_PSQ$B4S11I=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISI[d0_PSQ$B4S11I=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISI[d0_PSQ$B4S11I=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISI[d0_PSQ$B4S11I=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISI = as.numeric(d0_PSQ$SDISI)

#####

d0_PSQ$SDISJ[d0_PSQ$B4S11J=="(1) 1=NOT DURING PAST MONTH"] <- "1"
d0_PSQ$SDISJ[d0_PSQ$B4S11J=="(2) 2=LESS THAN 1 X WEEK"] <- "2"
d0_PSQ$SDISJ[d0_PSQ$B4S11J=="(3) 3=1-2 X WEEK"] <- "3"
d0_PSQ$SDISJ[d0_PSQ$B4S11J=="(4) 4=3+ WEEK"] <- "4"
d0_PSQ$SDISJ = as.numeric(d0_PSQ$SDISJ)

#Syntax to SUM Sleep Disturbance scores
d0_PSQ$SDis <- d0_PSQ$SDISA + d0_PSQ$SDISB + d0_PSQ$SDISC + d0_PSQ$SDISD + d0_PSQ$SDISE + d0_PSQ$SDISF + d0_PSQ$SDISG + d0_PSQ$SDISH + d0_PSQ$SDISI + d0_PSQ$SDISJ



#####CONVERTING FACTOR TO NUMERIC IN d0_sleepdaily#####

d0_sleepdaily$MED1[d0_sleepdaily$B4AD17=="(1) YES"] <- "1"
d0_sleepdaily$MED1[d0_sleepdaily$B4AD17=="(2) NO"] <- "2"
d0_sleepdaily$MED1 = as.numeric(d0_sleepdaily$MED1)

d0_sleepdaily$MED2[d0_sleepdaily$B4AD27=="(1) YES"] <- "1"
d0_sleepdaily$MED2[d0_sleepdaily$B4AD27=="(2) NO"] <- "2"
d0_sleepdaily$MED2 = as.numeric(d0_sleepdaily$MED2)

d0_sleepdaily$MED3[d0_sleepdaily$B4AD37=="(1) YES"] <- "1"
d0_sleepdaily$MED3[d0_sleepdaily$B4AD37=="(2) NO"] <- "2"
d0_sleepdaily$MED3 = as.numeric(d0_sleepdaily$MED3)

d0_sleepdaily$MED4[d0_sleepdaily$B4AD47=="(1) YES"] <- "1"
d0_sleepdaily$MED4[d0_sleepdaily$B4AD47=="(2) NO"] <- "2"
d0_sleepdaily$MED4 = as.numeric(d0_sleepdaily$MED4)

d0_sleepdaily$MED5[d0_sleepdaily$B4AD57=="(1) YES"] <- "1"
d0_sleepdaily$MED5[d0_sleepdaily$B4AD57=="(2) NO"] <- "2"
d0_sleepdaily$MED5 = as.numeric(d0_sleepdaily$MED5)

d0_sleepdaily$MED6[d0_sleepdaily$B4AD67=="(1) YES"] <- "1"
d0_sleepdaily$MED6[d0_sleepdaily$B4AD67=="(2) NO"] <- "2"
d0_sleepdaily$MED6 = as.numeric(d0_sleepdaily$MED6)

d0_sleepdaily$MED7[d0_sleepdaily$B4AD77=="(1) YES"] <- "1"
d0_sleepdaily$MED7[d0_sleepdaily$B4AD77=="(2) NO"] <- "2"
d0_sleepdaily$MED7 = as.numeric(d0_sleepdaily$MED7)

d0_sleepdaily$SDIFF1[d0_sleepdaily$B4AD110=="(1) VERY EASY"] <- "1"
d0_sleepdaily$SDIFF1[d0_sleepdaily$B4AD110=="(2) 2"] <- "2"
d0_sleepdaily$SDIFF1[d0_sleepdaily$B4AD110=="(3) 3"] <- "3"
d0_sleepdaily$SDIFF1[d0_sleepdaily$B4AD110=="(4) 4"] <- "4"
d0_sleepdaily$SDIFF1[d0_sleepdaily$B4AD110=="(5) VERY DIFFICULT"] <- "5"
d0_sleepdaily$SDIFF1 = as.numeric(d0_sleepdaily$SDIFF1)

d0_sleepdaily$SDIFF2[d0_sleepdaily$B4AD210=="(1) VERY EASY"] <- "1"
d0_sleepdaily$SDIFF2[d0_sleepdaily$B4AD210=="(2) 2"] <- "2"
d0_sleepdaily$SDIFF2[d0_sleepdaily$B4AD210=="(3) 3"] <- "3"
d0_sleepdaily$SDIFF2[d0_sleepdaily$B4AD210=="(4) 4"] <- "4"
d0_sleepdaily$SDIFF2[d0_sleepdaily$B4AD210=="(5) VERY DIFFICULT"] <- "5"
d0_sleepdaily$SDIFF2 = as.numeric(d0_sleepdaily$SDIFF2)

d0_sleepdaily$SDIFF3[d0_sleepdaily$B4AD310=="(1) VERY EASY"] <- "1"
d0_sleepdaily$SDIFF3[d0_sleepdaily$B4AD310=="(2) 2"] <- "2"
d0_sleepdaily$SDIFF3[d0_sleepdaily$B4AD310=="(3) 3"] <- "3"
d0_sleepdaily$SDIFF3[d0_sleepdaily$B4AD310=="(4) 4"] <- "4"
d0_sleepdaily$SDIFF3[d0_sleepdaily$B4AD310=="(5) VERY DIFFICULT"] <- "5"
d0_sleepdaily$SDIFF3 = as.numeric(d0_sleepdaily$SDIFF3)

d0_sleepdaily$SDIFF4[d0_sleepdaily$B4AD410=="(1) VERY EASY"] <- "1"
d0_sleepdaily$SDIFF4[d0_sleepdaily$B4AD410=="(2) 2"] <- "2"
d0_sleepdaily$SDIFF4[d0_sleepdaily$B4AD410=="(3) 3"] <- "3"
d0_sleepdaily$SDIFF4[d0_sleepdaily$B4AD410=="(4) 4"] <- "4"
d0_sleepdaily$SDIFF4[d0_sleepdaily$B4AD410=="(5) VERY DIFFICULT"] <- "5"
d0_sleepdaily$SDIFF4 = as.numeric(d0_sleepdaily$SDIFF4)

d0_sleepdaily$SDIFF5[d0_sleepdaily$B4AD510=="(1) VERY EASY"] <- "1"
d0_sleepdaily$SDIFF5[d0_sleepdaily$B4AD510=="(2) 2"] <- "2"
d0_sleepdaily$SDIFF5[d0_sleepdaily$B4AD510=="(3) 3"] <- "3"
d0_sleepdaily$SDIFF5[d0_sleepdaily$B4AD510=="(4) 4"] <- "4"
d0_sleepdaily$SDIFF5[d0_sleepdaily$B4AD510=="(5) VERY DIFFICULT"] <- "5"
d0_sleepdaily$SDIFF5 = as.numeric(d0_sleepdaily$SDIFF5)

d0_sleepdaily$SDIFF6[d0_sleepdaily$B4AD610=="(1) VERY EASY"] <- "1"
d0_sleepdaily$SDIFF6[d0_sleepdaily$B4AD610=="(2) 2"] <- "2"
d0_sleepdaily$SDIFF6[d0_sleepdaily$B4AD610=="(3) 3"] <- "3"
d0_sleepdaily$SDIFF6[d0_sleepdaily$B4AD610=="(4) 4"] <- "4"
d0_sleepdaily$SDIFF6[d0_sleepdaily$B4AD610=="(5) VERY DIFFICULT"] <- "5"
d0_sleepdaily$SDIFF6 = as.numeric(d0_sleepdaily$SDIFF6)

d0_sleepdaily$SDIFF7[d0_sleepdaily$B4AD710=="(1) VERY EASY"] <- "1"
d0_sleepdaily$SDIFF7[d0_sleepdaily$B4AD710=="(2) 2"] <- "2"
d0_sleepdaily$SDIFF7[d0_sleepdaily$B4AD710=="(3) 3"] <- "3"
d0_sleepdaily$SDIFF7[d0_sleepdaily$B4AD710=="(4) 4"] <- "4"
d0_sleepdaily$SDIFF7[d0_sleepdaily$B4AD710=="(5) VERY DIFFICULT"] <- "5"
d0_sleepdaily$SDIFF7 = as.numeric(d0_sleepdaily$SDIFF7)

d0_sleepdaily$SDIFF <- (d0_sleepdaily$SDIFF1 + 
                         d0_sleepdaily$SDIFF2 + 
                         d0_sleepdaily$SDIFF3 + 
                         d0_sleepdaily$SDIFF4 + 
                         d0_sleepdaily$SDIFF5 + 
                         d0_sleepdaily$SDIFF6 + 
                         d0_sleepdaily$SDIFF7)/7

d0_sleepdaily$WAKE <-  (d0_sleepdaily$B4AD111 + 
                         d0_sleepdaily$B4AD211 +
                         d0_sleepdaily$B4AD311 +
                         d0_sleepdaily$B4AD411 +
                         d0_sleepdaily$B4AD511 +
                         d0_sleepdaily$B4AD611 +
                         d0_sleepdaily$B4AD711)/7

d0_sleepdaily$DSQUAL1[d0_sleepdaily$B4AD120=="(1) VERY GOOD"] <- "1"
d0_sleepdaily$DSQUAL1[d0_sleepdaily$B4AD120=="(2) 2"] <- "2"
d0_sleepdaily$DSQUAL1[d0_sleepdaily$B4AD120=="(3) 3"] <- "3"
d0_sleepdaily$DSQUAL1[d0_sleepdaily$B4AD120=="(4) 4"] <- "4"
d0_sleepdaily$DSQUAL1[d0_sleepdaily$B4AD120=="(5) VERY POOR"] <- "5"
d0_sleepdaily$DSQUAL1 = as.numeric(d0_sleepdaily$DSQUAL1)

d0_sleepdaily$DSQUAL2[d0_sleepdaily$B4AD220=="(1) VERY GOOD"] <- "1"
d0_sleepdaily$DSQUAL2[d0_sleepdaily$B4AD220=="(2) 2"] <- "2"
d0_sleepdaily$DSQUAL2[d0_sleepdaily$B4AD220=="(3) 3"] <- "3"
d0_sleepdaily$DSQUAL2[d0_sleepdaily$B4AD220=="(4) 4"] <- "4"
d0_sleepdaily$DSQUAL2[d0_sleepdaily$B4AD220=="(5) VERY POOR"] <- "5"
d0_sleepdaily$DSQUAL2 = as.numeric(d0_sleepdaily$DSQUAL2)

d0_sleepdaily$DSQUAL3[d0_sleepdaily$B4AD320=="(1) VERY GOOD"] <- "1"
d0_sleepdaily$DSQUAL3[d0_sleepdaily$B4AD320=="(2) 2"] <- "2"
d0_sleepdaily$DSQUAL3[d0_sleepdaily$B4AD320=="(3) 3"] <- "3"
d0_sleepdaily$DSQUAL3[d0_sleepdaily$B4AD320=="(4) 4"] <- "4"
d0_sleepdaily$DSQUAL3[d0_sleepdaily$B4AD320=="(5) VERY POOR"] <- "5"
d0_sleepdaily$DSQUAL3 = as.numeric(d0_sleepdaily$DSQUAL3)

d0_sleepdaily$DSQUAL4[d0_sleepdaily$B4AD420=="(1) VERY GOOD"] <- "1"
d0_sleepdaily$DSQUAL4[d0_sleepdaily$B4AD420=="(2) 2"] <- "2"
d0_sleepdaily$DSQUAL4[d0_sleepdaily$B4AD420=="(3) 3"] <- "3"
d0_sleepdaily$DSQUAL4[d0_sleepdaily$B4AD420=="(4) 4"] <- "4"
d0_sleepdaily$DSQUAL4[d0_sleepdaily$B4AD420=="(5) VERY POOR"] <- "5"
d0_sleepdaily$DSQUAL4 = as.numeric(d0_sleepdaily$DSQUAL4)

d0_sleepdaily$DSQUAL5[d0_sleepdaily$B4AD520=="(1) VERY GOOD"] <- "1"
d0_sleepdaily$DSQUAL5[d0_sleepdaily$B4AD520=="(2) 2"] <- "2"
d0_sleepdaily$DSQUAL5[d0_sleepdaily$B4AD520=="(3) 3"] <- "3"
d0_sleepdaily$DSQUAL5[d0_sleepdaily$B4AD520=="(4) 4"] <- "4"
d0_sleepdaily$DSQUAL5[d0_sleepdaily$B4AD520=="(5) VERY POOR"] <- "5"
d0_sleepdaily$DSQUAL5 = as.numeric(d0_sleepdaily$DSQUAL5)

d0_sleepdaily$DSQUAL6[d0_sleepdaily$B4AD620=="(1) VERY GOOD"] <- "1"
d0_sleepdaily$DSQUAL6[d0_sleepdaily$B4AD620=="(2) 2"] <- "2"
d0_sleepdaily$DSQUAL6[d0_sleepdaily$B4AD620=="(3) 3"] <- "3"
d0_sleepdaily$DSQUAL6[d0_sleepdaily$B4AD620=="(4) 4"] <- "4"
d0_sleepdaily$DSQUAL6[d0_sleepdaily$B4AD620=="(5) VERY POOR"] <- "5"
d0_sleepdaily$DSQUAL6 = as.numeric(d0_sleepdaily$DSQUAL6)

d0_sleepdaily$DSQUAL7[d0_sleepdaily$B4AD720=="(1) VERY GOOD"] <- "1"
d0_sleepdaily$DSQUAL7[d0_sleepdaily$B4AD720=="(2) 2"] <- "2"
d0_sleepdaily$DSQUAL7[d0_sleepdaily$B4AD720=="(3) 3"] <- "3"
d0_sleepdaily$DSQUAL7[d0_sleepdaily$B4AD720=="(4) 4"] <- "4"
d0_sleepdaily$DSQUAL7[d0_sleepdaily$B4AD720=="(5) VERY POOR"] <- "5"
d0_sleepdaily$DSQUAL7 = as.numeric(d0_sleepdaily$DSQUAL7)

d0_sleepdaily$DSQUAL <-  (d0_sleepdaily$DSQUAL1 + 
                           d0_sleepdaily$DSQUAL2 +
                           d0_sleepdaily$DSQUAL3 +
                           d0_sleepdaily$DSQUAL4 +
                           d0_sleepdaily$DSQUAL5 +
                           d0_sleepdaily$DSQUAL6 +
                           d0_sleepdaily$DSQUAL7)/7

d0_sleepdaily$TRSLEEP1[d0_sleepdaily$B4AD113=="(1) YES"] <- "1"
d0_sleepdaily$TRSLEEP1[d0_sleepdaily$B4AD113=="(2) NO"] <- "2"
d0_sleepdaily$TRSLEEP1 = as.numeric(d0_sleepdaily$TRSLEEP1)

d0_sleepdaily$TRSLEEP3[d0_sleepdaily$B4AD313=="(1) YES"] <- "1"
d0_sleepdaily$TRSLEEP3[d0_sleepdaily$B4AD313=="(2) NO"] <- "2"
d0_sleepdaily$TRSLEEP3 = as.numeric(d0_sleepdaily$TRSLEEP3)

d0_sleepdaily$TRSLEEP4[d0_sleepdaily$B4AD413=="(1) YES"] <- "1"
d0_sleepdaily$TRSLEEP4[d0_sleepdaily$B4AD413=="(2) NO"] <- "2"
d0_sleepdaily$TRSLEEP4 = as.numeric(d0_sleepdaily$TRSLEEP4)

d0_sleepdaily$TRSLEEP5[d0_sleepdaily$B4AD513=="(1) YES"] <- "1"
d0_sleepdaily$TRSLEEP5[d0_sleepdaily$B4AD513=="(2) NO"] <- "2"
d0_sleepdaily$TRSLEEP5 = as.numeric(d0_sleepdaily$TRSLEEP5)

d0_sleepdaily$TRSLEEP6[d0_sleepdaily$B4AD613=="(1) YES"] <- "1"
d0_sleepdaily$TRSLEEP6[d0_sleepdaily$B4AD613=="(2) NO"] <- "2"
d0_sleepdaily$TRSLEEP6 = as.numeric(d0_sleepdaily$TRSLEEP6)

d0_sleepdaily$TRSLEEP7[d0_sleepdaily$B4AD713=="(1) YES"] <- "1"
d0_sleepdaily$TRSLEEP7[d0_sleepdaily$B4AD713=="(2) NO"] <- "2"
d0_sleepdaily$TRSLEEP7 = as.numeric(d0_sleepdaily$TRSLEEP7)

d0_sleepdaily$START1 = d0_sleepdaily(myData$B4AD18,"%Y-%m-%d %H:%M:%S")

#####RESHAPING DATA#####


# Create squared Sleep Duration term to use in regression for curvilinear (quadratic) relationship with cognition
#  Get the mean SleepDuration, then subtract it from each person's score, then multiply the centered variables together


#Drop outlier EF
PSQ <- d0_PSQ[ which(d0_PSQ$B3TEFZ3 > -4.00), ]

#Sleep duration term
PSQ$DurationC <- PSQ$B4S4 - 6.888
PSQ$Duration2 <- PSQ$DurationC * PSQ$DurationC


########## DESCRIPTIVE STATISTICS

##Run descriptive stats on ds00 (dataset with daily sleep variables dropped)

#with psych pkg
library(Hmisc)
describe(PSQ)
summary(PSQ)

library(psych)
describe(ds0daily_nomissing)


# For Correlations, see: http://www.statmethods.net/stats/correlations.html

#### Multivariate outliers #### 

# create an indicator of multivariate outliers
means <- colMeans(ds[,2:ncol(ds)]) # create a vector of mean using colMeans function
means
covar <- cov(ds[,2:ncol(ds)]) # create a matrix of correlation using cor function
covar

ds$mahal <- mahalanobis(ds[,2:ncol(ds)], means, covar) # create a column storing mahalanobis distance using mahalanobis() function
ds <- ds[order(ds$mahal,decreasing=T),] # order by descreasing "mahal"
ds 

# use df=nvariables and alpha=.001 from chi-square table to identify cut-off point for "multivariate outlier" status.

# GRAPHICAL look at data

# Basic Scatterplot Matrix - so you can scan them all quickly
pairs(~B3TEMZ3+B3TEFZ3+SDis+B4S4+DurationC+Duration2,data=PSQ, 
      main="Scatterplot Matrix")

# what is the id of the person with a potential outlier?
ds <- ds_PSQ[order(ds_PSQ$B4S4,decreasing=T),]
head(ds)

# If you want to highlight just one Simple Scatterplot
attach(PSQ)
plot(Duration2, B3TEMZ3, main="Scatterplot of Memory by Sleep Duration", 
     xlab="Sleep Duration", ylab="Episodic Memory ", pch=19)

# you can add  fit lines to your scatterplot with:
abline(lm(DurationC~B3TEMZ3), col="red") # regression line (y~x) 

# If you want to make visually stunning graphs for your poster
# you can try playing around with ggplot2: see  http://www.cookbook-r.com/Graphs/ 
# but lets get the basics done first.

# Multiple Linear Regression for Memory 
fit <- lm(B3TEMZ3 ~ SDis + DurationC + Duration2, data=PSQ)
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
fit <- lm(B3TEFZ3 ~ WAKE, data=d0_sleepdaily)
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
fit_h1_1 <- lm(B3TEMZ3 ~ SQUAL, data=PSQ)
summary(fit_h1_1) # show results

#EF
fit_h1_2 <- lm(B3TEFZ3 ~ SQUAL, data=PSQ)
summary(fit_h1_2) # show results

# Hypothesis 2: There is an association between sleep duration and cognition in that sleep duration predicts cognitive scores.

#memory
fit_h2_1 <- lm(B3TEMZ3 ~ DurationC + Duration2, data=PSQ)
summary(fit_h2_1) # show results

#EF
fit_h2_2 <- lm(B3TEFZ3 ~ DurationC + Duration2, data=PSQ)
summary(fit_h2_2) # show results

# Hypothesis 3: There is an association between sleep disturbance and cognition in that sleep disturbance predicts cognitive scores.

#memory
fit_h3_1 <- lm(B3TEMZ3 ~ SDis, data=PSQ)
summary(fit_h3_1) # show results

#EF
fit_h3_2 <- lm(B3TEFZ3 ~ SDis, data=PSQ)
summary(fit_h3_2) # show results


#Hypothesis 4: Sleep duration and sleep disturbance together are better predictors of cognitive score compared to each predictor separately.

#memory
fit_h4_1 <- lm(B3TEMZ3 ~ SDis + DurationC + Duration2, data=PSQ)
summary(fit_h4_1) # show results

#EF
fit_h4_2 <- lm(B3TEFZ3 ~ SDis + DurationC + Duration2, data=PSQ)
summary(fit_h4_2) # show results

#                       (Regress Cognition on sleep disturbance, sleep duration & sleepduration squared)
