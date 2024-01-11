# Data Submission Instructions

This page is intended to provide teams with all the information they need to submit forecasts. 

All projections should be submitted directly to the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-output) folder. Data in this directory should be added to the repository through a pull request so that automatic data validation checks are run.


## Sub-directory
Each sub-directory within the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-output) directory has the format:

```
team-model
```

where 
- ```team``` is the abbreviated team name, and
- ```model``` is the abbreviated name of your model.

Both team and model should be less than 15 characters and not include hyphens nor spaces.

Within each sub-directory, there should be a metadata file, a license file (optional), and a set of forecasts.

## Metadata
Each submission team should have an associated metadata file. The file should be submitted with the first projection in the [model-metadata/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-metadata) folder, in a file named: ```team-model.yaml```.

For more information on the metadata file format, please consult the associated [README](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-metadata/README.md) file.

## Date/Epiweek Information
For week-ahead projections, we will use the specification of epidemiological weeks (EWs) [defined by the US CDC](https://ndc.services.cdc.gov/wp-content/uploads/MMWR_Week_overview.pdf), which run Sunday through Saturday.

There are standard software packages to convert from dates to epidemic weeks and vice versa, e.g. [MMWRweek](https://cran.r-project.org/web/packages/MMWRweek/) for R and [pymmwr](https://pypi.org/project/pymmwr/) and [epiweeks](https://pypi.org/project/epiweeks/) for python.

## Model Results
Each model results file within the sub-directory should have the following name format

```
YYYY-MM-DD-team-model.parquet
```

where
- ```YYYY``` is the 4 digit year,
- ```MM``` is the 2 digit month,
- ```DD``` is the 2 digit day,
- ```team``` is the teamname, and
- ```model``` is the name of your model.

"parquet" files format from Apache "is an open source, column-oriented data file format designed for efficient data storage and retrieval." More information can be found on the [parquet.apache.org](https://parquet.apache.org/) website.

The "arrow" library can be used to read/write the files in [Python](https://arrow.apache.org/docs/python/parquet.html) and [R](https://arrow.apache.org/docs/r/index.html). Other tools are also accessible, for example [parquet-tools](https://github.com/hangxie/parquet-tools).

For example, in R:

```
# To write "parquet" file format:
filename <- ”path/YYYY-MM-DD-team_model.parquet”
arrow::write_parquet(df, filename)
# with "gz compression"
filename <- ”path/YYYY-MM-DD-team_model.gz.parquet”
arrow::write_parquet(df, filename, compression = "gzip", compression_level = 9)

# To read "parquet" file format:
arrow::read_parquet(filename)
```

The date YYYY-MM-DD should correspond to the start date for the projections ("first date of simulated transmission/outcomes" as noted in the description on the main [README](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/README.md)).

The ```team``` and ```model``` in this file must match the ```team``` and ```model``` in the directory this file is in. Both ```team``` and ```model``` should be less than 15 characters, alpha-numeric and underscores only, with no spaces or hyphens.

If the size of the file is larger than 100MB, it should be submitted in a ```.gz.parquet``` format.

## Model Results File Format
The output file must contain eleven columns (in any order):
- ```origin_date```
- ```scenario_id```
- ```target```
- ```horizon```
- ```location```
- ```age_group```
- ```output_type```
- ```output_type_id```
- ```value```
- ```run_grouping```
- ```stochastic_run```

No additional columns are allowed.

Each row in the file is a specific type of a scenario for a location on a particular date for a particular target.

| Column Name | Accepted Format |
| --- | --- |
| ```origin_date``` | character, date (datetime not accepted) |
| ```scenario_id``` | character |
| ```target``` | character |
| ```horizon``` | numeric, integer |
| ```location``` | character |
| ```age_group``` | character |
| ```output_type``` | character |
| ```output_type_id``` | numeric, character, logical (if all ```NA```) |
| ```value``` | numeric |
| ```run_grouping``` | numeric, integer |
| ```stochastic_run``` | numeric, integer |


### ```origin_date```
Values in the ```origin_date``` column must be a date in the format

```
YYYY-MM-DD
```

The ```origin_date``` is the start date for projections (first d
