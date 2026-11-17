# A function for determining data quality in a dataset.
# Akin to summarize() function that already exists
dq_summarize = function(df, categorical = character()) {
    # stop if the data variable is not a data frame
    stopifnot(is.data.frame(df))

    if (!all(categorical %in% names(df))) {
      stop("Some categorical variables are not in the dataset")
    }
    
    # find all numeric vars by checking if they pass `is.numeric`
    numeric_vars     = names(df)[sapply(df, is.numeric)]
    continuous_vars  = setdiff(numeric_vars, categorical)
    categorical_vars = union(
        names(df)[sapply(df, function(x) {
          is.factor(x) || is.character(x) || is.logical(x)
        })],
        categorical
    )
  
    # summary of continuous variables
    continuous_summary = do.call(rbind, lapply(
        continuous_vars, function(var) {
            x = df[[var]]
            n_missing = sum(is.na(x))
            n_nonmissing = sum(!is.na(x))

            data.frame(
                Variable   = var,
                Missing    = n_missing,
                NonMissing = n_nonmissing,
                Mean   = if (n_nonmissing > 0) mean(x, na.rm=TRUE)     else NA_real_,
                Median = if (n_nonmissing > 0) median(x, na.rm = TRUE) else NA_real_,
                SD     = if (n_nonmissing > 1) sd(x, na.rm = TRUE)     else NA_real_,
                IQR    = if (n_nonmissing > 0) IQR(x, na.rm = TRUE)    else NA_real_
            )
        }
    ))
  
    # categorical var summary
    categorical_summary = do.call(rbind, lapply(
        categorical_vars, function(var) {
            x = df[[var]]
            counts = table(x, useNA="no")
            
            if (length(counts) == 0) {
                return(
                    data.frame(
                        Variable   = var,
                        Missing    = sum(is.na(x)),
                        NonMissing = sum(!is.na(x)),
                        Level = NA_character_,
                        Count = 0L 
                    )
                )
            }
            
            # else if the count is 0, return this df
            data.frame(
                Variable   = var,
                Missing    = sum(is.na(x)),
                NonMissing = sum(!is.na(x)),
                Level      = names(counts),
                Count      = as.integer(counts)
            )
        }
    ))
    
    # call both summary subfunctions and return them both.
    return(list(
        continuous  = continuous_summary,
        categorical = categorical_summary
    ))
}
