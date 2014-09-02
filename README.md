# BISG_RACE_ETHNICITY

This document describes the steps needed to build the Bayesian Improved Surname
Geocoding Method (BISG) proxies.

The Consumer Financial Protection Bureau (CFPB) employs a BISG proxy methodology
in its fair lending analysis of non-mortgage credit products but does not set
forth a requirement for the way proxies should be constructed or used by
institutions supervised and regulated by the CFPB.
Finally, the proxy methodology is not static: it will evolve over time as
enhancements are identified that improve accuracy and performance.
See “Using Publicly Available Information to Proxy for Missing Race and
Ethnicity: Methodology and Assessment,” for more details.

Included are a series of Stata scripts and subroutines that prepare the input
public use census geography and surname data and that construct the
surname-only, geography-only, and BISG proxies for race and ethnicity.
The scripts, subroutines, and data provided do not contain Personally
Identifiable Information (PII) or Confidential Supervisory Information (CSI).

Please note that all scripts and subroutines are written in STATA 12 on Linux
and may need to be modified for other environments.

Users must define a number of parameters, including file paths and arguments for subroutines.
The scripts that define the subroutines also identify and describe arguments, as required.

Users must supply their own application- or individual-level data,
and any geocoding of those data must occur prior to the execution of the
script sequence: **this code assumes that the input application- or
individual-level data are already geocoded with census block group,
census tract, and 5-digit ZIP code.**

However, included is an example designed to instruct the user in executing
the proxy building code sequence.
It relies on a set of fictitious data constructed by `create_test_data.do` from
the publicly available census surname list and geography data.
It is provided to illustrate how the `main.do` is set up to run the proxy building code.

A control script, `/scripts/main.do`, is included to step through the process below.
The user will need to change paths and define parameters as required.

1. Geocode the data in a geocoding software package (for example, ArcGIS)
   to obtain tract and block group identifiers for each record.
1. Build name and geography proxies from Census files included in `/input_files`:
   1. Census surname list:
      1. `/scripts/surname_creation_lower.do`—takes .csv file of census surnames,
         formats surnames to be read as all lower case,
         and reallocates suppressed percentages.
         File created by `surname_creation_lower.do`:
         1. `/input_files/created/census_surnames_lower.dta`
      1. In order to prepare the user-defined datasets for use with the Census surname list,
         it is required to do basic cleaning of surnames using regular expressions
         and other forms of name standardization.
         This script exists at: `/scripts/surname_parser.do`.
         File created by `surname_parser.do` in user-defined directory:
         1. ````dir'/proxy_name.dta````
   1. Census geographies:
      1. `/scripts/create_attr_over18_all_geo_entities.do`—uses the base information,
         for individuals age 18 and older, from the Census flat files for
         block group, tract, and ZIP code and allocates "Some Other Race"
         to each group in proportion.
         It creates three files (one each for block group, tract, and ZIP code)
         with geo probabilities for use in proxy:
         1. `/input_files/created/blkgrp_attr_over18.dta`
         1. `/input_files/created/tract_attr_over18.dta`
         1. `/input_files/created/zip_attr_over18.dta`
1. Calculate the BISG probabilities following the methodology described in
   “Using Publicly Available Information to Proxy for Missing Race and Ethnicity:
   Methodology and Assessment” using the probabilities in the
   previously calculated (above) name and geography files:
   1. `/scripts/geo_name_merger_all_entities_over18.do`—this program
      creates three files (one each for block group, tract, and ZIP code)
      with BISG probabilities in user-defined directory:
      1. ```/`maindir'/`inst_name'_proxied_blkgrp.dta```
      1. ```/`maindir'/`inst_name'_proxied_tract.dta```
      1. ```/`maindir'/`inst_name'_proxied_zip.dta```
1. The final step is to merge together the block group, tract, and ZIP code-based BISG proxies
   and choose the most precise proxy given the precision of geocoding,
   e.g. block group (if available), then tract (if available), or ZIP code
   (if block group and tract unavailable) using:
   1. `/scripts/combine_probs.do`
      File created by combine_probs.do in user-defined directory:
      1. ```/`maindir'/`inst_name'_`file'proxied_final.dta```
