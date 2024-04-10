# BISG_RACE_ETHNICITY

In conducting fair lending analysis in both supervisory and enforcement
contexts, the Bureau’s Office of Research (OR) and Division of Supervision,
Enforcement, and Fair Lending (SEFL) rely on a Bayesian Improved Surname
Geocoding (BISG) proxy method, which combines geography- and surname-based
information into a single proxy probability for race and ethnicity used in fair
lending analysis conducted for non-mortgage products.
This document describes the steps needed to build the BISG proxies.

The methodology described here is an example of a proxy methodology that
OR and SEFL use, although we may alter this methodology in particular analyses,
depending on the circumstances involved.
In addition, the proxy method may be revised as we become aware of enhancements
that would increase accuracy and performance.
For more details, see [“Using Publicly Available Information to Proxy for
Unidentified Race and Ethnicity: A Methodology and Assessment”][paper].

Included are a series of Stata scripts and subroutines that prepare the
publicly available census geography and surname data and that construct the
surname-only, geography-only, and BISG proxies for race and ethnicity.
The scripts, subroutines, and data provided here do not contain directly
identifiable personal information or other confidential information,
such as confidential supervisory information.

Please note that all scripts and subroutines are written for execution in
Stata 12 on a Linux platform and may need to be modified for other environments.
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
It is provided to illustrate how the `main.do` is set up to run the proxy
building code and does not reflect any particular individual’s or
institution’s information.

A control script, `/scripts/main.do`, is included to step through the process below.
The user will need to change paths and define parameters as required.

1. Geocode the data in a geocoding software package (for example, ArcGIS)
   to obtain tract and block group identifiers for each record.
1. Build name and geography proxies from Census files included in `/input_files`:
   1. Census surname list:
      1. `/scripts/surname_creation_lower.do`—takes .csv file of census surnames,
         formats surnames to be read as all lower case,
         and imputes any suppressed values.
         File created by `surname_creation_lower.do`:
         1. `/input_files/created/census_surnames_lower.dta`
      1. In order to prepare the user-defined datasets for use with the Census surname list,
         basic cleaning of surnames using regular expressions and other forms of
         name standardization is required.
         This script exists at: `/scripts/surname_parser.do`.
         File created by `surname_parser.do` in user-defined directory:
         1. ``` `dir'/proxy_name.dta ```
   1. Census geographies:
      1. `/scripts/create_attr_over18_all_geo_entities.do`—uses the base information,
         for individuals age 18 and older, from the Census flat files for
         block group, tract, and ZIP code[<sup>1</sup>](#fn-1) and allocates
         "Some Other Race"[<sup>2</sup>](#fn-2) to each group in proportion.
         It creates three files (one each for block group, tract, and ZIP code)
         with geo probabilities for use in proxy:
         1. `/input_files/created/blkgrp_attr_over18.dta`
         1. `/input_files/created/tract_attr_over18.dta`
         1. `/input_files/created/zip_attr_over18.dta`
1. Calculate the BISG probabilities following the methodology described in
   [“Using Publicly Available Information to Proxy for Unidentified Race and Ethnicity:
   A Methodology and Assessment”][paper].
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

Please direct all questions, comments, and suggestions to:
CFPB_proxy_methodology_comments@cfpb.gov.

---

<a aria-hidden="true" href="#fn-1" class="anchor" name="user-content-fn-1"><span class="octicon octicon-link"></span></a>
<sup>1</sup>
    When referring to ZIP code demographics, we match the institution-based
    ZIP code information to ZIP Code Tabulation Areas (ZCTAs) as defined by
    the U.S. Census Bureau.

<a aria-hidden="true" href="#fn-2" class="anchor" name="user-content-fn-2"><span class="octicon octicon-link"></span></a>
<sup>2</sup>
    In the 2010 SF1, the U.S. Census Bureau produced tabulations that report
    counts of Hispanics and non-Hispanics by race.
    These tabulations include a “Some Other Race” category.
    We reallocate the “Some Other Race” counts to each of the remaining six
    race and ethnicity categories using an Iterative Proportional Fitting
    procedure to make geography based demographic categories consistent with
    those on the census surname list.


---

## Update to proxy methodology – April 2017

In the summer 2014 edition of _Supervisory Highlights_,[<sup>3</sup>](#fn-3)
the Bureau previously reported that examination teams use a
Bayesian Improved Surname Geocoding (BISG) proxy methodology for race and
ethnicity in their fair lending analysis of non-mortgage credit products.
The BISG methodology relies on the distribution of race and ethnicity based on
place-of-residence and surname, which are publicly available information from
Census. The method involves constructing a probability of assignment to race
and ethnicity based on demographic information associated with surname and then
updating this probability using the demographic characteristics of the census
block group associated with place of residence. The updating is performed
through the application of a Bayesian algorithm, which yields an integrated
probability that can be used to proxy for an individual’s race and
ethnicity.[<sup>4</sup>](#fn-4)

Through March of 2017, examination teams had relied on the surname list derived
from the 2000 Decennial Census of the Population in their construction of the
BISG proxy for race and ethnicity.[<sup>5</sup>](#fn-5) In December 2016, the
U.S. Census Bureau released a list of the most frequently occurring surnames
based on data derived from 2010 Decennial Census of the Population. The updated
2010 list generally uses the same definitions and formats as the list based on
the 2000 Census but includes updated values for total counts and race and
ethnicity shares associated with each surname.[<sup>6</sup>](#fn-6) In total,
the new surname list provides information on the 162,253 surnames that appear
at least 100 times in the 2010 Census, covering approximately 90% of the
population.[<sup>7</sup>](#fn-7) While 146,516 names appear on both the 2000
and 2010 surname lists, the 2010 list contains 15,737 names that do not appear
on the 2000 list, whereas the 2000 list contains 5,155 names that do not appear
on the 2010 list.[<sup>8</sup>](#fn-8)

As of April 2017, examination teams are relying on an updated proxy methodology
that reflects the newly available surname data from the Census Bureau. Our
updated proxy methodology relies on the race and ethnicity shares for the
162,253 names that appear on the 2010 list and supplements this list with the
race and ethnicity shares for the 5,155 names that appear on the 2000 list but
not on the 2010 list, resulting in a list of 167,409 surnames in
total.[<sup>9</sup>](#fn-9)

The updated name list, statistical software code written in Stata, and other
publicly available data used to build the BISG proxy are now available
in this repository.

Please direct all questions, comments, and suggestions to:
CFPB_proxy_methodology_comments@cfpb.gov.

---

## Update to proxy methodology – April 2024

As of April 2024, examination teams performing fair lending analysis 
are relying on the newly available demographic data from the Census Bureau. The
new demographic data is derived from the 2020 Census Demographic and Housing Characteristic
(DHC) Files.[<sup>10</sup>](#fn-10) To derive the new demographic files, the Bureau pulled DHC Table P11 at 
the Block Group, Census Tract, and Zip Code level through the Census API.[<sup>11</sup>](#fn-11)
This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau.

The updated demographic data and modified versions of the BISG proxy code using the new 2020 demographic
data are all now available in the 2024-update folder in this repository.  The repository also continues
to contain all of the previous code and data for users who would prefer to continue to generate proxies
using the 2010 demographic data.

Please direct all questions, comments, and suggestions to:
CFPB_proxy_methodology_comments@cfpb.gov.

---

<a aria-hidden="true" href="#fn-3" class="anchor" name="user-content-fn-3"><span class="octicon octicon-link"></span></a>
<sup>3</sup>
    See Consumer Financial Protection Bureau,
    [_Supervisory Highlights: Summer 2014_](http://files.consumerfinance.gov/f/201409_cfpb_supervisory-highlights_auto-lending_summer-2014.pdf)
    (Sept. 17, 2014).  

<a aria-hidden="true" href="#fn-4" class="anchor" name="user-content-fn-4"><span class="octicon octicon-link"></span></a>
<sup>4</sup>
    For more information on the methodology, see Consumer Financial Protection Bureau,
    [_Using publicly available information to proxy for unidentified race and ethnicity_](paper)
    (Sept. 2014).

<a aria-hidden="true" href="#fn-5" class="anchor" name="user-content-fn-5"><span class="octicon octicon-link"></span></a>
<sup>5</sup>
    See _id_.

<a aria-hidden="true" href="#fn-6" class="anchor" name="user-content-fn-6"><span class="octicon octicon-link"></span></a>
<sup>6</sup>
    For more details on the updated 2010 surname list, including revisions to
    the 2000 methodology and programming, see Joshua Comenetz,
    [_Frequently Occurring Surnames in the 2010 Census_](http://www2.census.gov/topics/genealogy/2010surnames/surnames.pdf)
    (Oct. 2016).

<a aria-hidden="true" href="#fn-7" class="anchor" name="user-content-fn-7"><span class="octicon octicon-link"></span></a>
<sup>7</sup>
    The surname data are available on the Census Bureau’s website, see
    [_Frequently Occurring Surnames from the 2010 Census_](https://www.census.gov/topics/population/genealogy/data/2010_surnames.html)
    (last revised Dec. 27, 2016).

<a aria-hidden="true" href="#fn-8" class="anchor" name="user-content-fn-8"><span class="octicon octicon-link"></span></a>
<sup>8</sup>
    Names must appear at least 100 times in the 2010 Decennial Census
    in order to be included on the surname list.

<a aria-hidden="true" href="#fn-9" class="anchor" name="user-content-fn-9"><span class="octicon octicon-link"></span></a>
<sup>9</sup>
    Although these names are not on the 2010 list, and thus likely no longer
    meet the 100-name threshold, we chose to include them so as to incorporate
    as much available surname information as possible into the proxy.

<a aria-hidden="true" href="#fn-10" class="anchor" name="user-content-fn-10"><span class="octicon octicon-link"></span></a>
<sup>10</sup>
     See
    [2020 Census Demographic and Housing Characteristics File (DHC)](https://www.census.gov/data/tables/2023/dec/2020-census-dhc.html)
    (last revised Sep. 27, 2023).

<a aria-hidden="true" href="#fn-11" class="anchor" name="user-content-fn-11"><span class="octicon octicon-link"></span></a>
<sup>11</sup>
     See
    [2020 DHC Table P11](https://data.census.gov/table?q=p11&g=010XX00US$1500000&y=2020&d=DEC%20Demographic%20and%20Housing%20Characteristics).

[paper]: http://www.consumerfinance.gov/reports/using-publicly-available-information-to-proxy-for-unidentified-race-and-ethnicity/
