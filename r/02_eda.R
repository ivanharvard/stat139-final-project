source("r/01_cleaning.R")

results = dq_summarize(
    select(mobile, -Code),
    categorical = categorical_vars
)

results$continuous

results$categorical
