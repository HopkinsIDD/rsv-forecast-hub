## retro_ensemble.R customized for rsv-forecast-hub

# Get the file_path from the command line arguments
args <- commandArgs(trailingOnly = TRUE)
retro_file_path <- args[1]

local_path <- paste0(dirname(here::here()))
dir_path <- file.path(local_path, "rsv-forecast-hub-kjsato/")
data_path <- file.path(local_path, "rsv-forecast-hub-kjsato/")
print(local_path)
print(dir_path)

library(hubUtils)
library(hubData)
library(hubEnsembles)
library(dplyr)
library(purrr)
library(jsonlite)

hub_path <- dir_path
print(hub_path)
hub_con <- connect_hub(hub_path)

loc_data <- readr::read_csv(file.path(dir_path, "auxiliary-data/location_census/locations.csv"))

output_path <- file.path(dir_path, "model-output")

# Extract date from file name
curr_origin_date <- as.Date(gsub("^(\\d{4}-\\d{2}-\\d{2}).*", "\\1", basename(retro_file_path)))

# Get all RETRO files (maybe needed consideration for the case of a combo without RETRO files)
file_paths <- list.files(output_path, pattern = "-RETRO\\.parquet$|-RETRO\\.csv$", full.names = TRUE, recursive = TRUE)
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

# Prepare data
projection_data_all <- dplyr::mutate(projection_data_all,
                                     target_date = as.Date(origin_date) + (horizon * 7) - 1)
projection_data_all <- as_model_out_tbl(projection_data_all)

round <- projection_data_all %>%
  dplyr::filter(origin_date == as.Date(curr_origin_date)) %>%
  dplyr::collect()

# Generate ensemble
round_ens <- hubEnsembles::simple_ensemble(round)

# Save ensemble
dir.create(file.path(dir_path, "model-output", "hub-ensemble"), showWarnings = FALSE, recursive = TRUE)
arrow::write_parquet(round_ens, file.path(dir_path, "model-output", "hub-ensemble", paste0(curr_origin_date, "-hub-ensemble-RETRO.parquet")))
