# Data Submission Instructions

This page is intended to provide teams with all the information they need to submit projections. 
All projectiosn should be submitted directly to the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-output) folder. Data in this directory should be added to the repository through a pull request.
Due to file size limitations, the file can be submitted in a ```.parquet``` or ```.gz.parquet```.

## Sub-directory
Each sub-directory within the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-output) directory has the format:

```
team-model
```

where 
- ```team``` is the abbreviated team name, and
- ```model``` is the abbreviated name of your model.
Both team and model should be less than 15 characters and not include hyphens nor spaces.

## Metadata
Each submission team should have an associated metadata file. The file should be submitted with the first projection in the [model-metadata/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-metadata) folder, in a file named: ```team-model.yaml```.
For more information on the metadata file format, please consult the associated [README](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-metadata/README.md) file.

## Date/Epiweek information
For week-ahead projections, we will use the specification of epidemiological weeks (EWs) [defined by the US CDC](https://ndc.services.cdc.gov/wp-content/uploads/MMWR_Week_overview.pdf), which run Sunday through Saturday.
There are standard software packages to convert from dates to epidemic weeks and vice versa, e.g. [MMWRweek](https://cran.r-project.org/web/packages/MMWRweek/) for R and [pymmwr](https://pypi.org/project/pymmwr/) and [epiweeks](https://pypi.org/project/epiweeks/) for python.
