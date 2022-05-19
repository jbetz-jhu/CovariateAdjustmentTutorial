# Case Study: Suboxone Taper CTN0003 with Fixed Sample Size

[Josh Betz](mailto:jbetz@jhu.edu), [Kelly Van Lancker](kvanlan3@jhu.edu), and [Michael Rosenblum](mrosen@jhu.edu)




-   [Executive Summary](#executive-summary)
-   [Covariate Adjusted Analysis in
    Practice](#covariate-adjusted-analysis-in-practice)
    -   [Installing R Packages](#installing-r-packages)
-   [CTN03 Study Design](#ctn03-study-design)
    -   [Creating Simulated Data:](#creating-simulated-data)
-   [Simulated CTN03 Data](#simulated-ctn03-data)
    -   [Reference level for Treatment](#reference-level-for-treatment)
    -   [Baseline Demographics &
        Stratum](#baseline-demographics--stratum)
    -   [End-of-Taper Outcomes](#end-of-taper-outcomes)
    -   [End-of-Taper Outcomes](#end-of-taper-outcomes-1)
-   [Continuous Outcome: ARSW Score](#continuous-outcome-arsw-score)
    -   [Unadjusted: Unequal Variance Two-sample
        t-test](#unadjusted-unequal-variance-two-sample-t-test)
    -   [Adjusted: Analysis of Covariance
        (ANCOVA)](#adjusted-analysis-of-covariance-ancova)
    -   [Adjusted for Baseline Variables & Stratified
        Design](#adjusted-for-baseline-variables--stratified-design)
-   [Binary Outcomes: Opioids by Urine Drug Screening
    (UDS)](#binary-outcomes-opioids-by-urine-drug-screening-uds)
    -   [Two Sample Test of
        Proportions](#two-sample-test-of-proportions)
    -   [Adjusted for Covariates:
        G-Computation](#adjusted-for-covariates-g-computation)
    -   [Adjusted for Baseline Variables & Stratified
        Design](#adjusted-for-baseline-variables--stratified-design-1)

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
stratified randomization to lessen the potential imbalance, and in
during the analysis phase, through covariate adjustment.

Both stratified randomization and covariate adjustment can lead to a
more efficient trial, even if covariates are balanced across treatment
groups: such approaches can lower the required sample size to detect a
given treatment effect if it exists, or provide greater precision
(shorter confidence interval widths and higher power) for the same
sample size and treatment effect. When stratified randomization is used,
covariate adjustment is generally suggested, but not always implemented,
which can lead to reduced power and precision (Kahan and Morris 2011).
The potential benefit of stratified randomization increases as the
correlation between the stratification variable and the outcome
increases, and the variability within the strata decreases relative to
the variability between strata. Accessible and practical discussions of
baseline balance, stratified randomized trials, and adjusted analyses
are also available to offer further explanation and guidance to
investigators Assmann et al. (2000).

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

#### Continuous Outcomes

The estimand or quantity of interest in a randomized trial with a
continuous or binary outcome is usually the average treatment effect
(ATE): this is the difference in the mean outcome if everyone in the
population received the treatment under investigation versus the mean
outcome if everyone in the population received the control/comparator
intervention. Let $$Y$$ denote the outcome of interest and $$A$$ denote the
indicator of treatment ($$A_{i} = 1$$ among the intervention
group and $$A_{i} = 0$$ among the control/comparator group)

$$ATE = E[Y \vert A=1\] − E[Y \vert A=0]$$

For continuous outcomes, adjustment for covariates can be done using the
analysis of covariance (ANCOVA). This is a regression of the outcome on
the treatment variable and baseline covariates. Even though the ANCOVA
models the conditional distribution of the outcome given the treatment
assignment and covariates, the identity link in the linear model means
the marginal and conditional associations are identical, and the
coefficient for the treatment indicator is the average treatment effect.
When the data are completely observed or the rates of missingness are
unrelated to the covariates, treatment, or outcomes (i.e. the missing
completely at random or MAR assumption), the ANCOVA estimator is valid
even under arbitrary model misspecification.

The ANCOVA does reduce bias and improve precision by adjusting for
baseline covariates, but its variance estimate does not automatically
account for stratified randomization. Additionally, missing data can
potentially introduce bias if out model is not correctly specified and
the MCAR assumption does not hold. These can be remedied by using a
doubly robust weighted least squares (DR-WLS) estimator, which
incorporates propensity score models that address imbalance and missing
data. This estimator is called doubly robust because if either the
outcome or propensity models are correctly specified, this estimator
will be a consistent estimator of the average treatment effect. Both the
ANCOVA and DR-WLS estimators can be modified to take advantage of
stratified randomization, potentially yielding additional efficiency
gains.

Other doubly robust estimators include the augmented inverse probablity
weighted (AIPW) estimator and the targeted maximum likelihood estimator
(TMLE), which can incorporate information from intermediate outcomes in
order to reduce bias and increase precision when estimating the effect
of the treatment on the final outcome.

#### Binary Outcomes

Unlike the ANCOVA, regression models for binary outcomes typically uses
a nonlinear link function, such as the logistic, probit, or cumulative
log-logistic links. In these models, the marginal and conditional
associations do not necessarily coincide, and the coefficient for the
treatment indicator does not correspond to the average treatment effect.
In these cases, we can obtain a marginal treatment effect by averaging
over the covariates. This average marginal effect (AME) is computed by
using a regression model to predict the outcome for each individual
under treatment and control, and then comparing the average prediction
under treatment to the average prediction under control. This approach
to inference is also known as G-computation. When any outcome data are
missing, the DR-WLS, AIPW, or TMLE can be employed to obtain doubly
robust inference for binary outcomes.

#### Ordinal Outcomes

If the outcome of interest is ordinal variable with $$K$$ categories,
there are other estimands that may be of interest. When categories can
be assigned a numeric score or utility, one estimand of interest is the
average treatment effect on the score or utility.

When the mean outcome is not defined, not meaningful, or simply not of
interest, other estimands are available. The Mann-Whitney estimand,
which estimates the probability that a randomly-selected individual from
a population of treated individuals will have a better outcome than a
randomly-selected individual from the population of indiviuals receiving
the control or comparator intervention.

The Log Odds Ratio compares the odds of having an outcome of category
$$k$$ or higher in a population of treated individuals relative to a
population receiving the control. The log of these odds ratios is then
averaged across each of the $$(K − 1)$$ possible cutoffs of the outcome.
This estimand is similar to the proportional odds logistic regression
model, but its validity does not require the assumption that the model
is correctly specified.

Covariate-adjusted estimators are also available for these estimands
which are also doubly robust.

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
-   [margins](https://cran.r-project.org/web/packages/margins/) -
    Computing Average Marginal Effects (AMEs)
-   [drord](https://cran.r-project.org/web/packages/drord/drord.pdf) -
    Doubly-Robust Estimators for Ordinal Outcomes
-   [sandwich](https://cran.r-project.org/web/packages/sandwich/index.html) -
    Robust Estimation of Variance

``` r
required_packages <-
  c("tidyverse",
    "table1",
    "margins",
    "drord",
    "sandwich")

install.packages(required_packages)
```

Once the required packages are installed, they can be loaded using
`library()`

``` r
library(purrr)
library(table1)
library(margins)
library(drord)
library(sandwich)
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

The results of CTN03 can be found [here](https://pubmed.ncbi.nlm.nih.gov/19149822).

### Creating Simulated Data:

The data in this template are simulated data, generated from probability
models fit to the original study data, and *not the actual data from the
CTN03 trial.* A new dataset was created by resampling with replacement
from the original data, and then each variable in the new dataset was
iteratively replaced using simulated values from probability models
based on the original data.

------------------------------------------------------------------------

## Simulated CTN03 Data

The data can be loaded directly from Github. More information is
available
[here](https://jbetz-jhu.github.io/CovariateAdjustmentTutorial/List_of_Datasets.html).

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

### Reference level for Treatment

When the treatment is a `factor` variable, we can use the `levels()`
function to see the reference level (i.e. the comparator/control group):
it will appear as the first level.

``` r
# Check reference level
levels(ctn03_sim$arm)
```

    ## [1] "28-day" "7-day"

Make sure that the reference level is appropriately chosen before
running analyses.

### Baseline Demographics & Stratum

Below are summary statistics of participant characteristics at baseline:

``` r
table1(
  ~ age + sex + race + ethnic + marital + stability_dose | arm, 
  data = ctn03_sim
)
```

<div class="Rtable1"><table class="Rtable1">
<thead>
<tr>
<th class='rowlabel firstrow lastrow'></th>
<th class='firstrow lastrow'><span class='stratlabel'>28-day<br><span class='stratn'>(N=261)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>7-day<br><span class='stratn'>(N=255)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>Overall<br><span class='stratn'>(N=516)</span></span></th>
</tr>
</thead>
<tbody>
<tr>
<td class='rowlabel firstrow'>age</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>35.9 (11.4)</td>
<td>36.3 (11.1)</td>
<td>36.1 (11.2)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>34.0 [18.0, 65.0]</td>
<td class='lastrow'>37.0 [19.0, 62.0]</td>
<td class='lastrow'>35.0 [18.0, 65.0]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>sex</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Male</td>
<td>173 (66.3%)</td>
<td>201 (78.8%)</td>
<td>374 (72.5%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Female</td>
<td class='lastrow'>88 (33.7%)</td>
<td class='lastrow'>54 (21.2%)</td>
<td class='lastrow'>142 (27.5%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>race</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>White</td>
<td>185 (70.9%)</td>
<td>199 (78.0%)</td>
<td>384 (74.4%)</td>
</tr>
<tr>
<td class='rowlabel'>Black/African American</td>
<td>30 (11.5%)</td>
<td>25 (9.8%)</td>
<td>55 (10.7%)</td>
</tr>
<tr>
<td class='rowlabel'>Spanish, Hispanic, or Latino</td>
<td>12 (4.6%)</td>
<td>15 (5.9%)</td>
<td>27 (5.2%)</td>
</tr>
<tr>
<td class='rowlabel'>Other</td>
<td>3 (1.1%)</td>
<td>4 (1.6%)</td>
<td>7 (1.4%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Multiple</td>
<td class='lastrow'>31 (11.9%)</td>
<td class='lastrow'>12 (4.7%)</td>
<td class='lastrow'>43 (8.3%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>ethnic</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Not Hispanic</td>
<td>240 (92.0%)</td>
<td>236 (92.5%)</td>
<td>476 (92.2%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Hispanic</td>
<td class='lastrow'>21 (8.0%)</td>
<td class='lastrow'>19 (7.5%)</td>
<td class='lastrow'>40 (7.8%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>marital</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Married/Cohabitating</td>
<td>60 (23.0%)</td>
<td>80 (31.4%)</td>
<td>140 (27.1%)</td>
</tr>
<tr>
<td class='rowlabel'>Never married</td>
<td>129 (49.4%)</td>
<td>111 (43.5%)</td>
<td>240 (46.5%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Divorced/Separated/Widowed</td>
<td class='lastrow'>72 (27.6%)</td>
<td class='lastrow'>64 (25.1%)</td>
<td class='lastrow'>136 (26.4%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>stability_dose</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>8 mg</td>
<td>21 (8.0%)</td>
<td>17 (6.7%)</td>
<td>38 (7.4%)</td>
</tr>
<tr>
<td class='rowlabel'>16 mg</td>
<td>86 (33.0%)</td>
<td>69 (27.1%)</td>
<td>155 (30.0%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>24 mg</td>
<td class='lastrow'>154 (59.0%)</td>
<td class='lastrow'>169 (66.3%)</td>
<td class='lastrow'>323 (62.6%)</td>
</tr>
</tbody>
</table>
</div>

### End-of-Taper Outcomes

Below are summary statistics of the baseline outcomes: if there are
clinically significant imbalances between treatment arms, an adjusted
estimator can reduce the bias that this may introduce.

``` r
table1(
  ~ arsw_score_bl + cows_total_score_bl + vas_crave_opiates_bl +
    vas_current_withdrawal_bl + vas_study_tx_help_bl +
    uds_opioids_bl + uds_oxycodone_bl + uds_any_positive_bl | arm,
  data = ctn03_sim
)
```

<div class="Rtable1"><table class="Rtable1">
<thead>
<tr>
<th class='rowlabel firstrow lastrow'></th>
<th class='firstrow lastrow'><span class='stratlabel'>28-day<br><span class='stratn'>(N=261)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>7-day<br><span class='stratn'>(N=255)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>Overall<br><span class='stratn'>(N=516)</span></span></th>
</tr>
</thead>
<tbody>
<tr>
<td class='rowlabel firstrow'>arsw_score_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>10.9 (12.7)</td>
<td>11.4 (15.0)</td>
<td>11.1 (13.9)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>8.00 [0, 99.0]</td>
<td class='lastrow'>9.00 [0, 171]</td>
<td class='lastrow'>8.50 [0, 171]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>cows_total_score_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>0.966 (1.47)</td>
<td>0.902 (1.30)</td>
<td>0.934 (1.39)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>0 [0, 8.00]</td>
<td class='lastrow'>0 [0, 9.00]</td>
<td class='lastrow'>0 [0, 9.00]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_crave_opiates_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>12.9 (17.1)</td>
<td>15.0 (19.4)</td>
<td>13.9 (18.3)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>6.00 [0, 91.0]</td>
<td class='lastrow'>7.00 [0, 97.0]</td>
<td class='lastrow'>7.00 [0, 97.0]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_current_withdrawal_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>7.64 (11.9)</td>
<td>8.34 (13.9)</td>
<td>7.98 (12.9)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>3.00 [0, 87.0]</td>
<td class='lastrow'>3.00 [0, 87.0]</td>
<td class='lastrow'>3.00 [0, 87.0]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_study_tx_help_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>81.5 (19.3)</td>
<td>81.8 (21.1)</td>
<td>81.6 (20.2)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>88.0 [10.0, 100]</td>
<td class='lastrow'>90.0 [6.00, 100]</td>
<td class='lastrow'>89.0 [6.00, 100]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_opioids_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>170 (65.1%)</td>
<td>188 (73.7%)</td>
<td>358 (69.4%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>91 (34.9%)</td>
<td class='lastrow'>67 (26.3%)</td>
<td class='lastrow'>158 (30.6%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_oxycodone_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>204 (78.2%)</td>
<td>208 (81.6%)</td>
<td>412 (79.8%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>57 (21.8%)</td>
<td class='lastrow'>47 (18.4%)</td>
<td class='lastrow'>104 (20.2%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_any_positive_bl</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>80 (30.7%)</td>
<td>109 (42.7%)</td>
<td>189 (36.6%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>181 (69.3%)</td>
<td class='lastrow'>146 (57.3%)</td>
<td class='lastrow'>327 (63.4%)</td>
</tr>
</tbody>
</table>
</div>

### End-of-Taper Outcomes

Here we summarize the outcomes of the study if there were no missing
data:

``` r
table1(
  ~ arsw_score_eot + cows_total_score_eot + vas_crave_opiates_eot +
    vas_current_withdrawal_eot + vas_study_tx_help_eot +
    uds_opioids_eot + uds_oxycodone_eot + uds_any_positive_eot | arm,
  data = ctn03_sim
)
```

<div class="Rtable1"><table class="Rtable1">
<thead>
<tr>
<th class='rowlabel firstrow lastrow'></th>
<th class='firstrow lastrow'><span class='stratlabel'>28-day<br><span class='stratn'>(N=261)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>7-day<br><span class='stratn'>(N=255)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>Overall<br><span class='stratn'>(N=516)</span></span></th>
</tr>
</thead>
<tbody>
<tr>
<td class='rowlabel firstrow'>arsw_score_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>18.9 (29.1)</td>
<td>20.6 (32.4)</td>
<td>19.7 (30.8)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>7.00 [0, 144]</td>
<td class='lastrow'>7.00 [0, 144]</td>
<td class='lastrow'>7.00 [0, 144]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>cows_total_score_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>2.65 (3.39)</td>
<td>2.55 (3.06)</td>
<td>2.60 (3.23)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>1.00 [0, 23.0]</td>
<td class='lastrow'>2.00 [0, 18.0]</td>
<td class='lastrow'>2.00 [0, 23.0]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_crave_opiates_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>29.2 (28.7)</td>
<td>27.1 (26.5)</td>
<td>28.2 (27.6)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>20.0 [0, 100]</td>
<td class='lastrow'>20.0 [0, 99.0]</td>
<td class='lastrow'>20.0 [0, 100]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_current_withdrawal_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>21.5 (24.5)</td>
<td>17.9 (21.2)</td>
<td>19.7 (22.9)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>10.0 [0, 98.0]</td>
<td class='lastrow'>10.0 [0, 100]</td>
<td class='lastrow'>10.0 [0, 100]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_study_tx_help_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>76.8 (33.6)</td>
<td>77.7 (32.8)</td>
<td>77.3 (33.2)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>94.0 [0, 100]</td>
<td class='lastrow'>92.0 [0, 100]</td>
<td class='lastrow'>93.0 [0, 100]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_opioids_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>147 (56.3%)</td>
<td>167 (65.5%)</td>
<td>314 (60.9%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>114 (43.7%)</td>
<td class='lastrow'>88 (34.5%)</td>
<td class='lastrow'>202 (39.1%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_oxycodone_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>179 (68.6%)</td>
<td>198 (77.6%)</td>
<td>377 (73.1%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>82 (31.4%)</td>
<td class='lastrow'>57 (22.4%)</td>
<td class='lastrow'>139 (26.9%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_any_positive_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>91 (34.9%)</td>
<td>84 (32.9%)</td>
<td>175 (33.9%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>170 (65.1%)</td>
<td class='lastrow'>171 (67.1%)</td>
<td class='lastrow'>341 (66.1%)</td>
</tr>
</tbody>
</table>
</div>

Note that when data are missing, summary statistics may be potentially
misleading:

``` r
table1(
  ~ arsw_score_eot + cows_total_score_eot + vas_crave_opiates_eot +
    vas_current_withdrawal_eot + vas_study_tx_help_eot +
    uds_opioids_eot + uds_oxycodone_eot + uds_any_positive_eot | arm,
  data = ctn03_sim_mar %>% 
    dplyr::filter(
      !is.na(arsw_score_eot)
    )
)
```

<div class="Rtable1"><table class="Rtable1">
<thead>
<tr>
<th class='rowlabel firstrow lastrow'></th>
<th class='firstrow lastrow'><span class='stratlabel'>28-day<br><span class='stratn'>(N=151)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>7-day<br><span class='stratn'>(N=202)</span></span></th>
<th class='firstrow lastrow'><span class='stratlabel'>Overall<br><span class='stratn'>(N=353)</span></span></th>
</tr>
</thead>
<tbody>
<tr>
<td class='rowlabel firstrow'>arsw_score_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>19.4 (27.7)</td>
<td>20.7 (33.1)</td>
<td>20.1 (30.9)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>7.00 [0, 144]</td>
<td class='lastrow'>6.50 [0, 144]</td>
<td class='lastrow'>7.00 [0, 144]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>cows_total_score_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>2.43 (2.98)</td>
<td>2.54 (3.10)</td>
<td>2.49 (3.05)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>2.00 [0, 17.0]</td>
<td class='lastrow'>1.50 [0, 18.0]</td>
<td class='lastrow'>2.00 [0, 18.0]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_crave_opiates_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>28.0 (27.3)</td>
<td>27.7 (26.3)</td>
<td>27.9 (26.7)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>20.0 [0, 100]</td>
<td class='lastrow'>21.0 [0, 99.0]</td>
<td class='lastrow'>21.0 [0, 100]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_current_withdrawal_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>21.7 (25.6)</td>
<td>19.3 (22.0)</td>
<td>20.3 (23.6)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>9.00 [0, 98.0]</td>
<td class='lastrow'>12.0 [0, 97.0]</td>
<td class='lastrow'>10.0 [0, 98.0]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>vas_study_tx_help_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Mean (SD)</td>
<td>77.0 (34.2)</td>
<td>78.7 (32.0)</td>
<td>78.0 (32.9)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Median [Min, Max]</td>
<td class='lastrow'>95.0 [0, 100]</td>
<td class='lastrow'>94.0 [0, 100]</td>
<td class='lastrow'>95.0 [0, 100]</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_opioids_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>88 (58.3%)</td>
<td>132 (65.3%)</td>
<td>220 (62.3%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>63 (41.7%)</td>
<td class='lastrow'>70 (34.7%)</td>
<td class='lastrow'>133 (37.7%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_oxycodone_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>111 (73.5%)</td>
<td>154 (76.2%)</td>
<td>265 (75.1%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>40 (26.5%)</td>
<td class='lastrow'>48 (23.8%)</td>
<td class='lastrow'>88 (24.9%)</td>
</tr>
<tr>
<td class='rowlabel firstrow'>uds_any_positive_eot</td>
<td class='firstrow'></td>
<td class='firstrow'></td>
<td class='firstrow'></td>
</tr>
<tr>
<td class='rowlabel'>Negative</td>
<td>56 (37.1%)</td>
<td>64 (31.7%)</td>
<td>120 (34.0%)</td>
</tr>
<tr>
<td class='rowlabel lastrow'>Positive</td>
<td class='lastrow'>95 (62.9%)</td>
<td class='lastrow'>138 (68.3%)</td>
<td class='lastrow'>233 (66.0%)</td>
</tr>
</tbody>
</table>
</div>

------------------------------------------------------------------------

## Continuous Outcome: ARSW Score

### Unadjusted: Unequal Variance Two-sample t-test

The validity of inference assumes that data are missing completely at
random (MCAR): Missingness is unrelated to the observed data (baseline
covariates, treatment, nonmissing outcomes) and the missing data (the
missing outcomes). The MCAR assumption can and should be assessed
empirically by assessing relationships between the observed data and
missingness of outcomes. The t-test will also be more conservative when
stratified randomization is used.

``` r
arsw_t_test <-
  t.test(
    formula = arsw_score_eot ~ arm,
    data = ctn03_sim,
    conf.level = 0.95
  )

# Print a summary of the `htest` object
print(arsw_t_test)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  arsw_score_eot by arm
    ## t = -0.59912, df = 505.18, p-value = 0.5494
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -6.958148  3.706131
    ## sample estimates:
    ## mean in group 28-day  mean in group 7-day 
    ##             18.93870             20.56471

``` r
diff(arsw_t_test$estimate) # Estimate
```

    ## mean in group 7-day 
    ##            1.626009

``` r
arsw_t_test$stderr^2 # Variance = (Standard Error)^2
```

    ## [1] 7.365858

``` r
arsw_t_test$conf.int # Confidence Interval
```

    ## [1] -6.958148  3.706131
    ## attr(,"conf.level")
    ## [1] 0.95

Note that missing data results in increased variance, as well as the
potential for bias:

``` r
arsw_t_test_missing <-
  t.test(
    formula = arsw_score_eot ~ arm,
    data = ctn03_sim_mar,
    conf.level = 0.95
  )

# Print a summary of the `htest` object
print(arsw_t_test_missing)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  arsw_score_eot by arm
    ## t = -0.39991, df = 346.47, p-value = 0.6895
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -7.678610  5.083698
    ## sample estimates:
    ## mean in group 28-day  mean in group 7-day 
    ##             19.37086             20.66832

``` r
diff(arsw_t_test_missing$estimate) # Estimate
```

    ## mean in group 7-day 
    ##            1.297456

``` r
arsw_t_test_missing$stderr^2 # Variance = (Standard Error)^2
```

    ## [1] 10.52599

``` r
arsw_t_test_missing$conf.int # Confidence Interval
```

    ## [1] -7.678610  5.083698
    ## attr(,"conf.level")
    ## [1] 0.95

### Adjusted: Analysis of Covariance (ANCOVA)

#### Model 1 - Adjusted for Baseline ARSW & Strata

The ANCOVA involves regressing the outcome on baseline covariates and
treatment assignment. When stratified randomization is used, the
stratification variable (here `stability_dose`) should be included in
the model. Ideally, the estimate of the variance should also incorporate
information from the randomization in order to be as efficient as
possible - the ANCOVA does not make full use of this information.

``` r
arsw_ancova_1 <-
  lm(
    formula = 
      arsw_score_eot ~ arm + arsw_score_bl + stability_dose,
    data = ctn03_sim
  )

summary(arsw_ancova_1) # Print a summary of the `lm` object
```

    ## 
    ## Call:
    ## lm(formula = arsw_score_eot ~ arm + arsw_score_bl + stability_dose, 
    ##     data = ctn03_sim)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -53.922 -16.469 -11.933   1.878 127.365 
    ## 
    ## Coefficients:
    ##                     Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         13.22445    5.31996   2.486  0.01324 *  
    ## arm7-day             1.41030    2.69123   0.524  0.60048    
    ## arsw_score_bl        0.35841    0.09718   3.688  0.00025 ***
    ## stability_dose16 mg  1.91771    5.54293   0.346  0.72951    
    ## stability_dose24 mg  2.00169    5.25732   0.381  0.70355    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 30.47 on 511 degrees of freedom
    ## Multiple R-squared:  0.02661,    Adjusted R-squared:  0.01899 
    ## F-statistic: 3.492 on 4 and 511 DF,  p-value: 0.00793

``` r
coef(arsw_ancova_1)["arm7-day"] # Estimate
```

    ## arm7-day 
    ## 1.410297

``` r
diag(vcov(arsw_ancova_1))["arm7-day"] # Variance of Estimate
```

    ## arm7-day 
    ## 7.242741

``` r
# Confidence Interval
confint(
  object = arsw_ancova_1,
  level = 0.95
)["arm7-day",]
```

    ##     2.5 %    97.5 % 
    ## -3.876947  6.697542

When we have missing data, the ANCOVA can be more precise than the
unadjusted estimator. However, without accounting for missing data, this
estimate is only valid under the assumption that the outcome model is
correctly specified or assuming that the data are missing completely at
random, both of which are very strong assumptions.

``` r
arsw_ancova_1_missing <-
  lm(
    formula = 
      arsw_score_eot ~ arm + arsw_score_bl,
    data = ctn03_sim_mar
  )

summary(arsw_ancova_1_missing) # Print a summary of the `lm` object
```

    ## 
    ## Call:
    ## lm(formula = arsw_score_eot ~ arm + arsw_score_bl, data = ctn03_sim_mar)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -59.709 -16.711 -12.184   4.751 125.816 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    15.5796     2.7176   5.733 2.13e-08 ***
    ## arm7-day        0.6043     3.2850   0.184 0.854154    
    ## arsw_score_bl   0.3832     0.1123   3.414 0.000716 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 30.48 on 350 degrees of freedom
    ##   (163 observations deleted due to missingness)
    ## Multiple R-squared:  0.03264,    Adjusted R-squared:  0.02711 
    ## F-statistic: 5.904 on 2 and 350 DF,  p-value: 0.003006

``` r
coef(arsw_ancova_1_missing)["arm7-day"] # Estimate
```

    ##  arm7-day 
    ## 0.6043013

``` r
diag(vcov(arsw_ancova_1_missing))["arm7-day"] # Variance of Estimate
```

    ## arm7-day 
    ## 10.79138

``` r
# Confidence Interval
confint(
  object = arsw_ancova_1_missing,
  level = 0.95
)["arm7-day",]
```

    ##     2.5 %    97.5 % 
    ## -5.856567  7.065170

#### Model 2 - Adjusted for Baseline Variables

Here, we can include more baseline variables to potentially gain more
precision. Again, since the ANCOVA does not make use of stratified
randomization in the variance estimate, inference will be conservative.

``` r
arsw_ancova_2 <-
  lm(
    formula = 
      arsw_score_eot ~ arm + arsw_score_bl +
      stability_dose + age + sex + marital +
      cows_total_score_bl + vas_crave_opiates_bl +
      vas_current_withdrawal_bl + vas_study_tx_help_bl +
      uds_opioids_bl + uds_oxycodone_bl + uds_any_positive_bl,
    data = ctn03_sim
  )

summary(arsw_ancova_2) # Print a summary of the `lm` object
```

    ## 
    ## Call:
    ## lm(formula = arsw_score_eot ~ arm + arsw_score_bl + stability_dose + 
    ##     age + sex + marital + cows_total_score_bl + vas_crave_opiates_bl + 
    ##     vas_current_withdrawal_bl + vas_study_tx_help_bl + uds_opioids_bl + 
    ##     uds_oxycodone_bl + uds_any_positive_bl, data = ctn03_sim)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -49.931 -15.883  -8.943   3.321 134.249 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                       21.089609  11.074727   1.904 0.057445 .  
    ## arm7-day                           0.220245   2.711453   0.081 0.935293    
    ## arsw_score_bl                     -0.158377   0.155313  -1.020 0.308351    
    ## stability_dose16 mg                1.645439   5.478747   0.300 0.764049    
    ## stability_dose24 mg                3.528432   5.273791   0.669 0.503772    
    ## age                               -0.103443   0.147243  -0.703 0.482674    
    ## sexFemale                          1.749434   3.052881   0.573 0.566873    
    ## maritalNever married              -6.661046   3.471809  -1.919 0.055603 .  
    ## maritalDivorced/Separated/Widowed -7.128804   3.828493  -1.862 0.063184 .  
    ## cows_total_score_bl                2.635313   1.037318   2.541 0.011371 *  
    ## vas_crave_opiates_bl               0.159918   0.095198   1.680 0.093614 .  
    ## vas_current_withdrawal_bl          0.498158   0.148224   3.361 0.000836 ***
    ## vas_study_tx_help_bl              -0.007385   0.070471  -0.105 0.916583    
    ## uds_opioids_blPositive            -2.325451   3.745441  -0.621 0.534965    
    ## uds_oxycodone_blPositive           0.325448   3.990218   0.082 0.935028    
    ## uds_any_positive_blPositive       -2.497936   3.278821  -0.762 0.446515    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 29.82 on 500 degrees of freedom
    ## Multiple R-squared:  0.08788,    Adjusted R-squared:  0.06052 
    ## F-statistic: 3.212 on 15 and 500 DF,  p-value: 4.29e-05

``` r
coef(arsw_ancova_2)["arm7-day"] # Estimate
```

    ## arm7-day 
    ## 0.220245

``` r
diag(vcov(arsw_ancova_2))["arm7-day"] # Variance of Estimate
```

    ## arm7-day 
    ## 7.351975

``` r
# Confidence Interval
confint(
  object = arsw_ancova_2,
  level = 0.95
)["arm7-day",]
```

    ##    2.5 %   97.5 % 
    ## -5.10700  5.54749

Again, without accounting for missing data, the ANCOVA estimate is only
valid under the assumption that the outcome model is correctly specified
or the data are missing completely at random.

``` r
arsw_ancova_2_missing <-
  lm(
    formula = 
      arsw_score_eot ~ arm + arsw_score_bl +
      stability_dose + age + sex + marital +
      cows_total_score_bl + vas_crave_opiates_bl +
      vas_current_withdrawal_bl + vas_study_tx_help_bl +
      uds_opioids_bl + uds_oxycodone_bl + uds_any_positive_bl,
    data = ctn03_sim
  )

summary(arsw_ancova_2_missing) # Print a summary of the `lm` object
```

    ## 
    ## Call:
    ## lm(formula = arsw_score_eot ~ arm + arsw_score_bl + stability_dose + 
    ##     age + sex + marital + cows_total_score_bl + vas_crave_opiates_bl + 
    ##     vas_current_withdrawal_bl + vas_study_tx_help_bl + uds_opioids_bl + 
    ##     uds_oxycodone_bl + uds_any_positive_bl, data = ctn03_sim)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -49.931 -15.883  -8.943   3.321 134.249 
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                       21.089609  11.074727   1.904 0.057445 .  
    ## arm7-day                           0.220245   2.711453   0.081 0.935293    
    ## arsw_score_bl                     -0.158377   0.155313  -1.020 0.308351    
    ## stability_dose16 mg                1.645439   5.478747   0.300 0.764049    
    ## stability_dose24 mg                3.528432   5.273791   0.669 0.503772    
    ## age                               -0.103443   0.147243  -0.703 0.482674    
    ## sexFemale                          1.749434   3.052881   0.573 0.566873    
    ## maritalNever married              -6.661046   3.471809  -1.919 0.055603 .  
    ## maritalDivorced/Separated/Widowed -7.128804   3.828493  -1.862 0.063184 .  
    ## cows_total_score_bl                2.635313   1.037318   2.541 0.011371 *  
    ## vas_crave_opiates_bl               0.159918   0.095198   1.680 0.093614 .  
    ## vas_current_withdrawal_bl          0.498158   0.148224   3.361 0.000836 ***
    ## vas_study_tx_help_bl              -0.007385   0.070471  -0.105 0.916583    
    ## uds_opioids_blPositive            -2.325451   3.745441  -0.621 0.534965    
    ## uds_oxycodone_blPositive           0.325448   3.990218   0.082 0.935028    
    ## uds_any_positive_blPositive       -2.497936   3.278821  -0.762 0.446515    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 29.82 on 500 degrees of freedom
    ## Multiple R-squared:  0.08788,    Adjusted R-squared:  0.06052 
    ## F-statistic: 3.212 on 15 and 500 DF,  p-value: 4.29e-05

``` r
coef(arsw_ancova_2_missing)["arm7-day"] # Estimate
```

    ## arm7-day 
    ## 0.220245

``` r
diag(vcov(arsw_ancova_2_missing))["arm7-day"] # Variance of Estimate
```

    ## arm7-day 
    ## 7.351975

``` r
# Confidence Interval
confint(
  object = arsw_ancova_2_missing,
  level = 0.95
)["arm7-day",]
```

    ##    2.5 %   97.5 % 
    ## -5.10700  5.54749

### Adjusted for Baseline Variables & Stratified Design

The Inference under Covariate Adaptive Design (ICAD) framework can be
used to make full use of the stratified randomization. `ICAD` not only
allows adjustment for baseline covariates, but also can gain efficiency
from designs with stratified randomization. When the strata are
correlated with the response, and when the variation between strata is
large relative to the variation within strata, variance estimates which
incorporate the strata will be more efficient than those that ignore the
stratified randomization.

``` r
icad_continuous_binary_link <-
  "https://raw.githubusercontent.com/BingkaiWang/covariate-adaptive/master/R/ICAD.R"
source(url(icad_continuous_binary_link))

baseline_covariates <-
  c("age", "sex", "marital",
    "arsw_score_bl", "cows_total_score_bl",
    "vas_crave_opiates_bl", "vas_current_withdrawal_bl", "vas_study_tx_help_bl",
    "uds_opioids_bl", "uds_oxycodone_bl", "uds_any_positive_bl")

arsw_icad <-
  ICAD(
    # Outcome: 1 if Negative, 0 if Positive or Missing
    Y = ctn03_sim$arsw_score_eot, 
    A = 1*(ctn03_sim$arm == "7-day"), # Treatment indicator - Must be 1/0
    Strata = ctn03_sim$stability_dose, # Abstinence x Substance Strata
    W = ctn03_sim[, baseline_covariates],
    pi = 0.5 # 1:1 Randomization
  )

arsw_icad
```

    ##                          est      var  CI.lower CI.upper
    ## unadjusted          1.626009 7.331891 -3.681077 6.933094
    ## adjusted-for-strata 1.618690 7.331891 -3.688396 6.925776
    ## adjusted-for-all    0.220245 6.692248 -4.850060 5.290550

In this particular dataset, the stratification variable does not appear
to be strongly related to the response. When there are missing outcomes,
`ICAD` produces the DR-WLS estimator.

``` r
arsw_icad_missing <-
  ICAD(
    # Outcome: 1 if Negative, 0 if Positive or Missing
    Y = ctn03_sim_mar$arsw_score_eot, 
    A = 1*(ctn03_sim_mar$arm == "7-day"), # Treatment indicator - Must be 1/0
    Strata = ctn03_sim_mar$stability_dose, # Abstinence x Substance Strata
    W = ctn03_sim_mar[, baseline_covariates],
    pi = 0.5 # 1:1 Randomization
  )

arsw_icad_missing
```

    ##                            est       var  CI.lower CI.upper
    ## unadjsed             1.2974559 10.805138 -5.145175 7.740087
    ## adjusted-for-strata  1.1844728 10.805077 -5.258140 7.627086
    ## adjusted-for-all    -0.6216036  9.766322 -6.746710 5.503502
    ## drwls               -0.7356085 10.239015 -7.007192 5.535975

------------------------------------------------------------------------

## Binary Outcomes: Opioids by Urine Drug Screening (UDS)

### Two Sample Test of Proportions

Similar to the t-test, the validity of from a two-sample test of
proportions assumes that data are missing completely at random (MCAR),
which should be empirically assessed.

``` r
opioids_prop_test <-
  prop.test(
    x = with(ctn03_sim, table(uds_opioids_eot, arm))
  )

print(opioids_prop_test)
```

    ## 
    ##  2-sample test for equality of proportions with continuity correction
    ## 
    ## data:  with(ctn03_sim, table(uds_opioids_eot, arm))
    ## X-squared = 4.1745, df = 1, p-value = 0.04104
    ## alternative hypothesis: two.sided
    ## 95 percent confidence interval:
    ##  -0.18814378 -0.00426336
    ## sample estimates:
    ##    prop 1    prop 2 
    ## 0.4681529 0.5643564

``` r
diff(opioids_prop_test$estimate) # Estimate
```

    ##     prop 2 
    ## 0.09620357

``` r
opioids_prop_test$conf.int # Confidence Interval
```

    ## [1] -0.18814378 -0.00426336
    ## attr(,"conf.level")
    ## [1] 0.95

``` r
opioids_prop_test$p.value # P-Value
```

    ## [1] 0.04103575

Again, missing data not only increases variance, but also introduces
potential bias:

``` r
opioids_prop_test_missing <-
  prop.test(
    x = with(ctn03_sim_mar, table(uds_opioids_eot, arm))
  )

print(opioids_prop_test_missing)
```

    ## 
    ##  2-sample test for equality of proportions with continuity correction
    ## 
    ## data:  with(ctn03_sim_mar, table(uds_opioids_eot, arm))
    ## X-squared = 1.5498, df = 1, p-value = 0.2132
    ## alternative hypothesis: two.sided
    ## 95 percent confidence interval:
    ##  -0.18644715  0.03907873
    ## sample estimates:
    ##    prop 1    prop 2 
    ## 0.4000000 0.4736842

``` r
diff(opioids_prop_test_missing$estimate) # Estimate
```

    ##     prop 2 
    ## 0.07368421

``` r
opioids_prop_test_missing$conf.int # Confidence Interval
```

    ## [1] -0.18644715  0.03907873
    ## attr(,"conf.level")
    ## [1] 0.95

``` r
opioids_prop_test_missing$p.value # P-Value
```

    ## [1] 0.2131611

### Adjusted for Covariates: G-Computation

We can use a logistic regression to adjust for baseline covariates with
a binary outcome, however, inference is not as straightforward as with
ANCOVA. The coefficient in a logistic regression is a *conditional
association:* it is the associated change in the log odds of the outcome
with a unit change in the predictor when holding all other variables
constant. The average treatment effect is a *marginal, not conditional
quantity*. In order to obtain the average treatment effect, we must
marginalize by averaging over the covariates. First, fit a logistic
regression model for the outcome.

``` r
opioids_glm <-
  glm(
    formula = 
      1*(ctn03_sim$uds_opioids_eot == "Negative") ~
      arm + arsw_score_eot +
      stability_dose + age + sex + marital +
      cows_total_score_bl + vas_crave_opiates_bl +
      vas_current_withdrawal_bl + vas_study_tx_help_bl +
      uds_opioids_bl + uds_oxycodone_bl + uds_any_positive_bl,
    data = ctn03_sim,
    family = binomial(link = "logit")
  )

summary(opioids_glm) # Print a summary of the `lm` object
```

    ## 
    ## Call:
    ## glm(formula = 1 * (ctn03_sim$uds_opioids_eot == "Negative") ~ 
    ##     arm + arsw_score_eot + stability_dose + age + sex + marital + 
    ##         cows_total_score_bl + vas_crave_opiates_bl + vas_current_withdrawal_bl + 
    ##         vas_study_tx_help_bl + uds_opioids_bl + uds_oxycodone_bl + 
    ##         uds_any_positive_bl, family = binomial(link = "logit"), 
    ##     data = ctn03_sim)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.2493  -0.7370   0.5552   0.7316   2.0468  
    ## 
    ## Coefficients:
    ##                                    Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)                        0.591838   0.891477   0.664  0.50676    
    ## arm7-day                           0.136351   0.220632   0.618  0.53658    
    ## arsw_score_eot                     0.002325   0.003817   0.609  0.54241    
    ## stability_dose16 mg                1.213039   0.428571   2.830  0.00465 ** 
    ## stability_dose24 mg                1.139822   0.412592   2.763  0.00573 ** 
    ## age                               -0.007705   0.011870  -0.649  0.51625    
    ## sexFemale                         -0.279525   0.247945  -1.127  0.25959    
    ## maritalNever married              -0.389937   0.287230  -1.358  0.17460    
    ## maritalDivorced/Separated/Widowed -0.112614   0.316909  -0.355  0.72233    
    ## cows_total_score_bl                0.104553   0.084008   1.245  0.21329    
    ## vas_crave_opiates_bl               0.010931   0.007350   1.487  0.13693    
    ## vas_current_withdrawal_bl         -0.017388   0.010014  -1.736  0.08252 .  
    ## vas_study_tx_help_bl               0.003060   0.005636   0.543  0.58712    
    ## uds_opioids_blPositive            -2.468361   0.307377  -8.030 9.71e-16 ***
    ## uds_oxycodone_blPositive           0.423671   0.324342   1.306  0.19147    
    ## uds_any_positive_blPositive       -0.598961   0.271839  -2.203  0.02757 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 690.82  on 515  degrees of freedom
    ## Residual deviance: 529.26  on 500  degrees of freedom
    ## AIC: 561.26
    ## 
    ## Number of Fisher Scoring iterations: 4

We obtain an estimate of the ATE estimate this by plugging in estimating
of the probabilities from a fitted model: this involves obtaining a
prediction for each individual as if they were assigned to treatment,
and a prediction for each individual assigned to control, and
marginalize over the covariates by taking the sample average:

``` r
# Predict Pr{Y = 1 | A = 1}
pr_y1_a1 <-
  predict(
    object = opioids_glm,
    newdata =
      ctn03_sim %>% 
      dplyr::mutate(
        arm = "7-day"
      ),
    type = "response"
  )

# Predict Pr{Y = 1 | A = 0}
pr_y1_a0 <-
  predict(
    object = opioids_glm,
    newdata =
      ctn03_sim %>% 
      dplyr::mutate(
        arm = "28-day"
      ),
    type = "response"
  )

mean(pr_y1_a1) - mean(pr_y1_a0) # Estimate
```

    ## [1] 0.02287549

Note that this process just produces a point estimate of the ATE:
confidence intervals can be obtained using the delta method, bootstrap,
or influence functions.

``` r
opioids_margins <-
  margins::margins(
    model = opioids_glm,
    # Specify treatment variable
    variables = "arm",
    # Obtain robust standard errors
    vcov = vcovHC(opioids_glm)
  )

summary(object = opioids_margins)
```

    ##    factor    AME     SE      z      p   lower  upper
    ##  arm7-day 0.0229 0.0372 0.6154 0.5383 -0.0500 0.0957

Note that the G-computation estimate does not account for missing data
or stratified randomization. Adjustment for missing data can be done by
constructing propensity score models for treatment and missingness,
giving the DR-WLS estimator. For continuous and binary outcomes, there
are existing methods to account for stratified randomization.

### Adjusted for Baseline Variables & Stratified Design

The `ICAD` function can also handle binary outcomes using the argument
`family = "binomial"`:

``` r
baseline_covariates <-
  c("age", "sex", "marital",
    "arsw_score_bl", "cows_total_score_bl",
    "vas_crave_opiates_bl", "vas_current_withdrawal_bl", "vas_study_tx_help_bl",
    "uds_opioids_bl", "uds_oxycodone_bl", "uds_any_positive_bl")

opioids_icad <-
  ICAD(
    # Outcome: 1 if Negative, 0 if Positive or Missing
    Y = 1*(ctn03_sim$uds_opioids_eot == "Negative"), 
    A = 1*(ctn03_sim$arm == "7-day"), # Treatment indicator - Must be 1/0
    Strata = ctn03_sim$stability_dose, # Abstinence x Substance Strata
    W = ctn03_sim[, baseline_covariates],
    pi = 0.5, # 1:1 Randomization
    family = "binomial"
  )

opioids_icad
```

    ##                            est         var     CI.lower   CI.upper
    ## unadjusted          0.09168357 0.001814535  0.008194288 0.17517285
    ## adjusted-for-strata 0.09263800 0.001814495  0.009149625 0.17612637
    ## adjusted-for-all    0.02301603 0.001291296 -0.047414517 0.09344657

Since there does not appear to be a strong relationship between the
strata and the outcome, there appears to be minimal gain in efficiency
from adjustment. When there is missing data in the outcome, `ICAD`
calculates the DR-WLS estimate of the average treatment effect:

``` r
baseline_covariates <-
  c("age", "sex", "marital",
    "arsw_score_bl", "cows_total_score_bl",
    "vas_crave_opiates_bl", "vas_current_withdrawal_bl", "vas_study_tx_help_bl",
    "uds_opioids_bl", "uds_oxycodone_bl", "uds_any_positive_bl")

opioids_icad_missing <-
  ICAD(
    # Outcome: 1 if Negative, 0 if Positive or Missing
    Y = 1*(ctn03_sim_mar$uds_opioids_eot == "Negative"), 
    A = 1*(ctn03_sim_mar$arm == "7-day"), # Treatment indicator - Must be 1/0
    Strata = ctn03_sim_mar$stability_dose, # Abstinence x Substance Strata
    W = ctn03_sim_mar[, baseline_covariates],
    pi = 0.5, # 1:1 Randomization
    family = "binomial"
  )
```

    ## Warning in eval(family$initialize): non-integer #successes in a binomial glm!

`Warning in eval(family$initialize): non-integer #successes in a binomial glm!`
arises even when the outcomes are all binary - this happens when weights
are used in `glm` and the `binomial` family is specified. If your
outcome is binary, this can be safely ignored. Using the `quasibinomial`
family in GLMs can avoid this message.

``` r
opioids_icad_missing
```

    ##                            est         var    CI.lower  CI.upper
    ## unadjsed            0.07068389 0.002601561 -0.02928505 0.1706528
    ## adjusted-for-strata 0.07374103 0.002601386 -0.02622455 0.1737066
    ## adjusted-for-all    0.01828269 0.001815700 -0.06523340 0.1017988
    ## drwls               0.02303305 0.002019535 -0.06504623 0.1111123

The DR-WLS Estimator has less restrictive assumptions about missingness:
if either the outcome model or the missingness model are correctly
specified, the DR-WLS estimator is a consistent estimator of the average
treatment effect.

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
