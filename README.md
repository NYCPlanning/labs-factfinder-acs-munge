

# Population FactFinder ACS / Decennial Munge

This R script is an [ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load) pipeline for transforming ACS and Decennial with value-add features into a structure that [NYC Population FactFinder](https://github.com/NYCPlanning/labs-nyc-factfinder) understands. The `melt.R` file transforms ACS data while `meltDecennial.R` separately transforms Decennial data.

## Input Structure

There are two main required inputs:
 - ACS Data
 - ACS Metadata (Data Dictionary)

### "ACS Data" Columns
 - `PrdctType` - Name of product (usually `ACS`)
 - `Dataset` - Year-range for value, in the format: `Y2012-2016`
 - `GeoType` - One of 5 types:
    - `City2010`
    - `Boro2010`
    - `CT2010`
    - `NTA2010`
    - `PUMA2010`
 - `GeogName` - Place-specific name/identifier, in some DCP-familiar format
 - `GeoID` - Quasi-ACS geographic identifiers in alphanumeric format.
 - `FIPS` - ACS Code
 - `BoroID` - DCP-specific code
 - `CT` - ACS Code
 - `BoroCT1` - DCP-specific code
 - `BoroCT2` - DCP-specific code
 - `NTA_Equiv` - DCP-specific code
 - `PUMA_Equiv` - DCP-specific code
 - `...` - Each "variable" gets 5 columns, each with either an `E`,`M`,`C`,`P`,`Z` suffix to indicate the following:
   - `E` - Estimate
   - `M` - Margin of Error
   - `C` - Coefficient of Variance
   - `P` - Percentage
   - `Z` - Percentage Margin of Error


 #### Sample:


     | PrdctType | Dataset    | GeoType  | GeogName                                                                             | GeoID | Pop_1E | Pop_1M | Pop_1C | Pop_1P | Pop_1Z |
     |-----------|------------|----------|--------------------------------------------------------------------------------------|-------|--------|--------|--------|--------|--------|
     | ACS       | Y2006-2010 | PUMA2010 | NYC-Queens Community District 2--Sunnyside & Woodside PUMA, New York                 | 4109  | 130386 | 3057   | 1.4    | 100    | NA     |
     | ACS       | Y2006-2010 | PUMA2010 | NYC-Queens Community District 5--Ridgewood, Glendale & Middle Village PUMA; New York | 4110  | 168628 | 2893   | 1.0    | 100    | NA     |
     | ACS       | Y2006-2010 | PUMA2010 | NYC-Queens Community District 9--Richmond Hill & Woodhaven PUMA, New York            | 4111  | 141150 | 3119   | 1.3    | 100    | NA     |
     | ACS       | Y2006-2010 | PUMA2010 | NYC-Queens Community District 12--Jamaica, Hollis & St. Albans PUMA; New York        | 4112  | 214294 | 3825   | 1.1    | 100    | NA     |


### "ACS Metadata" Columns
Columns:
 - `VariableName` - Name of each column in `ACS DATA`, _excluding_ the `e,m,z,p,c` suffixes
 - `ProductType` - Name of US Census Bureau Product. Not used.
 - `Dataset` - Comma-separated list of years. For example, `2006-2010, 2012-2016`.
 - `Profile` - One of 4 DCP-specific topics: `Economic`, `Housing`, `Demographic`, `Social`
 - `Category` - One of 46 profile-level categories:
   - `Sex and Age`
   - `Mutually Exclusive Race/Hispanic Origin`
   - `Hispanic Subgroup`
   - `Asian Subgroup`
   - `Demographic- Special Variable`
   - `PopPyramid Only`
   - `Household Type`
   - `Relationship to Head of Household (Householder`
   - `Marital Status`
   - `Grandparents`
   - `School Enrollment`
   - `Educational Attainment (Highest Grade Completed`
   - `Veteran Status`
   - `Disability Status of the Civilian Noninstitutionalized Population`
   - `Residence 1 Year Ago`
   - `Place of Birth`
   - `U.S. Citizenship Status`
   - `Year of Entry`
   - `Language Spoken at Home`
   - `Ancestry`
   - `Social-Special Variable`
   - `Employment Status`
   - `Commute to Work`
   - `Occupation`
   - `Industry`
   - `Class of Worker`
   - `Income and Benefits`
   - `Earnings`
   - `Health Insurance Coverage`
   - `Income in Past 12 Months is Below the Poverty Level`
   - `Ratio of Income to Poverty Level`
   - `Economic- Special Variable`
   - `Housing Occupancy`
   - `Units in Structure`
   - `Year Structure Built`
   - `Rooms`
   - `Housing Tenure`
   - `Year Householder Moved Into Unit`
   - `Vehicles Available`
   - `Occupants Per Room`
   - `Value`
   - `Mortgage Status`
   - `Selected Monthly Owner Costs as a Percentage of Household Income (SMOCAPI`
   - `Gross Rent`
   - `Gross Rent as a Percentage of Household Income (GRAPI`
   - `Housing- Special Variable`
 - `Order` - Unused
 - `Relation` - Name of column containing the universe or "total" for the column. Used for calculating percentages.
 - `UnitType` - One of four types, used to determine how to calculate: `basic`, `median`, `mean`, `rate`

## How we work

[NYC Planning Labs](https://planninglabs.nyc) takes on a single project at a time, working closely with our customers from concept to delivery in a matter of weeks.  We conduct regular maintenance between larger projects.  

Take a look at our sprint planning board {link to waffle} to get an idea of our current priorities for this project.

## How you can help

In the spirit of free software, everyone is encouraged to help improve this project.  Here are some ways you can contribute.

- Comment on or clarify [issues](https://github.com/NYCPlanning/labs-factfinder-acs-munge/issues)
- Report [bugs](https://github.com/NYCPlanning/labs-factfinder-acs-munge/issues)
- Suggest new features
- Write or edit documentation
- Write code (no patch is too small)
  - Fix typos
  - Add comments
  - Clean up code
  - Add new features

**[Read more about contributing.](CONTRIBUTING.md)**

## Requirements

You will need the following things properly installed on your computer.

- [R](https://www.r-project.org)

## Contact us

You can find us on Twitter at [@nycplanninglabs](https://twitter.com/nycplanninglabs), or comment on issues and we'll follow up as soon as we can. If you'd like to send an email, use [labs_dl@planning.nyc.gov](mailto:labs_dl@planning.nyc.gov)
