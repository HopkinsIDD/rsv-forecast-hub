# RSV Forecast Hub

**This repository is in development.**

This repository is designed to collect forecast data for the 2023-2024 RSV Forecast Hub run by Johns Hopkins University Infectious Disease Dynamics Group. This project collects forecasts for weekly new hospitalizations due to confirmed Respiratory Syncytial Virus (RSV). 

## Forecasts of Confirmed RSV Hospitalizations Admissions During the 2023-2024 Season
RSV is the #1 cause of hospitalizations in children under 5 in the United States. Tracking RSV-associated hospitalization rates helps public health professionals understand trends in virus circulation, estimate disease burden, and respond to outbreaks. Accurate predictions of hospital admissions linked to RSV will help support appropriate public health interventions and planning during the 2023-2024 RSV season, as COVID-19, influenza, and other respiratory pathogens are circulating. 

### How to Participate:
This RSV Forecast Hub will serve as a collaborative forecasting challenge for weekly laboratory confirmed RSV hospital admissions. Each week, participants are asked to provide national- and jurisdiction-specific probabilistic forecasts of the weekly number of confirmed RSV hospitalizations for the following three weeks. 

The RSV Forecast Hub is open to any team willing to provide projections at the right temporal and spatial scales. We only require that participating teams share point estimates and uncertainty bounds, along with a short model description and answers to a list of key questions about design. A major output of the forecast hub is ensemble estimates of the prediction targets. Model projections should be submitted via pull request to the model-output/ folder and associated metadata should be submitted at the same time to the m odel-metadata/ folder of this GitHub repository. 

Those interested in participating, please read the README file and email Kimberlyn Roosa at kroosa1@jh.edu.

### Prediction Targets:
The Respiratory Syncytial Virus Hospitalization Surveillance Network (RSV-NET) is a network that conducts active, population-based surveillance for laboratory-confirmed RSV-associated hospitalizations in children younger than 18 years of age and adults. The network currently includes 58 counties in 12 states that participate in the Emerging Infections Program (California, Colorado, Connecticut, Georgia, Maryland, Minnesota, New Mexico, New York, Oregon, and Tennessee) or the Influenza Hospitalization Surveillance Program (Michigan and Utah). RSV-NET covers almost 8% of the U.S. population. RSV-NET hospitalization data are preliminary and subject to change as more data become available. Case counts and rates for recent hospital admissions are subject to reporting lags that might increase around holidays or during periods of increased hospital utilization. As new data are received each month, previous case counts and rates are updated accordingly.

Participating teams are asked to provide national- and jurisdiction-specific quantile forecasts of the weekly number of confirmed RSV hospitalizations for the epidemiological week (EW) ending on the reference date as well as the three following weeks. Teams can, but are not required to, submit forecasts for all weekly horizons or all locations. We will use the specification of EWs defined by the CDC, which run Sunday through Saturday. The target end date for a prediction is the Saturday that ends an EW of interest and can be calculated using the expression: target end date = reference date + horizon * (7 days). There are standard software packages to convert from dates to epidemic weeks and vice versa (e.g. MMWRweek and lubridate for R and pymmwr and epiweeks for Python).

## Acknowledgements
This repository follows the guidelines and standards outlined by the hubverse, which provides a set of data formats and open source tools for modeling hubs.

