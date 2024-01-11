# Model Metadata

This folder contains metadata files for each team-model submitting to the RSV Forecast Hub.

## Sub-directory
Each sub-directory within the [model-metadata/](https://github.com/HopkinsIDD/rsv-forecast-hub/edit/main/model-metadata) directory has the format:

```
team-model
```

where 
- ```team``` is the abbreviated team name (```team_abbr```) and
- ```model``` is teh abbreviated name of your model (```model_abbr```).

Both team and model should be less than 15 characters and not include hyphens nor spaces.
The ```team-model``` should correspond to the ```team-model``` sub-directory in the associated model-output folder containing the associated projections.

## Required Information
### ```team_name```
The name of your team that is less than 50 characters, no spaces. Will be displayed online.

### ```model_name```
The name of your model that is less than 50 characters, no spaces. Will be displayed online.

### Abbreviation
### ```team_abbr```
An abbreviated name for your team that is less than 15 alphanumeric characters (```_``` also accepted, please avoid using other punctuation characters, including ```-```, ```/```, etc.).

### ```model_abbr```
An abbreviated name for your model that is less than 15 alphanumeric characters (```_``` also accepted, please avoid using other punctuation characters, including ```-```, ```/```, etc.). 

#### Team-model name and filename
The team-model abbreviation used in all the file names must be in the format of ```[team_abbr]-[model_abbr]```, where each of the ```[team_abbr]``` and ```[model_abbr]``` are text strings that are each less than 15 alphanumeric characters that do not include a hyphen or whitespace.
Note that this is a uniquely identifying field in our system, so please choose this name carefully, as it may not be changed once defined. The model abbreviation will be displayed online. 

