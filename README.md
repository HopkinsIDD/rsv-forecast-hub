# RSV Forecast Hub

**This repository is in development.**

## Rationale
Respiratory Syncytial Virus (RSV) is the #1 cause of hospitalizations in children under 5 in the United States. Tracking RSV-associated hospitalization rates helps public health professionals understand trends in virus circulation, estimate disease burden, and respond to outbreaks. Accurate predictions of hospital admissions linked to RSV will help support appropriate public health interventions and planning during the 2023-2024 RSV season, as COVID-19, influenza, and other respiratory pathogens are circulating. 

This repository is designed to collect forecast data for the 2023-2024 RSV Forecast Hub run by Johns Hopkins University Infectious Disease Dynamics Group. This project collects forecasts for weekly new hospitalizations due to confirmed RSV. 

## How to Participate:
This RSV Forecast Hub will serve as a collaborative forecasting challenge for weekly laboratory confirmed RSV hospital admissions. Each week, participants are asked to provide national- and jurisdiction-specific probabilistic forecasts of the weekly number of confirmed RSV hospitalizations for the following three weeks. The RSV Forecast Hub is open to any team willing to provide projections at the right temporal and spatial scales. We only require that participating teams share point estimates and uncertainty bounds, along with a short model description and answers to a list of key questions about design. 

Those interested in participating, please read the README file and email Kimberlyn Roosa at kroosa1@jh.edu. 

Model projections should be submitted via pull request to the [model-output/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/model-output) folder and associated metadata should be submitted at the same time to the [model-metadata/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/model-metadata) folder of this GitHub repository. 

### RSV Model Calibration
**RSV-NET Dataset**

The Respiratory Syncytial Virus Hospitalization Surveillance Network (RSV-NET) is a network that conducts active, population-based surveillance for laboratory-confirmed RSV-associated hospitalizations in children younger than 18 years of age and adults. The network currently includes 58 counties in 12 states that participate in the Emerging Infections Program (California, Colorado, Connecticut, Georgia, Maryland, Minnesota, New Mexico, New York, Oregon, and Tennessee) or the Influenza Hospitalization Surveillance Program (Michigan and Utah). Age- and state-specific data on laboratory-confirmed RSV hospitalization rates are available for 12 states and the US from RSV-NET spanning 2017-18 to present [(RSV-NET CDC Webpage)](https://www.cdc.gov/rsv/research/rsv-net/index.html). Age-specific weekly rates per 100,000 population are reported in this system.

The data has been standardized and posted on the rsv-forecast-hub github [target-data/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/target-data) folder and is updated weekly. **The target in this data is the weekly number of hospitalizations in each given state (inc_hosp variable), for all ages and for each age group.** To obtain counts, we have converted RSV-NET weekly rates based on state population sizes. This method assumes that RSV-NET hospitals are representative of the whole state. To obtain national US counts, we have used the rates provided for the “overall RSV-NET network”. The data covers 2017-present. Reported age groups include: [0-6 months], [6-12 months], [1-2 yr], [2-4 yr], [5-17 yr], [18-49 yr], [50-64 yr], and 65+ years. The standardized dataset includes week- state- and age-specific RSV counts (the target), rates, and population sizes. 

**Note:** Different states joined RSVnet in different years (between 2014 and 2018) while RSV surveillance throughout the network was initially limited to adults. Children RSV surveillance began in the 2018-19 season. Further, RSV-NET hospitalization data are preliminary and subject to change as more data become available. Case counts and rates for recent hospital admissions are subject to reporting lags that might increase around holidays or during periods of increased hospital utilization. As new data are received each month, previous case counts and rates are updated accordingly.

The source of age distribution used for calibration (RSV-NET vs other estimates) should be provided in the abstract metadata that is submitted with the projections.

**Other RSV datasets available for calibration:**
A few auxiliary datasets have been posted in the GitHub repositority [auxiliary-data/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/auxiliary-data) folder including:

- State-specific CDC surveillance from NVERSS (only last year of data available)
- State-specific ED data (only last year of data available)

### Prediction Targets
Participating teams are asked to provide **quantile forecasts of the weekly incident confirmed RSV hospital admissions (counts) in the 12 RSV-NET states, nationally for all ages, and for a set of minimal age groups** for the epidemiological week ending on the reference date as well as the three following weeks. Teams can, but are not required to, submit forecasts for all weekly horizons or all locations.

**Weekly targets**
- Weekly reported all-age and age-specific state-level incident hospital admissions, based on RSV-NET. This dataset is updated daily and covers 2017-2023. There should be no adjustment for reporting (=raw data from RSV-NET dataset to be projected). 
- All targets should be number of individuals, rather than rates. 

**Age target**

**Required:**
-  Weekly state-specific and national RSV hospitalizations for all ages (or 0-130) is the only mandatory age target. 

Additional age details (optional):
- Weekly state-specific and national RSV hospitalizations among individuals <1 yr, 1-4, 5-17, 18-49, 50-64, and 65+ (most of the RSV burden on hospitalizations comes from the 0-1 and 65+ age groups)

### Timeline
*Add info here*

## Target Data
The [target-data/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/target-data) folder contains the RSV hospitalization data (also called "truth data") standardized from the [Weekly Rates of Laboratory-Confirmed RSV Hospitalizations from the RSV-NET Surveillance System](https://data.cdc.gov/Public-Health-Surveillance/Weekly-Rates-of-Laboratory-Confirmed-RSV-Hospitali/29hc-w46k/about_data).

The weekly hospitalization number per location are going to be used as truth data in the hub.

## Auxiliary Data
The repository stores and updates additional data relevant to the RSV modeling efforts in the [auxiliary-data/](https://github.com/HopkinsIDD/rsv-forecast-hub/tree/main/auxiliary-data) folder:

- Population and census data:
  - National and State level name and fips code as used in the Hub and associated population size.
  - State level population size per year and per age from the US Census Bureau.

- Birth Rate:
  - Birth Number and Rate per state and per year from 1995 to 2022 included.
  - Data from the US Census Bureau and from the Centers for Disease Control and Prevention, National Center for Health Statistics. National Vital Statistics System, Natality on CDC WONDER Online Database.

- RSV data:
  - The National Respiratory and Enteric Virus Surveillance System (NREVSS) data at national and state level.
  - The [Weekly Rates of Laboratory-Confirmed RSV Hospitalizations from the RSV-NET Surveillance System](https://data.cdc.gov/Public-Health-Surveillance/Weekly-Rates-of-Laboratory-Confirmed-RSV-Hospitali/29hc-w46k)
  - The [National Emergency Department Visits for COVID-19, Influenza, and Respiratory Syncytial Virus](https://www.cdc.gov/ncird/surveillance/respiratory-illnesses/index.html)

## Data License and Reuse:
All source code that is specific to the overall project is available under an open-source MIT license. We note that this license does not cover model code from the various teams, model scenario data if there is (available under specified licenses as described above) and auxiliary data.

## Acknowledgements
This repository follows the guidelines and standards outlined by the [hubverse](https://hubdocs.readthedocs.io/en/latest/), which provides a set of data formats and open source tools for modeling hubs.

