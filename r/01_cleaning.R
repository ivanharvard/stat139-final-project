library(tidyverse)
library(readxl)
library(janitor)
source("r/helpers.R")

path = "data/mobile_dependence/mobile_dependence_data.xlsx"

demo_cols = c("Program", "Department", "Semester", "Age", "Sex", "MS", "SES")

# read and stdize col names
read_sheet = function(sheet) {
    data = read_excel(path, sheet, .name_repair = "minimal")

    names(data) = names(data) |>
        str_remove("^.*\\s{2,}") |>
        make_clean_names(case = "none")

    data
}

# read questionnaire sheets
read_scale = function(sheet, scale) {
    data = read_sheet(sheet)

    if (scale == "bdi") {
        data = rename(data, A = DepressionA)
    }

    if (scale == "nordic") {
        data = rename(data, Q2_Lower_Back = Q1_Lower_Back_2)
    }

    data |>
        select(-all_of(demo_cols)) |>
        rename_with(\(x) paste0(scale, "_", x), -Code)
}

# load datasets
socio <- read_sheet("SocioDemo_data") |>
  rename(
    Usual_Phone_Location = Usual_Phone_Locationn,
    Using_Time_management_Apps = Using_Ttime_management_Apps
  )

scale_sheets <- c(
    tmd    = "TMD_data",
    nordic = "Nordic_Questionnaire_data",
    bdi    = "Depression_data",
    stai   = "Anxiety_data"
)
scales <- imap(scale_sheets, read_scale)

# now merge and validate
mobile = reduce(
    scales,
    left_join,
    .init = socio,
    by = "Code",
    relationship = "one-to-one"
)

stopifnot(
    nrow(mobile) == 1220,
    !anyDuplicated(names(mobile))
)

categorical_vars = c(
    setdiff(names(socio), c("Code", "Semester", "Age")),
    names(scales$nordic)[-1]
)


