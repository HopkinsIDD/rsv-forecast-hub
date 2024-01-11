# Data Submission Instructions

This page is intended to provide teams with all the information they need to submit forecasts. 

All projections should be submitted directly to the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-output) folder. Data in this directory should be added to the repository through a pull request so that automatic data validation checks are run.

## Data Formatting
The automatic check validates both the filename and file contents to ensure the file can be used in the visualization and ensemble forecasting.

### Sub-directory
Each sub-directory within the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-output) directory has the format:

```
team-model
```

where 
- ```team``` is the abbreviated team name, and
- ```model``` is the abbreviated name of your model.

Both team and model should be less than 15 characters and not include hyphens nor spaces.

Within each sub-directory, there should be a metadata file, a license file (optional), and a set of forecasts.

### Metadata
Each submission team should have an associated metadata file. The file should be submitted with the first projection in the [model-metadata/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-metadata) folder, in a file named: ```team-model.yaml```.

For more information on the metadata file format, please consult the associated [README](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-metadata/README.md) file.

### License
If you would like to include a license file, please use the following format

```
LICENSE.txt
```

If you are not using one of the [standard licenses](https://github.com/reichlab/covid19-forecast-hub/blob/master/code/validation/accepted-licenses.csv), then you must include a license file.

### Forecasts
Each forecast file within the sub-directory should have the following name format

```
YYYY-MM-DD-team-model.parquet
```

where
- ```YYYY``` is the 4 digit year,
- ```MM``` is the 2 digit month,
- ```DD``` is the 2 digit day,
- ```team``` is the teamname, and
- ```model``` is the name of your model.

The date YYYY-MM-DD is the ```forecast_date```.

The ```team``` and ```model``` in this file must match the ```team``` and ```model``` in the directory this file is in. Both ```team``` and ```model``` should be less than 15 characters, alpha-numeric and underscores only, with no spaces or hyphens.

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

If the size of the file is larger than 100MB, it should be submitted in a ```.gz.parquet``` format.

## Forecast File Format
The output file must contain eleven columns (in any order):
- ```forecast_date```
- ```target```
- ```target_end_date```
- ```location```
- ```age_group```
- ```output_type```
- ```quantile```
- ```value```

No additional columns are allowed.

Each row in the file is either a point or quantile forecast for a location on a particular date for a particular target.

| Column Name | Accepted Format |
| --- | --- |
| ```origin_date``` | character, date (datetime not accepted) |
| ```target``` | character |
| ```target_end_date``` | character, date (datetime not accepted) |
| ```location``` | character |
| ```age_group``` | character |
| ```type``` | character |
| ```quantile``` | numeric |
| ```value``` | numeric |


### ```forecast_date```
Values in the ```forecast_date``` column must be a date in the format

```
YYYY-MM-DD
```

This is the date on which the submitted forecasts were available. This will typically be the date on which the computation finishes running and produces the standard formatted file. ```forecast_date``` should correspond and be redundant with the date in the filename, but is included here by request from some analysts. We will enforce that the ```forecast_date``` for a file must be either the date on which the file was submitted to the repository or the previous day. Exceptions will be made for legitimate extenuating circumstances.

### ```target```
Values in the ```target``` column must be a character (string) and follow the format

- "N wk ahead inc hosp" where N is a number between 1 and 8

For week-ahead forecasts, we will use the specification of epidemiological weeks (EWs) [defined by the US CDC](https://ndc.services.cdc.gov/wp-content/uploads/MMWR_Week_overview.pdf) which run Sunday through Saturday. There are standard software packages to convert from dates to epidemic weeks and vice versa, e.g. [MMWRweek](https://cran.r-project.org/web/packages/MMWRweek/) for R and [pymmwr](https://pypi.org/project/pymmwr/) and [epiweeks](https://pypi.org/project/epiweeks/) for python.

For week-ahead forecasts with ```forecast_date``` of Sunday or Monday of EW12, a 1 week ahead forecast corresponds to EW12 and should ```have target_end_date``` of the Saturday of EW12. For week-ahead forecasts with ```forecast_date``` of Tuesday through Saturday of EW12, a 1 week ahead forecast corresponds to EW13 and should have ```target_end_date``` of the Saturday of EW13.

### ```target_end_date```
Values in the ```target_end_date``` column must be a date in the format

```
YYYY-MM-DD
```

This is the date for the forecast ```target```. For "# wk" targets, ```target_end_date``` will be the Saturday at the end of the week time period.

### ```location```
Values in the ```location``` column must be one of the "locations" in this in this [FIPS numeric code file](https://github.com/reichlab/covid19-forecast-hub/blob/master/data-locations/locations.csv), which includes numeric FIPS codes for U.S. states, counties, territories, and districts, as well as "US" for national forecasts.

Please note that when writing FIPS codes, they should be written in as a character string to preserve any leading zeroes. 

Only those locations included in the RSV-NET target data are expected:
```"US","06","08","09","13","24","26","27","35","36","41","47","49"```

### ```age_group```
Accepted values in the ```age_group``` column are:
- "0-0.99"
- "1-4" 
- "5-17"
- "18-49"
- "50-64"
- "65-130" 
- "5-64" 
- "0-130" (required)

Aggregation of the previous list, for example: "0-17" is NOT accepted.

Most of the age_group are optionals, however, the submission should contain at least the "0-130" age group (all ages).

### ```type```
Values in the ```type``` column are either
- "point" or
- "quantile"

This values indicates whether that row corresponds to a point forecast or a quantile forecast. Point forecasts are used in visualization, while quantile forecasts are used in visualization and in ensemble construction.

### ```quantile```
Values in the ```quantile``` column are either "NA" (if ```type``` is "point") or a quantile in the format

```
0.###
```

For quantile forecasts, this value indicates the quantile for the ```value``` in this row.

Teams must provide the following 23 quantiles:

```
c(0.01, 0.025, seq(0.05, 0.95, by = 0.05), 0.975, 0.99)

##  [1] 0.010 0.025 0.050 0.100 0.150 0.200 0.250 0.300 0.350 0.400 0.450 0.500
## [13] 0.550 0.600 0.650 0.700 0.750 0.800 0.850 0.900 0.950 0.975 0.990
```

### ```value```
Values in the ```value``` column are non-negative numbers indicating the "point" or "quantile" prediction for this row. For a "point" prediction, ```value``` is simply the value of that point prediction for the ```target``` and ```location``` associated with that row. For a "quantile" prediction, ```value``` is the inverse of the cumulative distribution function (CDF) for the ```target```, ```location```, and ```quantile``` associated with that row.
