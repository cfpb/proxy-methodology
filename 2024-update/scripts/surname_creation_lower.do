* This script creates the master surname list from the census surname file,
* including the proportions of individuals by race and ethnicity by surname.

clear all

set more off
set type double

* Input files are included in input_files subfolder.

* Import 2010 surname data.
insheet using "../input_files/Names_2010Census.csv", comma clear
replace name = trim(proper(name))
gen list_year = 2010

tempfile surnames_2010
save `surnames_2010', replace

* Import 2000 surname data.
insheet using "../input_files/app_c.csv", comma clear
replace name = trim(proper(name))
gen list_year = 2000

tempfile surnames_2000
save `surnames_2000', replace

* Append 2000 data to 2010 data.
use `surnames_2010', clear
append using `surnames_2000'

* Create a flag where there are duplicates within a name.
bysort name : gen multiple_flag = _N > 1

* If there are duplicates, drop the entry from 2000.
drop if multiple_flag == 1 & list_year == 2000

* Formats the values in the Census data as proportions.
foreach k in white black api aian 2prace hispanic {

destring pct`k', force replace
replace pct`k' = pct`k' / 100
}

gen countmiss = (pctwhite == .) + (pctblack == .) + (pctapi == .) + (pctaian == .) + (pct2prace == .) + (pcthispanic == .)
egen remaining = rowtotal(pctblack pctwhite pctapi pctaian pct2prace pcthispanic)
replace remaining = count * (1 - remaining)

foreach k in white black api aian 2prace hispanic {

replace pct`k' = remaining / (countmiss * count) if pct`k' == .
}

replace name = lower(name)

save "../input_files/created/census_surnames_lower.dta", replace

exit

*END
