# Simulated Datasets for Tutorials


### Simulated MISTIE III Data: Minimally Invasive Surgery for Intracranial Hemorrhage

The **M**inimally **I**nvasive **S**urgery with **T**hrombolysis in **I**ntracerebral haemorrhage **E**vacuation trial was a Phase III trial evaluating the safety and efficacy of minimally invasive surgery with Alteplase for ICH removal compared to standard-of-care medical management. Outcomes were measured at 30, 180, and 365-days post-randomization using the Modified Rankin Scale (MRS). Survival was also assessed, with patients administratively censored on the date of their final MRS assessment.

A new synthetic dataset was created by resampling baseline covariates from the original data with replacement. The columns in the synthetic dataset were sequentially replaced using simulated values based on predictions from a sequence of regression models based on the actual study data.

  - [ClinicalTrials.gov Entry - NCT00078117](https://clinicaltrials.gov/show/NCT01827046)
  - [Primary Publication](https://pubmed.ncbi.nlm.nih.gov/30739747/)
  - Arms: Two
  - Randomization: Block Randomized
  - Sample Size: 500 in simulated data, 516 in actual trial
  - [Link to Simulated Data](https://github.com/jbetz-jhu/CovariateAdjustmentTutorial/raw/main/Simulated_MISTIE_III_v1.1.csv)

#### Simulated MISTIE III Data Dictionary

  - `sim_participant_id`: Patient id
  - Baseline Covariates
    - `age`: Age in years
    - `male`: male sex
    - `hx_cvd`:	cardiovascular disease history
    - `hx_hyperlipidemia`:	hyperlipidemia history
    - `on_anticoagulants`:	on anticoagulant medication
    - `on_antiplatelets`:	on antiplatelet medication
    - `ich_location`: intracerebral hemorrhage location: (`Lobar`, `Deep`)
    - `ich_s_volume`:	intracerebral hemorrhage volume on stability scan
    - `ivh_s_volume`:	intraventricular hemorrhage volume on stability scan
    - `gcs_category`: presenting Glasgow Coma Score (GCS)
  - Treatment:
    - `arm`: treatment arm
    - `ich_eot_volume`: intracerebral hemorrhage volume on end-of-treatment scan
  - Outcome:
    - `mrs_30d`: MRS at 30 days (`0-3`, `4`, `5`, `6`)
    - `mrs_30d_complete`: MRS at 30 days if no data were missing
    - `mrs_180d`: MRS at 180 days (`0-2`, `3`, `4`, `5`, `6`)
    - `mrs_180d_complete`: MRS at 180 days if no data were missing
    - `mrs_365d`: MRS at 365 days (`0-1`, `2`, `3`, `4`, `5`, `6`)
    - `mrs_365d_complete`: MRS at 365 days if no data were missing
    - `days_on_study`: days until death or administrative censoring
    - `died_on_study`: participant died (`1`) or is censored (`0`)
    
The outcomes `mrs_30d`, `mrs_180d`, and `mrs_365d` contain missing values: the actual values before the missingness mechanism is applied are also included with the `_complete` suffix. Survival up to administrative censoring is given by `days_on_study` and `died_on_study`.




--------------------------------------------------------------------------------




### CTN 0003 - Suboxone (Buprenorphine/Naloxone) Taper: A Comparison of Two Schedules

CTN03 was a phase III two arm trial to assess tapering schedules of the drug buprenorphine, a pharmacotherapy for opioid dependence. At the time of the study design, there was considerable variation in tapering schedules in practice, and a knowledge gap in terms of the best way to administer buprenorphine to control withdrawal symptoms and give the greatest chance of abstinence at the end of treatment. It was hypothesized that a longer taper schedule would result in greater likelihood of a participant being retained on study and providing opioid-free urine samples at the end of the drug taper schedule. Participants were randomized 1:1 to a 7-day or 28-day taper using stratified block randomization across 11 sites in 10 US cities. Randomization was stratified by the maintenance dose of buprenorphine at stabilization: 8, 16, or 24 mg.

  - [ClinicalTrials.gov Entry - NCT00078117](https://clinicaltrials.gov/show/NCT00078117)
  - [Primary Publication](https://pubmed.ncbi.nlm.nih.gov/19149822/)
  - Arms: Two
  - Randomization: Stratified, 3 strata: Maintenance dose of 8, 16, or 24 mg
  - Sample Size: 516
  - [Link to Simulated Data](https://github.com/jbetz-jhu/CovariateAdjustmentTutorial/raw/main/SIMULATED_CTN03_220506.Rdata)

#### CTN 0003 Data Dictionary

  - Randomization Information
    - `arm`: Treatment Arm
    - `stability_dose`: Stratification Factor
  - Baseline Covariates
    - `age`: Participant age at baseline
    - `sex`: Participant sex
    - `race`: Participant race
    - `ethnic`: Participant ethnicity
    - `marital`: Participant marital status
  - Baseline
    - `arsw_score_bl`: Adjective Rating Scale for Withdrawal (ARSW) Score at baseline
    - `cows_score_bl`: Clinical Opiate Withdrawal Scale (COWS) Score at baseline
    - `cows_category_bl`: COWS Severity Category - Ordinal - at baseline
    - `vas_crave_opiates_bl`: Visual Analog Scale (VAS) - Self report of opiate cravings at baseline
    - `vas_current_withdrawal_bl`: Visual Analog Scale (VAS) - Current withdrawal symptoms at baseline
    - `vas_study_tx_help_bl`: Visual Analog Scale (VAS) - Study treatment helping symptoms at baseline
    - `uds_opioids_bl`: Urine Drug Screen Result - Opioids at baseline
    - `uds_oxycodone_bl`: Urine Drug Screen Result - Oxycodone at baseline
    - `uds_any_positive_bl`: Urine Drug Screen - Any positive result at baseline
  - End-of-Taper: *Note - this is 7 days post randomization in one arm and 28-days post randomization in the other.*
    - `arsw_score_eot`: Adjective Rating Scale for Withdrawal (ARSW) Score at end-of-taper
    - `cows_score_eot`: Clinical Opiate Withdrawal Scale (COWS) Score at end-of-taper
    - `cows_category_eot`: COWS Severity Category - Ordinal - at end-of-taper
    - `vas_crave_opiates_eot`: Visual Analog Scale (VAS) - Self report of opiate cravings at end-of-taper
    - `vas_current_withdrawal_eot`: Visual Analog Scale (VAS) - Current withdrawal symptoms at end-of-taper
    - `vas_study_tx_help_eot`: Visual Analog Scale (VAS) - Study treatment helping symptoms at end-of-taper
    - `uds_opioids_eot`: Urine Drug Screen Result - Opioids at end-of-taper
    - `uds_oxycodone_eot`: Urine Drug Screen Result - Oxycodone at end-of-taper
    - `uds_any_positive_eot`: Urine Drug Screen - Any positive result at end-of-taper




--------------------------------------------------------------------------------




### CTN 0030 - Prescription Opioid Addiction Treatment Study (POATS)

  - [ClinicalTrials.gov Entry - NCT00316277](https://clinicaltrials.gov/ct2/show/NCT00316277)
  - [Primary Publication](https://pubmed.ncbi.nlm.nih.gov/22065255/)
  - Arms: Two
  - Randomization: Stratified, 4 strata: Chronic Pain x Opioid Use
  - Sample Size: 653
  - [Link to Simulated Data (TBA)](https://github.com/jbetz-jhu/CovariateAdjustmentTutorial/List_of_Datasets.html)
