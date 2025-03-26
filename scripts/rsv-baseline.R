# # The cdc_baseline_forecaster functionality is still in the v0.0.6 development
# # branch at the time of writing. Before it's merged, we'll work off of a
# # particular commit in the epipredict repo:
# pak::pkg_install("cmu-delphi/epipredict@3b809894d00c52ec9e166f26dc6f1c55c671b601")
#remotes::install_github("cmu-delphi/epipredict", ref="3b809894d00c52ec9e166f26dc6f1c55c671b601", dependencies = T)

library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(checkmate)
library(cli)
library(epidatr)
# pak::pkg_install("cmu-delphi/epiprocess@main")
# pak::pkg_install("cmu-delphi/epipredict@main")
library(epiprocess)
library(epipredict)
library(ggplot2)
library(plotly)
library(lubridate)

##############################
## Configuration parameters ##
##############################

local_path <- paste0(dirname(here::here()))

dir_path <- file.path(local_path, "rsv-forecast-hub")
output_dirpath <- file.path(dir_path, "model-output/hub-baseline")
cat_ouput_dir <- file.path(dir_path, "model-output/hub-baseline")


######################
## Helper functions ##
######################

#' Return `date` if it has the desired weekday, else the next date that does
#' @param date `Date` vector
#' @param ltwday integerish vector; of weekday code(s), following POSIXlt
#'   encoding (not `lubridate`'s), but allowing either 0 or 7 to represent
#'   Sunday.
#' @return `Date` object
curr_else_next_date_with_ltwday <- function(date, ltwday) {
  assert_class(date, "Date")
  assert_integerish(ltwday, lower = 0L, upper = 7L)
  #
  date + (ltwday - as.POSIXlt(date)$wday) %% 7L
}

location_to_abbr <- function(location) {
  dictionary <-
    state_census %>%
    mutate(fips = sprintf("%02d", fips)) %>%
    transmute(
      location = case_match(fips, "00" ~ "US", .default = fips),
      abbr
    )
  dictionary$abbr[match(location, dictionary$location)]
}

###############################
## Fetch, prepare input data ##
###############################

# Get target data from HopkinsIDD/rsv-forecast-hub@main:
dates_archive <- unlist(jsonlite::read_json(file.path(dir_path, "hub-config/tasks.json"))$rounds[[1]]$model_tasks[[1]]$task_ids$origin_date$optional)
dates_archive <- dates_archive[as.Date(dates_archive) <= Sys.Date()]
curr_origin_date <- as.Date(max(dates_archive, na.rm = TRUE))

truth_path <- file.path(dir_path, "target-data")

# all file paths retrieval
file_paths <- list.files(truth_path, pattern = "\\.parquet$|\\.csv$", full.names = TRUE, recursive = TRUE)
file_paths <- file_paths[!grepl("archive", file_paths)]

truth_data_all <- file_paths %>%
  map_df(~{
    # func selection according to the input file format
    read_fun <- ifelse(grepl("\\.parquet$", .x), arrow::read_parquet, readr::read_csv)
    
    # read data
    data <- read_fun(.x)
    
    # return data
    data
  })
truth_data <- dplyr::filter(truth_data_all,
                            target == "inc hosp")

target_tbl <- truth_data %>%
  dplyr::select(c("date","location","age_group","value")) %>%
  dplyr::filter(age_group == "0-130")


target_edf <- target_tbl %>%
  transmute(
    geo_value = location_to_abbr(location),
    time_value = .data$date,
    weekly_count = .data$value
  ) %>%
  as_epi_df()

# Implied date settings:
#forecast_as_of_date <- Sys.Date()
forecast_as_of_date <- curr_origin_date
reference_date <- curr_else_next_date_with_ltwday(forecast_as_of_date, 7L) # Sunday

# Validation:
desired_max_time_value <- reference_date - 7L

excess_latency_tbl <- target_edf %>%
  drop_na(weekly_count) %>%
  group_by(geo_value) %>%
  summarize(
    max_time_value = max(time_value),
    .groups = "drop"
  ) %>%
  mutate(
    excess_latency =
      pmax(
        as.integer(desired_max_time_value - max_time_value) %/% 7L,
        0L
      ),
    has_excess_latency = excess_latency > 0L
  )
excess_latency_small_tbl <- excess_latency_tbl %>%
  filter(has_excess_latency)

prop_locs_overlatent_err_thresh <- 0.20
prop_locs_overlatent <- mean(excess_latency_tbl$has_excess_latency)
if (prop_locs_overlatent > prop_locs_overlatent_err_thresh) {
  cli_abort("
    More than {100*prop_locs_overlatent_err_thresh}% of locations have excess
    latency. The reference date is {reference_date} so we desire observations at
    least through {desired_max_time_value}. However,
    {nrow(excess_latency_small_tbl)} location{?s} had excess latency and did not
    have reporting through that date: {excess_latency_small_tbl$geo_value}.
  ")
} else if (prop_locs_overlatent > 0) {
  cli_abort("
    Some locations have excess latency. The reference date is {reference_date}
    so we desire observations at least through {desired_max_time_value}.
    However, {nrow(excess_latency_small_tbl)} location{?s} had excess latency
    and did not have reporting through that date:
    {excess_latency_small_tbl$geo_value}.
  ")
}

######################
## Prepare baseline ##
######################

# For reproducibility, run with a particular RNG configuration. Make seed the
# same for all runs for the same `reference_date`, but different for different
# `reference_date`s. (It's probably not necessary to change seeds between
# `reference_date`s, though, since we use a large number of simulations so even
# if we sample the same quantile level trajectories, it won't be noticeable. The
# `%% 1e9` is also not necessary unless more seed-setting dependencies are added
# that would take us beyond R's integer max value.)
rng_seed <- as.integer((59460707 + as.numeric(reference_date)) %% 2e9)
withr::with_rng_version("4.0.0", withr::with_seed(rng_seed, {
  # Forecasts for all but the -1 horizon, in `epipredict`'s forecast output
  # format. We will want to edit some of the labeling and add horizon -1, so we
  # won't use this directly.
  fcst <- cdc_baseline_forecaster(
    target_edf,
    "weekly_count",
    cdc_baseline_args_list(
      data_frequency = "1 week",
      aheads = 1:5,
      nsims = 1e5,
      # (defaults for everything else)
    )
  )
  # Extract the predictions in `epipredict` format
  preds <- fcst$predictions %>%
    mutate(ahead = ahead - 1) %>%
    distinct()

}))


###################
## Format, write ##
###################

preds_formatted <- preds %>%
  flusight_hub_formatter(
    target = "inc hosp",
    output_type = "quantile",
    age_group = "0-130"
  ) %>%
  drop_na(output_type_id) %>%
  arrange(target, horizon, location) %>%
 dplyr::select(
    reference_date, horizon, target, target_end_date, location,
    output_type, output_type_id, value, age_group
  ) %>%
  dplyr::mutate(target_end_date = as.Date(target_end_date + 1),
                reference_date = curr_origin_date) %>%
  dplyr::rename(origin_date = reference_date) %>%
  dplyr::filter(horizon %in% 0:4)

if (!dir.exists(output_dirpath)) {
  dir.create(output_dirpath, recursive = TRUE)
}

# To write "parquet" file format:
arrow::write_parquet(preds_formatted, 
                     file.path(output_dirpath, 
                     sprintf("%s-hub-baseline.parquet", reference_date))
)

