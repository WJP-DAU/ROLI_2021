clear
set more off, perm

*cd "C:\Users\nrodriguez\Dropbox\WJP\QRQ 2021 Final Data"
*cd "C:\Users\poncea\Dropbox\Rule_of_Law_Index\Vienna_2\Index_3\2020\Data\QRQ\"

/*=================================================================================================================
					Pre-settings
=================================================================================================================*/

*--- Required packages:
* NONE

*--- Defining paths to SharePoint & your local Git Repo copy:

*------ (a) Natalia Rodriguez:
if (inlist("`c(username)'", "nrodriguez")) {
	global path2SP "C:\Users\nrodriguez\OneDrive - World Justice Project\Programmatic\Data Analytics\7. WJP ROLI\ROLI_2021\1. Cleaning\QRQ"
	global path2GH ""
}


*--- Defining path to Data and DoFiles:
global path2data "${path2SP}/1. Data"
global path2dos  "${path2SP}/2. Code"

/*-------------------------------------------------------*/
/* THIS FILE INCORPORATES ALSO THE RESPONDENTS FROM 2014 */
/*-------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*----------------------*/
/* I. Cleaning the data */
/*----------------------*/
/*-----------*/
/* 1. Civil  */
/*-----------*/

import delimited using "$path2data/1. Original/CCLong.csv"
drop *_2019
gen longitudinal=1
order sg_id
save "$path2data/1. Original/cc_final_long.dta", replace

clear
import delimited using "$path2data/1. Original/CCReg.csv"
rename (cc_g34a cc_35g) (cc_q34a cc_q35g)
gen longitudinal=0

// Append the regular and the longitudinal databases
append using "$path2data/1. Original/cc_final_long.dta"
drop cc_leftout-cc_referral3_language ivstatus
gen question="cc"

* Check for experts without id
count if sg_id==.

rename sg_id id_original
rename vlanguage language
rename wjp_country country

* Create ID
egen id=concat(language longitudinal id_original), punct(_)
egen id_alex=concat(question id), punct(_)
drop id id_original

/* These 3 lines are for incorporating 2019 data */
gen year=2021
gen regular=0
drop if language=="Last_Year"

order question year regular longitudinal id_alex language country wjp_login

/* Drop new variables for Andrei added in 2017 (Not used for the Index) */
drop cc_q17a cc_q17b cc_q18a cc_q18b


/* Recoding question 26 */
foreach var of varlist cc_q26a-cc_q26k {
	replace `var'=. if `var'==99
}

/* Recoding questions */
foreach var of varlist cc_q20a cc_q20b cc_q21 {
	replace `var'=1 if `var'==0
	replace `var'=2 if `var'==5
	replace `var'=3 if `var'==25
	replace `var'=4 if `var'==50
	replace `var'=5 if `var'==75
	replace `var'=6 if `var'==100
}
/* Changing 9 for missing */
foreach var of varlist cc_q1- cc_q5e {
	replace `var'=. if `var'==9
}

foreach var of varlist cc_q7a-cc_q25  {
	replace `var'=. if `var'==9
}

foreach var of varlist cc_q27- cc_q40b{
	replace `var'=. if `var'==9
}

/* Change names to match the MAP file and the GPP */

drop if country=="Burundi"

replace country="Congo, Rep." if country=="Republic of Congo"
replace country="Korea, Rep." if country=="Republic of Korea"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Iran, Islamic Rep." if country=="Iran"
replace country="St. Kitts and Nevis" if country=="Saint Kitts and Nevis"		
replace country="St. Lucia" if country=="Saint Lucia"
replace country="St. Vincent and the Grenadines" if country=="Saint Vincent and the Grenadines"
replace country="Cote d'Ivoire" if country=="Ivory Coast"
replace country="Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country="Gambia" if country=="The Gambia"

replace country="Kyrgyz Republic" if country=="Kyrgyzstan"
replace country="North Macedonia" if country=="Macedonia, FYR"
replace country="Russian Federation" if country=="Russia"
replace country="Venezuela, RB" if country=="Venezuela"

save "$path2data/1. Original/cc_final.dta", replace
erase "$path2data/1. Original/cc_final_long.dta"

/*--------------*/
/* 2. Criminal  */
/*--------------*/

clear
import delimited using "$path2data/1. Original/CJLong.csv"
drop *_2019
gen longitudinal=1
order sg_id
drop cj_leftout-cj_referral3_language ivstatus
save "$path2data/1. Original/cj_final_long.dta", replace

clear
import delimited using "$path2data/1. Original/CJReg.csv"
gen longitudinal=0
drop cj_leftout-cj_referral3_language ivstatus

// Append the regular and the longitudinal databases
append using "$path2data/1. Original/cj_final_long.dta"
gen question="cj"

* Check for experts without id
count if sg_id==.

rename sg_id id_original
rename vlanguage language
rename wjp_country country

* Create ID
egen id=concat(language longitudinal id_original), punct(_)
egen id_alex=concat(question id), punct(_)
drop id id_original

/* These 3 lines are for incorporating 2019 data */
gen year=2021
gen regular=0
drop if language=="Last_Year"

order question year regular longitudinal id_alex language country wjp_login

/* Change 99 for missing */
foreach var of varlist cj_q16a- cj_q21k cj_q27a cj_q27b cj_q37a-cj_q37d cj_q43a-cj_q43h  {
	replace `var'=. if `var'==99
}

/* Changing 9 for missing */
foreach var of varlist cj_q1- cj_q15 cj_q17 {
	replace `var'=. if `var'==9
}

/* Recoding questions */
foreach var of varlist cj_q22a-cj_q25c cj_q28 {
	replace `var'=1 if `var'==0
	replace `var'=2 if `var'==5
	replace `var'=3 if `var'==25
	replace `var'=4 if `var'==50
	replace `var'=5 if `var'==75
	replace `var'=6 if `var'==100
}

foreach var of varlist cj_q22a-cj_q36d cj_q38-cj_q42h {
	replace `var'=. if `var'==9
}

/* Change names to match the MAP file and the GPP */

drop if country=="Burundi"

replace country="Congo, Rep." if country=="Republic of Congo"
replace country="Korea, Rep." if country=="Republic of Korea"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Iran, Islamic Rep." if country=="Iran"
replace country="St. Kitts and Nevis" if country=="Saint Kitts and Nevis"		
replace country="St. Lucia" if country=="Saint Lucia"
replace country="St. Vincent and the Grenadines" if country=="Saint Vincent and the Grenadines"
replace country="Cote d'Ivoire" if country=="Ivory Coast"
replace country="Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country="Gambia" if country=="The Gambia"

replace country="Kyrgyz Republic" if country=="Kyrgyzstan"
replace country="North Macedonia" if country=="Macedonia, FYR"
replace country="Russian Federation" if country=="Russia"
replace country="Venezuela, RB" if country=="Venezuela"

save "$path2data/1. Original/cj_final.dta", replace
erase "$path2data/1. Original/cj_final_long.dta"

/*-----------*/
/* 3. Labor  */
/*-----------*/

clear
import delimited using "$path2data/1. Original/LBLong.csv"
drop *_2019
gen longitudinal=1
order sg_id
drop lb_teach lb_leftout-lb_referral3_language ivstatus
save "$path2data/1. Original/lb_final_long.dta", replace

clear
import delimited using "$path2data/1. Original/LBReg.csv"

gen longitudinal=0
drop lb_teach lb_leftout-lb_referral3_language ivstatus

// Append the regular and the longitudinal databases
append using "$path2data/1. Original/lb_final_long.dta"
gen question="lb"

* Check for experts without id
count if sg_id==.

rename sg_id id_original
rename vlanguage language
rename wjp_country country

* Create ID
egen id=concat(language longitudinal id_original), punct(_)
egen id_alex=concat(question id), punct(_)
drop id id_original

/* These 3 lines are for incorporating 2019 data */
gen year=2021
gen regular=0
drop if language=="Last_Year"

order question year regular longitudinal id_alex language country wjp_login

/* Recoding questions */
foreach var of varlist lb_q11a lb_q11b lb_q12 {
	replace `var'=1 if `var'==0 
	replace `var'=2 if `var'==5
	replace `var'=3 if `var'==25
	replace `var'=4 if `var'==50
	replace `var'=5 if `var'==75
	replace `var'=6 if `var'==100
}

/* Changing 9 for missing */
foreach var of varlist lb_q1a- lb_q4d {
	replace `var'=. if `var'==9
}

foreach var of varlist lb_q6a- lb_q28b {
	replace `var'=. if `var'==9
}

/* Change names to match the MAP file and the GPP */

drop if country=="Burundi"

replace country="Congo, Rep." if country=="Republic of Congo"
replace country="Korea, Rep." if country=="Republic of Korea"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Iran, Islamic Rep." if country=="Iran"
replace country="St. Kitts and Nevis" if country=="Saint Kitts and Nevis"		
replace country="St. Lucia" if country=="Saint Lucia"
replace country="St. Vincent and the Grenadines" if country=="Saint Vincent and the Grenadines"
replace country="Cote d'Ivoire" if country=="Ivory Coast"
replace country="Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country="Gambia" if country=="The Gambia"

replace country="Kyrgyz Republic" if country=="Kyrgyzstan"
replace country="North Macedonia" if country=="Macedonia, FYR"
replace country="Russian Federation" if country=="Russia"
replace country="Venezuela, RB" if country=="Venezuela"

save "$path2data/1. Original/lb_final.dta", replace
erase "$path2data/1. Original/lb_final_long.dta"

/*------------------*/
/* 4. Public Health */
/*------------------*/

clear
import delimited using "$path2data/1. Original/PHLong.csv"
drop *_2019
gen longitudinal=1
order sg_id
drop ph_leftout-ph_referral3_language ivstatus
save "$path2data/1. Original/ph_final_long.dta", replace

clear
import delimited using "$path2data/1. Original/PHReg.csv"
drop ph_leftout-ph_referral3_language ivstatus
gen longitudinal=0

// Append the regular and the longitudinal databases
append using "$path2data/1. Original/ph_final_long.dta"
gen question="ph"

* Check for experts without id
count if sg_id==.

rename sg_id id_original
rename vlanguage language
rename wjp_country country

* Create ID
egen id=concat(language longitudinal id_original), punct(_)
egen id_alex=concat(question id), punct(_)
drop id id_original

/* These 3 lines are for incorporating 2019 data */
gen year=2021
gen regular=0
drop if language=="Last_Year"

order question year regular longitudinal id_alex language country wjp_login

/* Recoding questions */
foreach var of varlist ph_q5a ph_q5b ph_q5c ph_q5d {
	replace `var'=1 if `var'==0
	replace `var'=2 if `var'==5
	replace `var'=3 if `var'==25
	replace `var'=4 if `var'==50
	replace `var'=5 if `var'==75
	replace `var'=6 if `var'==100
}

/* Changing 9 for missing */
foreach var of varlist ph_q1a- ph_q6g {
	replace `var'=. if `var'==9
}

foreach var of varlist ph_q7- ph_q14 {
	replace `var'=. if `var'==9
}

/* Change names to match the MAP file and the GPP */

drop if country=="Burundi"

replace country="Congo, Rep." if country=="Republic of Congo"
replace country="Korea, Rep." if country=="Republic of Korea"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Iran, Islamic Rep." if country=="Iran"
replace country="St. Kitts and Nevis" if country=="Saint Kitts and Nevis"		
replace country="St. Lucia" if country=="Saint Lucia"
replace country="St. Vincent and the Grenadines" if country=="Saint Vincent and the Grenadines"
replace country="Cote d'Ivoire" if country=="Ivory Coast"
replace country="Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country="Gambia" if country=="The Gambia"

replace country="Kyrgyz Republic" if country=="Kyrgyzstan"
replace country="North Macedonia" if country=="Macedonia, FYR"
replace country="Russian Federation" if country=="Russia"
replace country="Venezuela, RB" if country=="Venezuela"

save "$path2data/1. Original/ph_final.dta", replace
erase "$path2data/1. Original/ph_final_long.dta"

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------*/
/* II. Appending the data */
/*------------------------*/
clear
use "$path2data/1. Original/cc_final.dta"
append using "$path2data/1. Original/cj_final.dta"
append using "$path2data/1. Original/lb_final.dta"
append using "$path2data/1. Original/ph_final.dta"

save "$path2data/1. Original/qrq.dta", replace

erase "$path2data/1. Original/cc_final.dta"
erase "$path2data/1. Original/cj_final.dta"
erase "$path2data/1. Original/lb_final.dta"
erase "$path2data/1. Original/ph_final.dta"

/*--------------------------*/
/* III. Re-scaling the data */
/*--------------------------*/
/*----------*/
/* 1. Civil */
/*----------*/
use "$path2data/1. Original/qrq.dta", clear

foreach var of varlist cc_q1- cc_q5e cc_q7a- cc_q40b {
	gen `var'_norm=.
}

/* Cases */
replace cc_q1_norm=1 if cc_q1==1
replace cc_q1_norm=0 if cc_q1==2 | cc_q1==3

replace cc_q15_norm=(cc_q15-1)/2

/* Dummy  */
replace cc_q12_norm=0 if cc_q12==2
replace cc_q12_norm=1 if cc_q12==1
replace cc_q23g_norm=0 if cc_q23g==. & question=="cc"
replace cc_q23g_norm=1 if cc_q23g==1 & question=="cc"

/* Likert 3 Values: Positive */
# delimit;
foreach var of varlist 
	cc_q31a cc_q31b cc_q31c cc_q31d cc_q31e cc_q31f cc_q31g cc_q31h
	cc_q33 cc_q38 {;
	replace `var'_norm=(`var'-1)/2; 
};
# delimit cr;

/* Likert 3 Values: Negative */
replace cc_q25_norm=1-((cc_q25-1)/2)
replace cc_q27_norm=1-((cc_q27-1)/2)

/* Likert 4 Values: Positive */
# delimit;
foreach var of varlist 
	cc_q2a cc_q2b cc_q2c cc_q2d cc_q2e 
	cc_q5a cc_q5b cc_q5c cc_q5d cc_q5e
	cc_q8
	cc_q9a cc_q9b cc_q9c
	cc_q10
	cc_q11a cc_q11b cc_q11c
	cc_q13
	cc_q14a cc_q14b
	cc_q16a cc_q16b cc_q16c cc_q16d cc_q16e cc_q16f cc_q16g
	cc_q22a cc_q22b cc_q22c
	cc_q24
	cc_q29a cc_q29b cc_q29c
	cc_q30a cc_q30b cc_q30c
	cc_q32a cc_q32b cc_q32c cc_q32d cc_q32e cc_q32f cc_q32g cc_q32h cc_q32i cc_q32j cc_q32k cc_q32l
	cc_q34a cc_q34b cc_q34c cc_q34d cc_q34e cc_q34f cc_q34g cc_q34h cc_q34i cc_q34j cc_q34k cc_q34l
	cc_q35a cc_q35b cc_q35c cc_q35d cc_q35e cc_q35f cc_q35g
	cc_q36a cc_q36b cc_q36c cc_q36d cc_q36e cc_q36f cc_q36g 
	cc_q39a cc_q39b cc_q39c cc_q39d cc_q39e 
	cc_q40a cc_q40b {;
		replace `var'_norm=(`var'-1)/3; 
};
# delimit cr;

/* Likert 4 Values: Negative */
# delimit;
foreach var of varlist 
	cc_q2f
	cc_q7a cc_q7b cc_q7c cc_q7d cc_q7e
	cc_q19a cc_q19b cc_q19c cc_q19d cc_q19e cc_q19f cc_q19g cc_q19h cc_q19i cc_q19j cc_q19k cc_q19l
	cc_q23a cc_q23b cc_q23c cc_q23d cc_q23e cc_q23f
	cc_q28a cc_q28b cc_q28c cc_q28d cc_q28e cc_q28f
	cc_q29d
	cc_q36h 
	cc_q37a cc_q37b cc_q37c cc_q37d cc_q37e {;
		replace `var'_norm=1-((`var'-1)/3); 
};
# delimit cr;

/* Likert 5 Values: Positive */
# delimit;
foreach var of varlist 
	cc_q3a cc_q3b cc_q3c cc_q3d cc_q3e
	cc_q4a cc_q4b cc_q4c cc_q4d cc_q4e  {;
		replace `var'_norm=(`var'-1)/4; 
};
# delimit cr;

/* Likert 6 Values: Positive */
replace cc_q20a_norm=1 if cc_q20a==6
replace cc_q20a_norm=0.75 if cc_q20a==5
replace cc_q20a_norm=0.5 if cc_q20a==4
replace cc_q20a_norm=0.25 if cc_q20a==3
replace cc_q20a_norm=0.05 if cc_q20a==2
replace cc_q20a_norm=0 if cc_q20a==1

/* Likert 6 Values: Negative */
replace cc_q20b_norm=0 if cc_q20b==6
replace cc_q20b_norm=0.05 if cc_q20b==5
replace cc_q20b_norm=0.25 if cc_q20b==4
replace cc_q20b_norm=0.5 if cc_q20b==3
replace cc_q20b_norm=0.75 if cc_q20b==2
replace cc_q20b_norm=1 if cc_q20b==1

replace cc_q21_norm=0 if cc_q21==6
replace cc_q21_norm=0.05 if cc_q21==5
replace cc_q21_norm=0.25 if cc_q21==4
replace cc_q21_norm=0.5 if cc_q21==3
replace cc_q21_norm=0.75 if cc_q21==2
replace cc_q21_norm=1 if cc_q21==1

/* Likert 10 Values: Negative */
# delimit;
foreach var of varlist 
	cc_q26a cc_q26b cc_q26c cc_q26d cc_q26e cc_q26f cc_q26g cc_q26h cc_q26i cc_q26j cc_q26k {;
		replace `var'_norm=1-((`var'-1)/9); 
};
# delimit cr;

foreach var of varlist cc_q23a cc_q23b cc_q23c cc_q23d cc_q23e cc_q23f {
		replace `var'_norm=1 if cc_q23g_norm==1 & `var'_norm==.
}

/*-------------*/
/* 2. Criminal */
/*-------------*/
foreach var of varlist cj_q1- cj_q43h {
	gen `var'_norm=.
}

/* Cases */
gen alex=0 if cj_q38~=. 
replace alex=1 if cj_q38==4
bysort country: egen alex_co=mean(alex)
replace cj_q38_norm=1-((cj_q38-1)/2) if alex_co<0.5
replace cj_q38_norm=. if cj_q38==4
drop alex_co alex

replace cj_q8_norm=(cj_q8-1)/2
replace cj_q9_norm=(cj_q9-1)/2
replace cj_q14_norm=(cj_q14-1)

/* Dummy  */
replace cj_q12g_norm=0 if cj_q12g==. & question=="cj"
replace cj_q12g_norm=1 if cj_q12g==1 & question=="cj"

replace cj_q13g_norm=0 if cj_q13g==. & question=="cj"
replace cj_q13g_norm=1 if cj_q13g==1 & question=="cj"

/* Likert 4 Values: Positive */
# delimit;
foreach var of varlist 
	cj_q3a cj_q3b cj_q3c
	cj_q4
	cj_q17
	cj_q26
	cj_q30a cj_q30b
	cj_q35a cj_q35b cj_q35c cj_q35d cj_q35e
	cj_q36a cj_q36b cj_q36c cj_q36d
	cj_q39a cj_q39b cj_q39c cj_q39d cj_q39e cj_q39f cj_q39g cj_q39h cj_q39i cj_q39j cj_q39k cj_q39l
	cj_q40a cj_q40b cj_q40c cj_q40d cj_q40e cj_q40f cj_q40g cj_q40h
	cj_q41a cj_q41b cj_q41c cj_q41d cj_q41e cj_q41f cj_q41g {;
		replace `var'_norm=(`var'-1)/3; 
};
# delimit cr;

/* Likert 4 Values: Negative */
# delimit;
foreach var of varlist 
	cj_q1
	cj_q2
	cj_q5
	cj_q6a cj_q6b cj_q6c cj_q6d
	cj_q7a cj_q7b cj_q7c cj_q7d 
	cj_q10
	cj_q11a cj_q11b
	cj_q12a cj_q12b cj_q12c cj_q12d cj_q12e cj_q12f
	cj_q13a cj_q13b cj_q13c cj_q13d cj_q13e cj_q13f
	cj_q15
	cj_q29a cj_q29b cj_q29c cj_q29d
	cj_q31a cj_q31b cj_q31c cj_q31d cj_q31e cj_q31f cj_q31g cj_q31h cj_q31i
	cj_q32a cj_q32b cj_q32c cj_q32d cj_q32e
	cj_q33a cj_q33b cj_q33c cj_q33d cj_q33e 
	cj_q34a cj_q34b cj_q34c cj_q34d cj_q34e 
	cj_q41h
	cj_q42a cj_q42b cj_q42c cj_q42d cj_q42e cj_q42f cj_q42g cj_q42h {;
		replace `var'_norm=1-((`var'-1)/3); 
};
# delimit cr;

/* Likert 5 Values: Positive */
# delimit;
foreach var of varlist 
	cj_q27a cj_q27b {;
		replace `var'_norm=(`var'-1)/4; 
};
# delimit cr;

/* Likert 6 Values: Positive */
# delimit;
foreach var of varlist 
	cj_q22a cj_q22b cj_q22d cj_q22e
	cj_q23a cj_q23b cj_q23c cj_q23d cj_q23e
	cj_q24a {;
		replace `var'_norm=1 if `var'==6;
		replace `var'_norm=0.75 if `var'==5;
		replace `var'_norm=0.5 if `var'==4;
		replace `var'_norm=0.25 if `var'==3;
		replace `var'_norm=0.05 if `var'==2;
		replace `var'_norm=0 if `var'==1; 
};
# delimit cr;

/* Likert 6 Values: Negative */
# delimit;
foreach var of varlist 
	cj_q22c
	cj_q24b cj_q24c
	cj_q25a cj_q25b cj_q25c
	cj_q28 {;
		replace `var'_norm=0 if `var'==6;
		replace `var'_norm=0.05 if `var'==5;
		replace `var'_norm=0.25 if `var'==4;
		replace `var'_norm=0.5 if `var'==3;
		replace `var'_norm=0.75 if `var'==2;
		replace `var'_norm=1 if `var'==1; 
};
# delimit cr;

/* Likert 10 Values: Positive. Added by Natalia (before, the normalization was wrong */
foreach var of varlist cj_q43a cj_q43b cj_q43c cj_q43d cj_q43e cj_q43f cj_q43g cj_q43h {
		replace `var'_norm=(`var'-1)/9
}

/* Likert 10 Values: Negative */
# delimit;
foreach var of varlist 
	cj_q16a cj_q16b cj_q16c cj_q16d cj_q16e cj_q16f cj_q16g cj_q16h cj_q16i cj_q16j cj_q16k cj_q16l cj_q16m
 	cj_q18a cj_q18b cj_q18c cj_q18d cj_q18e
	cj_q19a cj_q19b cj_q19c cj_q19d cj_q19e cj_q19f cj_q19g
	cj_q20a cj_q20b cj_q20c cj_q20d cj_q20e cj_q20f cj_q20g cj_q20h cj_q20i cj_q20j cj_q20k cj_q20l cj_q20m cj_q20n cj_q20o cj_q20p
	cj_q21a cj_q21b cj_q21c cj_q21d cj_q21e cj_q21f cj_q21g cj_q21h cj_q21i cj_q21j cj_q21k 
	cj_q37a cj_q37b cj_q37c cj_q37d {;
		replace `var'_norm=1-((`var'-1)/9); 
};
# delimit cr;

foreach var of varlist cj_q12a cj_q12b cj_q12c cj_q12d cj_q12e cj_q12f {
		replace `var'_norm=1 if cj_q12g_norm==1 & `var'_norm==.
}

foreach var of varlist cj_q13a cj_q13b cj_q13c cj_q13d cj_q13e cj_q13f {
		replace `var'_norm=1 if cj_q13g_norm==1 & `var'_norm==.
}

/*----------*/
/* 3. Labor */
/*----------*/
foreach var of varlist lb_q1a-lb_q4d lb_q6a-lb_q28b {
	gen `var'_norm=.
}

/* Cases */
replace lb_q8_norm=(lb_q8-1)/2

replace lb_q9_norm=0 if lb_q9==1 | lb_q9==4
replace lb_q9_norm=0.5 if lb_q9==2
replace lb_q9_norm=1 if lb_q9==3

replace lb_q22_norm=1-((lb_q22-1)/2)

/* Dummy  */
replace lb_q13g_norm=0 if lb_q13g==. & question=="lb"
replace lb_q13g_norm=1 if lb_q13g==1 & question=="lb"

replace lb_q16g_norm=0 if lb_q16g==. & question=="lb"
replace lb_q16g_norm=1 if lb_q16g==1 & question=="lb"

/* Likert 3 Values: Positive */
# delimit;
foreach var of varlist 
	lb_q15a lb_q15b lb_q15c lb_q15d lb_q15e {;
	replace `var'_norm=(`var'-1)/2; 
};
# delimit cr;

/* Likert 3 Values: Negative */
# delimit;
foreach var of varlist 
	lb_q20a lb_q20b lb_q20c lb_q20d lb_q20e lb_q20f lb_q20g lb_q20h {;
	replace `var'_norm=1-((`var'-1)/2); 
};
# delimit cr;

/* Likert 4 Values: Positive */
# delimit;
foreach var of varlist 
	lb_q1a lb_q1b lb_q1c lb_q1d lb_q1e 
	lb_q4a lb_q4b lb_q4c lb_q4d
	lb_q7
	lb_q14
	lb_q18a lb_q18b lb_q18c 
	lb_q19a lb_q19b lb_q19c lb_q19d
	lb_q21a lb_q21b lb_q21c lb_q21d lb_q21e lb_q21f lb_q21g lb_q21h lb_q21i lb_q21j
	lb_q23a lb_q23b lb_q23c lb_q23d lb_q23e lb_q23f lb_q23g
	lb_q24a lb_q24b lb_q24c lb_q24d lb_q24e lb_q24f lb_q24g lb_q24h
	lb_q25a lb_q25b lb_q25c lb_q25d lb_q25e lb_q25f lb_q25g lb_q25h lb_q25i 
	lb_q27a lb_q27b lb_q27c lb_q27d lb_q27e 
	lb_q28a lb_q28b {;
		replace `var'_norm=(`var'-1)/3; 
};
# delimit cr;

/* Likert 4 Values: Negative */
# delimit;
foreach var of varlist 
	lb_q1f
	lb_q6a lb_q6b lb_q6c lb_q6d lb_q6e
	lb_q10a lb_q10b lb_q10c lb_q10d lb_q10e lb_q10f lb_q10g lb_q10h lb_q10i lb_q10j lb_q10k lb_q10l
	lb_q13a lb_q13b lb_q13c lb_q13d lb_q13e lb_q13f
	lb_q16a lb_q16b lb_q16c lb_q16d lb_q16e lb_q16f
	lb_q17a lb_q17b lb_q17c lb_q17d lb_q17e
	lb_q18d
	lb_q25j
	lb_q26a lb_q26b lb_q26c lb_q26d lb_q26e lb_q26f lb_q26g {;
		replace `var'_norm=1-((`var'-1)/3); 
};
# delimit cr;

/* Likert 5 Values: Positive */
# delimit;
foreach var of varlist 
	lb_q2a lb_q2b lb_q2c lb_q2d
	lb_q3a lb_q3b lb_q3c lb_q3d {;
		replace `var'_norm=(`var'-1)/4; 
};
# delimit cr;

/* Likert 6 Values: Positive */
# delimit;
foreach var of varlist 
	lb_q11a {;
		replace `var'_norm=1 if `var'==6;
		replace `var'_norm=0.75 if `var'==5;
		replace `var'_norm=0.5 if `var'==4;
		replace `var'_norm=0.25 if `var'==3;
		replace `var'_norm=0.05 if `var'==2;
		replace `var'_norm=0 if `var'==1; 
};
# delimit cr;

/* Likert 6 Values: Negative */
# delimit;
foreach var of varlist 
	lb_q11b
	lb_q12 {;
		replace `var'_norm=0 if `var'==6;
		replace `var'_norm=0.05 if `var'==5;
		replace `var'_norm=0.25 if `var'==4;
		replace `var'_norm=0.5 if `var'==3;
		replace `var'_norm=0.75 if `var'==2;
		replace `var'_norm=1 if `var'==1; 
};
# delimit cr;

foreach var of varlist lb_q13a lb_q13b lb_q13c lb_q13d lb_q13e lb_q13f {
		replace `var'_norm=1 if lb_q13g_norm==1 & `var'_norm==.
}

foreach var of varlist lb_q16a lb_q16b lb_q16c lb_q16d lb_q16e lb_q16f {
		replace `var'_norm=1 if lb_q16g_norm==1 & `var'_norm==.
}

/*------------------*/
/* 4. Public Health */
/*------------------*/
foreach var of varlist ph_q1a - ph_q14{
	gen `var'_norm=.
}

/* Cases */
replace ph_q2_norm=(ph_q2-1)/2
replace ph_q7_norm=1-((ph_q7-1)/2)

replace ph_q3_norm=1 if ph_q3==1
replace ph_q3_norm=0 if ph_q3==2 | ph_q3==3

/* Dummy  */
replace ph_q6h_norm=0 if ph_q6h==. & question=="PH"
replace ph_q6h_norm=1 if ph_q6h==1 & question=="PH"

/* Likert 4 Values: Positive */
# delimit;
foreach var of varlist 
	ph_q1a ph_q1b ph_q1c 
	ph_q4a ph_q4b ph_q4c
	ph_q9a ph_q9b ph_q9c 
	ph_q10a ph_q10b ph_q10c ph_q10d ph_q10e ph_q10f
	ph_q13
	ph_q14 {;
		replace `var'_norm=(`var'-1)/3; 
};
# delimit cr;

/* Likert 4 Values: Negative */
# delimit;
foreach var of varlist 
	ph_q1d
	ph_q6a ph_q6b ph_q6c ph_q6d ph_q6e ph_q6f ph_q6g
	ph_q8a ph_q8b ph_q8c ph_q8d ph_q8e ph_q8f ph_q8g
	ph_q9d
	ph_q11a ph_q11b ph_q11c
	ph_q12a ph_q12b ph_q12c ph_q12d ph_q12e {;
		replace `var'_norm=1-((`var'-1)/3); 
};
# delimit cr;

/* Likert 6 Values: Positive */
# delimit;
foreach var of varlist 
	ph_q5a {;
		replace `var'_norm=1 if `var'==6;
		replace `var'_norm=0.75 if `var'==5;
		replace `var'_norm=0.5 if `var'==4;
		replace `var'_norm=0.25 if `var'==3;
		replace `var'_norm=0.05 if `var'==2;
		replace `var'_norm=0 if `var'==1; 
};
# delimit cr;

/* Likert 6 Values: Negative */
# delimit;
foreach var of varlist 
	ph_q5b ph_q5c ph_q5d {;
		replace `var'_norm=0 if `var'==6;
		replace `var'_norm=0.05 if `var'==5;
		replace `var'_norm=0.25 if `var'==4;
		replace `var'_norm=0.5 if `var'==3;
		replace `var'_norm=0.75 if `var'==2;
		replace `var'_norm=1 if `var'==1; 
};
# delimit cr;

foreach var of varlist ph_q6a ph_q6b ph_q6c ph_q6d ph_q6e ph_q6f ph_q6g {
		replace `var'_norm=1 if ph_q6h_norm==1 & `var'_norm==.
}


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------*/
/* IV. Creating variables common in various questionnaires */
/*---------------------------------------------------------*/

gen all_q1=cc_q36h_norm if question=="cc"
replace all_q1=cj_q41h_norm if question=="cj"
replace all_q1=lb_q25j_norm if question=="lb"

gen all_q2=cc_q35a_norm if question=="cc"
replace all_q2=cj_q40a_norm if question=="cj"
replace all_q2=lb_q24a_norm if question=="lb"

gen all_q3=cc_q35d_norm if question=="cc"
replace all_q3=cj_q40d_norm if question=="cj"
replace all_q3=lb_q24d_norm if question=="lb"

gen all_q4=cc_q35b_norm if question=="cc"
replace all_q4=cj_q40b_norm if question=="cj"
replace all_q4=lb_q24b_norm if question=="lb"

gen all_q5=cc_q26k_norm if question=="cc"
replace all_q5=cj_q20m_norm if question=="cj"

gen all_q6=cc_q21_norm if question=="cc"
replace all_q6=lb_q12_norm if question=="lb"

gen all_q7=cc_q35c_norm if question=="cc"
replace all_q7=cj_q40c_norm if question=="cj"
replace all_q7=lb_q24c_norm if question=="lb"

gen all_q8=cc_q36d_norm if question=="cc"
replace all_q8=cj_q41d_norm if question=="cj"
replace all_q8=lb_q25d_norm if question=="lb"

gen all_q9=cc_q35e_norm if question=="cc"
replace all_q9=cj_q40e_norm if question=="cj"
replace all_q9=lb_q24e_norm if question=="lb"

gen all_q10=cc_q35f_norm if question=="cc"
replace all_q10=cj_q40f_norm if question=="cj"
replace all_q10=lb_q24f_norm if question=="lb"

gen all_q11=cj_q40g_norm if question=="cj"
replace all_q11=lb_q24g_norm if question=="lb"

gen all_q12=cc_q35g_norm if question=="cc"
replace all_q12=cj_q40h_norm if question=="cj"
replace all_q12=lb_q24h_norm if question=="lb"

gen all_q13=cj_q42a_norm if question=="cj"
replace all_q13=lb_q26a_norm if question=="lb"

gen all_q14=cc_q34e_norm if question=="cc"
replace all_q14=cj_q39e_norm if question=="cj"

gen all_q15=cc_q34h_norm if question=="cc"
replace all_q15=cj_q39h_norm if question=="cj"

gen all_q16=cc_q34i_norm if question=="cc"
replace all_q16=cj_q39i_norm if question=="cj"

gen all_q17=cj_q42b_norm if question=="cj"
replace all_q17=lb_q26b_norm if question=="lb"

gen all_q18=cc_q34j_norm if question=="cc"
replace all_q18=cj_q39j_norm if question=="cj"

gen all_q19=cc_q34a_norm if question=="cc"
replace all_q19=cj_q39a_norm if question=="cj"

gen all_q20=cc_q34k_norm if question=="cc"
replace all_q20=cj_q39k_norm if question=="cj"
replace all_q20=lb_q25h_norm if question=="lb"

gen all_q21=cc_q34l_norm if question=="cc"
replace all_q21=cj_q39l_norm if question=="cj"
replace all_q21=lb_q25i_norm if question=="lb"

gen all_q22=cc_q36a_norm if question=="cc"
replace all_q22=cj_q41a_norm if question=="cj"
replace all_q22=lb_q25a_norm if question=="lb"

gen all_q23=cc_q36f_norm if question=="cc"
replace all_q23=cj_q41f_norm if question=="cj"
replace all_q23=lb_q25f_norm if question=="lb"

gen all_q24=cc_q36b_norm if question=="cc"
replace all_q24=cj_q41b_norm if question=="cj"
replace all_q24=lb_q25b_norm if question=="lb"

gen all_q25=cc_q36c_norm if question=="cc"
replace all_q25=cj_q41c_norm if question=="cj"
replace all_q25=lb_q25c_norm if question=="lb"

gen all_q26=cc_q36e_norm if question=="cc"
replace all_q26=cj_q41e_norm if question=="cj"
replace all_q26=lb_q25e_norm if question=="lb"

gen all_q27=cc_q36g_norm if question=="cc"
replace all_q27=cj_q41g_norm if question=="cj"
replace all_q27=lb_q25g_norm if question=="lb"

gen all_q28=cc_q20b_norm if question=="cc"
replace all_q28=lb_q11b_norm if question=="lb"

gen all_q29=cc_q34f_norm if question=="cc"
replace all_q29=cj_q39f_norm if question=="cj"

gen all_q30=cc_q34g_norm if question=="cc"
replace all_q30=cj_q39g_norm if question=="cj"

gen all_q31=cc_q34c_norm if question=="cc"
replace all_q31=cj_q39c_norm if question=="cj"

gen all_q32=cc_q34d_norm if question=="cc"
replace all_q32=cj_q39d_norm if question=="cj"

gen all_q33=cc_q32a_norm if question=="cc"
replace all_q33=cj_q35a_norm if question=="cj"
replace all_q33=lb_q21a_norm if question=="lb"
replace all_q33=ph_q10a_norm if question=="ph"

gen all_q34=cc_q32b_norm if question=="cc"
replace all_q34=cj_q35c_norm if question=="cj"
replace all_q34=lb_q21b_norm if question=="lb"

gen all_q35=cc_q32c_norm if question=="cc"
replace all_q35=cj_q35b_norm if question=="cj"
replace all_q35=lb_q21c_norm if question=="lb"
replace all_q35=ph_q10b_norm if question=="ph"

gen all_q36=cc_q32d_norm if question=="cc"
replace all_q36=lb_q21d_norm if question=="lb"
replace all_q36=ph_q10c_norm if question=="ph"

gen all_q37=cc_q32e_norm if question=="cc"
replace all_q37=lb_q21f_norm if question=="lb"
replace all_q37=ph_q10e_norm if question=="ph"

gen all_q38=cc_q32f_norm if question=="cc"
replace all_q38=cj_q35d_norm if question=="cj"
replace all_q38=lb_q21g_norm if question=="lb"

gen all_q39=cc_q32g_norm if question=="cc"
replace all_q39=cj_q35e_norm if question=="cj"
replace all_q39=lb_q21h_norm if question=="lb"
replace all_q39=ph_q10f_norm if question=="ph"

gen all_q40=cc_q31a_norm if question=="cc"
replace all_q40=lb_q20a_norm if question=="lb"

gen all_q41=cc_q31b_norm if question=="cc"
replace all_q41=lb_q20b_norm if question=="lb"

gen all_q42=cc_q31c_norm if question=="cc"
replace all_q42=lb_q20c_norm if question=="lb"

gen all_q43=cc_q31d_norm if question=="cc"
replace all_q43=lb_q20d_norm if question=="lb"

gen all_q44=cc_q31e_norm if question=="cc"
replace all_q44=lb_q20e_norm if question=="lb"

gen all_q45=cc_q31f_norm if question=="cc"
replace all_q45=lb_q20f_norm if question=="lb"

gen all_q46=cc_q31g_norm if question=="cc"
replace all_q46=lb_q20g_norm if question=="lb"

gen all_q47=cc_q31h_norm if question=="cc"
replace all_q47=lb_q20h_norm if question=="lb"

gen all_q48=cc_q30a_norm if question=="cc"
replace all_q48=lb_q19b_norm if question=="lb"

gen all_q49=cc_q30b_norm if question=="cc"
replace all_q49=lb_q19c_norm if question=="lb"

gen all_q50=cc_q30c_norm if question=="cc"
replace all_q50=lb_q19d_norm if question=="lb"

gen all_q51=cc_q20a_norm if question=="cc"
replace all_q51=lb_q11a_norm if question=="lb"

gen all_q52=cc_q15_norm if question=="cc"
replace all_q52=ph_q2_norm if question=="ph"

gen all_q53=cc_q38_norm if question=="cc"
replace all_q53=lb_q8_norm if question=="lb"

gen all_q54=cc_q1_norm if question=="cc"
replace all_q54=ph_q3_norm if question=="ph"

gen all_q55=cc_q29d_norm if question=="cc"
replace all_q55=lb_q18d_norm if question=="lb"

gen all_q56=cc_q28f_norm if question=="cc"
replace all_q56=lb_q17d_norm if question=="lb"

gen all_q57=cc_q7a_norm if question=="cc"
replace all_q57=lb_q6a_norm if question=="lb"

gen all_q58=cc_q7b_norm if question=="cc"
replace all_q58=lb_q6b_norm if question=="lb"

gen all_q59=cc_q7c_norm if question=="cc"
replace all_q59=lb_q6d_norm if question=="lb"

gen all_q60=cc_q19j_norm if question=="cc"
replace all_q60=cj_q20k_norm if question=="cj"
replace all_q60=lb_q10j_norm if question=="lb"

gen all_q61=cc_q7d_norm if question=="cc"
replace all_q61=lb_q6e_norm if question=="lb"

gen all_q62=cc_q32k_norm if question=="cc"
replace all_q62=lb_q21i_norm if question=="lb"

gen all_q63=cc_q32l_norm if question=="cc"
replace all_q63=lb_q21j_norm if question=="lb"

gen all_q64=cc_q19l_norm if question=="cc"
replace all_q64=lb_q10l_norm if question=="lb"

gen all_q65=cc_q8_norm if question=="cc"
replace all_q65=lb_q7_norm if question=="lb"

gen all_q66=cc_q19b_norm if question=="cc"
replace all_q66=lb_q10b_norm if question=="lb"

gen all_q67=cc_q19c_norm if question=="cc"
replace all_q67=lb_q10c_norm if question=="lb"

gen all_q68=cc_q19d_norm if question=="cc"
replace all_q68=lb_q10d_norm if question=="lb"

gen all_q69=cc_q19e_norm if question=="cc"
replace all_q69=lb_q10e_norm if question=="lb"

gen all_q70=cc_q19f_norm if question=="cc"
replace all_q70=lb_q10f_norm if question=="lb"

gen all_q71=cc_q5a_norm if question=="cc"
replace all_q71=lb_q4a_norm if question=="lb"

gen all_q72=cc_q5b_norm if question=="cc"
replace all_q72=lb_q4b_norm if question=="lb"

gen all_q73=cc_q19a_norm if question=="cc"
replace all_q73=lb_q10a_norm if question=="lb"

gen all_q74=cc_q19i_norm if question=="cc"
replace all_q74=lb_q10i_norm if question=="lb"

gen all_q75=cc_q19k_norm if question=="cc"
replace all_q75=lb_q10k_norm if question=="lb"

gen all_q76=cc_q23a_norm if question=="cc"
replace all_q76=lb_q13a_norm if question=="lb"

gen all_q77=cc_q23b_norm if question=="cc"
replace all_q77=lb_q13b_norm if question=="lb"

gen all_q78=cc_q23c_norm if question=="cc"
replace all_q78=lb_q13c_norm if question=="lb"

gen all_q79=cc_q23d_norm if question=="cc"
replace all_q79=lb_q13d_norm if question=="lb"

gen all_q80=cc_q23e_norm if question=="cc"
replace all_q80=lb_q13e_norm if question=="lb"

gen all_q81=cc_q23f_norm if question=="cc"
replace all_q81=lb_q13f_norm if question=="lb"

gen all_q82=cc_q19h_norm if question=="cc"
replace all_q82=lb_q10h_norm if question=="lb"

gen all_q83=cc_q19j_norm if question=="cc"
replace all_q83=lb_q10j_norm if question=="lb"

gen all_q84=cc_q3a_norm if question=="cc"
replace all_q84=lb_q2a_norm if question=="lb"

gen all_q85=cc_q3b_norm if question=="cc"
replace all_q85=lb_q2b_norm if question=="lb"

gen all_q86=cc_q4a_norm if question=="cc"
replace all_q86=lb_q3a_norm if question=="lb"

gen all_q87=cc_q4b_norm if question=="cc"
replace all_q87=lb_q3b_norm if question=="lb"

gen all_q88=cc_q19g_norm if question=="cc"
replace all_q88=lb_q10g_norm if question=="lb"

gen all_q89=cc_q5c_norm if question=="cc"
replace all_q89=lb_q4c_norm if question=="lb"

gen all_q90=cc_q3c_norm if question=="cc"
replace all_q90=lb_q2c_norm if question=="lb"

gen all_q91=cc_q4c_norm if question=="cc"
replace all_q91=lb_q3c_norm if question=="lb"

gen all_q92=cc_q24_norm if question=="cc"
replace all_q92=lb_q14_norm if question=="lb"

gen all_q93=cc_q37a_norm if question=="cc"
replace all_q93=cj_q42e_norm if question=="cj"
replace all_q93=lb_q26c_norm if question=="lb"

gen all_q94=cc_q37b_norm if question=="cc"
replace all_q94=cj_q42f_norm if question=="cj"
replace all_q94=lb_q26d_norm if question=="lb"

gen all_q95=cc_q37c_norm if question=="cc"
replace all_q95=cj_q42g_norm if question=="cj"
replace all_q95=lb_q26e_norm if question=="lb"

gen all_q96=cc_q37d_norm if question=="cc"
replace all_q96=cj_q42h_norm if question=="cj"
replace all_q96=lb_q26f_norm if question=="lb"

gen all_q97=cc_q37e_norm if question=="cc"
replace all_q97=lb_q26g_norm if question=="lb"

gen all_q98=cc_q39a_norm if question=="cc"
replace all_q98=lb_q27a_norm if question=="lb"

gen all_q99=cc_q39b_norm if question=="cc"
replace all_q99=lb_q27b_norm if question=="lb"

gen all_q100=cc_q39c_norm if question=="cc"
replace all_q100=lb_q27c_norm if question=="lb"

gen all_q101=cc_q39d_norm if question=="cc"
replace all_q101=lb_q27d_norm if question=="lb"

gen all_q102=cc_q39e_norm if question=="cc"
replace all_q102=lb_q27e_norm if question=="lb"

gen all_q103=cc_q40a_norm if question=="cc"
replace all_q103=lb_q28a_norm if question=="lb"

gen all_q104=cc_q40b_norm if question=="cc"
replace all_q104=lb_q28b_norm if question=="lb"

gen all_q105=cc_q34b_norm if question=="cc"
replace all_q105=cj_q39b_norm if question=="cj"
replace all_q105=lb_q21e_norm if question=="lb"

foreach var of varlist all_q1- all_q105 {
	rename `var' `var'_norm
}

sort country question id_alex

drop if id_alex=="cc__0_."
drop if id_alex=="cj__0_."
drop if id_alex=="lb__0_."
drop if id_alex=="ph__0_."
drop if id_alex=="cc__1_."
drop if id_alex=="cj__1_."
drop if id_alex=="lb__1_."
drop if id_alex=="ph__1_."

save "$path2data/1. Original/qrq.dta", replace

/*----------------------------------------------*/
/* VI. Merging with 2019 data and previous years */
/*----------------------------------------------*/
/* Responded in 2019 */
clear
use "$path2data/1. Original/qrq_original_2019.dta"
keep wjp_login
duplicates drop
sort wjp_login
save "$path2data/1. Original/qrq_2019_login.dta", replace

/* Responded longitudinal survey in 2020-2021 */ 
clear
use "$path2data/1. Original/qrq.dta"
keep wjp_login
duplicates drop
sort wjp_login
save "$path2data/1. Original/qrq_login.dta", replace 

/* Only answered in 2019 (and not in 2020-2021) (Login) */
clear
use "$path2data/1. Original/qrq_2019_login.dta"
merge 1:1 wjp_login using "$path2data/1. Original/qrq_login.dta"
keep if _merge==1
drop _merge
sort wjp_login
save "$path2data/1. Original/qrq_2019_login_unique.dta", replace 

/* Only answered in 2019 (and not in 2020-2021) (Full data) */
clear
use "$path2data/1. Original/qrq_original_2019.dta"
sort wjp_login
merge m:1 wjp_login using "$path2data/1. Original/qrq_2019_login_unique.dta"
keep if _merge==3
drop _merge
gen aux="2019"
egen id_alex_1=concat(id_alex aux), punct(_)
replace id_alex=id_alex_1
drop id_alex_1 aux
sort wjp_login
save "$path2data/1. Original/qrq_2019.dta", replace

erase "$path2data/1. Original/qrq_2019_login.dta"
erase "$path2data/1. Original/qrq_login.dta"
erase "$path2data/1. Original/qrq_2019_login_unique.dta"

/* Merging with 2019 data and older regular data*/
clear
use "$path2data/1. Original/qrq.dta"
append using "$path2data/1. Original/qrq_2019.dta"
*Observations are no longer longitudinal because the database we're appending only includes people that only answered in 2019 or before
replace longitudinal=0 if year==2019 | year==2018
drop total_score total_n f_1* f_2* f_3* f_4* f_6* f_7* f_8* N total_score_mean total_score_sd outlier outlier_CO

/* Change names of countries according to new MAP (for the 2019 and older data) */
replace country="Congo, Rep." if country=="Republic of Congo"
replace country="Korea, Rep." if country=="Republic of Korea"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Iran, Islamic Rep." if country=="Iran"
replace country="St. Kitts and Nevis" if country=="Saint Kitts and Nevis"		
replace country="St. Lucia" if country=="Saint Lucia"
replace country="St. Vincent and the Grenadines" if country=="Saint Vincent and the Grenadines"
replace country="Cote d'Ivoire" if country=="Ivory Coast"
replace country="Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country="Gambia" if country=="The Gambia"

replace country="Kyrgyz Republic" if country=="Kyrgyzstan"
replace country="North Macedonia" if country=="Macedonia, FYR"
replace country="Russian Federation" if country=="Russia"
replace country="Venezuela, RB" if country=="Venezuela"


/* Merging with Cost of Lawyers 2021 clean data for new countries */
/*
drop cc_q6a_usd cc_q6a_gni removed_in_2018
sort id_alex
merge id_alex using "cost of lawyers_2021.dta"
tab _merge
drop if _merge==2
drop _merge 
save qrq.dta, replace
*/


/*-----------*/
/* V. Checks */
/*-----------*/

/* 1.Averages */
egen total_score=rowmean(cc_q1_norm- ph_q14_norm)
drop if total_score==.

/* 2.Duplicates */
sort wjp_login
egen total_n=rownonmiss(cc_q1_norm- ph_q14_norm)

// Duplicates by login (can show duplicates for years and surveys. Ex: An expert that answered three qrq's one year)
duplicates tag wjp_login, generate (dup)
tab dup
*br if dup>0

// Duplicates by login and score (shows duplicates of year and expert, that SHOULD be removed)
duplicates tag wjp_login total_score, generate(true_dup)
tab true_dup
*br if true_dup>0

*I'm dropping this expert that has a duplicate survey for CJ 2014
drop if id_alex=="cj_English_0_717_2014_2016_2017_2018_2019"

// Duplicates by id and year (Doesn't show the country)
duplicates tag id_alex, generate (dup_alex)
tab dup_alex
*br if dup_alex>0

//Duplicates by id, year and score (Should be removed)
duplicates tag id_alex total_score, generate(true_dup_alex)
tab true_dup_alex
*br if true_dup_alex>0

//Duplicates by login and questionnaire. They should be removed if the country and year are the same.
duplicates tag question wjp_login, generate(true_dup_question)
tab true_dup_question
*br if true_dup_question>0

//Duplicates by login, questionnaire and year. They should be removed if the country and year are the same.
duplicates tag question wjp_login year, generate(true_dup_question_year)
tab true_dup_question_year
*br if true_dup_question_year>0

/* HABLARLO CON ALEX
//Duplicates by login (lowercases) and questionnaire. 
/*This check drops experts that have emails with uppercases and are included 
from two different years of the same questionnaire and country (consecutive years). We should remove the 
old responses that we are including as "regular" that we think are regular because of the 
upper and lower cases. */


gen wjp_login_lower=ustrlower(wjp_login)
duplicates tag question wjp_login_lower, generate(true_dup_question_lower)
tab true_dup_question_lower

sort wjp_login_lower year
br if true_dup_question_lower>0

bys wjp_login_lower country question: egen year_max=max(year) if true_dup_question_lower>0
gen dif_year=year_max-year if true_dup_question_lower>0

gen dup_mark=1 if year!=year_max & true_dup_question_lower>0
drop if dup_mark==1

*Test it again
drop true_dup_question_lower
duplicates tag question wjp_login_lower, generate(true_dup_question_lower)
tab true_dup_question_lower
sort wjp_login_lower year
br if true_dup_question_lower>0

drop dup true_dup dup_alex true_dup_alex true_dup_question true_dup_question_year 

*/

/* 3. Drop questionnaires with very few observations */

*Total number of experts by country
bysort country: gen N=_N

*Number of questions per QRQ
*CC: 162
*CJ: 197
*LB: 134
*PH: 49

*Drops surveys with less than 25 nonmissing values. Erin cleaned empty suveys and surveys with low responses
*There are countries with low total_n because we removed the DN/NA at the beginning of the do file
*br if total_n<25
drop if total_n<=25 & N>=10

/* 4.Outliers */
bysort country: egen total_score_mean=mean(total_score)
bysort country: egen total_score_sd=sd(total_score)
gen outlier=0
replace outlier=1 if total_score>=(total_score_mean+2.5*total_score_sd) & total_score~=.
replace outlier=1 if total_score<=(total_score_mean-2.5*total_score_sd) & total_score~=.
bysort country: egen outlier_CO=max(outlier)

*Shows the number of experts of low count countries have and if the country has outliers
tab country outlier_CO if N<20

*Shows the number of outlies per each low count country
tab country outlier if N<20

drop if outlier==1 & N>19 //Ireland has only 4 cj experts. 
*drop if outlier==1

sort country id_alex

/* 5. Factor scores */
egen f_1_2=rowmean(all_q1_norm all_q2_norm all_q20_norm all_q21_norm)
egen f_1_3=rowmean(all_q2_norm all_q3_norm cc_q25_norm all_q4_norm all_q5_norm all_q6_norm all_q7_norm all_q8_norm)
egen f_1_4=rowmean(cc_q33_norm all_q9_norm cj_q38_norm cj_q36c_norm cj_q8_norm)
egen f_1_5=rowmean(all_q52_norm all_q53_norm all_q93_norm all_q10_norm all_q11_norm all_q12_norm cj_q36b_norm cj_q36a_norm cj_q9_norm cj_q8_norm)
egen f_1_6=rowmean(all_q13_norm all_q14_norm all_q15_norm all_q16_norm all_q17_norm cj_q10_norm all_q18_norm all_q94_norm all_q19_norm all_q20_norm all_q21_norm)
egen f_1_7=rowmean(all_q23_norm all_q27_norm all_q22_norm all_q24_norm all_q25_norm all_q26_norm all_q8_norm)
egen f_1=rowmean(f_1_2 f_1_3 f_1_4 f_1_5 f_1_6 f_1_7)

egen f_2_1=rowmean(cc_q27_norm all_q97_norm ph_q5a_norm ph_q5b_norm ph_q7_norm cc_q28a_norm cc_q28b_norm cc_q28c_norm cc_q28d_norm all_q56_norm lb_q17e_norm lb_q17c_norm ph_q8d_norm lb_q17b_norm ph_q8a_norm ph_q8b_norm ph_q8c_norm ph_q8e_norm ph_q8f_norm ph_q8g_norm ph_q9d_norm ph_q11a_norm ph_q11b_norm ph_q11c_norm ph_q12a_norm ph_q12b_norm ph_q12c_norm ph_q12d_norm ph_q12e_norm all_q54_norm all_q55_norm all_q95_norm)
egen f_2_2=rowmean(all_q57_norm all_q58_norm all_q59_norm all_q60_norm cc_q26h_norm cc_q28e_norm lb_q6c_norm cj_q32b_norm all_q28_norm all_q6_norm)
egen f_2_3=rowmean(cj_q32c_norm cj_q32d_norm all_q61_norm cj_q31a_norm cj_q31b_norm cj_q34a_norm cj_q34b_norm cj_q34c_norm cj_q34d_norm cj_q34e_norm cj_q16j_norm cj_q18a_norm)
egen f_2_4=rowmean(all_q96_norm)
egen f_2=rowmean(f_2_1 f_2_2 f_2_3 f_2_4)

egen f_3_1=rowmean(all_q33_norm all_q34_norm all_q35_norm all_q36_norm all_q37_norm all_q38_norm cc_q32h_norm cc_q32i_norm)
egen f_3_2=rowmean(cc_q9b_norm cc_q39a_norm cc_q39b_norm cc_q39b_norm cc_q39c_norm cc_q39e_norm all_q40_norm all_q41_norm all_q42_norm all_q43_norm all_q44_norm all_q45_norm all_q46_norm all_q47_norm)
egen f_3_3=rowmean(all_q13_norm all_q14_norm all_q15_norm all_q16_norm all_q17_norm cj_q10_norm all_q18_norm all_q94_norm all_q19_norm all_q20_norm all_q21_norm all_q19_norm all_q31_norm all_q32_norm all_q14_norm cc_q9a_norm cc_q11b_norm cc_q32j_norm all_q105_norm)
egen f_3_4=rowmean(cc_q9c_norm cc_q40a_norm cc_q40b_norm)
egen f_3=rowmean(f_3_1 f_3_2 f_3_3 f_3_4)

egen f_4_1=rowmean(all_q76_norm lb_q16a_norm ph_q6a_norm cj_q12a_norm all_q77_norm lb_q16b_norm ph_q6b_norm cj_q12b_norm all_q78_norm lb_q16c_norm ph_q6c_norm cj_q12c_norm all_q79_norm lb_q16d_norm ph_q6d_norm cj_q12d_norm all_q80_norm lb_q16e_norm ph_q6e_norm cj_q12e_norm all_q81_norm lb_q16f_norm ph_q6f_norm cj_q12f_norm)
egen f_4_2=rowmean(cj_q11a_norm cj_q11b_norm cj_q31e_norm cj_q42c_norm cj_q42d_norm cj_q10_norm)
egen f_4_3=rowmean(cj_q22d_norm cj_q22b_norm cj_q25a_norm cj_q31c_norm cj_q22e_norm cj_q6a_norm cj_q6b_norm cj_q6c_norm cj_q29a_norm cj_q29b_norm cj_q42c_norm cj_q42d_norm cj_q22a_norm cj_q1_norm cj_q2_norm cj_q11a_norm cj_q22c_norm cj_q3a_norm cj_q3b_norm cj_q3c_norm cj_q19b_norm cj_q19c_norm cj_q4_norm cj_q21a_norm cj_q21b_norm cj_q21c_norm cj_q21d_norm cj_q21f_norm)
egen f_4_4=rowmean(all_q13_norm all_q14_norm all_q15_norm all_q16_norm all_q17_norm cj_q10_norm all_q18_norm all_q94_norm all_q19_norm all_q20_norm all_q21_norm)
egen f_4_5=rowmean(all_q29_norm all_q30_norm)
egen f_4_6=rowmean(cj_q31f_norm cj_q31g_norm cj_q42c_norm cj_q42d_norm)
egen f_4_7=rowmean(all_q19_norm all_q31_norm all_q32_norm all_q14_norm)
egen f_4_8=rowmean(lb_q16a_norm lb_q16b_norm lb_q16c_norm lb_q16d_norm lb_q16e_norm lb_q16f_norm lb_q23a_norm lb_q23b_norm lb_q23c_norm lb_q23d_norm lb_q23e_norm lb_q23f_norm lb_q23g_norm)
egen f_4=rowmean(f_4_1 f_4_2 f_4_3 f_4_4 f_4_5 f_4_6 f_4_7 f_4_8)

egen f_6_1=rowmean(lb_q8_norm lb_q9_norm lb_q22_norm lb_q15a_norm lb_q15b_norm lb_q15c_norm lb_q15d_norm lb_q15e_norm lb_q18a_norm lb_q18b_norm lb_q18c_norm cc_q1_norm cc_q29a_norm cc_q29b_norm cc_q29c_norm ph_q3_norm ph_q4a_norm ph_q4b_norm ph_q4c_norm ph_q9a_norm ph_q9b_norm ph_q9c_norm)
egen f_6_2=rowmean(all_q54_norm all_q55_norm cc_q28a_norm cc_q28b_norm cc_q28c_norm cc_q28d_norm all_q56_norm lb_q17e_norm lb_q17c_norm ph_q8d_norm lb_q17b_norm ph_q8a_norm ph_q8b_norm ph_q8c_norm ph_q8e_norm ph_q8f_norm ph_q8g_norm ph_q9d_norm ph_q11a_norm ph_q11b_norm ph_q11c_norm ph_q12a_norm ph_q12b_norm ph_q12c_norm ph_q12d_norm ph_q12e_norm)
egen f_6_3=rowmean(lb_q2d_norm lb_q3d_norm all_q62_norm all_q63_norm)
egen f_6_4=rowmean(all_q48_norm all_q49_norm all_q50_norm lb_q19a_norm)
egen f_6_5=rowmean(cc_q10_norm cc_q11a_norm cc_q16a_norm cc_q14a_norm cc_q14b_norm cc_q16b_norm cc_q16c_norm cc_q16d_norm cc_q16e_norm cc_q16f_norm cc_q16g_norm)
egen f_6=rowmean(f_6_1 f_6_2 f_6_3 f_6_4 f_6_5)

egen f_7_1=rowmean(all_q92_norm cj_q26_norm all_q75_norm all_q65_norm cc_q22a_norm cc_q22b_norm cc_q22c_norm cc_q12_norm all_q74_norm all_q75_norm all_q69_norm all_q70_norm all_q71_norm all_q72_norm)
egen f_7_2=rowmean(all_q76_norm all_q77_norm all_q78_norm all_q79_norm all_q80_norm all_q81_norm all_q82_norm)
egen f_7_3=rowmean(all_q57_norm all_q58_norm all_q59_norm all_q83_norm cc_q26h_norm cc_q28e_norm lb_q6c_norm all_q51_norm all_q28_norm)
egen f_7_4=rowmean(all_q6_norm cc_q11a_norm all_q3_norm all_q4_norm all_q7_norm)
egen f_7_5=rowmean(all_q84_norm all_q85_norm cc_q13_norm all_q88_norm cc_q26a_norm)
egen f_7_6=rowmean(cc_q26b_norm all_q86_norm all_q87_norm)
egen f_7_7=rowmean(all_q89_norm all_q59_norm all_q90_norm all_q91_norm cc_q14a_norm cc_q14b_norm)
egen f_7=rowmean(f_7_1 f_7_2 f_7_3 f_7_4 f_7_5 f_7_6 f_7_7)

egen f_8_1=rowmean(cj_q16a_norm cj_q16b_norm cj_q16c_norm cj_q16e_norm cj_q16f_norm cj_q16g_norm cj_q16h_norm cj_q16i_norm cj_q16j_norm cj_q18a_norm cj_q18d_norm cj_q25a_norm)
egen f_8_2=rowmean(cj_q27a_norm cj_q27b_norm cj_q7a_norm cj_q7b_norm cj_q7c_norm cj_q20a_norm cj_q20b_norm cj_q20e_norm)
egen f_8_3=rowmean(cj_q21a_norm cj_q21e_norm cj_q21g_norm cj_q21h_norm cj_q28_norm)
egen f_8_4=rowmean(cj_q12a_norm cj_q12b_norm cj_q12c_norm cj_q12d_norm cj_q12e_norm cj_q12f_norm cj_q20o_norm)
egen f_8_5=rowmean(cj_q32c_norm cj_q32d_norm cj_q31a_norm cj_q31b_norm cj_q34a_norm cj_q34b_norm cj_q34c_norm cj_q34d_norm cj_q34e_norm cj_q16j_norm cj_q18a_norm cj_q18d_norm cj_q32b_norm cj_q20k_norm)
egen f_8_6=rowmean(cj_q40b_norm cj_q40c_norm cj_q20m_norm)
egen f_8_7=rowmean(cj_q22d_norm cj_q22b_norm cj_q25a_norm cj_q31c_norm cj_q22e_norm cj_q6a_norm cj_q6b_norm cj_q6c_norm cj_q29a_norm cj_q29b_norm cj_q42c_norm cj_q42d_norm cj_q22a_norm cj_q1_norm cj_q2_norm cj_q11a_norm cj_q22c_norm cj_q3a_norm cj_q3b_norm cj_q3c_norm cj_q19b_norm cj_q19c_norm cj_q4_norm cj_q21a_norm cj_q21b_norm cj_q21c_norm cj_q21d_norm cj_q21f_norm)

egen f_8=rowmean(f_8_1 f_8_2 f_8_3 f_8_4 f_8_5 f_8_6 f_8_7)


*----- Saving original dataset BEFORE adjustments

save "C:\Users\nrodriguez\OneDrive - World Justice Project\Programmatic\Data Analytics\8. Data\QRQ\QRQ_2021_raw.dta", replace


/* Adjustments */

sort country question total_score

//Checked by Alex//

drop if id_alex=="cj_English_0_654_2018_2019"  /* Albania */
drop if id_alex=="lb_English_1_256" /* Albania */
replace cj_q12c_norm=. if country=="Albania" /* Albania */
drop if id_alex=="cc_Arabic_0_1666" /* Algeria */
replace all_q84_norm=. if country=="Algeria" /*Algeria*/
replace all_q85_norm=. if country=="Algeria" /*Algeria*/
replace cc_q26a_norm=. if country=="Algeria" /*Algeria*/
replace all_q87_norm=. if country=="Algeria" /*Algeria*/
replace all_q29_norm=0 if id_alex=="cj_French_0_596_2018_2019" /*Algeria*/
replace cj_q40b_norm=0 if id_alex=="cj_French_0_596_2018_2019" /*Algeria*/
replace cj_q40c_norm=0 if id_alex=="cj_French_0_596_2018_2019" /*Algeria*/
replace cj_q20m_norm=0 if id_alex=="cj_French_0_596_2018_2019" /*Algeria*/
drop if id_alex=="cc_Portuguese_1_1363" /*Angola*/ 
drop if id_alex=="cc_Portuguese_0_1430" /*Angola*/ 
drop if id_alex=="lb_Portuguese_0_219" /*Angola*/ 
drop if id_alex=="lb_Portuguese_0_274" /*Angola*/ 
drop if id_alex=="cc_Portuguese_0_452" /*Angola*/ 
drop if id_alex=="cj_Portuguese_0_103" /*Angola*/ 
drop if id_alex=="cj_Portuguese_0_136" /* Angola */
drop if id_alex=="cc_Portuguese_0_1319" /* Angola */
drop if id_alex=="cc_Portuguese_0_405" /* Angola */
drop if id_alex=="cj_Portuguese_1_1233_2019" /* Angola */
replace cc_q26a_norm=. if country=="Angola" /*Angola*/
replace cj_q11b_norm=. if country=="Angola" /* Angola */
replace cj_q31e_norm=. if country=="Angola" /* Angola */
replace cj_q42c_norm=. if country=="Angola" /* Angola */
replace cc_q10_norm=. if country=="Angola" /* Angola */
replace cc_q14b_norm=. if country=="Angola" /* Angola */
drop if id_alex=="cc_English_0_928" /*Antigua and Barbuda*/ 
replace cj_q21a_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
drop if id_alex=="lb_English_0_571" /*Antigua and Barbuda*/
drop if id_alex=="cc_English_0_1936_2018_2019" /*Antigua and Barbuda*/
replace cj_q38_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
drop if id_alex=="cc_English_0_1545_2016_2017_2018_2019" /*Antigua and Barbuda*/
drop if id_alex=="lb_English_0_905" /*Antigua and Barbuda*/
replace cj_q36c_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
replace cj_q32c_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
replace cj_q31a_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
replace cj_q16j_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
replace all_q78_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
replace cj_q21e_norm=. if country=="Antigua and Barbuda" /*Antigua and Barbuda*/
drop if id_alex=="cc_Spanish_0_172" /* Argentina */
drop if id_alex=="cc_Spanish_0_757" /* Argentina */
drop if id_alex=="cj_Spanish_0_730" /* Argentina */
drop if id_alex=="lb_Spanish_0_328" /* Argentina */
drop if id_alex=="cc_English_0_97" /* Argentina */
drop if id_alex=="cc_Spanish_0_843" /* Argentina */
drop if id_alex=="lb_Spanish_1_219_2016_2017_2018_2019" /* Argentina */
replace all_q26_norm=. if country=="Argentina" /* Argentina */
replace all_q88_norm=. if country=="Argentina" /* Argentina */
drop if id_alex=="cj_English_0_1024_2018_2019" /*Austria*/ /*Not added but Alex in his do file but correct in MAP*/
drop if id_alex=="cc_English_0_446" /*The Bahamas*/
drop if id_alex=="cc_English_0_1651" /*The Bahamas*/
drop if id_alex=="cc_English_0_399" /*The Bahamas*/
drop if id_alex=="cc_English_0_648" /*The Bahamas*/
drop if id_alex=="cj_English_0_1122" /*The Bahamas*/ /*Added by Alex, but not correct in MAP*/
drop if id_alex=="cj_English_1_1239" /*The Bahamas*/
replace cj_q42c_norm=. if country=="Bahamas" /*The Bahamas*/
replace cj_q42d_norm=. if country=="Bahamas" /*The Bahamas*/
replace cj_q22b_norm=. if country=="Bahamas" /*The Bahamas*/
replace cj_q29b_norm=. if country=="Bahamas" /*The Bahamas*/
drop if id_alex=="cc_English_1_1644_2019" /*Bangladesh*/
drop if id_alex=="ph_English_1_190_2018_2019" /*Bangladesh*/
drop if id_alex=="ph_English_0_62_2019" /*Bangladesh*/
drop if id_alex=="cc_English_0_1728" /*Bangladesh*/  
drop if id_alex=="cc_English_0_1157" /*Bangladesh*/
drop if id_alex=="cj_English_0_905_2019" /*Bangladesh*/ 
drop if id_alex=="lb_English_0_564" /*Bangladesh*/
replace all_q91_norm=. if country=="Bangladesh" /*Bangladesh*/
drop if id_alex=="cc_English_0_311" /*Bangladesh*/
drop if id_alex=="cc_English_1_811" /*Bangladesh*/
drop if id_alex=="cc_English_1_193" /*Barbados*/
drop if id_alex=="cj_English_0_1067" /*Barbados*/
replace all_q96_norm=0 if id_alex=="cc_English_1_377" /*Barbados*/
replace all_q96_norm=0 if id_alex=="cc_English_0_83_2016_2017_2018_2019" /*Barbados*/
replace all_q96_norm=0 if id_alex=="cc_English_0_300_2019" /*Barbados*/
replace all_q42_norm=. if country=="Barbados" /* Barbados */
replace cc_q39c_norm=. if country=="Barbados" /* Barbados */
replace lb_q16a_norm=1 if id_alex=="lb_English_0_527" /* Barbados */
replace lb_q16b_norm=1 if id_alex=="lb_English_0_527" /* Barbados */
replace lb_q16c_norm=1 if id_alex=="lb_English_0_527" /* Barbados */
replace lb_q16d_norm=1 if id_alex=="lb_English_0_527" /* Barbados */
replace lb_q16e_norm=1 if id_alex=="lb_English_0_527" /* Barbados */
replace lb_q16f_norm=1 if id_alex=="lb_English_0_527" /* Barbados */
drop if id_alex=="lb_English_0_37_2018_2019" /* Barbados */
replace all_q86_norm=1 if id_alex=="cc_English_1_557_2017_2018_2019" /* Barbados */
drop if id_alex=="cc_Russian_1_949" /* Belarus */
drop if id_alex=="cj_Russian_0_942" /* Belarus */
drop if id_alex=="cc_English_1_671_2016_2017_2018_2019" /* Belarus */
replace all_q85_norm=. if country=="Belarus" /*Belarus*/
replace cc_q26a_norm=. if country=="Belarus" /*Belarus*/
replace all_q84_norm=. if country=="Belarus" /*Belarus*/
replace cj_q28_norm=. if country=="Belarus" /*Belarus*/
replace cj_q19a_norm=. if country=="Belarus" /*Belarus*/
replace cj_q2_norm=. if country=="Belarus" /*Belarus*/
replace cj_q6d_norm=. if country=="Belarus" /*Belarus*/
drop if id_alex=="cc_French_1_957_2017_2018_2019" /*Belgium*/
drop if id_alex=="cc_French_1_665_2017_2018_2019" /*Belgium*/
drop if id_alex=="cc_French_1_752_2017_2018_2019" /* Belgium */
drop if id_alex=="cj_English_0_648" /*Belize*/
replace cj_q21h_norm=. if country=="Belize" /*Belize*/
drop if id_alex=="cc_English_0_875_2014_2016_2017_2018_2019" /*Belize*/
replace all_q87_norm=. if country=="Belize" /*Belize*/
replace cj_q15_norm=. if country=="Belize" /*Belize*/
replace all_q96_norm=. if id_alex=="cc_English_0_1247_2016_2017_2018_2019" /* Belize */
replace all_q96_norm=. if id_alex=="cc_English_1_56_2019" /* Belize */
replace all_q96_norm=. if id_alex=="cc_English_0_1339_2014_2016_2017_2018_2019" /* Belize */
replace cj_q42c_norm=. if country=="Belize" /* Belize */
replace all_q91_norm=. if country=="Belize" /* Belize */
replace cc_q14b_norm=. if country=="Belize" /* Belize */
replace all_q91_norm=1 if id_alex=="cc_English_0_1247_2016_2017_2018_2019" /* Belize */
replace cj_q40b_norm=. if id_alex=="cj_English_1_652" /* Belize */
drop if id_alex=="cc_French_1_327" /*Benin*/ 
drop if id_alex=="cc_English_1_1601" /*Benin*/  
drop if id_alex=="cj_French_1_716" /*Benin*/  
drop if id_alex=="cc_French_0_562" /*Benin*/
drop if id_alex=="cc_English_0_764_2018_2019" /*Benin*/
replace all_q78_norm=. if country=="Benin" /*Benin*/
drop if id_alex=="cc_French_0_1075_2018_2019" /*Benin*/
drop if id_alex=="lb_English_1_772" /*Benin*/
//Done by Alicia and Natalia//
drop if id_alex=="lb_Spanish_1_595" /*Bolivia*/
replace cj_q15_norm=. if country=="Bolivia" /*Bolivia*/
drop if id_alex=="cc_English_0_973_2019" /* Bolivia */
drop if id_alex=="cj_Spanish_1_826_2018_2019" /* Bolivia */
drop if id_alex=="cj_Spanish_1_764_2018_2019" /* Bolivia */
drop if id_alex=="lb_English_0_138" /* Botswana */
replace all_q4_norm=. if country=="Brazil" /* Brazil */
replace all_q6_norm=. if country=="Brazil" /* Brazil */
replace cj_q40b_norm=. if country=="Brazil" /* Brazil */
drop if id_alex=="cj_English_1_653" /*Bosnia and Herzegovina*/ 
drop if id_alex=="cj_English_0_484" /*Bosnia and Herzegovina*/ 
drop if id_alex=="lb_English_1_447" /*Bosnia and Herzegovina*/ 
replace lb_q2d_norm=. if country=="Bosnia and Herzegovina" /*Bosnia and Herzegovina*/ 
replace lb_q3d_norm=. if country=="Bosnia and Herzegovina" /*Bosnia and Herzegovina*/ 
replace all_q59_norm=. if country=="Bosnia and Herzegovina" /*Bosnia and Herzegovina*/
drop if id_alex=="cj_English_1_25"  /*Bosnia and Herzegovina*/
drop if id_alex=="cc_English_0_336" /*Botswana*/ 
drop if id_alex=="cj_English_0_601" /*Botswana*/ 
drop if id_alex=="cj_English_1_281_2019" /*Botswana*/ 
drop if id_alex=="cj_English_1_363_2017_2018_2019" /*Bulgaria*/
drop if id_alex=="cj_English_1_490" /*Bulgaria*/
drop if id_alex=="cc_French_0_1619" /*Burkina Faso*/
drop if id_alex=="lb_French_0_695" /*Burkina Faso*/
drop if id_alex=="cj_French_1_690" /*Burkina Faso*/
drop if id_alex=="ph_English_0_600_2018_2019" /*Burkina Faso*/
drop if id_alex=="ph_French_1_734" /*Burkina Faso*/
replace cj_q40b_norm=. if id_alex=="cj_French_1_835" /*Burkina Faso*/
replace cj_q40c_norm=. if id_alex=="cj_French_1_835" /*Burkina Faso*/
replace cj_q20m_norm=. if id_alex=="cj_French_1_835" /*Burkina Faso*/
drop if id_alex=="lb_French_0_518" /* Burkina Faso */
replace cj_q11b_norm=. if country=="Burkina Faso" /* Burkina Faso */
replace lb_q19a_norm=0 if id_alex=="lb_French_0_659" /* Burkina Faso */
drop if id_alex=="cc_English_0_1446" /*Cambodia*/
drop if id_alex=="cc_English_1_1077" /*Cambodia*/
drop if id_alex=="cj_English_0_88_2016_2017_2018_2019" /*Cambodia*/
drop if id_alex=="cj_English_1_801" /*Cambodia*/
drop if id_alex=="ph_English_1_722" /*Cameroon*/ 
drop if id_alex=="cc_English_0_194_2019" /*Cameroon*/
drop if id_alex=="cc_English_0_1568" /*Cameroon*/
drop if id_alex=="lb_French_0_730" /*Cameroon*/
drop if id_alex=="cc_French_1_1082" /*Cameroon*/
drop if id_alex=="lb_French_0_116_2019" /*Cameroon*/
replace ph_q6d_norm=. if country=="Cameroon" /*Cameroon*/
replace ph_q6e_norm=. if country=="Cameroon" /*Cameroon*/
replace ph_q6f_norm=. if country=="Cameroon" /*Cameroon*/
drop if id_alex=="cj_English_0_1067_2018_2019" /*Cameroon*/
replace ph_q5a_norm=. if country=="Cameroon" /*Cameroon*/
replace ph_q5b_norm=. if country=="Cameroon" /*Cameroon*/
replace cc_q27_norm=. if country=="Cameroon" /*Cameroon*/
drop if id_alex=="cc_English_0_840_2017_2018_2019" /*Cameroon*/
drop if id_alex=="lb_French_0_409_2016_2017_2018_2019" /*Canada*/
drop if id_alex=="cc_English_1_331_2016_2017_2018_2019" /*Canada*/
drop if id_alex=="cc_English_1_1246" /* Canada */
replace all_q95_norm=0 if id_alex=="lb_English_0_204_2019" /* Canada */
replace all_q96_norm=0 if id_alex=="lb_English_0_204_2019" /*Canada */
replace all_q80_norm=. if country=="Canada" /* Canada */
drop if id_alex=="lb_English_0_369" /* Canada */
replace all_q96_norm=0 if id_alex=="cc_English_0_1095_2019" /*Canada */
replace all_q96_norm=0 if id_alex=="cc_English_0_939_2018_2019" /*Canada */
drop if id_alex=="cc_Spanish_0_74_2016_2017_2018_2019" /*Chile*/
drop if id_alex=="cc_Spanish_1_1111" /*Chile*/
drop if id_alex=="cc_English_1_700_2018_2019" /*Chile*/
drop if id_alex=="cj_English_1_843" /* China */
drop if id_alex=="lb_English_0_622" /* China */
drop if id_alex=="lb_English_0_819" /* China */
drop if id_alex=="cj_English_0_220" /* China */
drop if id_alex=="cc_English_1_451_2019" /* China */
replace cj_q10_norm=. if country=="China" /* China */
replace cj_q28_norm=. if country=="China" /* China */
replace lb_q3d_norm=. if country=="China" /* China */
replace cc_q9c_norm=. if country=="China" /* China */
replace cc_q40b_norm=. if country=="China" /* China */
replace cj_q36c_norm=. if country=="China" /* China */
replace all_q63_norm=. if country=="China" /* China */
replace all_q29_norm=. if country=="China" /* China */
drop if id_alex=="cj_English_1_684" /* China */
drop if id_alex=="cc_English_1_1622_2019" /*Colombia :) */
drop if id_alex=="cc_Spanish_0_1340_2016_2017_2018_2019" /*Colombia :) */
drop if id_alex=="lb_Spanish_0_734_2017_2018_2019" /*Colombia :) */
drop if id_alex=="cj_Spanish_1_814_2016_2017_2018_2019" /*Colombia :) */
drop if id_alex=="ph_Spanish_1_254" /*Colombia :) */
drop if id_alex=="ph_Spanish_1_387" /*Colombia :) */
replace all_q85_norm=.  if id_alex=="cc_Spanish (Mexico)_0_1391_2019" /* Colombia */
replace all_q85_norm=.  if id_alex=="cc_French_1_714_2019" /* Colombia */
drop if id_alex=="cj_French_0_459" /*DRC*/  
drop if id_alex=="cj_French_0_155" /*DRC*/  
drop if id_alex=="lb_French_0_210_2019" /*DRC*/  
replace cj_q21h_norm=. if id_alex=="cj_French_1_934" /*DRC*/  
drop if id_alex=="ph_French_0_439" /*Congo, Rep.*/
drop if id_alex=="lb_French_0_352" /*Congo, Rep.*/
drop if id_alex=="cc_French_0_1217" /*Congo, Rep.*/
drop if id_alex=="cj_French_0_977" /*Congo, Rep.*/
replace cj_q33a_norm=. if country=="Congo, Rep." /*Congo, Rep.*/
replace cj_q33b_norm=. if country=="Congo, Rep." /*Congo, Rep.*/
replace cj_q33d_norm=. if country=="Congo, Rep." /*Congo, Rep.*/
drop if id_alex=="lb_English_0_631" /*Costa Rica*/
drop if id_alex=="cc_English_1_1382_2019" /*Costa Rica*/
drop if id_alex=="cc_French_1_779_2018_2019" /*Cote d'Ivoire*/  
drop if id_alex=="cj_French_0_987_2017_2018_2019" /*Cote d'Ivoire*/
drop if id_alex=="cj_French_0_950" /*Cote d'Ivoire*/
replace cj_q15_norm=. if id_alex=="cj_French_0_1347_2018_2019" /*Cote d'Ivoire*/
drop if id_alex=="cc_French_0_139" /*Cote d'Ivoire*/
drop if id_alex=="cc_English_0_392" /*Cote d'Ivoire*/
replace lb_q23d_norm=. if country=="Croatia" /* Croatia */
replace cj_q10_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q31g_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q42c_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q42d_norm=. if country=="Cyprus" /*Chipre*/
replace all_q62_norm=. if id_alex=="cc_English_0_62" /*Chipre*/
replace all_q63_norm=. if id_alex=="cc_English_0_62" /*Chipre*/
replace all_q62_norm=. if id_alex=="cc_English_0_1315" /*Chipre*/
replace all_q63_norm=. if id_alex=="cc_English_0_1315" /*Chipre*/
replace cc_q26a_norm=. if country=="Cyprus" /*Chipre*/
replace cc_q26b_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q21e_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q21g_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q21h_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q28_norm=. if country=="Cyprus" /*Chipre*/
replace cj_q20m_norm=. if country=="Cyprus" /*Chipre*/
replace all_q84_norm=. if country=="Cyprus" /*Chipre*/
replace cc_q13_norm=. if country=="Cyprus" /*Chipre*/ /* Cyprus */
replace cj_q40b_norm=0.6666666 if id_alex=="cj_English_0_843" /* Cyprus */
replace cj_q40c_norm=0.6666666 if id_alex=="cj_English_0_843" /* Cyprus */
replace cj_q31g_norm=. if country=="Czech Republic" /* Czech Republic */
drop if id_alex=="lb_English_1_375" /* Czech Republic */
replace ph_q5a_norm=. if country=="Czech Republic" /* Czech Republic */
drop if id_alex=="cc_English_0_1420" /* Czech Republic */
replace all_q76_norm=. if id_alex=="cc_English_0_620" /* Czech Republic */
replace all_q78_norm=. if country=="Denmark" /*Denmark*/
replace lb_q16c_norm=. if country=="Denmark" /*Denmark*/
replace all_q79_norm=. if country=="Denmark" /*Denmark*/
replace lb_q16d_norm=. if country=="Denmark" /*Denmark*/
replace ph_q6d_norm=. if country=="Denmark" /*Denmark*/
replace lb_q16e_norm=. if country=="Denmark" /*Denmark*/
replace all_q29_norm=. if country=="Denmark" /*Denmark*/
drop if id_alex=="cc_English_0_1976_2018_2019" /* Denmark */
drop if id_alex=="cj_English_0_334" /* Denmark */
drop if id_alex=="cc_English_0_1702" /*Dominica*/
drop if id_alex=="cj_English_1_1156" /*Dominica*/
replace cj_q34a_norm=. if country=="Dominica" /*Dominica*/
replace cj_q34b_norm=. if country=="Dominica" /*Dominica*/
replace cj_q34d_norm=. if country=="Dominica" /*Dominica*/
replace cj_q34e_norm=. if country=="Dominica" /*Dominica*/
replace all_q85_norm=. if country=="Dominica" /*Dominica*/
replace all_q87_norm=. if country=="Dominica" /*Dominica*/
replace cj_q28_norm=. if country=="Dominica" /*Dominica*/
replace cj_q21h_norm=. if country=="Dominica" /*Dominica*/
replace cj_q20m_norm=. if country=="Dominica" /*Dominica*/
replace all_q29_norm=. if id_alex=="cj_Spanish_0_321" /*Dominican Republic*/
replace all_q30_norm=. if id_alex=="cj_Spanish_0_321" /*Dominican Republic*/
replace cj_q12e_norm=. if id_alex=="cj_Spanish_0_1213_2019" /*Dominican Republic*/
replace cj_q12f_norm=. if id_alex=="cj_Spanish_0_1213_2019" /*Dominican Republic*/
replace cj_q12f_norm=. if id_alex=="cj_Spanish_0_62_2016_2017_2018_2019" /*Dominican Republic*/
drop if id_alex=="cj_Spanish_0_790"  /*Dominican Republic*/
drop if id_alex=="cj_Spanish_0_875" /*Dominican Republic*/
drop if id_alex=="cc_Spanish_0_1121_2016_2017_2018_2019" /* Ecuador */
drop if id_alex=="cc_Arabic_0_966" /*Egypt, Arab Rep.*/
drop if id_alex=="cj_Arabic_0_599" /*Egypt, Arab Rep.*/
drop if id_alex=="ph_English_1_441_2016_2017_2018_2019" /*Egypt, Arab Rep.*/
replace all_q1_norm=. if id_alex=="cc_English_0_349_2019" /*Egypt, Arab Rep.*/
replace all_q1_norm=. if id_alex=="cj_English_0_555" /*Egypt, Arab Rep.*/
replace all_q1_norm=. if id_alex=="lb_English_0_158_2013_2014_2016_2017_2018_2019" /*Egypt, Arab Rep.*/
*replace all_q52_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
*replace all_q13_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
*replace cc_q33_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
*replace all_q57_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/  
drop if id_alex=="cj_English_1_622" /*Egypt, Arab Rep.*/
drop if id_alex=="lb_English_0_673_2019" /*Egypt, Arab Rep.*/
drop if id_alex=="lb_Arabic_0_831" /*Egypt, Arab Rep.*/
drop if id_alex=="lb_English_1_752" /*Egypt, Arab Rep.*/
replace cc_q39c_norm=. if id_alex=="cc_English_0_1394_2019" /*Egypt, Arab Rep.*/
replace cc_q39e_norm=. if id_alex=="cc_English_0_1394_2019" /*Egypt, Arab Rep.*/
replace cc_q39c_norm=. if id_alex=="cc_English_1_575" /*Egypt, Arab Rep.*/
replace cc_q39e_norm=. if id_alex=="cc_English_1_575" /*Egypt, Arab Rep.*/
replace cj_q10_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
replace all_q18_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
replace cc_q40a_norm=. if id_alex=="cc_Arabic_0_1010" /*Egypt, Arab Rep.*/
replace cc_q40b_norm=. if id_alex=="cc_Arabic_0_1010" /*Egypt, Arab Rep.*/
replace lb_q3d_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
replace all_q62_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
replace all_q59_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
replace cj_q21h_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
replace cj_q28_norm=. if country=="Egypt, Arab Rep." /*Egypt, Arab Rep.*/
drop if id_alex=="cc_English_0_1108" /*Egypt, Arab Rep.*/
drop if id_alex=="cc_Spanish (Mexico)_0_611_2019" /*El Salvador*/
drop if id_alex=="cj_Spanish_1_156" /* El Salvador */
replace cj_q28_norm=. if id_alex=="cj_Spanish_0_326" /*El Salvador*/
replace cj_q28_norm=. if id_alex=="cj_Spanish_0_837_2017_2018_2019" /*El Salvador*/
drop if id_alex=="cj_Spanish_0_326" /* El Salvador */
drop if id_alex=="lb_English_1_328_2018_2019" /*Estonia*/
drop if id_alex=="cj_English_0_236" /*Estonia*/
replace cj_q38_norm=. if id_alex=="cj_English_1_779" /*Ethiopia*/
replace cj_q38_norm=. if id_alex=="cj_English_0_394" /*Ethiopia*/
replace cj_q38_norm=. if id_alex=="cj_English_1_1166" /*Ethiopia*/
replace lb_q16a_norm=. if country=="Ethiopia" /*Ethiopia*/
drop if id_alex=="cc_English_0_665_2017_2018_2019" /*Ethiopia*/
drop if id_alex=="cc_English_0_1577" /*Ethiopia*/
drop if id_alex=="lb_English_1_481_2019" /*Ethiopia*/
drop if id_alex=="lb_English_1_318" /*Ethiopia*/
drop if id_alex=="cj_English_0_394" /*Ethiopia*/
drop if id_alex=="cj_English_1_159" /*Ethiopia*/
replace lb_q16f_norm=. if country=="Ethiopia" /*Ethiopia*/
replace cj_q11a_norm=. if country=="France" /* France */
drop if id_alex=="lb_English_0_679" /* The Gambia */
replace all_q86_norm=. if id_alex=="cc_English_1_1027" /* The Gambia */
replace all_q86_norm=. if id_alex=="lb_English_0_646_2019" /* The Gambia */
replace all_q87_norm=. if id_alex=="cc_English_1_1027" /* The Gambia */
replace all_q87_norm=. if id_alex=="lb_English_0_646_2019" /* The Gambia */
replace cc_q13_norm=. if id_alex=="cc_English_0_1646" /* The Gambia */
replace lb_q16e_norm=. if id_alex=="lb_English_0_679" /* The Gambia */
replace lb_q16f_norm=. if id_alex=="lb_English_0_679" /* The Gambia */
drop if id_alex=="ph_English_0_264_2016_2017_2018_2019" /*Georgia*/
drop if id_alex=="ph_English_1_419" /*Georgia*/
drop if id_alex=="cj_English_0_430" /*Georgia*/
replace cj_q15_norm=. if id_alex=="cj_English_1_221" /*Germany*/
drop if id_alex=="cc_English_1_585_2016_2017_2018_2019" /* Germany */
drop if id_alex=="cc_English_0_557" /* Germany */
drop if id_alex=="cj_English_1_221" /* Germany */
drop if id_alex=="cc_English_1_581_2019" /* Germany */
replace cc_q33_norm=. if id_alex=="cc_English_0_861" /*Greece*/
replace cc_q33_norm=. if id_alex=="cc_English_0_1585" /*Greece*/
replace cj_q40b_norm=. if id_alex=="cj_English_1_1270" /*Greece*/
replace cj_q40b_norm=. if id_alex=="cj_English_1_236" /*Greece*/
replace cj_q40b_norm=. if id_alex=="cj_English_1_469" /*Greece*/
replace cj_q40b_norm=. if id_alex=="cj_English_1_469" /*Greece*/
drop if id_alex=="lb_English_0_521" /* Greece */
drop if id_alex=="cj_English_0_360_2018_2019" /* Greece */
drop if id_alex=="cc_English_0_1465" /* Greece */
replace cj_q36c_norm=. if country=="Greece" /* Greece */
replace all_q49_norm=. if country=="Greece" /* Greece */
replace cc_q10_norm=. if country=="Greece" /* Greece */
replace all_q87_norm=. if country=="Greece" /* Greece */
drop if id_alex=="cj_English_0_485" /*Ghana*/
replace cj_q11b_norm=. if id_alex=="cj_English_0_776" /*Ghana*/
replace cj_q25c_norm=. if country=="Ghana" /*Ghana*/
replace cj_q42c_norm=. if id_alex=="cj_English_0_1091_2019" /*Ghana*/
replace cj_q42d_norm=. if id_alex=="cj_English_0_1091_2019" /*Ghana*/
drop if id_alex=="cj_English_1_160_2018_2019" /*Ghana*/
drop if id_alex=="cc_English_0_395_2016_2017_2018_2019" /*Ghana*/
replace all_q62_norm=. if country=="Grenada" /*Grenada*/
replace all_q63_norm=. if country=="Grenada" /*Grenada*/
replace all_q69_norm=. if country=="Grenada" /*Grenada*/
replace all_q70_norm=. if country=="Grenada" /*Grenada*/
replace all_q84_norm=. if country=="Grenada" /*Grenada*/
replace cc_q13_norm=. if country=="Grenada" /*Grenada*/
replace all_q87_norm=0.25 if id_alex=="cc_English_0_1676" /*Grenada*/
replace all_q87_norm=. if id_alex=="cc_English_1_1552" /*Grenada*/
replace cc_q10_norm=. if country=="Grenada" /*Grenada*/
drop if id_alex=="cc_English_0_1511_2016_2017_2018_2019" /* Guyana */
drop if id_alex=="cj_English_0_541_2019" /* Guyana */
replace all_q70_norm=. if country=="Guyana" /* Guyana */
drop if id_alex=="cj_Spanish_1_84" /*Guatemala*/
drop if id_alex=="lb_Spanish_1_46_2019" /*Guatemala*/
drop if id_alex=="cj_Spanish_0_446_2018_2019" /*Guatemala*/
replace all_q85_norm=. if id_alex=="cc_English_0_948_2019" /* Guatemala */
replace all_q79_norm=. if id_alex=="cc_Spanish_0_242_2016_2017_2018_2019" /* Guatemala */
replace all_q79_norm=. if id_alex=="cc_Spanish_1_340_2016_2017_2018_2019" /* Guatemala */
drop if id_alex=="cc_French_0_1044" /*Guinea*/
drop if id_alex=="ph_French_1_429" /*Guinea*/
replace cj_q15_norm=. if id_alex=="cj_French_1_604_2019" /*Guinea*/
replace cj_q28_norm=. if id_alex=="cj_French_0_1164_2018_2019" /*Guinea*/
replace cj_q28_norm=. if id_alex=="cj_English_1_1251" /*Guinea*/
drop if id_alex=="cj_French_0_1143" /* Guinea */
drop if id_alex=="cj_French_0_565" /* Guinea */
drop if id_alex=="lb_English_0_35" /*Haiti*/
replace all_q59_norm=. if id_alex=="cc_French_0_849" /* Haiti */
replace all_q59_norm=. if id_alex=="cc_English_0_283" /* Haiti */
replace cc_q14a_norm=. if id_alex=="cc_French_0_1070" /* Haiti */
replace cc_q14b_norm=. if id_alex=="cc_French_0_1070" /* Haiti */
replace cc_q14a_norm=. if id_alex=="cc_English_0_234" /* Haiti */
replace all_q89_norm=. if id_alex=="lb_French_0_76" /* Haiti */
replace all_q90_norm=. if id_alex=="lb_French_0_76" /* Haiti */
replace all_q90_norm=. if country=="Haiti" /* Haiti */
replace all_q89_norm=. if country=="Haiti" /* Haiti */
replace cc_q14b_norm=. if country=="Haiti" /* Haiti */
drop if id_alex=="cc_Spanish_1_223" /*Honduras: score 0.12*/ 
drop if id_alex=="lb_English_0_206_2016_2017_2018_2019" /*Honduras*/
drop if id_alex=="ph_Spanish_1_70_2019" /*Honduras*/ 
drop if id_alex=="cc_English_0_177" /* Honduras */
replace cj_q36b_norm=. if country=="Honduras" /*Honduras*/
replace all_q11_norm=. if country=="Honduras" /*Honduras*/
replace all_q76_norm=. if country=="Honduras" /* Honduras */
replace all_q78_norm=. if country=="Honduras" /* Honduras */
drop if id_alex=="cc_English_0_338" /*Hong Kong SAR, China*/
drop if id_alex=="ph_English_1_462_2019" /*Hong Kong SAR, China*/
drop if id_alex=="cj_English_0_549" /*Hong Kong SAR, China*/
drop if id_alex=="cj_English_1_891" /*Hong Kong SAR, China*/
replace all_q29_norm=. if country=="Hong Kong SAR, China" /*Hong Kong SAR, China*/
replace all_q89_norm=. if country=="Hong Kong SAR, China" /*Hong Kong SAR, China*/
drop if id_alex=="ph_English_1_718" /*Hungary*/
drop if id_alex=="ph_English_0_329_2019" /*Hungary*/
drop if id_alex=="cj_English_0_1115" /*Hungary*/
drop if id_alex=="ph_English_0_588" /*Hungary*/
drop if id_alex=="cc_English_0_404" /*Hungary*/
drop if id_alex=="cj_English_0_330" /*Hungary*/
drop if id_alex=="cj_English_0_440" /*Hungary*/
replace cj_q32d_norm=. if country=="Hungary" /*Hungary*/
replace cj_q31e_norm=. if country=="Hungary" /*Hungary*/
replace cj_q11b_norm=. if country=="Hungary" /*Hungary*/
replace cj_q12b_norm=. if country=="Hungary" /*Hungary*/
replace cj_q12d_norm=. if country=="Hungary" /*Hungary*/
replace cj_q34a_norm=. if country=="Hungary" /*Hungary*/
replace cj_q34b_norm=. if country=="Hungary" /*Hungary*/
replace cj_q34e_norm=. if country=="Hungary" /*Hungary*/
replace cj_q33a_norm=. if country=="Hungary" /*Hungary*/
replace cj_q33b_norm=. if country=="Hungary" /*Hungary*/
replace cj_q33e_norm=. if country=="Hungary" /*Hungary*/
replace cj_q22e_norm=. if country=="Hungary" /*Hungary*/
replace cj_q6c_norm=. if country=="Hungary" /*Hungary*/
replace cj_q22a_norm=. if country=="Hungary" /*Hungary*/
drop if id_alex=="cj_English_1_431_2018_2019" /* Hungary */
drop if id_alex=="cj_English_1_560" /* Hungary */
replace cc_q33_norm=. if country=="Hungary" /*Hungary*/
replace all_q87_norm=. if country=="Hungary" /*Hungary*/
replace all_q85_norm=. if country=="Hungary" /*Hungary*/
replace cc_q26a_norm=. if country=="Hungary" /*Hungary*/
drop if id_alex=="cj_English_0_608" /*India*/
drop if id_alex=="cc_English_0_744_2017_2018_2019" /*India*/
drop if id_alex=="cc_English_1_802_2019" /*India*/ 
drop if id_alex=="cc_English_1_661" /*India*/
drop if id_alex=="cc_English_1_1468" /*India*/
drop if id_alex=="ph_English_1_342_2018_2019" /*India*/
drop if id_alex=="lb_English_0_341" /*India*/
replace cj_q28_norm=. if id_alex=="cj_English_1_1122" /*India*/
replace cj_q28_norm=. if id_alex=="cj_English_1_636" /*India*/
drop if id_alex=="cj_English_0_738" /* India */
drop if id_alex=="ph_English_0_707" /*Indonesia*/
drop if id_alex=="ph_English_0_699" /*Indonesia*/
drop if id_alex=="cj_English_0_429" /*Indonesia*/
replace cj_q40b_norm=. if country=="Indonesia"  /*Indonesia*/
replace cj_q31e_norm=. if id_alex=="cj_English_1_681_2017_2018_2019" /*Iran, Islamic Rep.*/
replace cj_q11a_norm=. if id_alex=="cj_English_1_681_2017_2018_2019" /*Iran, Islamic Rep.*/
replace cj_q11a_norm=. if id_alex=="cj_English_1_195" /*Iran, Islamic Rep.*/
drop if id_alex=="cc_English_0_1785_2019" /* Iran, Islamic Rep. */
replace cj_q15_norm=. if country=="Ireland" /* Ireland */
drop if id_alex=="cc_English_1_68" /*Italy champion of the EURO*/
drop if id_alex=="cc_English_0_202" /* Italy */ 
drop if id_alex=="cc_English_1_967_2019" /* Italy */
drop if id_alex=="lb_English_0_689" /* Italy */
replace all_q80_norm=. if country=="Italy" /* Italy */
replace cc_q25_norm=. if country=="Jamaica" /*Jamaica*/
replace all_q5_norm=. if country=="Jamaica" /*Jamaica*/
replace cj_q12c_norm=. if country=="Jamaica" /*Jamaica*/
replace cj_q12e_norm=. if country=="Jamaica" /*Jamaica*/
replace all_q1_norm=. if country=="Jamaica" /*Jamaica*/
replace all_q20_norm=. if country=="Jamaica" /*Jamaica*/
replace cj_q36c_norm=. if country=="Jamaica" /*Jamaica*/
replace all_q93_norm=. if country=="Jamaica" /*Jamaica*/
drop if id_alex=="cc_English_0_1743_2018_2019" /*Jamaica*/
replace cj_q40c_norm=. if country=="Jamaica"  /*Jamaica*/
replace cj_q20m_norm=. if country=="Jamaica"  /*Jamaica*/
replace cj_q12a_norm=. if country=="Jamaica"  /*Jamaica*/
replace all_q87_norm=0 if id_alex=="lb_English_0_206_2017_2018_2019" /* Jamaica */
replace all_q87_norm=0 if id_alex=="cc_English_1_967" /* Jamaica */
replace all_q87_norm=0 if id_alex=="cc_English_0_1099_2018_2019" /* Jamaica */
drop if id_alex=="lb_English_0_384" /*Japan*/
drop if id_alex=="cj_English_1_99" /*Japan*/
drop if id_alex=="lb_English_1_228_2013_2014_2016_2017_2018_2019" /*Japan*/
drop if id_alex=="cc_English_0_1456_2017_2018_2019" /* Japan */
replace cj_q42c_norm=. if country=="Jordan" /*Jordan*/
replace cj_q42d_norm=. if country=="Jordan" /*Jordan*/
replace lb_q16f_norm=. if id_alex=="lb_English_0_829" /*Jordan*/
replace lb_q23f_norm=. if country=="Jordan" /*Jordan*/
replace lb_q23g_norm=. if country=="Jordan" /*Jordan*/
replace cj_q11a_norm=. if country=="cj_English_0_868_2019" /*Jordan*/
replace cj_q11a_norm=. if country=="cj_English_1_782" /*Jordan*/
replace all_q49_norm=. if country=="Jordan" /*Jordan*/
replace all_q50_norm=. if country=="Jordan" /*Jordan*/
drop if id_alex=="cc_Russian_1_394" /*Kazakhstan*/
drop if id_alex=="cc_Russian_1_237" /*Kazakhstan*/
drop if id_alex=="cj_Russian_0_631" /*Kazakhstan*/
replace cj_q38_norm=. if country=="Kazakhstan" /*Kazakhstan*/
replace cj_q28_norm=. if country=="Kazakhstan" /*Kazakhstan*/
replace cj_q8_norm=. if country=="Kazakhstan" /*Kazakhstan*/
replace cj_q42d_norm=. if country=="Kazakhstan" /*Kazakhstan*/
drop if id_alex=="lb_English_0_482" /*Kenya*/
drop if id_alex=="ph_English_0_257" /*Kenya*/
replace cj_q31g_norm=. if id_alex=="cj_English_0_535_2019" /*Kenya*/
replace cj_q12c_norm=. if country=="Kenya" /*Kenya*/
replace cj_q12e_norm=. if country=="Kenya" /*Kenya*/
replace cj_q20o_norm=. if id_alex=="cj_English_1_603" /*Kenya*/
replace cj_q20o_norm=. if id_alex=="cj_English_0_554" /*Kenya*/
replace cj_q12f_norm=. if id_alex=="cj_English_1_808_2019" /*Kenya*/
replace cj_q12f_norm=. if id_alex=="cj_English_1_603" /*Kenya*/
replace cj_q12b_norm=. if id_alex=="cj_English_1_603" /*Kenya*/
replace cj_q12b_norm=. if id_alex=="cj_English_1_496" /*Kenya*/
replace cj_q31g_norm=. if id_alex=="cj_English_1_224" /*Kenya*/
drop if id_alex=="lb_English_1_599_2019" /* Kenya */
drop if id_alex=="cc_English_1_681" /* Korea, Rep. */
replace all_q93_norm=. if id_alex=="cj_English_0_114_2016_2017_2018_2019" /* Korea, Rep. */
replace all_q93_norm=. if id_alex=="cj_English_0_400" /* Korea, Rep. */
replace all_q93_norm=. if id_alex=="cj_English_1_51" /* Korea, Rep. */
replace all_q96_norm=. if id_alex=="cc_English_1_506" /* Korea, Rep. */
replace all_q96_norm=. if id_alex=="cc_English_1_652_2019" /* Korea, Rep. */
replace all_q10_norm=. if country=="Korea, Rep." /* Korea, Rep. */
drop if id_alex=="cc_English_0_1003" /*Kosovo*/
drop if id_alex=="cj_English_0_1073" /*Kosovo*/
drop if id_alex=="cj_English_1_1264" /*Kosovo*/
drop if id_alex=="ph_English_0_138_2019" /*Kosovo*/
replace lb_q6c_norm=. if id_alex=="lb_English_1_753" /*Kosovo*/
replace lb_q16f_norm=. if id_alex=="lb_English_0_681" /*Kosovo*/
replace lb_q16f_norm=. if id_alex=="lb_English_0_447" /*Kosovo*/
drop if id_alex=="cc_English_0_666" /* Kosovo */
drop if id_alex=="lb_English_0_681" /* Kosovo */
drop if id_alex=="lb_English_0_559" /* Kosovo */
replace lb_q2d_norm=. if id_alex=="lb_English_0_342_2019" /* Kosovo */
replace lb_q3d_norm=. if id_alex=="lb_English_0_342_2019" /* Kosovo */
replace ph_q6a_norm=. if country=="Kosovo" /* Kosovo */
replace ph_q6c_norm=. if country=="Kosovo" /* Kosovo */
replace lb_q23f_norm=. if country=="Kosovo" /* Kosovo */
replace lb_q19a_norm=. if country=="Kosovo" /* Kosovo */
replace cj_q28_norm=. if country=="Kosovo" /* Kosovo */
replace cc_q14a_norm=. if id_alex=="cc_English_0_643_2019" /* Kosovo */
replace cc_q14a_norm=. if id_alex=="cc_English_0_475_2019" /* Kosovo */
replace cc_q14a_norm=. if id_alex=="cc_English_0_869_2019" /* Kosovo */
replace cc_q14a_norm=. if id_alex=="cc_English_0_557_2019" /* Kosovo */
replace cc_q14b_norm=. if id_alex=="cc_English_0_643_2019" /* Kosovo */
replace cc_q14b_norm=. if id_alex=="cc_English_0_475_2019" /* Kosovo */
replace cc_q14b_norm=. if id_alex=="cc_English_0_869_2019" /* Kosovo */
replace cc_q14b_norm=. if id_alex=="cc_English_0_557_2019" /* Kosovo */
replace cc_q40a_norm=. if country=="Kyrgyz Republic" /*Kyrgyz Republic*/
drop if id_alex=="cc_English_1_775_2016_2017_2018_2019" /*Kyrgyz Republic*/
drop if id_alex=="lb_Russian_1_84" /*Kyrgyz Republic*/
drop if id_alex=="cj_English_0_379_2017_2018_2019" /*Kyrgyz Republic*/
replace ph_q6c_norm=. if country=="Latvia" /*Latvia*/
replace ph_q6f_norm=. if country=="Latvia" /*Latvia*/
replace ph_q6b_norm=. if country=="Latvia" /*Latvia*/
replace ph_q6e_norm=. if country=="Latvia" /*Latvia*/
drop if id_alex=="cj_English_0_147"  /*Latvia*/
drop if id_alex=="cc_English_0_572" /*Latvia*/
replace cj_q12a_norm=. if id_alex=="cj_English_0_1120" /*Latvia*/
replace cj_q12b_norm=. if id_alex=="cj_English_0_1120" /*Latvia*/
replace cj_q12c_norm=. if id_alex=="cj_English_0_1120" /*Latvia*/
replace cj_q12d_norm=. if id_alex=="cj_English_0_1120" /*Latvia*/
replace cj_q12e_norm=. if id_alex=="cj_English_0_1120" /*Latvia*/
replace cj_q12f_norm=. if id_alex=="cj_English_0_1120" /*Latvia*/
replace cj_q12a_norm=. if id_alex=="cj_English_0_147" /*Latvia*/
replace cj_q12b_norm=. if id_alex=="cj_English_0_147" /*Latvia*/
replace cj_q12c_norm=. if id_alex=="cj_English_0_147" /*Latvia*/
replace cj_q12d_norm=. if id_alex=="cj_English_0_147" /*Latvia*/
replace cj_q12e_norm=. if id_alex=="cj_English_0_147" /*Latvia*/
replace cj_q12f_norm=. if id_alex=="cj_English_0_147" /*Latvia*/
replace all_q49_norm=. if country=="Latvia" /*Latvia*/
drop if id_alex=="cj_English_1_110" /*Lebanon*/
drop if id_alex=="ph_English_0_548_2018_2019" /*Lebanon*/
replace cc_q14a_norm=. if id_alex=="cc_English_1_1129" /*Lebanon*/
replace cc_q14a_norm=. if id_alex=="cc_English_0_612" /*Lebanon*/
replace all_q89_norm=. if country=="Lebanon" /*Lebanon*/
replace all_q59_norm =. if country=="Lebanon" /*Lebanon*/
replace cc_q26b_norm=. if id_alex=="cc_English_0_612" /*Lebanon*/
replace cc_q26b_norm=. if id_alex=="cc_English_0_897" /*Lebanon*/
replace cj_q20o_norm=. if id_alex=="cj_English_1_1221" /*Lebanon*/
replace cj_q12f_norm=0 if country=="Lebanon" /*Lebanon*/
replace cj_q12d_norm=. if id_alex=="cj_English_1_398" /*Lebanon*/
replace cj_q20o_norm=. if id_alex=="cj_English_1_398" /*Lebanon*/
drop if id_alex=="cc_English_0_897" /* Lebanon */
replace cj_q11a_norm=. if country=="Lebanon" /* Lebanon */
replace all_q22_norm=. if id_alex=="cc_English_0_550" /*Liberia*/
replace all_q22_norm=. if id_alex=="lb_English_0_858" /*Liberia*/
replace all_q27_norm=. if id_alex=="cc_English_0_1325_2018_2019" /*Liberia*/
replace all_q8_norm=. if id_alex=="cc_English_0_1187_2018_2019" /*Liberia*/
replace all_q8_norm=. if id_alex=="cc_English_0_550" /*Liberia*/
replace all_q8_norm=. if id_alex=="lb_English_0_858" /*Liberia*/
drop if id_alex=="cc_English_0_550" /* Liberia */
drop if id_alex=="lb_English_0_858" /* Liberia */
drop if id_alex=="cj_English_0_205" /* Liberia */
replace cj_q7a_norm=. if country=="Luxembourg" /*Luxembourg*/
drop if id_alex=="cc_French_1_269" /*Madagascar*/
drop if id_alex=="cc_French_1_1454" /*Madagascar*/
replace cj_q20m_norm=. if country=="Madagascar" /*Madagascar*/
drop if id_alex=="cj_English_0_571" /* Malawi */
drop if id_alex=="cc_English_0_1056_2018_2019" /* Malawi */
replace all_q77_norm=. if country=="Malawi" /*Malawi*/
replace all_q78_norm=. if country=="Malawi" /*Malawi*/
replace all_q59_norm=. if country=="Malawi" /*Malawi*/
replace all_q90_norm=. if country=="Malawi" /*Malawi*/
replace all_q91_norm=. if country=="Malawi" /*Malawi*/
replace cc_q25_norm=. if country=="Malawi" /*Malawi*/
drop if id_alex=="ph_English_1_563" /* Malaysia */
drop if id_alex=="cj_English_1_168_2019" /* Malaysia */
drop if id_alex=="cj_English_1_361" /* Malaysia */
drop if id_alex=="ph_French_1_575" /*Mali*/
drop if id_alex=="ph_French_0_507" /*Mali*/
replace all_q20_norm=. if country=="Mali" /*Mali*/
replace cj_q8_norm=. if id_alex=="cj_French_0_371" /*Mali*/
replace cc_q33_norm=. if country=="Mali" /*Mali*/
replace cc_q9c_norm=. if id_alex=="cc_French_0_884_2019" /*Mali*/
replace cc_q9c_norm=. if id_alex=="cc_French_0_996" /*Mali*/
replace cc_q9c_norm=. if id_alex=="cc_French_1_1309" /*Mali*/
drop if id_alex=="cj_French_0_378_2019" /* Mali */
drop if id_alex=="cc_French_0_884_2019" /* Mali */
replace all_q24_norm=. if country=="Mali" /* Mali */
replace all_q84_norm=. if country=="Mali" /* Mali */
replace all_q85_norm=. if country=="Mali" /* Mali */
replace all_q2_norm=. if country=="Mali" /* Mali */
drop if id_alex=="cc_English_0_669" /* Malta */
drop if id_alex=="cj_English_0_154" /* Malta */
replace all_q96_norm=. if id_alex=="cc_English_0_669" /*Malta*/
replace all_q96_norm=. if id_alex=="cj_English_0_351" /*Malta*/
replace cc_q39e_norm=. if country=="Malta" /*Malta*/
replace all_q48_norm=. if country=="Malta" /*Malta*/
replace cc_q16a_norm=. if country=="Malta" /*Malta*/
replace all_q80_norm=. if country=="Malta" /*Malta*/
replace all_q78_norm=. if country=="Malta" /*Malta*/
replace all_q79_norm=. if country=="Malta" /*Malta*/
replace cc_q26a_norm=. if country=="Malta" /*Malta*/
replace all_q57_norm=. if country=="Malta" /*Malta*/
replace all_q59_norm=. if country=="Malta" /*Malta*/
drop if id_alex=="cj_Arabic_1_1068" /*Mauritania*/
drop if id_alex=="cj_French_0_499" /*Mauritania*/
drop if id_alex=="cc_French_0_637" /*Mauritania*/
replace lb_q16d_norm=. if country=="Mauritania" /*Mauritania*/
replace lb_q16f_norm=. if country=="Mauritania" /*Mauritania*/
replace lb_q23f_norm=. if country=="Mauritania" /*Mauritania*/
replace lb_q23e_norm=. if country=="Mauritania" /*Mauritania*/
replace lb_q23g_norm=. if country=="Mauritania" /*Mauritania*/
replace lb_q2d_norm=. if country=="Mauritania" /*Mauritania*/
replace lb_q3d_norm=. if country=="Mauritania" /*Mauritania*/
replace all_q90_norm=. if country=="Mauritania" /*Mauritania*/
replace cj_q15_norm=. if id_alex=="cj_French_0_325"  /*Mauritania*/ 
replace cj_q20m_norm=. if id_alex=="cj_French_0_325" /*Mauritania*/
drop if id_alex=="cj_English_1_307" /* Mauritius */
replace cc_q39e_norm=. if country=="Mauritius" /* Mauritius */
drop if id_alex=="cc_Spanish_1_73" /*Mexico*/
drop if id_alex=="ph_Spanish_0_67_2019" /*Mexico*/
drop if id_alex=="ph_Spanish_1_476" /*Mexico*/
replace cj_q25c_norm=. if country=="Mexico" /*Mexico*/
replace cj_q11a_norm=. if country=="Mexico" /*Mexico*/
replace cj_q29a_norm=. if country=="Mexico" /*Mexico*/
replace cj_q29b_norm=. if country=="Mexico" /*Mexico*/
replace all_q78_nor=. if country=="Mexico" /*Mexico*/
replace all_q86_norm=. if country=="Mexico" /*Mexico*/
replace all_q89_norm=. if country=="Mexico" /*Mexico*/
replace cj_q28_norm=. if country=="Mexico"  /*Mexico*/
replace all_q85_norm=. if country=="Mexico" /*Mexico*/
drop if id_alex=="ph_Russian_0_546_2019" /*Moldova*/
drop if id_alex=="cc_English_1_540_2018_2019" /* Moldova */
drop if id_alex=="cc_French_1_134_2017_2018_2019" /*Morocco*/
replace cj_q8_norm=. if id_alex=="cj_Arabic_1_574" /*Morocco*/
replace cj_q8_norm=. if id_alex=="cj_English_1_1231" /*Morocco*/
replace cj_q11b_norm=. if country=="Morocco" /*Morocco*/
replace all_q9_norm=. if id_alex=="cc_English_1_1597" /*Morocco*/
replace all_q9_norm=. if id_alex=="cj_English_1_1231" /*Morocco*/
replace all_q9_norm=. if id_alex=="cj_Arabic_1_574" /*Morocco*/
drop if id_alex=="cj_English_1_1231" /*Morocco*/
drop if id_alex=="cj_French_1_866" /*Morocco*/
replace cj_q40c_norm=. if country=="Morocco" /*Morocco*/
replace cj_q27b_norm=. if country=="Morocco" /*Morocco*/
replace all_q1_norm=. if country=="Morocco" /*Morocco*/
replace all_q2_norm=. if country=="Morocco" /*Morocco*/
replace all_q85_norm=. if country=="Morocco" /*Morocco*/
replace all_q81_norm=. if country=="Morocco" /*Morocco*/
replace cj_q25c_norm=. if country=="Mozambique" /*Mozambique*/
replace cj_q22e_norm=. if country=="Mozambique" /*Mozambique*/
replace cj_q3b_norm=. if country=="Mozambique" /*Mozambique*/
replace cj_q3c_norm=. if country=="Mozambique" /*Mozambique*/
replace cj_q22a_norm=. if country=="Mozambique" /*Mozambique*/
replace cj_q6d_norm=. if country=="Mozambique" /*Mozambique*/
replace cj_q19e_norm=. if country=="Mozambique" /*Mozambique*/
replace cj_q21h_norm=. if country=="Mozambique" /*Mozambique*/
replace all_q1_norm=. if country=="Mozambique" /* Mozambique */
replace cj_q12a_norm=. if id_alex=="cj_Portuguese_0_188" /* Mozambique */
replace cj_q12b_norm=. if id_alex=="cj_Portuguese_0_188" /* Mozambique */
replace cj_q12c_norm=. if id_alex=="cj_Portuguese_0_188" /* Mozambique */
replace cj_q12d_norm=. if id_alex=="cj_Portuguese_0_188" /* Mozambique */
replace cj_q12e_norm=. if id_alex=="cj_Portuguese_0_188" /* Mozambique */
replace cj_q12f_norm=. if id_alex=="cj_Portuguese_0_188" /* Mozambique */
replace cj_q20m_norm=. if country=="Mozambique" /* Mozambique */
drop if id_alex=="cj_English_0_338" /* Mozambique */
drop if id_alex=="cc_English_0_1025_2018_2019" /*Myanmar*/
replace cj_q11a_norm=. if country=="Myanmar" /*Myanmar*/
replace cj_q11b_norm=. if country=="Myanmar" /*Myanmar*/
replace cj_q6d_norm=. if country=="Myanmar" /*Myanmar*/
replace cj_q6b_norm=. if country=="Myanmar" /*Myanmar*/
replace cj_q6c_norm=. if country=="Myanmar" /*Myanmar*/
replace cj_q6d_norm=. if country=="Myanmar" /*Myanmar*/
drop if id_alex=="ph_English_0_238" /*Namibia*/
drop if id_alex=="cc_English_1_1015" /*Namibia*/
drop if id_alex=="lb_English_0_287" /*Namibia*/
drop if id_alex=="cc_English_0_386" /*Nepal*/
drop if id_alex=="cj_English_0_920" /*Nepal*/
drop if id_alex=="cc_English_0_1739_2019" /* Netherlands */
drop if id_alex=="cj_Spanish_0_421_2014_2016_2017_2018_2019" /*Nicaragua*/
drop if id_alex=="cc_English_1_630_2017_2018_2019" /*Nicaragua*/
drop if id_alex=="cc_English_0_696_2017_2018_2019" /*Nicaragua*/
drop if id_alex=="lb_Spanish_0_45_2013_2014_2016_2017_2018_2019" /*Nicaragua*/
drop if id_alex=="ph_Spanish_1_250_2014_2016_2017_2018_2019" /*Nicaragua*/
drop if id_alex=="cc_Spanish (Mexico)_1_1258_2019" /*Nicaragua*/
replace cj_q36c_norm=. if country=="Nicaragua" /*Nicaragua*/
replace cc_q9b_norm=. if country=="Nicaragua" /*Nicaragua*/
replace cc_q40b_norm=. if country=="Nicaragua" /*Nicaragua*/
drop if id_alex=="cc_French_0_1552" /*Niger*/
replace cc_q33_norm=. if country=="Niger" /*Niger*/
replace cj_q8_norm=. if id_alex=="cj_English_1_1245_2019" /*Niger*/
replace cj_q8_norm=. if id_alex=="cj_French_1_1033" /*Niger*/
replace cj_q36c_norm=. if country=="Niger" /*Niger*/
replace cc_q40b_norm=. if id_alex=="cc_French_1_1276" /*Niger*/
replace lb_q19a_norm=. if country=="Niger" /*Niger*/
replace all_q78_norm=. if country=="Niger" /*Niger*/
replace all_q81_norm=. if country=="Niger" /*Niger*/
replace cc_q11a_norm=. if country=="Niger" /*Niger*/
replace all_q85_norm=. if country=="Niger" /*Niger*/
replace lb_q16b_norm=. if country=="Niger" /*Niger*/
replace lb_q16f_norm=. if country=="Niger" /*Niger*/
replace cc_q25_norm=. if country=="Niger"  /*Niger*/
replace all_q1_norm=. if country=="Niger"  /*Niger*/
replace all_q2_norm=. if country=="Niger"  /*Niger*/
replace all_q6_norm=. if country=="Niger"  /*Niger*/
replace all_q84_norm=. if country=="Niger"  /*Niger*/
drop if id_alex=="cc_English_1_602_2016_2017_2018_2019" /* Nigeria */
drop if id_alex=="cj_English_0_207" /* Nigeria */
replace all_q87_norm=. if id_alex=="cc_English_0_1038" /*North Macedonia*/
drop if id_alex=="cc_English_0_1038" /* North Macedonia */
replace all_q89_norm=. if country=="Norway" /*Norway*/
replace cc_q40a_norm=. if country=="Pakistan" /*Pakistan*/
replace cc_q40b_norm=. if country=="Pakistan" /*Pakistan*/
replace all_q57_norm=. if country=="Pakistan" /*Pakistan*/
replace cc_q26h_norm=. if country=="Pakistan" /*Pakistan*/
drop if id_alex=="cc_English_1_673" /*Pakistan*/
drop if id_alex=="lb_English_0_100" /*Pakistan*/
replace lb_q3d_norm=0 if id_alex=="lb_English_1_502_2018_2019" /*Pakistan*/
replace lb_q3d_norm=0 if id_alex=="lb_English_1_622_2017_2018_2019" /*Pakistan*/
replace lb_q19a_norm=. if id_alex=="lb_English_1_591_2018_2019" /*Pakistan*/
replace lb_q19a_norm=. if id_alex=="lb_English_1_442_2017_2018_2019" /*Pakistan*/
replace all_q87_norm=0 if id_alex=="cc_English_0_1285_2017_2018_2019" /*Pakistan*/
replace all_q85_norm=0 if id_alex=="cc_English_0_1285_2017_2018_2019" /*Pakistan*/
drop if id_alex=="lb_Spanish_1_71" /*Panama*/
drop if id_alex=="ph_Spanish_0_146" /*Panama*/
drop if id_alex=="ph_Spanish_1_690_2019" /*Panama*/
drop if id_alex=="cj_Spanish_0_515" /*Panama*/
replace cj_q27b_norm=. if country=="Panama" /*Panama*/
drop if id_alex=="lb_Spanish_1_292" /* Panama */
replace lb_q19a_norm=. if id_alex=="lb_Spanish_0_372_2017_2018_2019" /* Panama */
replace lb_q19a_norm=. if id_alex=="lb_Spanish_1_292" /* Panama */
replace cj_q42c_norm=. if country=="Paraguay" /*Paraguay*/
replace cj_q42d_norm=. if country=="Paraguay" /*Paraguay*/
drop if id_alex=="lb_Spanish_0_142" /* Paraguay */
drop if id_alex=="cc_Spanish_0_224" /* Paraguay */
drop if id_alex=="cj_Spanish_0_105" /* Paraguay */
replace all_q90_norm=. if country=="Paraguay" /*Paraguay*/
replace cc_q14b_norm=. if country=="Paraguay" /*Paraguay*/
replace all_q89_norm=. if country=="Paraguay" /*Paraguay*/
drop if id_alex=="ph_Spanish_1_416" /*Peru*/
drop if id_alex=="ph_Spanish_0_694_2018_2019" /*Peru*/
drop if id_alex=="cj_Spanish_0_143" /* Peru */
drop if id_alex=="cc_Spanish_0_302" /* Peru */
drop if id_alex=="cc_Spanish_0_893" /* Peru */
replace all_q85_norm=. if country=="Peru" /* Peru */
drop if id_alex=="cc_English_1_650_2019" /*Philippines*/
drop if id_alex=="ph_English_0_100" /*Philippines*/
drop if id_alex=="ph_English_0_449" /*Philippines*/
drop if id_alex=="ph_English_0_478" /*Philippines*/
drop if id_alex=="ph_English_0_158" /*Philippines*/
drop if id_alex=="ph_English_0_40" /*Philippines*/
replace lb_q16a_norm=. if id_alex=="lb_English_0_540" /*Philippines*/
replace lb_q16a_norm=. if id_alex=="lb_English_1_401" /*Philippines*/
replace ph_q6a_norm=. if id_alex=="ph_English_0_425" /*Philippines*/
replace lb_q16b_norm=. if id_alex=="lb_English_0_815" /*Philippines*/
replace lb_q16b_norm=. if id_alex=="lb_English_0_540" /*Philippines*/
replace lb_q16b_norm=. if id_alex=="lb_English_1_401" /*Philippines*/
replace lb_q16d_norm=. if id_alex=="lb_English_0_815" /*Philippines*/
replace lb_q16d_norm=. if id_alex=="lb_English_0_540" /*Philippines*/
replace lb_q16d_norm=. if id_alex=="lb_English_1_401" /*Philippines*/
replace lb_q16f_norm=. if id_alex=="lb_English_0_815" /*Philippines*/
replace lb_q16f_norm=. if id_alex=="lb_English_0_540" /*Philippines*/
replace lb_q16f_norm=. if id_alex=="lb_English_1_401" /*Philippines*/
replace lb_q23c_norm=. if id_alex=="lb_English_0_815" /*Philippines*/
replace lb_q23d_norm=. if id_alex=="lb_English_0_815" /*Philippines*/
replace lb_q23e_norm=. if id_alex=="lb_English_0_815" /*Philippines*/
replace lb_q16c_norm=. if id_alex=="lb_English_0_540" /*Philippines*/
replace lb_q16c_norm=. if id_alex=="lb_English_1_401" /*Philippines*/
replace lb_q23f_norm=. if id_alex=="lb_English_0_815" /*Philippines*/
replace all_q88_norm=. if country=="Philippines" /*Philippines*/
replace cc_q26a_norm=. if country=="Philippines" /*Philippines*/
replace cj_q6b_norm=. if country=="Philippines" /*Philippines*/
replace cj_q6c_norm=. if country=="Philippines" /*Philippines*/
replace cj_q6d_norm=. if country=="Philippines" /*Philippines*/
drop if id_alex=="cc_English_0_467" /*Philippines*/
replace cc_q39b_norm=. if country=="Philippines" /*Philippines*/
drop if id_alex=="cc_English_1_534" /*Poland*/
drop if id_alex=="ph_English_1_53_2014_2016_2017_2018_2019" /*Poland*/
drop if id_alex=="cc_English_0_1058" /*Poland*/
drop if id_alex=="lb_English_0_186" /*Poland*/
drop if id_alex=="ph_English_0_203" /*Poland*/
replace cj_q38_norm=. if country=="Poland" /*Poland*/
replace cc_q33_norm=. if id_alex=="cc_English_0_63" /*Poland*/
replace cc_q33_norm=. if id_alex=="cc_English_0_800" /*Poland*/
replace cc_q40a_norm=. if country=="Poland" /*Poland*/
replace all_q62_norm=. if id_alex=="cc_English_0_63" /*Poland*/
replace all_q62_norm=. if id_alex=="lb_English_1_334" /*Poland*/
replace all_q63_norm=. if id_alex=="cc_English_0_63" /*Poland*/
replace all_q63_norm=. if id_alex=="lb_English_1_334" /*Poland*/
replace all_q89_norm=. if country=="Poland" /*Poland*/
drop if id_alex=="cc_English_0_63" /* Poland */
replace all_q59_norm=. if country=="Poland" /* Poland */
replace lb_q16a_norm=. if country=="Poland" /* Poland */
replace all_q76_norm=. if country=="Poland" /* Poland */
replace all_q78_norm=. if country=="Poland" /* Poland */
drop if id_alex=="cj_English_0_942_2019" /* Poland */
replace all_q80_norm=. if country=="Poland" /* Poland */
replace cj_q12e_norm=. if country=="Poland" /* Poland */
replace ph_q6e_norm=. if country=="Poland" /* Poland */
replace cc_q25_norm=. if country=="Poland" /* Poland */
replace cj_q42d_norm=. if id_alex=="cj_English_1_639" /* Poland */
drop if id_alex=="lb_English_1_773" /* Poland */
drop if id_alex=="cc_Portuguese_1_763" /*Portugal*/
drop if id_alex=="cc_Portuguese_0_1228" /*Portugal*/
replace all_q46_norm=. if id_alex=="cc_Portuguese_0_592" /*Portugal*/
replace all_q46_norm=. if id_alex=="cc_Portuguese_1_431" /*Portugal*/
replace all_q46_norm=. if id_alex=="cc_Portuguese_1_559" /*Portugal*/
replace all_q46_norm=. if id_alex=="cc_Portuguese_1_1561" /*Portugal*/
drop if id_alex=="cc_English_1_837_2019" /* Romania */
drop if id_alex=="lb_English_0_443" /* Romania */
drop if id_alex=="lb_English_0_717" /* Romania */
drop if id_alex=="cc_English_0_146" /* Romania */
drop if id_alex=="lb_English_0_549" /* Romania */
drop if id_alex=="cc_English_1_929" /* Romania */
drop if id_alex=="cj_English_1_845_2017_2018_2019" /* Romania */
drop if id_alex=="cj_English_1_172_2018_2019" /* Romania */
replace all_q30_norm=1 if id_alex=="cj_English_0_636_2017_2018_2019" /* Romania */
replace cj_q31g_norm=. if id_alex=="cj_English_0_264_2016_2017_2018_2019" /* Romania */
replace cj_q31g_norm=. if id_alex=="cj_English_1_487" /* Romania */
replace cc_q13_norm=0 if id_alex=="cc_English_1_655_2018_2019" /* Romania */
replace cj_q20m_norm=. if country=="Romania" /* Romania */
drop if id_alex=="cc_Russian_0_1603" /* Russia */
drop if id_alex=="cc_Russian_0_1461" /* Russia */
drop if id_alex=="cj_Russian_1_842" /* Russia */
drop if id_alex=="cc_Russian_0_1372" /* Russia */
drop if id_alex=="cc_Russian_0_1365" /* Russia */
drop if id_alex=="lb_English_0_483_2019" /* Russia */
drop if id_alex=="cc_English_1_405_2018_2019" /* Russia */
drop if id_alex=="cc_Russian_1_1201" /* Russia */
replace cj_q21g_norm=. if country=="Russian Federation" /* Russia */
replace cj_q31e_norm=. if country=="Russian Federation" /* Russia */
replace lb_q3d_norm=. if country=="Russian Federation" /* Russia */
replace cj_q42d_norm=. if country=="Russian Federation" /* Russia */
replace all_q84_norm=. if country=="Russian Federation" /* Russia */
replace all_q59_norm=. if country=="Russian Federation" /* Russia */
drop if id_alex=="cc_English_1_1252" /* Rwanda */
drop if id_alex=="cc_English_0_131" /* Rwanda */
drop if id_alex=="cj_French_0_1129" /* Rwanda */
drop if id_alex=="lb_English_1_765" /* Rwanda */
drop if id_alex=="cc_English_1_460" /* Rwanda */
drop if id_alex=="cc_English_1_776" /* Rwanda */
drop if id_alex=="cc_English_1_99" /* Rwanda */
drop if id_alex=="cc_French_1_1253" /* Rwanda */
drop if id_alex=="cc_English_1_1596" /* Rwanda */
drop if id_alex=="cc_English_0_682" /* Rwanda */
drop if id_alex=="lb_English_0_190" /* Rwanda */
drop if id_alex=="cj_English_0_462_2019" /* Rwanda */ 
replace all_q84_norm=. if country=="Rwanda" /* Rwanda */
replace cc_q13_norm=. if country=="Rwanda" /* Rwanda */
replace cc_q26a_norm=. if country=="Rwanda" /* Rwanda */
replace all_q87_norm=. if country=="Rwanda" /* Rwanda */
replace all_q90_norm=. if country=="Rwanda" /* Rwanda */
replace cc_q33_norm=. if country=="Rwanda" /* Rwanda */
replace all_q54_norm=. if country=="Rwanda" /* Rwanda */
replace lb_q16f_norm=. if country=="Rwanda" /* Rwanda */
replace all_q29_norm=. if country=="Rwanda" /* Rwanda */
replace all_q2_norm=. if country=="Rwanda" /* Rwanda */
replace all_q78_norm=. if country=="Rwanda" /* Rwanda */
replace all_q79_norm=. if country=="Rwanda" /* Rwanda */
replace all_q81_norm=. if country=="Rwanda" /* Rwanda */
replace cc_q9c_norm=. if country=="Rwanda" /* Rwanda */
replace all_q86_norm=. if country=="Rwanda" /* Rwanda */
replace all_q91_norm=. if country=="Rwanda" /* Rwanda */
replace all_q28_norm=. if country=="Rwanda" /* Rwanda */
replace all_q83_norm=. if country=="Rwanda" /* Rwanda */
replace cc_q26h_norm=. if country=="Rwanda" /* Rwanda */
replace lb_q6c_norm=. if country=="Rwanda" /* Rwanda */
replace all_q9_norm=. if country=="Rwanda" /* Rwanda */
drop if id_alex=="ph_French_0_585" /*Senegal*/
drop if id_alex=="cj_French_0_601_2018_2019"/* Senegal */
drop if id_alex=="cj_French_0_381" /* Senegal */
replace all_q20_norm=. if country=="Senegal" /*Senegal*/
replace all_q9_norm=. if country=="Senegal" /*Senegal*/
replace all_q84_norm=. if country=="Senegal" /*Senegal*/
replace all_q85_norm=. if country=="Senegal" /*Senegal*/
replace cc_q26a_norm=. if country=="Senegal" /*Senegal*/
drop if id_alex=="cj_English_1_717" /*Serbia*/
drop if id_alex=="cj_English_0_468_2017_2018_2019" /*Serbia*/
replace cj_q15_norm=. if country=="Serbia" /*Serbia*/
drop if id_alex=="ph_English_0_384_2018_2019" /*Sierra Leone*/
drop if id_alex=="ph_English_0_688_2018_2019" /*Sierra Leone*/
drop if id_alex=="ph_English_0_573_2019" /*Sierra Leone*/
replace all_q6_norm=. if country=="Sierra Leone" /*Sierra Leone*/
replace all_q93_norm=. if country=="Sierra Leone" /*Sierra Leone*/
replace cj_q21h_norm=. if country=="Sierra Leone" /*Sierra Leone*/
replace cj_q20e_norm=. if id_alex=="cj_English_0_518" /*Sierra Leone*/
replace cj_q27b_norm=. if id_alex=="cj_English_1_661" /*Sierra Leone*/
replace cj_q22d_norm=. if country=="Sierra Leone" /*Sierra Leone*/
replace cj_q22e_norm=. if country=="Sierra Leone" /*Sierra Leone*/
drop if id_alex=="lb_English_0_746" /* Singapore */
replace cc_q40a_norm=. if country=="Singapore" /* Singapore */
replace all_q44_norm=. if country=="Singapore" /* Singapore */
replace cj_q10_norm=. if country=="Singapore" /* Singapore */
replace all_q17_norm=. if country=="Singapore" /* Singapore */
replace all_q32_norm=. if country=="Singapore" /* Singapore */
replace all_q31_norm=. if country=="Singapore" /* Singapore */
replace all_q94_norm=. if country=="Singapore" /* Singapore */
replace cj_q20m_norm=. if country=="Slovak Republic" /* Slovak Republic */
replace cj_q40c_norm=. if country=="Slovak Republic" /* Slovak Republic */
replace cj_q24c_norm=. if country=="Slovak Republic" /* Slovak Republic */
drop if id_alex=="cc_English_0_180_2016_2017_2018_2019" /* Slovenia */
drop if id_alex=="cc_English_0_1856_2018_2019" /* Slovenia */
drop if id_alex=="cc_English_0_630" /* Slovenia */
drop if id_alex=="cc_English_0_989" /* Slovenia */
drop if id_alex=="cj_English_1_215" /* Slovenia */
drop if id_alex=="cc_English_0_325" /* Slovenia */
replace lb_q2d_norm=. if country=="Slovenia" /* Slovenia */
drop if id_alex=="cj_English_0_627" /* Slovenia */
drop if id_alex=="cc_English_0_640" /* Slovenia */
replace all_q29_norm=0.33333 if id_alex=="cc_English_1_94" /* Slovenia */
replace all_q29_norm=0.33333 if id_alex=="cc_English_1_1300" /* Slovenia */
drop if id_alex=="cc_English_0_888" /* South Africa */
drop if id_alex=="cj_English_0_301_2017_2018_2019" /* South Africa */
drop if id_alex=="lb_English_0_698_2019" /* South Africa */
drop if id_alex=="cj_English_0_630_2019" /* South Africa */
drop if id_alex=="cj_Spanish_1_483_2019" /* Spain */
drop if id_alex=="cc_Spanish_0_517_2016_2017_2018_2019" /* Spain */
drop if id_alex=="lb_Spanish_0_37" /* Spain */
drop if id_alex=="cc_Spanish_1_206" /* Spain */ 
drop if id_alex=="cj_Spanish_1_483_2019" /* Spain */
drop if id_alex=="cj_Spanish_1_967" /* Spain */
drop if id_alex=="cc_English_0_1360" /* Sri Lanka */
drop if id_alex=="lb_English_0_643" /* Sri Lanka */
drop if id_alex=="lb_English_0_792" /* Sri Lanka */
drop if id_alex=="cj_English_1_715" /* Sri Lanka */
replace cj_q21h_norm=. if country=="Sri Lanka" /* Sri Lanka */
replace all_q87_norm=. if country=="Sri Lanka" /* Sri Lanka */
replace all_q3_norm=. if country=="Sri Lanka" /* Sri Lanka */
replace cc_q33_norm=. if country=="Sri Lanka" /* Sri Lanka */
replace cj_q38_norm=. if country=="Sri Lanka" /* Sri Lanka */
replace all_q57_norm=. if country=="Sri Lanka" /* Sri Lanka */

replace all_q30_norm=. if country=="St. Lucia" /* St. Lucia */
replace cc_q29b_norm=. if country=="St. Lucia" /* St. Lucia */
replace all_q29_norm=. if country=="St. Lucia" /* St. Lucia */
drop if id_alex=="cj_English_0_458" /* Sudan */
drop if id_alex=="cc_English_0_501" /* Sudan */
drop if id_alex=="cc_English_0_752" /* Sudan */
drop if id_alex=="ph_English_0_76" /* Sudan */
drop if id_alex=="lb_English_0_110" /* Sudan */
drop if id_alex=="lb_English_0_879" /* Sudan */
drop if id_alex=="cc_English_0_462" /* Sudan */
replace cc_q12_norm=. if country=="Sudan" /* Sudan */
replace all_q71_norm=. if country=="Sudan" /* Sudan */
replace all_q78_norm=. if country=="Sudan" /* Sudan */
replace all_q79_norm=. if country=="Sudan" /* Sudan */
replace cc_q26h_norm=. if country=="Sudan" /* Sudan */
replace all_q83_norm=. if country=="Sudan" /* Sudan */
replace all_q59_norm=. if country=="Sudan" /* Sudan */
replace all_q57_norm=. if country=="Sudan" /* Sudan */
replace all_q51_norm=. if country=="Sudan" /* Sudan */
replace all_q84_norm=. if country=="Sudan" /* Sudan */
replace all_q85_norm=. if country=="Sudan" /* Sudan */
replace all_q86_norm=. if country=="Sudan" /* Sudan */
replace all_q87_norm=. if country=="Sudan" /* Sudan */
replace all_q59_norm=. if country=="Sudan" /* Sudan */
replace all_q90_norm=. if country=="Sudan" /* Sudan */
replace all_q91_norm=. if country=="Sudan" /* Sudan */
replace all_q93_norm=. if country=="Sudan" /* Sudan */
replace cj_q27b_norm=. if country=="Sudan" /* Sudan */
replace cj_q7c_norm=. if country=="Sudan" /* Sudan */
replace cj_q28_norm=. if country=="Sudan" /* Sudan */
replace cj_q34a_norm=. if country=="Sudan" /* Sudan */
replace cj_q34b_norm=. if country=="Sudan" /* Sudan */
replace cj_q34c_norm=. if country=="Sudan" /* Sudan */
replace cj_q24c_norm=. if country=="Sudan" /* Sudan */
replace cj_q25b_norm=. if country=="Sudan" /* Sudan */
replace cj_q25c_norm=. if country=="Sudan" /* Sudan */
replace cj_q11a_norm=. if country=="Sudan" /* Sudan */
replace cj_q32b_norm=. if country=="Sudan" /* Sudan */
replace cj_q24b_norm=. if country=="Sudan" /* Sudan */
replace cj_q34d_norm=. if country=="Sudan" /* Sudan */
replace lb_q9_norm=. if country=="Sudan" /* Sudan */
replace cj_q42c_norm=. if country=="Sudan" /* Sudan */
replace cj_q42d_norm=. if country=="Sudan" /* Sudan */
replace cj_q20o_norm=. if country=="Sudan" /* Sudan */
replace cc_q1_norm=. if country=="Sudan" /* Sudan */
replace cj_q15_norm=. if country=="Sudan" /* Sudan */
replace all_q6_norm=. if country=="Sudan" /* Sudan */
//replace cj_q21e_norm=. if country=="Sudan" /* Sudan */ //Not in Map_7
replace cj_q32d_norm=. if country=="Sudan" /* Sudan */
drop if id_alex=="cc_English_0_1732" /* Suriname */
drop if id_alex=="cc_English_0_1696" /* Suriname */
drop if id_alex=="cj_English_0_1137" /* Suriname */
drop if id_alex=="cc_English_0_1735" /* Suriname */
drop if id_alex=="cc_English_0_1743" /* Suriname */
drop if id_alex=="lb_English_0_141" /* Suriname */
drop if id_alex=="lb_English_0_893" /* Suriname */
replace cc_q14a_norm=. if country=="Suriname" /* Suriname */
replace cc_q9c_norm=. if country=="Suriname" /* Suriname */
replace cj_q31f_norm=. if country=="Suriname" /* Suriname */
drop if id_alex=="lb_English_0_553_2017_2018_2019" /* St. Vincent and the Grenadines */
replace all_q90_norm=. if country=="St. Vincent and the Grenadines" /* St. Vincent and the Grenadines */
replace all_q91_norm=. if country=="St. Vincent and the Grenadines" /* St. Vincent and the Grenadines */
drop if id_alex=="cc_English_0_1716" /* St. Kitts and Nevis */
replace all_q89_norm=. if country=="St. Kitts and Nevis" /* St. Kitts and Nevis */
replace all_q35_norm=. if country=="St. Kitts and Nevis" /* St. Kitts and Nevis */
replace all_q36_norm=. if country=="St. Kitts and Nevis" /* St. Kitts and Nevis */
replace cc_q32h_norm=. if country=="St. Kitts and Nevis" /* St. Kitts and Nevis */
replace lb_q16a_norm=. if country=="St. Kitts and Nevis" /* St. Kitts and Nevis */
replace all_q90_norm=. if country=="St. Kitts and Nevis" /* St. Kitts and Nevis */
drop if id_alex=="cj_English_0_359_2019" /* Sweden */
drop if id_alex=="cc_English_1_899" /* Tanzania */
drop if id_alex=="cc_English_0_552" /* Tanzania */
drop if id_alex=="cc_English_0_151" /* Tanzania */
drop if id_alex=="cj_English_0_763" /* Tanzania */
drop if id_alex=="lb_English_0_670" /* Tanzania */
drop if id_alex=="lb_English_0_550" /* Tanzania */
drop if id_alex=="cc_English_1_952" /* Thailand */
drop if id_alex=="cc_English_1_1529" /* Thailand */
drop if id_alex=="lb_English_1_529" /* Thailand */
drop if id_alex=="cc_English_0_871" /* Thailand */
drop if id_alex=="cc_English_1_531" /* Thailand */
drop if id_alex=="cj_English_1_1225" /* Thailand */
drop if id_alex=="cj_English_1_141" /* Thailand */
drop if id_alex=="lb_English_1_535" /* Thailand */
replace all_q29_norm=. if country=="Thailand" /* Thailand */
replace cc_q16a_norm=. if country=="Thailand" /* Thailand */
replace all_q90_norm=. if country=="Thailand" /* Thailand */
replace all_q59_norm=. if country=="Thailand" /* Thailand */
replace cj_q21g_norm=. if country=="Thailand" /* Thailand */
replace cj_q21h_norm=. if country=="Thailand" /* Thailand */
replace all_q85_norm=. if country=="Thailand" /* Thailand */
replace all_q89_norm=. if id_alex=="lb_English_0_650" /* Thailand */
replace all_q89_norm=. if id_alex=="lb_English_0_459" /* Thailand */
replace all_q89_norm=. if id_alex=="lb_English_1_561" /* Thailand */
replace all_q89_norm=. if id_alex=="lb_English_1_612" /* Thailand */
replace all_q91_norm=. if id_alex=="lb_English_0_650" /* Thailand */
replace cc_q10_norm=.  if country=="Thailand" /* Thailand */
drop if id_alex=="cc_English_0_687" /* Togo */
drop if id_alex=="cc_French_1_1089" /* Togo */
drop if id_alex=="cj_French_1_154" /* Togo */
drop if id_alex=="lb_French_0_146" /* Togo */
drop if id_alex=="cc_French_0_1189" /* Togo */
drop if id_alex=="lb_French_0_908" /* Togo */
drop if id_alex=="cc_French_0_1057_2019" /* Togo */
drop if id_alex=="cc_English_0_136_2016_2017_2018_2019" /* Trinidad and Tobago */
drop if id_alex=="cj_English_0_521" /* Trinidad and Tobago */
replace cj_q15_norm=. if country=="Trinidad and Tobago" /* Trinidad and Tobago */
replace lb_q19a_norm=. if id_alex=="lb_French_0_529" /* Tunisia */
replace cj_q12a_norm=0 if id_alex=="cj_French_1_953_2017_2018_2019" /* Tunisia */
replace cj_q12b_norm=0 if id_alex=="cj_French_1_953_2017_2018_2019" /* Tunisia */
replace cj_q12c_norm=0 if id_alex=="cj_French_1_953_2017_2018_2019" /* Tunisia */
replace cj_q12d_norm=0 if id_alex=="cj_French_1_953_2017_2018_2019" /* Tunisia */
replace cj_q27b_norm=. if country=="Tunisia" /* Tunisia */
drop if id_alex=="cc_English_1_1050" /* Turkey */
drop if id_alex=="cc_English_0_619" /* Turkey */
drop if id_alex=="cj_English_0_491" /* Turkey */
drop if id_alex=="cc_English_0_1070_2017_2018_2019" /* Turkey */
drop if id_alex=="cc_English_1_484" /* Uganda */
drop if id_alex=="cc_English_0_1651_2018_2019" /* Uganda */
drop if id_alex=="cc_English_0_1689_2017_2018_2019" /* Uganda */
drop if id_alex=="cc_English_1_881_2018_2019" /* Uganda */
replace all_q85_norm=. if country=="Uganda" /* Uganda */
drop if id_alex=="cc_English_0_979" /* UAE */
drop if id_alex=="cj_English_1_1260" /* UAE */
drop if id_alex=="cj_English_0_1134" /* UAE */
drop if id_alex=="cj_English_0_934" /* UAE */
drop if id_alex=="lb_English_0_767" /* UAE */
replace all_q63_norm=. if country=="United Arab Emirates" /*UAE*/
replace cc_q9b_norm=. if country=="United Arab Emirates" /*UAE*/
replace cc_q26a_norm=. if country=="United Arab Emirates" /*UAE*/
replace all_q84_norm=. if country=="United Arab Emirates" /*UAE*/
replace all_q79_norm=. if country=="United Arab Emirates" /*UAE*/
drop if id_alex=="cc_English_0_1562" /* UK */
replace lb_q2d_norm =. if country=="United Kingdom" /* UK */
replace cj_q42c_norm=. if country=="United Kingdom" /* UK */
drop if id_alex=="cc_English_1_977_2018_2019" /* USA */
drop if id_alex=="cc_English_0_1003_2019" /* USA */
drop if id_alex=="cj_English_0_740" /* USA */
replace all_q1_norm=. if country=="United States" /* USA */
replace all_q21_norm=. if country=="United States" /* USA */
drop if id_alex=="cc_Spanish_1_62" /* Uruguay */
drop if id_alex=="cc_English_0_262"  /* Uzbekistan */
drop if id_alex=="lb_Russian_0_226"  /* Uzbekistan */
drop if id_alex=="cc_Russian_0_416_2019" /* Uzbekistan */
drop if id_alex=="ph_Russian_0_443" /* Uzbekistan */
replace cj_q32b_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace cj_q33b_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace cj_q36c_norm=. if country=="Uzbekistan" /* Uzbekistan */ 
replace all_q8_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace all_q87_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace all_q80_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace all_q76_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace cj_q12e_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace cj_q21g_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace ph_q5a_norm=. if country=="Uzbekistan"  /* Uzbekistan */
replace cj_q15_norm=. if id_alex=="cj_Russian_1_445" /* Uzbekistan */
replace all_q49_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace cj_q16g_norm=. if country=="Uzbekistan" /* Uzbekistan */
replace cj_q28_norm=. if country=="Vietnam" /* Vietnam */
drop if id_alex=="cc_English_1_1450" /* Zambia */
drop if id_alex=="cc_English_0_715" /* Zambia */
drop if id_alex=="lb_English_1_501_2018_2019" /* Zambia */
drop if id_alex=="lb_English_0_563" /* Zambia */
replace all_q91_norm=. if country=="Zambia" /* Zambia */
replace lb_q19a_norm=. if country=="Zambia" /* Zambia */
replace cc_q12_norm=. if country=="Zambia" /* Zambia */
replace cj_q40c_norm=. if country=="Zambia" /* Zambia */
replace cc_q14b_norm=. if country=="Zambia" /* Zambia */
drop if id_alex=="cc_English_0_305_2017_2018_2019" /* Zambia */
drop if id_alex=="cc_English_1_1598" /* Zambia */
drop if id_alex=="cc_English_1_848" /* Zambia */
replace all_q76_norm=. if id_alex=="cc_English_0_503_2018_2019" /* Zambia */
replace all_q77_norm=. if id_alex=="cc_English_0_503_2018_2019" /* Zambia */
replace all_q78_norm=. if id_alex=="cc_English_0_503_2018_2019" /* Zambia */
replace all_q79_norm=. if id_alex=="cc_English_0_503_2018_2019" /* Zambia */
replace all_q80_norm=. if id_alex=="cc_English_0_503_2018_2019" /* Zambia */
replace all_q81_norm=. if id_alex=="cc_English_0_503_2018_2019" /* Zambia */
replace all_q82_norm=. if id_alex=="cc_English_0_503_2018_2019" /* Zambia */
replace cj_q21h_norm=. if country=="Zambia" /* Zambia */
replace all_q49_norm=. if country=="Zambia" /* Zambia */
drop if id_alex=="cc_English_1_889" /* Zimbabwe */
drop if id_alex=="cc_English_1_1140" /* Zimbabwe */
drop if id_alex=="cc_English_0_1286_2019" /* Zimbabwe */
drop if id_alex=="cj_English_1_766_2019" /* Zimbabwe */
replace cc_q40a_norm=. if country=="Zimbabwe" /* Zimbabwe */
replace cj_q21h_norm=. if country=="Zimbabwe" /* Zimbabwe */


*sort country question year
*br question year longitudinal id_alex country total_score f_1_2-f_8 if country=="Belize"








drop total_score_mean
bysort country: egen total_score_mean=mean(total_score)

save "$path2data/2. Final/qrq.dta", replace



/*-----------------------------------------------------*/
/* Number of surveys per discipline, year, and country */
/*-----------------------------------------------------*/
gen aux1=1 if question=="cc"
gen aux2=1 if question=="cj"
gen aux3=1 if question=="lb"
gen aux4=1 if question=="ph"

gen aux5=1 if question=="cc" & year==2021
gen aux6=1 if question=="cj" & year==2021
gen aux7=1 if question=="lb" & year==2021
gen aux8=1 if question=="ph" & year==2021

gen aux9=1 if question=="cc" & year==2021 & longitudinal==1
gen aux10=1 if question=="cj" & year==2021 & longitudinal==1
gen aux11=1 if question=="lb" & year==2021 & longitudinal==1
gen aux12=1 if question=="ph" & year==2021 & longitudinal==1

bysort country: egen cc_total=total(aux1)
bysort country: egen cj_total=total(aux2)
bysort country: egen lb_total=total(aux3)
bysort country: egen ph_total=total(aux4)

bysort country: egen cc_total_2021=total(aux5)
bysort country: egen cj_total_2021=total(aux6)
bysort country: egen lb_total_2021=total(aux7)
bysort country: egen ph_total_2021=total(aux8)

bysort country: egen cc_total_2021_long=total(aux9)
bysort country: egen cj_total_2021_long=total(aux10)
bysort country: egen lb_total_2021_long=total(aux11)
bysort country: egen ph_total_2021_long=total(aux12)

egen tag = tag(country)
*br country cc_total-ph_total_2021_long if tag==1

drop  aux1-tag

*br question year id_alex country total_score_mean  f*  if country=="Australia"


*----- Saving original dataset AFTER adjustments

save "C:\Users\nrodriguez\OneDrive - World Justice Project\Programmatic\Data Analytics\8. Data\QRQ\QRQ_2021_clean.dta", replace


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*------------------*/
/* Country Averages */
/*------------------*/
foreach var of varlist cc_q1_norm- all_q105_norm cc_q6a_usd cc_q6a_gni{
	bysort country: egen CO_`var'=mean(`var')
}

egen tag = tag(country)
keep if tag==1
drop cc_q1- all_q105_norm cc_q6a_usd cc_q6a_gni

rename CO_* *
drop tag
drop question id_alex language
sort country

drop wjp_login longitudinal year regular
drop total_score- total_score_mean 

drop cj_q43a_norm-cj_q43h_norm
drop removed_in_2018 wjp_password cc_q6a_usd cc_q6a_gni

*Create scores
do "C:\Users\nrodriguez\OneDrive - World Justice Project\Natalia\GitHub\ROLI_2024\1. Cleaning\QRQ\2. Code\Routines\scores.do"

save "$path2data/2. Final/qrq_country_averages_2021.dta", replace

*Saving scores in 2022 folder for analysis
save "C:\Users\nrodriguez\OneDrive - World Justice Project\Programmatic\Data Analytics\7. WJP ROLI\ROLI_2022\1. Cleaning\QRQ\1. Data\3. Final\qrq_country_averages_2021.dta", replace


br






