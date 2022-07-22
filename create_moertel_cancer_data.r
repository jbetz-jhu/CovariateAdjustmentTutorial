### Create Time-To-Event Example Dataset: Colon Cancer Trial ###################
# Josh Betz (jbetz@jhu.edu)
#
# This code creates an example time-to-event dataset based on the `colon`
# dataset in the survival package. This is a 3-arm trial involving colon cancer:
# arms include observation, levamisole, and levamisole + 5-Fluorouracil.
#
# Baseline covariates `differ` and `nodes` have missing values that are imputed:
# a single imputation is performed. This simplifies analysis, likely at the
# expense of underestimation of standard errors. Multiple iterations of the MICE
# algorithm are performed.
#
# Since follow-up is fairly long (upwards of 8 years in some cases), the time
# scale is coarsened from days to months (365.25/12 ~ 30.4375 days). This
# coarsening of the time scale is useful when converting to a survival dataset
# with one row per (person on-study) x (time-unit at risk).

library(survival)
library(mice)
library(tidyr)
library(dplyr)




### Rename Columns, Convert from Long to Wide ##################################
colon_cancer <-
  survival::colon %>%
  dplyr::select(
    id,
    arm = rx,
    age, sex,
    obstruction = obstruct,
    perforation = perfor,
    organ_adherence = adhere,
    positive_nodes = nodes,
    differentiation = differ,
    local_spread = extent,
    time_surgery_registration = surg,
    event = status,
    time_to = time,
    event_type = etype
  ) %>% 
  # Convert from Long to Wide
  tidyr::pivot_longer(
    cols = all_of(x = c("event", "time_to"))
  ) %>%
  dplyr::mutate(
    event_type =
      case_when(
        event_type == 1 ~ "recurrence",
        event_type == 2 ~ "death"
      )
  ) %>% 
  tidyr::unite(
    col = name,
    name, event_type
  ) %>% 
  tidyr::pivot_wider(
    names_from = name,
    values_from = value
  )


### Label Factors, Create Composite, Coarsen Time Scale ########################
colon_cancer <- 
  colon_cancer %>%
  # Label factor variables
  dplyr::mutate(
    recurrence = event_recurrence,
    death = event_death,
    composite = 1*(recurrence | death),
    
    across(
      .cols = c("obstruction", "perforation", "organ_adherence",
                "recurrence", "death", "composite"),
      .fns = function(x)
        factor(
          x = x,
          levels = 0:1,
          labels = c("0. No", "1. Yes"),
        )
    ),
    
    arm =
      factor(
        x = arm,
        levels = c("Obs", "Lev", "Lev+5FU")
      ),
    
    sex =
      factor(
        x = sex,
        levels = 0:1,
        labels = c("0. Female", "1. Male"),
      ),
    
    differentiation =
      factor(
        x = differentiation,
        levels = 1:3,
        labels = c("1. Well", "2. Moderate", "3. Poor"),
      ),
    
    local_spread =
      factor(
        x = local_spread,
        levels = 1:4,
        labels =
          c("1. Submucosa", "2. Muscle",
            "3. Serosa", "4. Contiguous structures"),
      ),
    
    time_surgery_registration =
      factor(
        x = time_surgery_registration,
        levels = 0:1,
        labels =
          c("0. Short", "1. Long")
      ),
    
    time_to_composite =
      case_when(
        death == "1. Yes" & recurrence == "1. Yes" ~
          pmin(time_to_death, time_to_recurrence),
        death == "0. No" & recurrence == "1. Yes" ~ time_to_recurrence,
        death == "1. Yes" & recurrence == "0. No" ~ time_to_death,
        death == "0. No" & recurrence == "0. No" ~
          pmin(time_to_death, time_to_recurrence),
      ),
    
    # Coarsen time scale to months:
    months_to_death = ceiling(time_to_death/(365.25/12)),
    
    months_to_recurrence = ceiling(time_to_recurrence/(365.25/12)),
    
    months_to_composite = ceiling(time_to_composite/(365.25/12)),
  )


# Save the original dataset prior to imputation
colon_cancer_original <- colon_cancer


### Impute Missing Covariates ##################################################
# NOTE: In an attempt to preserve covariate-outcome relationships,
# a (year of event x event indicator) interaction is included as a categorical
# variable in imputation. One issue is that of the 929 participants in the
# trial, very few (929 - 915 = 14) are censored prior to the 5th year of
# follow-up, and sparsity also occurs after 7 years of follow-up. When imputing,
# those N=14 censored before year 5 are dropped, and time-to-event is top-coded
# at 7 years.

colon_cancer_impute <-
  colon_cancer %>% 
  dplyr::filter(
    time_to_death >= 5*365.25 | event_death == 1
  ) %>% 
  dplyr::mutate(
    # Coarsen time scale to years:
    years_to_death = ceiling(time_to_death/(365.25)),
    
    years_to_recurrence = ceiling(time_to_recurrence/(365.25)),
    
    years_to_composite = ceiling(time_to_composite/(365.25)),
    
    years_to_death_topcode =
      case_when(
        years_to_death < 7 ~ years_to_death,
        years_to_death >= 7 ~ 7
      )
  ) %>% 
  dplyr::select(
    id,
    arm,
    age, sex,
    obstruction, perforation, organ_adherence,
    differentiation, local_spread,
    time_surgery_registration,
    positive_nodes,
    years_to_death_topcode, event_death
  ) %>% 
  dplyr::mutate(
    id = as.character(id),
    death_time =
      factor(
        x = paste0(event_death, ":", years_to_death_topcode),
      ),
    event_death = NULL, 
    years_to_death_topcode = NULL
  )

# Massive Imputation
colon_cancer_predictor_matrix <-
  matrix(
    data = 1,
    nrow = ncol(colon_cancer_impute),
    ncol = ncol(colon_cancer_impute),
  )

diag(colon_cancer_predictor_matrix) <- 0

# Do not use "id" as predictor
colon_cancer_predictor_matrix[
  , which(names(colon_cancer_impute) %in% c("id"))
] <- 0


### Perform MICE ###############################################################
colon_cancer_mice <-
  mice(
    data = colon_cancer_impute,
    predictorMatrix = colon_cancer_predictor_matrix,
    exclude = "id",
    # Single Imputation
    m = 1,
    # 20 Iterations of MICE Algorithm
    maxit = 20,
    # Seed for reproducibility
    seed = 12345,
    printFlag = FALSE
  )


# Get completed data for the N=915
colon_cancer_mice <-
  complete(colon_cancer_mice) %>% 
  dplyr::mutate(
    id = as.numeric(id)
  ) %>% 
  dplyr::select(
    id, differentiation, positive_nodes
  )


### Assemble Completed Dataset #################################################
colon_cancer_original <- colon_cancer

colon_cancer <-
  dplyr::full_join(
    x = 
      colon_cancer %>% 
      dplyr::select(
        -all_of(x = c('differentiation', "positive_nodes"))
      ),
    y = 
      dplyr::bind_rows(
        colon_cancer_mice,
        colon_cancer %>% 
          dplyr::filter(
            time_to_death < 5*365.25 & event_death == 0
          ) %>% 
          dplyr::select(
            id, differentiation, positive_nodes
          )
      ),
    by = "id"
  ) %>% 
  dplyr::select(
    all_of(x = names(colon_cancer))
  )
