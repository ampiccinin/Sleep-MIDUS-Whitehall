# remove all elements for a clean start
rm(list=ls(all=TRUE))

## @knitr LoadData
load("./Data/Raw/25281-0001-Data.rda")
load("./Data/Raw/29282-0001-Data.rda")

ds01 <- da25281.0001
ds02 <- da29282.0001
str(ds01)

ds0 <- merge(ds01,ds02,by="M2ID", all=TRUE)


# Object with MIDUS II participant variables from ds0.
MIDUS_pvars <- c('M2ID', 'B1PAGE_M2.x', 'B1PGENDER.x', 'B4ZAGE')

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
MIDUS_all <- c('M2ID', 'B1PAGE_M2.x', 'B1PGENDER.x', 'B4ZAGE', 
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

# MIDUS_pvars codes:
# M2ID = Participant ID number
# B1PAGE_M2 = Age deterimined by subtracting DOB_Final from b1ipdate
# B1PGENDER = Gender
# B4ZAGE = Respondent age at P4 data collection (Biomarker project)

# MIDUS_cogvars codes:
# B3TCOMPZ3 = Z-score Brief Test of Adult Cognition by Telephone for complete sample (MIDUS + Milkwaukee)
# B3TEMZ3 = Z-score Episodic memory computer for complete sample (MIDUS + Milwaukee)
# B3TEFZ3 = Z-score executive functioning for complete sample (MIDUS + Milwaulkee)


#Variables pulled out of ds0
dspvars <- ds0[MIDUS_pvars]
dscog <- ds0[MIDUS_cogvars]
dssleep <-ds0[MIDUS_sleepvars]
ds_ALL <-ds0[MIDUS_all]
