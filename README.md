# US RSV Forecast Hub

## IMPORTANT: STARTING IN THE 2025-26 SEASON, THE RSV FORECAST HUB HAS BEEN HANDED OFF TO THE CDC'S CENTER FOR FORECASTING AND OUTBREAK ANALYSIS (CFA). PLEASE SUBMIT YOUR FORECASTS TO [CDCgov/rsv-forecast-hub](https://github.com/CDCgov/rsv-forecast-hub). Thank you to the CFA for taking over this important effort!



## Rationale
Respiratory Syncytial Virus (RSV) is the #1 cause of hospitalizations in children under 5 in the United States. Tracking RSV-associated hospitalization rates helps public health professionals understand trends in virus circulation, estimate disease burden, and respond to outbreaks. Accurate predictions of hospital admissions linked to RSV will help support appropriate public health interventions and planning during the 2024-2025 RSV season, as COVID-19, influenza, and other respiratory pathogens are circulating. 

This repository is designed to collect forecast data for the 2024-2025 RSV Forecast Hub run by Johns Hopkins University Infectious Disease Dynamics Group. This project collects forecasts for weekly new hospitalizations due to confirmed RSV. 

The most recent RSV forecasts on the [RSV Forecast Hub dashboard](https://hopkinsidd.github.io/rsv-forecast-hub_website/).

## How to Participate:
This RSV Forecast Hub will serve as a collaborative forecasting challenge for weekly laboratory confirmed RSV hospital admissions. Each week, participants are asked to provide national- and jurisdiction-specific probabilistic forecasts of the weekly number of confirmed RSV hospitalizations for the following four weeks. The RSV Forecast Hub is open to any team willing to provide projections at the right temporal and spatial scales. We only require that participating teams share quantile estimates, along with a short model description and answers to a list of key questions about design. 

Those interested in participating, please read the [submission README](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/model-output) and email Kimberlyn Roosa at kroosa1@jh.edu. 

Model projections should be submitted via pull request to the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/model-output) folder and associated metadata should be submitted at the same time to the [model-metadata/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/model-metadata) folder of this GitHub repository. 

### RSV Model Calibration
**RSV-NET Dataset**

The Respiratory Syncytial Virus Hospitalization Surveillance Network (RSV-NET) is a network that conducts active, population-based surveillance for laboratory-confirmed RSV-associated hospitalizations in children younger than 18 years of age and adults. The network currently includes 161 counties in 13 states that participate in the Respiratory Virus Surveillance Network (California, Colorado, Connecticut, Georgia, Maryland, Michigan, Minnesota, New Mexico, New York, North Carolina, Oregon, Tennessee, and Utah). Age- and state-specific data on laboratory-confirmed RSV hospitalization rates are available from RSV-NET spanning 2017-18 to present [(RSV-NET CDC Webpage)](https://www.cdc.gov/rsv/research/rsv-net/index.html). Age-specific weekly rates per 100,000 population are reported in this system.

The data has been standardized and posted in the rsv-forecast-hub github [target-data/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/target-data) folder and is updated weekly. **The target in this data is the weekly number of hospitalizations in each given state (inc_hosp variable), for all ages and for each age group.** To obtain counts, we have converted RSV-NET weekly rates based on state population sizes. This method assumes that RSV-NET hospitals are representative of the whole state. To obtain national US counts, we have used the rates provided for the “overall RSV-NET network”. The data covers 2017-present. Reported age groups include: [0-6 months], [6-12 months], [1-2 yr], [2-4 yr], [5-17 yr], [18-49 yr], [50-64 yr], and 65+ years. The standardized dataset includes week- state- and age-specific RSV counts (the target), rates, and population sizes. 

**Note:** Different states joined RSV-NET in different years (between 2014 and 2018), and RSV surveillance throughout the network was initially limited to adults. RSV surveillance in children began in the 2018-19 season. Further, RSV-NET hospitalization data are preliminary and subject to change as more data become available. Case counts and rates for recent hospital admissions are subject to reporting lags that might increase around holidays or during periods of increased hospital utilization. As new data are received each month, previous case counts and rates are updated accordingly.

The source of age distribution used for calibration (RSV-NET vs other estimates) should be provided in the abstract metadata that is submitted with the projections.


### Prediction Targets
Participating teams are asked to provide **quantile forecasts of the weekly incident confirmed RSV hospital admissions (counts) in the 13 RSV-NET states, nationally for all ages, and for a set of minimal age groups** for the four weeks following the epidemiological week that begins on the origin date. Teams can, but are not required to, submit forecasts for all age groups or all locations.

**Weekly targets:**
- Weekly reported all-age and age-specific state-level incident hospital admissions, based on RSV-NET. This dataset is updated daily and covers 2017-2024. There should be no adjustment for reporting (=raw data from RSV-NET dataset to be projected). 
- All targets should be number of individuals, rather than rates. 

**Age target:**
- **Required:**
  -  Weekly state-specific and national RSV hospitalizations for all ages (or 0-130) is the only mandatory age target. 
- Additional age details (optional):
  - Weekly state-specific and national RSV hospitalizations among individuals <1 yr, 1-4, 5-64, and 65+ (most of the RSV burden on hospitalizations comes from the 0-1 and 65+ age groups)

### Timeline
The RSV Forecast Hub challenge period will begin October 22, 2024 and run through May, 2025. Participating teams are asked to submit weekly forecasts by 11:59 PM Eastern Time each Tuesday.

## Target Data
The [target-data/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/target-data) folder contains the RSV hospitalization data (also called "truth data") standardized from the [Weekly Rates of Laboratory-Confirmed RSV Hospitalizations from the RSV-NET Surveillance System](https://data.cdc.gov/Public-Health-Surveillance/Weekly-Rates-of-Laboratory-Confirmed-RSV-Hospitali/29hc-w46k/about_data).

The weekly hospitalization number per location are going to be used as truth data in the hub.

## Auxiliary Data
The repository stores and updates additional data relevant to the RSV modeling efforts in the [auxiliary-data/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/auxiliary-data) folder:

- Population and census data:
  - National and State level name and fips code as used in the Hub and associated population size.
  - State level population size per year and per age from the US Census Bureau.

## Data License and Reuse:
All source code that is specific to the overall project is available under an open-source MIT license. We note that this license does not cover model code from the various teams, model scenario data if there is (available under specified licenses as described above) and auxiliary data.

## Acknowledgements
This repository follows the guidelines and standards outlined by the [hubverse](https://hubdocs.readthedocs.io/en/latest/), which provides a set of data formats and open source tools for modeling hubs.

