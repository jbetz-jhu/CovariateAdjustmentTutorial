# CTN-0003 Case Study: Ordinal Outcome, Fixed Sample Size

[Josh Betz](mailto:jbetz@jhu.edu), [Kelly Van Lancker](kvanlan3@jhu.edu), and [Michael Rosenblum](mrosen@jhu.edu)

-   [Executive Summary](#executive-summary)
-   [Covariate Adjusted Analysis in
    Practice](#covariate-adjusted-analysis-in-practice)
    -   [Installing R Packages](#installing-r-packages)
-   [CTN03 Study Design](#ctn03-study-design)
    -   [Creating Simulated Data:](#creating-simulated-data)
-   [Simulated CTN03 Data](#simulated-ctn03-data)
    -   [Baseline Demographics &
        Stratum](#baseline-demographics--stratum)
-   [Checks on the Data:](#checks-on-the-data)
    -   [Categorical Variables in R](#categorical-variables-in-r)
    -   [Reference level for Treatment](#reference-level-for-treatment)
    -   [Frequency of Ordinal Outcomes](#frequency-of-ordinal-outcomes)
    -   [Dropping Unused Factor Levels](#dropping-unused-factor-levels)
-   [Unadjusted Analysis](#unadjusted-analysis)
    -   [Mann-Whitney](#mann-whitney)
    -   [Log Odds Ratio](#log-odds-ratio)
    -   [Weighted Difference in Means](#weighted-difference-in-means)
-   [Covariate Adjusted Analyses using
    `drord()`](#covariate-adjusted-analyses-using-drord)
    -   [Model 1: Adjusting for Stratification
        Variable](#model-1-adjusting-for-stratification-variable)
    -   [Model 2: Adjusting for Baseline
        Covariates](#model-2-adjusting-for-baseline-covariates)
-   [Comparing Adjusted to Unadjusted
    Results](#comparing-adjusted-to-unadjusted-results)
    -   [Mann-Whitney](#mann-whitney-1)
    -   [Log Odds Ratio](#log-odds-ratio-1)
    -   [Diference in Means](#diference-in-means)

<style type="text/css">
.main-container {
  max-width: 100% !important;
  margin: auto;
}
</style>

## Executive Summary

Randomly allocating participants to treatment arms will tend to produce
groups that are initially comparable to one another across both observed
and unobserved factors. In any given randomized trial, there will be
some degree of imbalance in the distribution of baseline covariates
between treatment groups. When a variable is a strong predictor of the
outcome and is imbalanced across treatment arms, it represents a
potential confounding variable and source of bias, even if these
differences are not statistically significant (Assmann et al. 2000).
Confounding can be addressed both in the design phase of a trial, using
stratified randomization to lessen the potential for imbalance, and in
during the analysis phase, through covariate adjustment.

Covariate adjustment can lead to a more efficient trial, even if
covariates are balanced across treatment groups. Covariate adjusted
analyses can lower the required sample size to detect a given treatment
effect if it exists, or provide greater precision (shorter confidence
interval widths and higher power) for the same sample size and treatment
effect. When stratified randomization is used, covariate adjustment is
generally suggested, but not always implemented, which can lead to
reduced power and precision (Kahan and Morris 2011). Accessible and
practical discussions of baseline balance, stratified randomized trials,
and adjusted analyses are also available to offer further explanation
and guidance to investigators Assmann et al. (2000).

When using regression models for inference, it is important to
understand how model misspecification may affect statistical inference.
Fortunately, there are several approaches to covariate-adjusted analyses
whose validity does not depend on a correctly specified model, or
provide inference with greater robustness to misspecification than those
used in common practice.

This tutorial illustrates the use of covariate-adjusted analysis in
clinical trials using a simulated dataset which mimics key features of
an actual randomized trial in substance abuse. Covariate-adjusted
estimates are also illustrated for trials with stratified randomization,
using variance estimates that are more efficient than those that do not
account for stratified randomization. All of the methods illustrated
give estimates that are consistent even when the models are partly or
wholly misspecified.

**The focus of this template is on the analysis of ordinal outcomes,**
and covers three commonly used estimands: the Mann-Whitney estimand, the
log odds ratio (LOR) estimand, and the difference in weighed means (or
mean utility) estimand. These estimands are first computed without
covariate adjustment, then with covariate adjustment using the `drord`
package.

#### Using This Tutorial

This tutorial contains an example dataset as well as code to illustrate
how to perform covariate adjustment in practice for continuous and
binary outcomes using [R](https://www.r-project.org/). R is a free and
open source language and statistical computing environment.
[Rstudio](https://rstudio.com/) is a powerful development environment
for using the R language. The ability of R can be extended by
downloading software packages from the [Comprehensive R Archival Network
(CRAN)](https://cran.r-project.org/). In R, these packages can be
installed from the Comprehensive R Archival Network, or CRAN, using the
`install.packages()` command. In Rstudio IDE, there is a ‘Packages’ tab
that allows users to see which packages are installed, which packages
are currently in use, and install or update packages using a graphical
interface. Once the required packages are installed, data can be
downloaded from Github, and users can run the code on their own devices.

## Covariate Adjusted Analysis in Practice

### Installing R Packages

The following packages and their dependencies needs to be installed:

-   [tidyverse](https://www.tidyverse.org/packages/) - An ecosystem of
    packages for working with data
-   [table1](https://cran.r-project.org/web/packages/table1/index.html) -
    Creating simple tabulations in aggregate and by treatment arm
-   [drord](https://cran.r-project.org/web/packages/drord/drord.pdf) -
    Doubly-Robust Estimators for Ordinal Outcomes
-   [sandwich](https://cran.r-project.org/web/packages/sandwich/index.html) -
    Robust variance-covariance estimates of model parameters
-   [lmtest](https://cran.r-project.org/web/packages/lmtest/index.html) -
    Testing and confidence intervals for regression models

``` r
required_packages <-
  c("tidyverse",
    "table1",
    "margins",
    "drord",
    "sandwich",
    "lmtest")

install.packages(required_packages)
```

Once the required packages are installed, they can be loaded using
`library()`

``` r
library(tidyverse)
library(table1)
library(drord)
library(sandwich)
library(lmtest)
library(boot)
```

## CTN03 Study Design

CTN03 was a phase III two arm trial to assess tapering schedules of the
drug buprenorphine, a pharmacotherapy for opioid dependence. At the time
of the study design, there was considerable variation in tapering
schedules in practice, and a knowledge gap in terms of the best way to
administer buprenorphine to control withdrawal symptoms and give the
greatest chance of abstinence at the end of treatment. It was
hypothesized that a longer taper schedule would result in greater
likelihood of a participant being retained on study and providing
opioid-free urine samples at the end of the drug taper schedule.

Participants were randomized 1:1 to a 7-day or 28-day taper using
stratified block randomization across 11 sites in 10 US cities.
Randomization was stratified by the maintenance dose of buprenorphine at
stabilization: 8, 16, or 24 mg.

The results of CTN03 can be found [here]().

### Creating Simulated Data:

The data in this template are simulated data, generated from probability
models fit to the original study data, and *not the actual data from the
CTN03 trial.* A new dataset was created by resampling with replacement
from the original data, and then each variable in the new dataset was
iteratively replaced using simulated values from probability models
based on the original data.

------------------------------------------------------------------------

## Simulated CTN03 Data

The data can be loaded directly from Github:

``` r
data_url <-
  "https://github.com/jbetz-jhu/CovariateAdjustmentTutorial/raw/main/SIMULATED_CTN03_220506.Rdata"

load(file = url(data_url))
```

The complete simulated trial data without any missing values are in a
`data.frame` named `ctn03_sim`, and a missingness mechanism based on
baseline data is applied to `ctn03_sim_mar`.

-   Randomization Information
    -   `arm`: Treatment Arm
    -   `stability_dose`: Stratification Factor
-   Baseline Covariates
    -   `age`: Participant age at baseline
    -   `sex`: Participant sex
    -   `race`: Participant race
    -   `ethnic`: Participant ethnicity
    -   `marital`: Participant marital status
-   Baseline (`_bl`) & End-Of-Taper (`_eot`) Outcomes:
    -   `arsw_score`: Adjective Rating Scale for Withdrawal (ARSW) Score
        at baseline
    -   `cows_score`: Clinical Opiate Withdrawal Scale (COWS) Score at
        baseline
    -   `cows_category`: COWS Severity Category - Ordinal
    -   `vas_crave_opiates`: Visual Analog Scale (VAS) - Self report of
        opiate cravings
    -   `vas_current_withdrawal`: Visual Analog Scale (VAS) - Current
        withdrawal symptoms
    -   `vas_study_tx_help`: Visual Analog Scale (VAS) - Study treatment
        helping symptoms
    -   `uds_opioids`: Urine Drug Screen Result - Opioids
    -   `uds_oxycodone`: Urine Drug Screen Result - Oxycodone
    -   `uds_any_positive`: Urine Drug Screen - Any positive result

### Baseline Demographics & Stratum

Below are summary statistics of participant characteristics at baseline:

``` r
table1(
  ~ age + sex + race + ethnic + marital + stability_dose | arm, 
  data = ctn03_sim
)
```

    ##                                              28-day             7-day           Overall
    ## 1                                           (N=261)           (N=255)           (N=516)
    ## 2                             age                                                      
    ## 3                       Mean (SD)       35.9 (11.4)       36.3 (11.1)       36.1 (11.2)
    ## 4               Median [Min, Max] 34.0 [18.0, 65.0] 37.0 [19.0, 62.0] 35.0 [18.0, 65.0]
    ## 5                             sex                                                      
    ## 6                            Male       173 (66.3%)       201 (78.8%)       374 (72.5%)
    ## 7                          Female        88 (33.7%)        54 (21.2%)       142 (27.5%)
    ## 8                            race                                                      
    ## 9                           White       185 (70.9%)       199 (78.0%)       384 (74.4%)
    ## 10         Black/African American        30 (11.5%)         25 (9.8%)        55 (10.7%)
    ## 11   Spanish, Hispanic, or Latino         12 (4.6%)         15 (5.9%)         27 (5.2%)
    ## 12                          Other          3 (1.1%)          4 (1.6%)          7 (1.4%)
    ## 13                       Multiple        31 (11.9%)         12 (4.7%)         43 (8.3%)
    ## 14                         ethnic                                                      
    ## 15                   Not Hispanic       240 (92.0%)       236 (92.5%)       476 (92.2%)
    ## 16                       Hispanic         21 (8.0%)         19 (7.5%)         40 (7.8%)
    ## 17                        marital                                                      
    ## 18           Married/Cohabitating        60 (23.0%)        80 (31.4%)       140 (27.1%)
    ## 19                  Never married       129 (49.4%)       111 (43.5%)       240 (46.5%)
    ## 20     Divorced/Separated/Widowed        72 (27.6%)        64 (25.1%)       136 (26.4%)
    ## 21                 stability_dose                                                      
    ## 22                           8 mg         21 (8.0%)         17 (6.7%)         38 (7.4%)
    ## 23                          16 mg        86 (33.0%)        69 (27.1%)       155 (30.0%)
    ## 24                          24 mg       154 (59.0%)       169 (66.3%)       323 (62.6%)

------------------------------------------------------------------------

## Checks on the Data:

### Categorical Variables in R

Ordinal variables may come as numeric values (e.g. a scale of 0-6, such
as the [modified Rankin
Scale](https://en.wikipedia.org/wiki/Modified_Rankin_Scale)) or as
character labels that are not numeric (e.g. ‘Death’, ‘Persistent
vegetative state’, ‘Severe disability’, ‘Moderate disability’, ‘Low
disability’ in the [Glasgow Outcome
Scale](https://en.wikipedia.org/wiki/Glasgow_Outcome_Scale)).

R has variable types `factor` and `ordered` for unordered and ordered
categorical variables. These variables are labeled integers, but do not
function like numeric values: arithmetic operations are not defined on
them. Most software treats the first defined level as the ‘default’
level of the variable. The `levels` function can be used to check the
labels and orderings of a categorical variable. The `relevel` function
can be used to re-order the levels of a factor.

``` r
# Assess Outcome Variable Type
class(ctn03_sim$cows_category_eot)
```

    ## [1] "character"

``` r
typeof(ctn03_sim$cows_category_eot)
```

    ## [1] "character"

``` r
# Convert to Factor: Labeled Integer
ctn03_sim$cows_category_bl <-
  factor(
    x = ctn03_sim$cows_category_bl,
    levels =
      c("0. No withdrawal",
        "1. Mild withdrawal",
        "2. Moderate withdrawal",
        "3. Moderately severe withdrawal",
        "4. Severe withdrawal"
      )
  )

ctn03_sim$cows_category_eot <-
  factor(
    x = ctn03_sim$cows_category_eot,
    levels =
      c("0. No withdrawal",
        "1. Mild withdrawal",
        "2. Moderate withdrawal",
        "3. Moderately severe withdrawal",
        "4. Severe withdrawal"
      )
  )


# Re-assess Outcome Variable Type
class(ctn03_sim$cows_category_eot)
```

    ## [1] "factor"

``` r
typeof(ctn03_sim$cows_category_eot)
```

    ## [1] "integer"

``` r
levels(ctn03_sim$cows_category_eot)
```

    ## [1] "0. No withdrawal"                "1. Mild withdrawal"              "2. Moderate withdrawal"          "3. Moderately severe withdrawal" "4. Severe withdrawal"

The `as.numeric` function can convert a `factor` into numeric values
based on the defined levels of the factor:

``` r
with(
  ctn03_sim,
  table(
    cows_category_eot,
    as.numeric(cows_category_eot)
  )
)
```

    ##                                  
    ## cows_category_eot                   1   2   3
    ##   0. No withdrawal                385   0   0
    ##   1. Mild withdrawal                0 119   0
    ##   2. Moderate withdrawal            0   0  12
    ##   3. Moderately severe withdrawal   0   0   0
    ##   4. Severe withdrawal              0   0   0

### Reference level for Treatment

When the treatment is a `factor` variable, we can use the `levels()`
function to see the reference level (i.e. the comparator/control group):
it will appear as the first level.

``` r
# Check reference level
levels(ctn03_sim$arm)
```

    ## [1] "28-day" "7-day"

**Make sure that the reference level is appropriately chosen before
running analyses to avoid errors in inference.**

### Frequency of Ordinal Outcomes

Categorical variables which have categories with very low frequencies
may pose problems in statistical inference. Investigators should check
the frequency of categories prior to analysis and have a plan for
pooling levels of an outcome with low frequency.

``` r
table1(
  ~ cows_category_bl + cows_category_eot | arm, 
  data = ctn03_sim
)
```

    ##                                           28-day       7-day     Overall
    ## 1                                        (N=261)     (N=255)     (N=516)
    ## 2                   cows_category_bl                                    
    ## 3                   0. No withdrawal 243 (93.1%) 242 (94.9%) 485 (94.0%)
    ## 4                 1. Mild withdrawal   18 (6.9%)   13 (5.1%)   31 (6.0%)
    ## 5             2. Moderate withdrawal      0 (0%)      0 (0%)      0 (0%)
    ## 6    3. Moderately severe withdrawal      0 (0%)      0 (0%)      0 (0%)
    ## 7               4. Severe withdrawal      0 (0%)      0 (0%)      0 (0%)
    ## 8                  cows_category_eot                                    
    ## 9                   0. No withdrawal 195 (74.7%) 190 (74.5%) 385 (74.6%)
    ## 10                1. Mild withdrawal  59 (22.6%)  60 (23.5%) 119 (23.1%)
    ## 11            2. Moderate withdrawal    7 (2.7%)    5 (2.0%)   12 (2.3%)
    ## 12   3. Moderately severe withdrawal      0 (0%)      0 (0%)      0 (0%)
    ## 13              4. Severe withdrawal      0 (0%)      0 (0%)      0 (0%)

### Dropping Unused Factor Levels

Factor levels may still be used by statistical software even if there
are no observations in those levels. If we want to drop unobserved
levels of a factor, we can use `droplevels` either on variables or a
`data.frame`:

``` r
ctn03_sim <-
  droplevels(ctn03_sim)

# Re-run tabulations after `droplevels`
table1(
  ~ cows_category_bl + cows_category_eot | arm, 
  data = ctn03_sim
)
```

    ##                                 28-day       7-day     Overall
    ## 1                              (N=261)     (N=255)     (N=516)
    ## 2         cows_category_bl                                    
    ## 3         0. No withdrawal 243 (93.1%) 242 (94.9%) 485 (94.0%)
    ## 4       1. Mild withdrawal   18 (6.9%)   13 (5.1%)   31 (6.0%)
    ## 5        cows_category_eot                                    
    ## 6         0. No withdrawal 195 (74.7%) 190 (74.5%) 385 (74.6%)
    ## 7       1. Mild withdrawal  59 (22.6%)  60 (23.5%) 119 (23.1%)
    ## 8   2. Moderate withdrawal    7 (2.7%)    5 (2.0%)   12 (2.3%)

------------------------------------------------------------------------

## Unadjusted Analysis

### Mann-Whitney

Note that the Mann-Whitney
![U](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;U "U")
statistic is identical to the two-sample Wilcoxon Rank Sum Test. Note
that this procedure can be used to test one of [several possible null
hypotheses:](https://en.wikipedia.org/wiki/Mann-Whitney-Wilcoxon_test).
In R, the null hypothesis tested is one of a location shift in the
cumulative distribution of the outcome being equal to zero, not the
probability of outcomes under treatment being stochastically different
from controls (see `?wilcox.test`).

``` r
ctn03_cows_ordinal_wrst <-
  wilcox.test(
    as.numeric(cows_category_eot) ~ arm,
    data = ctn03_sim
  )

ctn03_cows_ordinal_wrst
```

    ## 
    ##  Wilcoxon rank sum test with continuity correction
    ## 
    ## data:  as.numeric(cows_category_eot) by arm
    ## W = 33273, p-value = 0.9972
    ## alternative hypothesis: true location shift is not equal to 0

However, we can get an estimate of the probability that a
randomly-selected individual from the treatment population would have a
better outcome than a randomly-selected individual from the control
population from the test statistic. This is given by taking the test
statistic and dividing it by the product of the sample sizes in each
group:

``` r
ctn03_cows_mw_pr_estimate <- 
  ctn03_cows_ordinal_wrst$statistic/prod(table(ctn03_sim$arm))
```

Confidence intervals for the unadjusted estimate can be obtained by the
bootstrap. See the [tutorial on using the Bootstrap for inference for
more details]().

``` r
# 1. Create statistic function
wilcox_to_auc <-
  function(data, indices = NULL, outcome, treatment){
    if(is.null(indices)) indices <- 1:nrow(data)
    
    wrst_formula <- as.formula(paste(outcome, treatment, sep = "~"))
    
    wrst_result <-
      wilcox.test(
        formula = wrst_formula,
        data = data[indices,]
      )
    
    wrst_result$statistic/prod(table(data[indices, treatment]))
  }

# 2. Call boot() using statistic function
ctn03_cows_mw_pr_boot <-
  boot(
    data = ctn03_sim,
    statistic = wilcox_to_auc,
    R = 10000,
    outcome = "as.numeric(cows_category_eot)",
    treatment = "arm"
  )

# 3. Call boot.ci to get BCA confidence interval
ctn03_cows_mw_pr_boot_ci <-
  boot.ci(
    boot.out = ctn03_cows_mw_pr_boot,
    type = "bca"
  )

# Review Results
ctn03_cows_mw_pr_boot
```

    ## 
    ## ORDINARY NONPARAMETRIC BOOTSTRAP
    ## 
    ## 
    ## Call:
    ## boot(data = ctn03_sim, statistic = wilcox_to_auc, R = 10000, 
    ##     outcome = "as.numeric(cows_category_eot)", treatment = "arm")
    ## 
    ## 
    ## Bootstrap Statistics :
    ##      original       bias    std. error
    ## t1* 0.4999249 8.021062e-05  0.01920132

``` r
ctn03_cows_mw_pr_boot_ci
```

    ## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
    ## Based on 10000 bootstrap replicates
    ## 
    ## CALL : 
    ## boot.ci(boot.out = ctn03_cows_mw_pr_boot, type = "bca")
    ## 
    ## Intervals : 
    ## Level       BCa          
    ## 95%   ( 0.4619,  0.5372 )  
    ## Calculations and Intervals on Original Scale

``` r
# Compile results together
ctn03_cows_mw_pr <-
  tibble(
    Model = "Unadjusted",
    Estimate = ctn03_cows_mw_pr_boot$t0,
    `Lower 95%` = tail(ctn03_cows_mw_pr_boot_ci$bca[1,], 2)[1],
    `Upper 95%` = tail(ctn03_cows_mw_pr_boot_ci$bca[1,], 2)[2]
  )
```

From this analysis, we’d estimate the unadjusted probability that a
randomly-selected individual from a population assigned to a 7-day taper
would have a better COWS score than a randomly-selected individual from
a population assigned to a 28-day taper is 0.5 (95% CI: 0.462, 0.537).

### Log Odds Ratio

The proportional odds logistic regression model is one possible model
for ordinal-level outcomes:

``` r
ctn03_cows_ordinal_unadjusted_lor <-
  MASS::polr(
    formula = cows_category_eot ~ arm,
    data = ctn03_sim,
    Hess = TRUE
  )

summary(ctn03_cows_ordinal_unadjusted_lor)
```

    ## Call:
    ## MASS::polr(formula = cows_category_eot ~ arm, data = ctn03_sim, 
    ##     Hess = TRUE)
    ## 
    ## Coefficients:
    ##              Value Std. Error  t value
    ## arm7-day 0.0007851     0.2016 0.003895
    ## 
    ## Intercepts:
    ##                                           Value   Std. Error t value
    ## 0. No withdrawal|1. Mild withdrawal        1.0784  0.1422     7.5816
    ## 1. Mild withdrawal|2. Moderate withdrawal  3.7381  0.3087    12.1074
    ## 
    ## Residual Deviance: 664.9156 
    ## AIC: 670.9156

While inference assumes that the proportional odds model is
approximately correctly specified, we can obtain standard errors and
confidence intervals that are robust to the misspecification of model
based standard errors using `sandwich::sandwich`. These can bse used
with `lmtest::coeftest` for testing and `lmtest::coefci` for confidence
intervals:

``` r
# Hypothesis Tests based on Robust SEs
ctn03_cows_unadjusted_lor_tests <-
  lmtest::coeftest(
    x = ctn03_cows_ordinal_unadjusted_lor,
    vcov. = sandwich(ctn03_cows_ordinal_unadjusted_lor)
  )

# Confidence Intervals based on Robust SEs
ctn03_cows_unadjusted_lor_ci <-
  lmtest::coefci(
    x = ctn03_cows_ordinal_unadjusted_lor,
    vcov. = sandwich(ctn03_cows_ordinal_unadjusted_lor)
  )


# Review Results
ctn03_cows_unadjusted_lor_tests
```

    ## 
    ## t test of coefficients:
    ## 
    ##            Estimate Std. Error t value Pr(>|t|)
    ## arm7-day 0.00078511 0.20156472  0.0039   0.9969

``` r
ctn03_cows_unadjusted_lor_ci
```

    ##               2.5 %   97.5 %
    ## arm7-day -0.3952087 0.396779

``` r
ctn03_cows_lor_unadjusted <-
  tibble(
    Model = "Unadjusted",
    Estimate = ctn03_cows_unadjusted_lor_tests["arm7-day", "Estimate"],
    `Lower 95%` = ctn03_cows_unadjusted_lor_ci["arm7-day", 1],
    `Upper 95%` = ctn03_cows_unadjusted_lor_ci["arm7-day", 2]
  )
```

From this analysis, **assuming that the proportional odds model is
correct,** we’d estimate the difference in the log odds of having a
lower category of withdrawal symptoms on the COWS scale between a
population assigned to a 7-day taper and a population assigned to a
28-day taper is 0.001 (95% CI: -0.395, 0.397).

The covariate-adjusted analysis for the log odds ratio will work
slightly differently: rather than fitting a single model for both
treatment arms, a separate model is fit for each treatment arm. The
covariates are ‘marginalized’ or ’averaged out of each model to obtain
an estimated CDF of the outcome in each treatment arm. The log odds
ratio is then computed based on these estimated CDFs:

``` r
# 1. Create statistic function
unadjusted_lor <-
  function(data, indices = NULL, outcome, treatment) {

    stopifnot(is.factor(data[, outcome]))
    arms <- levels(data[indices, treatment])
    stopifnot(length(arms) == 2)
    
    if(is.null(indices)){
      indices <- 1:nrow(data)
    }
    
    control_indices <- indices[which(data[indices, treatment] == arms[1])]
    treatment_indices <- indices[which(data[indices, treatment] == arms[2])]
    
    # Create outcome formula: Intercept Only
    lor_formula <- as.formula(paste0(outcome, "~ 1"))
    
    # Fit Stratified Treatment Models
    polr_treatment <-
      MASS::polr(
        formula = lor_formula,
        data = data,
        subset = treatment_indices
      )
    
    polr_control <-
      MASS::polr(
        formula = lor_formula,
        data = data,
        subset = control_indices
      )
    
    # Extract intercepts: take difference between arms, average over levels
    mean(polr_treatment$zeta - polr_control$zeta)
  }

# 2. Call boot() using statistic function
ctn03_cows_lor_boot <-
  boot(
    data = ctn03_sim,
    statistic = unadjusted_lor,
    R = 10000,
    outcome = "cows_category_eot",
    treatment = "arm"
  )

# 3. Call boot.ci to get BCA confidence interval
ctn03_cows_lor_boot_ci <-
  boot.ci(
    boot.out = ctn03_cows_lor_boot,
    type = "bca"
  )

# Review Results
ctn03_cows_lor_boot
```

    ## 
    ## ORDINARY NONPARAMETRIC BOOTSTRAP
    ## 
    ## 
    ## Call:
    ## boot(data = ctn03_sim, statistic = unadjusted_lor, R = 10000, 
    ##     outcome = "cows_category_eot", treatment = "arm")
    ## 
    ## 
    ## Bootstrap Statistics :
    ##      original   bias    std. error
    ## t1* 0.1546278 7.377656    145.1384

``` r
ctn03_cows_lor_boot_ci
```

    ## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
    ## Based on 10000 bootstrap replicates
    ## 
    ## CALL : 
    ## boot.ci(boot.out = ctn03_cows_lor_boot, type = "bca")
    ## 
    ## Intervals : 
    ## Level       BCa          
    ## 95%   (-0.5899,  0.9960 )  
    ## Calculations and Intervals on Original Scale

``` r
# Compile results together
ctn03_cows_lor <-
  tibble(
    Model = "Unadjusted",
    Estimate = ctn03_cows_lor_boot$t0,
    `Lower 95%` = tail(ctn03_cows_lor_boot_ci$bca[1,], 2)[1],
    `Upper 95%` = tail(ctn03_cows_lor_boot_ci$bca[1,], 2)[2]
  )
```

### Weighted Difference in Means

The weighted difference in means can be computed using a linear
regression model with robust standard errors, after constructing the
weighted outcome variable:

``` r
ctn03_cows_ordinal_unadjusted_dim <-
  lm(
    formula = as.numeric(cows_category_eot) ~ arm,
    data = ctn03_sim
  )
```

Like before, inference can be obtained using the `lmtest` package.

``` r
# Hypothesis Tests based on Robust SEs
ctn03_cows_unadjusted_dim_tests <-
  lmtest::coeftest(
    x = ctn03_cows_ordinal_unadjusted_dim,
    vcov. = sandwich(ctn03_cows_ordinal_unadjusted_dim)
  )

# Confidence Intervals based on Robust SEs
ctn03_cows_unadjusted_dim_ci <-
  lmtest::coefci(
    x = ctn03_cows_ordinal_unadjusted_dim,
    vcov. = sandwich(ctn03_cows_ordinal_unadjusted_dim)
  )


# Review Results
ctn03_cows_unadjusted_dim_tests
```

    ## 
    ## t test of coefficients:
    ## 
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.2796935  0.0312636 40.9324   <2e-16 ***
    ## arm7-day    -0.0051837  0.0437287 -0.1185   0.9057    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
ctn03_cows_unadjusted_dim_ci
```

    ##                  2.5 %     97.5 %
    ## (Intercept)  1.2182733 1.34111366
    ## arm7-day    -0.0910926 0.08072524

``` r
ctn03_cows_dim_unadjusted <-
  tibble(
    Model = "Unadjusted",
    Estimate = ctn03_cows_unadjusted_dim_tests["arm7-day", "Estimate"],
    `Lower 95%` = ctn03_cows_unadjusted_dim_ci["arm7-day", 1],
    `Upper 95%` = ctn03_cows_unadjusted_dim_ci["arm7-day", 2]
  )
```

From this analysis, we’d estimate the unadjusted difference in mean COWS
categories between a population assigned to a 7-day taper and a
population assigned to a 28-day taper is -0.005 (95% CI: -0.091, 0.081).

------------------------------------------------------------------------

## Covariate Adjusted Analyses using `drord()`

The vignette for using `drord` can be found
[here](https://cran.r-project.org/web/packages/drord/vignettes/using_drord.html).
In short, the call to `drord` requires specifying:

-   `out`: a numeric vector containing the outcome of interest
-   `treat`: a binary treatment indicator: 1 = treatment, 0 = control
-   `covar`: a `data.frame` containing covariates

By default, `drord()` will calculate three estimands: the weighted
difference in means, log odds, and Mann-Whitney, and perform inference
using Wald confidence intervals. Wald confidence intervals are
computationally convenient, but bootstrap confidence intervals should be
preferred. This can be done by setting the `ci="bca"` for the bias
corrected and accelerated bootstrap. In order to make results
reproducible, the random number generator should first be seeded:

``` r
set.seed(seed = 52590)
```

### Model 1: Adjusting for Stratification Variable

Since CTN-0003 was carried out using randomization stratified by
`stability_dose`, one potential model of interest is the estimator only
adjusted for the stratification factor. **Note: this merely adjusts the
estimate itself for the stratification factor - estimated variances and
standard errors do not include any modification to account for
stratified randomization.**

#### Adjusted for Stratification Variable: `stability_dose`

``` r
# Default Inference: Wald Confidence Interval
ctn03_cows_ordinal_model_1_wald <-
  with(ctn03_sim,
       drord(
         out = as.numeric(cows_category_eot),
         treat = 1*(arm == "7-day"),
         covar = data.frame(rnorm(n = length(stability_dose))),
       )
  )

ctn03_cows_ordinal_model_1_wald
```

    ## $mann_whitney
    ##       est  wald_cil  wald_ciu 
    ## 0.4998574 0.4619624 0.5377523 
    ## 
    ## $log_odds
    ##              est  wald_cil  wald_ciu
    ## treat1 2.4985347  1.999861 2.9972081
    ## treat0 2.3418296  1.903299 2.7803598
    ## diff   0.1567052 -0.507497 0.8209073
    ## 
    ## $weighted_mean
    ##                 est   wald_cil   wald_ciu
    ## treat1  1.273127292  1.2132402 1.33301439
    ## treat0  1.278757619  1.2174615 1.34005376
    ## diff   -0.005630327 -0.0914284 0.08016775

``` r
# Bias Corrected and Accelerated (BCA) Bootstrap Confidence Interval
ctn03_cows_ordinal_model_1_bca <-
  with(ctn03_sim,
       drord(
         out = as.numeric(cows_category_eot),
         treat = 1*(arm == "7-day"),
         covar = data.frame(stability_dose),
         ci = "bca"
       )
  )

ctn03_cows_ordinal_model_1_bca
```

    ## $mann_whitney
    ##       est   bca_cil   bca_ciu 
    ## 0.4999486 0.4667585 0.5399042 
    ## 
    ## $log_odds
    ##              est    bca_cil   bca_ciu
    ## treat1 2.4935532  1.9629540 3.0337450
    ## treat0 2.3386408  1.9002289 2.8537867
    ## diff   0.1549124 -0.7989413 0.8871559
    ## 
    ## $weighted_mean
    ##                 est     bca_cil    bca_ciu
    ## treat1  1.274172294  1.21732088 1.33877313
    ## treat0  1.279583871  1.22086470 1.34676386
    ## diff   -0.005411577 -0.09363222 0.08118445

### Model 2: Adjusting for Baseline Covariates

Further adjustment could be carried out by including other baseline
covariates, such as baseline values of the COWS, urine drug screening
(UDS), Adjective Rating Scale for Withdrawal (ARSW) score, and
Visual-Analog Scale subscales:

#### Adjusted for Stratification Variable: `stability_dose`

``` r
# Default Inference: Wald Confidence Interval
ctn03_cows_ordinal_model_2_wald <-
  with(ctn03_sim,
       drord(
         out = as.numeric(cows_category_eot),
         treat = 1*(arm == "7-day"),
         covar =
           data.frame(
             stability_dose,
             arsw_score_bl, cows_total_score_bl, vas_crave_opiates_bl,
             vas_current_withdrawal_bl, vas_study_tx_help_bl,
             uds_opioids_bl, uds_oxycodone_bl, uds_any_positive_bl
           )
       )
  )

ctn03_cows_ordinal_model_2_wald
```

    ## $mann_whitney
    ##       est  wald_cil  wald_ciu 
    ## 0.5010822 0.4640640 0.5381005 
    ## 
    ## $log_odds
    ##              est   wald_cil  wald_ciu
    ## treat1 2.4575967  1.9786847 2.9365088
    ## treat0 2.3274362  1.8988247 2.7560478
    ## diff   0.1301605 -0.5078601 0.7681811
    ## 
    ## $weighted_mean
    ##                 est    wald_cil   wald_ciu
    ## treat1  1.279487427  1.22014230 1.33883256
    ## treat0  1.282049612  1.22170050 1.34239873
    ## diff   -0.002562185 -0.08628112 0.08115675

``` r
# Bias Corrected and Accelerated (BCA) Bootstrap Confidence Interval
ctn03_cows_ordinal_model_2_bca <-
  with(ctn03_sim,
       drord(
         out = as.numeric(cows_category_eot),
         treat = 1*(arm == "7-day"),
         covar =
           data.frame(
             stability_dose,
             arsw_score_bl, cows_total_score_bl, vas_crave_opiates_bl,
             vas_current_withdrawal_bl, vas_study_tx_help_bl,
             uds_opioids_bl, uds_oxycodone_bl, uds_any_positive_bl
             ),
         ci = "bca"
       )
  )

ctn03_cows_ordinal_model_2_bca
```

    ## $mann_whitney
    ##       est   bca_cil   bca_ciu 
    ## 0.5010822 0.4644616 0.5397531 
    ## 
    ## $log_odds
    ##              est    bca_cil   bca_ciu
    ## treat1 2.4575967  1.9953895 3.0009241
    ## treat0 2.3274362  1.9236855 2.7751403
    ## diff   0.1301605 -0.5606023 0.9052718
    ## 
    ## $weighted_mean
    ##                 est     bca_cil    bca_ciu
    ## treat1  1.279487427  1.22293901 1.33982958
    ## treat0  1.282049612  1.23002651 1.35082492
    ## diff   -0.002562185 -0.09085872 0.07880886

------------------------------------------------------------------------

## Comparing Adjusted to Unadjusted Results

### Mann-Whitney

``` r
dplyr::bind_rows(
  ctn03_cows_mw_pr,
  
  with(ctn03_cows_ordinal_model_1_bca$mann_whitney,
       tibble(
         Model = "Model 1: Stratum Only",
         Estimate = est,
         `Lower 95%` = ci$bca[1],
         `Upper 95%` = ci$bca[2]
       )
  ),
  
  with(ctn03_cows_ordinal_model_2_bca$mann_whitney,
       tibble(
         Model = "Model 2: All Covariates",
         Estimate = est,
         `Lower 95%` = ci$bca[1],
         `Upper 95%` = ci$bca[2]
       )
  )
) %>% 
  dplyr::mutate(
    `CI Width` = `Upper 95%` - `Lower 95%`
  )
```

    ## # A tibble: 3 × 5
    ##   Model                   Estimate `Lower 95%` `Upper 95%` `CI Width`
    ##   <chr>                      <dbl>       <dbl>       <dbl>      <dbl>
    ## 1 Unadjusted                 0.500       0.462       0.537     0.0753
    ## 2 Model 1: Stratum Only      0.500       0.467       0.540     0.0731
    ## 3 Model 2: All Covariates    0.501       0.464       0.540     0.0753

### Log Odds Ratio

``` r
dplyr::bind_rows(
  ctn03_cows_lor,
  
  with(ctn03_cows_ordinal_model_1_bca$log_odds,
       tibble(
         Model = "Model 1: Stratum Only",
         Estimate = est[3],
         `Lower 95%` = ci$bca[3, 1],
         `Upper 95%` = ci$bca[3, 2]
       )
  ),
  
  with(ctn03_cows_ordinal_model_2_bca$log_odds,
       tibble(
         Model = "Model 2: All Covariates",
         Estimate = est[3],
         `Lower 95%` = ci$bca[3, 1],
         `Upper 95%` = ci$bca[3, 2]
       )
  )
) %>% 
  dplyr::mutate(
    `CI Width` = `Upper 95%` - `Lower 95%`
  )
```

    ## # A tibble: 3 × 5
    ##   Model                   Estimate `Lower 95%` `Upper 95%` `CI Width`
    ##   <chr>                      <dbl>       <dbl>       <dbl>      <dbl>
    ## 1 Unadjusted                 0.155      -0.590       0.996       1.59
    ## 2 Model 1: Stratum Only      0.155      -0.799       0.887       1.69
    ## 3 Model 2: All Covariates    0.130      -0.561       0.905       1.47

### Diference in Means

``` r
dplyr::bind_rows(
  ctn03_cows_dim_unadjusted,
  
  with(ctn03_cows_ordinal_model_1_bca$weighted_mean,
       tibble(
         Model = "Model 1: Stratum Only",
         Estimate = est$est[3],
         `Lower 95%` = ci$bca[3, 1],
         `Upper 95%` = ci$bca[3, 2]
       )
  ),
  
  with(ctn03_cows_ordinal_model_2_bca$weighted_mean,
       tibble(
         Model = "Model 2: All Covariates",
         Estimate = est$est[3],
         `Lower 95%` = ci$bca[3, 1],
         `Upper 95%` = ci$bca[3, 2]
       )
  )
) %>% 
  dplyr::mutate(
    `CI Width` = `Upper 95%` - `Lower 95%`
  )
```

    ## # A tibble: 3 × 5
    ##   Model                   Estimate `Lower 95%` `Upper 95%` `CI Width`
    ##   <chr>                      <dbl>       <dbl>       <dbl>      <dbl>
    ## 1 Unadjusted              -0.00518     -0.0911      0.0807      0.172
    ## 2 Model 1: Stratum Only   -0.00541     -0.0936      0.0812      0.175
    ## 3 Model 2: All Covariates -0.00256     -0.0909      0.0788      0.170

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-Assmann2000" class="csl-entry">

Assmann, Susan F, Stuart J Pocock, Laura E Enos, and Linda E Kasten.
2000. “Subgroup Analysis and Other (Mis)uses of Baseline Data in
Clinical Trials.” *The Lancet* 355 (9209): 1064–69.
<https://doi.org/10.1016/s0140-6736(00)02039-0>.

</div>

<div id="ref-Kahan2011" class="csl-entry">

Kahan, Brennan C., and Tim P. Morris. 2011. “Improper Analysis of Trials
Randomised Using Stratified Blocks or Minimisation.” *Statistics in
Medicine* 31 (4): 328–40. <https://doi.org/10.1002/sim.4431>.

</div>

<div id="ref-Kernan1999" class="csl-entry">

Kernan, W. 1999. “Stratified Randomization for Clinical Trials.”
*Journal of Clinical Epidemiology* 52 (1): 19–26.
<https://doi.org/10.1016/s0895-4356(98)00138-3>.

</div>

</div>
