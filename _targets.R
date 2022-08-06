library(targets)
library(tarchetypes)
suppressPackageStartupMessages(library(tidyverse))

class_number <- "PMAP 3210"
base_url <- "https://nonprofitf22.classes.andrewheiss.com/"
page_suffix <- ".html"

options(tidyverse.quiet = TRUE,
        dplyr.summarise.inform = FALSE)

tar_option_set(
  packages = c("tibble"),
  format = "rds",
  workspace_on_error = TRUE
)

# here::here() returns an absolute path, which then gets stored in tar_meta and
# becomes computer-specific (i.e. /Users/andrew/Research/blah/thing.Rmd).
# There's no way to get a relative path directly out of here::here(), but
# fs::path_rel() works fine with it (see
# https://github.com/r-lib/here/issues/36#issuecomment-530894167)
here_rel <- function(...) {fs::path_rel(here::here(...))}

# Load functions for the pipeline
# source("R/tar_slides.R")
source("R/tar_calendar.R")

# THE MAIN PIPELINE ----
list(
  ## Class schedule calendar ----
  tar_target(schedule_file, here_rel("data", "schedule.csv"), format = "file"),
  tar_target(schedule_page_data, build_schedule_for_page(schedule_file)),
  tar_target(schedule_ical_data, build_ical(schedule_file, base_url, page_suffix, class_number)),
  tar_target(schedule_ical_file,
             save_ical(schedule_ical_data,
                       here_rel("files", "schedule.ics")),
             format = "file"),

  ## Build site ----
  tar_quarto(site, path = ".")
)
