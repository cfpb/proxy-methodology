All notable changes to this project will be documented in this file.
We follow the [Semantic Versioning 2.0.0](http://semver.org/) format.

## 1.3.0 – 2020-04-08
### Added
- Block group, tract, and zip code data from 2020 Census
  (see [README.md] for more information)

### Changed
- Updated "create_attr_over18_all_geo_entities" script to use
  2020 Census data instead of 2010 Census data and saves created 
  attribute files with "jan20" in file name
- Update the file that merges name and geographic probabilities
  and the file that combines all probabilities to use 2020 files and 
  saves created files with "jan20" in the file name


## 1.2.0 – 2017-04-24

### Added
- Surname list from 2010 Census
  (see [README addendum](README.md#update-to-proxy-methodology-april-2017)
  for more information)

### Changed
- Updated master surname list creation script to also use
  the new 2010 Census surname list
- Updated surname parsing script to account for last names
  that begin with “O” or “D” followed by a space


## 1.1.0 – 2014-10-01

### Added
- Example output from `main_test_data.do`.


## 1.0.0 - 2014-09-18

Initial public release.
