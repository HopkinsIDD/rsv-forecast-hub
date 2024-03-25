## ensemble.R customized for rsv-forecast-hub, split from rsv-forecast-hub_data

local_path <- paste0(dirname(here::here()))
dir_path <- file.path(local_path, "rsv-forecast-hub/")
data_path <- file.path(local_path, "rsv-forecast-hub/")
print(local_path)
#dir_path <- local_path
#data_path <- local_path
print(dir_path)

## ----lib-ens, include=FALSE---------------------------------------------------
# remotes::install_github("Infectious-Disease-Modeling-Hubs/hubEnsembles")
# remotes::install_github("Infectious-Disease-Modeling-Hubs/hubUtils", dependencies = TRUE)
library(hubUtils)
library(hubData)
library(hubEnsembles)
library(dplyr)
library(purrr)
library(jsonlite)

#tasks_json_path <- file.path(dir_path, "hub-config/tasks.json")
#if (file.exists(tasks_json_path)) {
#  print("tasks.json exists.")
#} else {
#  print("tasks.json does not exist.")
#}
## ----setup_specifics, include=FALSE---------------------------------------------------

dates_archive <- unlist(jsonlite::read_json(file.path(dir_path, "hub-config/tasks.json"))$rounds[[1]]$model_tasks[[1]]$task_ids$origin_date$optional)
dates_archive <- dates_archive[as.Date(dates_archive) <= Sys.Date()]

curr_origin_date <- as.Date(max(dates_archive, na.rm = TRUE))
curr_origin_date <- as.Date("2024-03-17")

## ----prep_ens, include=FALSE--------------------------------------------------

#hub_path <- file.path(dir_path, "/")
hub_path <- dir_path
print(hub_path)
hub_con <- connect_hub(hub_path)

## ----load_data, include=FALSE--------------------------------------------------

loc_data <- readr::read_csv(file.path(dir_path, "auxiliary-data/location_census/locations.csv"))

# output path set
output_path <- file.path(dir_path, "model-output")

# all file paths retrieval
file_paths <- list.files(output_path, pattern = "\\.parquet$|\\.csv$", full.names = TRUE, recursive = TRUE)
file_paths <- file_paths[grepl(curr_origin_date, file_paths)]
print(file_paths)

# read the files, and concatenate all the data frames with adding the team name in "model_id" column
projection_data_all <- file_paths %>%
  map_df(~{
    # func selection according to the input file format
    read_fun <- ifelse(grepl("\\.parquet$", .x), arrow::read_parquet, readr::read_csv)

    # read data
    data <- read_fun(.x, stringsAsFactors = FALSE)

    # check if 'origin_date' column exists
    if (!"origin_date" %in% names(data)) {
      print(paste("File", .x, "does not contain 'origin_date' column"))
    }

    # append the team name in "model_id"
    data$model_id <- basename(dirname(.x))

    # return data
    data
  })
head(projection_data_all)


## ----data_prep --------------------------------------------------

projection_data_all <- dplyr::mutate(projection_data_all,
                                     target_date = as.Date(origin_date) + (horizon * 7) - 1)
projection_data_all <- as_model_out_tbl(projection_data_all)
#head(projection_data_all)

round <- projection_data_all %>%
  dplyr::filter(origin_date == as.Date(curr_origin_date)) %>%
  dplyr::collect()


## ----call-data-end, include=FALSE --------------------------------------------------

# Generate Ensembles
#source(file.path(dir_path, "report", "ensemble.R"))
round_ens <- hubEnsembles::simple_ensemble(round)
dir.create(file.path(dir_path, "model-output", "hub-ensemble"), showWarnings = FALSE, recursive = TRUE)
arrow::write_parquet(round_ens, file.path(dir_path, "model-output", "hub-ensemble", paste0(curr_origin_date, "-hub-ensemble.parquet")))

