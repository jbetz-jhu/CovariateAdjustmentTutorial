### Function: expit
# This function calculates expit
expit = function(x){
  exp(x)/(1+exp(x))
}

### Function: calculateEstimate
# This function calculates the estimator based on the observed data
# Input: data, a data frame containing the observed data;
# estimationMethod, a function which indicates the method of estimation;
# ..., further arguments for the estimator function.
# Output: estimate, an estimated value for the treatment effect.

calculateEstimate = function(data,
                             estimationMethod,
                             ...){
  
  ellipsis_args = as.list(substitute(list(...)))[-1L]
  all_args = c(list(data=data), ellipsis_args)
  
  # Estimate the treatment effect using the function 'estimationMethod'
  estimate = do.call(what = estimationMethod,
                     args = all_args[intersect(x=names(all_args), 
                                               y= formalArgs(estimationMethod))])[[1]]
  estimate
  
}

### Function: calculateVariance
# This function calculates the variance of the estimator based on observed data 
# Input: data, a data frame containing the observed data;
# estimationMethod, a function which indicates the method of estimation;
# bootstraps, the number of bootstraps;
# ..., further arguments for the estimator function.
# Output: variance, estimated variance of the estimated the treatment effect.

calculateVariance = function(data,
                             estimationMethod,
                             bootstraps = 2500,
                             ...){
  
  ellipsis_args = as.list(substitute(list(...)))[-1L]
  
  # Use bootstrap to estimate variance
  set.seed(123, "L'Ecuyer")
  med.boot = mclapply(1:bootstraps, function(i) {
    dataNew = data[sample(nrow(data), nrow(data), replace = TRUE), ]
    
    all_args = c(list(data=dataNew, estimationMethod=estimationMethod), ellipsis_args)
    estimate = do.call(what = calculateEstimate, 
                       args = all_args)
    
    estimate
    
  }, mc.cores = 16)
  
  
  # Calculate variance based on the different bootstrap estimates
  variance = var(unlist(med.boot))
  
  variance
  
}

### Function: calculateCovariance
# This function calculates the covariance of the estimator 
# and the previous estimators based on observed data 
# Input: data, a data frame containing the observed data;
# estimationMethod, a function which indicates the method of estimation;
# bootstraps, the number of bootstraps;
# ..., further arguments for the estimator function.
# Output: covariance, a vector of the estimated covariances between the 
# current estimate and previous estimates, and the estimated variance 
# of the current estimate.

calculateCovariance = function(data, 
                               estimationMethod,
                               bootstraps = 2500, 
                               #analysisTimes,
                               previousDatasets=list(),
                               parametersPreviousEstimators = NULL,
                               ...
){
  
  ellipsis_args = as.list(substitute(list(...)))[-1L]
  
  analysisNumber = length(previousDatasets)+1
  
  # Use bootstrap to estimate variance and covariances
  set.seed(123, "L'Ecuyer")
  med.boot = mclapply(1:bootstraps, function(i) {
    #dataNew = data[sample(nrow(data), nrow(data), replace = TRUE), ]
    selection = sample(data$id, nrow(data), replace = TRUE)
    selectionFreq = as.data.frame(table(selection))
    
    sub_sample_df = data[data$id%in%selection,]
    match_freq = selectionFreq[match(sub_sample_df$id, selectionFreq$selection),]
    
    sub_sample_df$Freq = match_freq$Freq
    selected_rows = rep(1:nrow(sub_sample_df), sub_sample_df$Freq)
    dataNew = sub_sample_df[selected_rows,]
    
    estimate=c()
    
    all_args = c(list(data = dataNew, estimationMethod = estimationMethod), ellipsis_args)
    estimate[analysisNumber]  = do.call(what = calculateEstimate, 
                                        args = all_args)[[1]] 
    
    for(j in 1:(analysisNumber-1)){
      
      # Make a dataset with data available at analysis j and
      # indicate which participants had the primary endpoint observed 
      # at analysis j (i.e., are part of cohort 1)
      
      dataNew1 = previousDatasets[[j]]
      
      sub_sample_df = dataNew1[dataNew1$id%in%selection,]
      match_freq = selectionFreq[match(sub_sample_df$id, selectionFreq$selection),]
      
      sub_sample_df$Freq = match_freq$Freq
      selected_rows = rep(1:nrow(sub_sample_df), sub_sample_df$Freq)
      dataNew1 = sub_sample_df[selected_rows,]
      
      
      if(is.list(parametersPreviousEstimators)==TRUE){
        
        ellipsis_args[names(parametersPreviousEstimators[[j]])]=parametersPreviousEstimators[[j]]
        all_args = c(list(data = dataNew1, estimationMethod = estimationMethod), ellipsis_args)
        estimate[j]  = do.call(what = calculateEstimate, 
                               args = all_args)[[1]] 
        
      }else{
        all_args = c(list(data = dataNew1, estimationMethod = estimationMethod), ellipsis_args)
        estimate[j]  = do.call(what = calculateEstimate, 
                               args = all_args)[[1]] 
      }
      
    }
    
    estimate
    
  }, mc.cores = 16)
  
  # Calculate covariances and variance based on the different bootstrap estimates
  dataCov = data.frame(matrix(unlist(med.boot), nrow=length(med.boot), byrow=TRUE))
  
  covariance = cov(dataCov)[analysisNumber,]
  
  covariance
  
}

### Function: updateEstimate
# This function orthogonalizes the original estimates.
# Input: covMatrix, covariance matrix of original estimates up to current analysis; 
# originalEstimates, original estimates up to current analysis.
# Output: a list with (1) estimateUpdated, the updated/orthogonalized 
# estimate at current analysis;
# (2) varianceUpdated, the variance of the updated/orthogonalized 
# estimate at current analysis.

updateEstimate = function(covMatrixOriginal, 
                          estimatesOriginal){
  
  # k is the analysis for which we want to update the estimate
  k = length(estimatesOriginal)  
  
  # covMatrixProjection is the kxk covariance matrix of 
  # (theta_k-theta_1, ..., theta_k-theta_{k-1}, theta_k)
  covMatrixProjection = matrix(1, k, k)*covMatrixOriginal[k,k] - 
    as.vector(rep(1, k))%*%t(as.vector(c(covMatrixOriginal[1:k-1,k], 0))) -
    t(as.vector(rep(1, k))%*%t(as.vector(c(covMatrixOriginal[1:k-1,k], 0)))) + 
    rbind(cbind(covMatrixOriginal[1:k-1,1:k-1], 0), 0)
  
  # A is the Cholesky decomposition of covMatrixProjection
  A = chol(covMatrixProjection)
  # Atilde is a kx(k-1) matrix with the first k-1 columns of A
  Atilde = A[,-k] 
  # Ak is a kx1 vector equal to the kth column of A
  Ak = A[,k] 
  
  # W equals the vector # (theta_k-theta_1, ..., theta_k-theta_{k-1}, theta_k)
  W = c(estimatesOriginal[k] - estimatesOriginal[1:k-1], estimatesOriginal[k])
  
  # scale are the orthogonalizing 'coefficients' 
  scale = solve(A)%*%(diag(k)-Atilde%*%solve(t(Atilde)%*%Atilde)
                      %*%t(Atilde))%*%Ak
  
  # updatedEstimate is the updated/orthogonalized estimate at analysis k
  estimateUpdated = t(scale)%*%W
  
  # updatedVariance is the variance of the 
  # updated/orthogonalized estimate at analysis k
  varianceUpdated = t(scale)%*%t(A)%*%A%*%scale
  
  list(cbind(estimateUpdated, varianceUpdated))
  
}

### Function: interimDecision
# This function makes a decision based on a test statistic
# Input: testStatistic, a numeric value for the calculated test statistic;
# alpha, the (total) siginificance level alpha;
# alternative, a character string specifying the alternative hypothesis;
# boundaries, type of alpha spending function to use (see bounds in ldbounds package);
# plannedAnalyses, total number of planned analyses (interim and final);
# previousInformationTimes, information times of estimates up to the previous analysis; 
# currentInformationTime, information time of current analysis.
# Output: decision, a logical value whether the null hypothesis is rejected or not.

interimDecision = function(testStatistic,
                           alpha = 0.05, 
                           alternative = "two.sided", 
                           boundaries = 1,
                           plannedAnalyses,
                           previousInformationTimes, 
                           currentInformationTime
){
  
  # Number of current analysis
  analysisNumber=length(previousInformationTimes)+1
  
  # Make decision based on test statistics and bounds
  if(alternative=="two.sided"){
    
    if(analysisNumber==plannedAnalyses){
      
      bound=bounds(t= c(previousInformationTimes, 1), 
                   iuse = c(boundaries, boundaries), 
                   asf = NULL, 
                   alpha = c(alpha/2, alpha/2))$upper.bounds[analysisNumber]
      
    }else{
      
      bound=bounds(t= c(previousInformationTimes, currentInformationTime), 
                   iuse = c(boundaries, boundaries), 
                   asf = NULL, 
                   alpha = c(alpha/2, alpha/2))$upper.bounds[analysisNumber]
      
    }
    
    decision = as.logical(abs(testStatistic)>bound)
    
  }else{
    
    if(analysisNumber==plannedAnalyses){
      
      bound=bounds(t= c(previousInformationTimes, 1), 
                   iuse = boundaries, 
                   asf = NULL, 
                   alpha = alpha)$upper.bounds[analysisNumber]
      
    }else{
      
      bound=bounds(t= c(previousInformationTimes, currentInformationTime), 
                   iuse = boundaries, 
                   asf = NULL, 
                   alpha = alpha)$upper.bounds[analysisNumber]
      
    }
    
    if(alternative=="less"){
      
      decision = as.logical(testStatistic<(-bound))
      
    }else{
      
      decision = as.logical(testStatistic>bound)
      
    }
    
  }
  
  decision
  
}

### Function: interimInformation
# This function calculates the information based on observed data for chosen estimator
# Input: data, a data frame containing the observed data;
# totalInformation, a value indicating the total/maximum information;
# analysisNumber, number of analysis;
# estimationMethod, method of estimation for the treatment effect;
# update, a character string indicating whether information needs to be calculated
# based on updated estimate ("yes") or based on original estimate ("no");
# previousEstimatesOriginal, vector of original estimates up to the previous analysis;
# previousCovMatrixOriginal, covariance matrix of original estimates up to the previous analysis;
# ..., further arguments for the estimator function or calculation of variance (ie, number of bootstraps).
# Output: a list with (1) information, information available in current data;
# (2) informationTime, information time (information available relative to total information)

interimInformation = function(data, 
                              totalInformation, 
                              analysisNumber,
                              #analysisTimes,
                              previousDatasets=list(),
                              estimationMethod,
                              update,
                              previousEstimatesOriginal=c(),
                              previousCovMatrixOriginal=c(),
                              parametersPreviousEstimators = NULL,
                              ...){
  
  ellipsis_args = as.list(substitute(list(...)))[-1L]
  
  # Estimate (original) treatment effect and corresponding variance 
  all_args = c(list(data=data, estimationMethod=estimationMethod), ellipsis_args)
  estimate = do.call(what = calculateEstimate, 
                     args = all_args) 
  
  if(update == "no" | analysisNumber==1){
    
    variance = do.call(what = calculateVariance, 
                       args = all_args) 
    
    # Calculate (original) information and information time 
    information = 1/variance
    informationTime = information/totalInformation
    
  }else{
    
    all_args_cov = c(all_args, 
                     list(previousDatasets=previousDatasets))
    all_args_cov = c(all_args_cov, 
                     list(parametersPreviousEstimators = parametersPreviousEstimators))
    
    covariance = do.call(what = calculateCovariance, 
                         args = all_args_cov)
    
    # Update covariance matrix of original estimates
    covMatrix = cbind(rbind(previousCovMatrixOriginal, covariance[-analysisNumber]), covariance)
    
    # Update/orthogonalize the original estimate at the (interim) analysis
    # based on the original covariance matrix and
    # the original estimates
    updated = updateEstimate(
      covMatrixOriginal=covMatrix, 
      estimatesOriginal=c(previousEstimatesOriginal, estimate))
    
    information = 1/updated[[1]][1,2]
    informationTime = information/totalInformation
    
  }
  
  list(information, informationTime)
  
}

### Function: calculateCorrectionTerm
calculateCorrectionTerm = function(data, 
                                   y0_formula, 
                                   y1_formula){
  number = length(names(select(data, contains(".r_"))))
  n1=length(which(data[,paste(".r_",number,sep='')]==1&data[,"treatment"]==1))
  n0=length(which(data[,paste(".r_",number,sep='')]==1&data[,"treatment"]==0))
  p0=dim(model.matrix(y0_formula, data))[2]
  p1=dim(model.matrix(y1_formula, data))[2]
  correctionTerm = (1/(n1-p1)+1/(n0-p0))/(1/(n1-1)+1/(n0-1))
  
  correctionTerm
}

### Function: interimAnalysis
# This function performs an interim analysis based on observed data 
# Input: data, a data frame containing the observed data;
# totalInformation, a value indicating the total/maximum information;
# estimationMethod, method of estimation for the treatment effect;
# previousEstimatesOriginal, vector of original estimates up to the previous analysis;
# previousCovMatrixOriginal, covariance matrix of original estimates up to the previous analysis;
# previousInformationTimesOriginal, information times of original estimates up to the previous analysis; 
# previousInformationTimesUpdated, information times of updated estimates up to the previous analysis; 
# null.value, a number indicating the value of theta under the null hypothesis, 
# alpha, the (total) siginificance level alpha;
# alternative, a character string specifying the alternative hypothesis, 
# must be one of "two.sided" (default), "greater" or "less";
# boundaries, type of alpha spending function to use (see bounds in ldbounds package);
# plannedAnalyses, total number of analyses (interim and final);
# ..., further arguments for the estimator function or calculation of covariance (ie, number of bootstraps).
# Output: a list with (1) estimateOriginal, original estimate at current analysis;
# (2) standardErrorOriginal, estimated standard error of original estimate at current analysis; 
# (3) testStatisticOriginal, test statistics corresponding with original estimate at current analysis; 
# (4) decisionOriginal, decision corresponding with original estimate at current analysis;  
# (5) informationTimeOriginal, information time corresponding with original estimate at current analysis; 
# (6) estimateUpdated, updated/orthogonalized estimate at current analysis;
# (7) standardErrorUpdated, estimated standard error of updated/orthogonalized 
# estimate at current analysis;
# (8) testStatisticUpdated, test statistics corresponding with updated estimate at current analysis; 
# (9) decisionUpdated, decision corresponding with updated estimate at current analysis;
# (10) informationTimeUpdated, information time corresponding with updated estimate at current analysis;
# (11) covMatrixOriginal, covariance matrix of original estimates up to current analysis.

interimAnalysis = function(data, 
                           totalInformation, 
                           estimationMethod,
                           previousEstimatesOriginal=c(),
                           previousCovMatrixOriginal=c(),
                           previousInformationTimesOriginal=c(),
                           previousInformationTimesUpdated=c(),
                           #analysisTimes,
                           previousDatasets=list(),
                           null.value = 0,
                           alpha = 0.025, 
                           alternative = "two.sided", 
                           boundaries = 1,
                           plannedAnalyses,
                           parametersPreviousEstimators = NULL,
                           correction="no",
                           ...){
  
  # Number of current analysis
  analysisNumber = length(previousInformationTimesOriginal)+1
  
  ellipsis_args = as.list(substitute(list(...)))[-1L]
  
  # Estimate (original) treatment effect and corresponding variance 
  # based on the estimator in Appendix C
  all_args = c(list(data=data, estimationMethod=estimationMethod), ellipsis_args)
  estimateOriginal = do.call(what = calculateEstimate, 
                             args = all_args) 
  
  
  # Update covariance matrix of original estimates
  
  if(analysisNumber==1){
    variance = do.call(what = calculateVariance, 
                       args = all_args) 
    covMatrixOriginal = variance
    
    standardErrorOriginal = sqrt(variance)
  }else{
    
    all_args_cov = c(all_args, 
                     list(previousDatasets=previousDatasets))
    all_args_cov = c(all_args_cov, 
                     list(parametersPreviousEstimators = parametersPreviousEstimators))
    
    covariance = do.call(what = calculateCovariance, 
                         args = all_args_cov)
    covMatrixOriginal = cbind(rbind(previousCovMatrixOriginal, covariance[-analysisNumber]), covariance)
    
    standardErrorOriginal = sqrt(covariance[analysisNumber])
  }
  
  if(correction=="yes"){
    
    correctionTerm = do.call(what = calculateCorrectionTerm, 
                             args = all_args[intersect(x=names(all_args), 
                                                       y= formalArgs(calculateCorrectionTerm))])
    
    
  }else{
    correctionTerm = 1
  }
  
  
  # Calculate (original) SE, information, information time and test statistic
  standardErrorOriginal = standardErrorOriginal*sqrt(correctionTerm)
  informationOriginal=1/(standardErrorOriginal)^2
  informationTimeOriginal = informationOriginal/totalInformation
  testStatisticOriginal = estimateOriginal/standardErrorOriginal
  
  
  
  if(analysisNumber==1){
    
    # Calculate updated variance and 
    # calculate (updated) SE, information, information time and test statistic
    estimateUpdated = estimateOriginal 
    standardErrorUpdated = standardErrorOriginal
    informationUpdated = informationOriginal
    informationTimeUpdated = informationTimeOriginal
    testStatisticUpdated = testStatisticOriginal
    
  }else{
    
    # Update/orthogonalize the original estimate at the (interim) analysis
    # based on the original covariance matrix and
    # the original estimates
    updated = updateEstimate(
      covMatrixOriginal=covMatrixOriginal, 
      estimatesOriginal=c(previousEstimatesOriginal, estimateOriginal))
    estimateUpdated = updated[[1]][1,1] 
    standardErrorUpdated = sqrt(updated[[1]][1,2])*sqrt(correctionTerm)
    informationUpdated=1/(standardErrorUpdated)^2
    informationTimeUpdated = informationUpdated/totalInformation
    testStatisticUpdated = estimateUpdated/standardErrorUpdated
    
  }
  
  
  decisionOriginal = interimDecision(testStatistic=testStatisticOriginal,
                                     alpha = alpha, 
                                     alternative = alternative, 
                                     boundaries = boundaries,
                                     plannedAnalyses=plannedAnalyses,
                                     previousInformationTimes=previousInformationTimesOriginal, 
                                     currentInformationTime=informationTimeOriginal
  )
  
  decisionUpdated = interimDecision(testStatistic=testStatisticUpdated,
                                    alpha = alpha, 
                                    alternative = alternative, 
                                    boundaries = boundaries,
                                    plannedAnalyses=plannedAnalyses,
                                    previousInformationTimes=previousInformationTimesUpdated, 
                                    currentInformationTime=informationTimeUpdated)
  
  
  list(estimateOriginal=estimateOriginal, 
       standardErrorOriginal=standardErrorOriginal, 
       testStatisticOriginal=testStatisticOriginal, 
       decisionOriginal=decisionOriginal, 
       informationTimeOriginal=informationTimeOriginal, 
       estimateUpdated=estimateUpdated, 
       standardErrorUpdated=standardErrorUpdated, 
       testStatisticUpdated=testStatisticUpdated, 
       decisionUpdated=decisionUpdated, 
       informationTimeUpdated=informationTimeUpdated, 
       covMatrixOriginal=covMatrixOriginal) 
  
  
  
}

### Function: standardization
# This function implements the estimator in Appendix C of the paper 
# Input: data, a data frame containing the observed data;
# y0_formula, the model to be fitted for the outcome under control;
# y1_formula, the model to be fitted for the outcome under treatment;
# family, a description of the error distribution and link function to be used in the model. 
# Output: a list with 
# (1) estimate, original estimate based on estimator in Appendix C; 
# (2) y1_pred, predictions of the outcome under treatment for all recruited participants;
# (3) y0_pred, predictions of the outcome under control for all recruited participants;

standardization = function(data, 
                           y0_formula, 
                           y1_formula, 
                           family){
  
  # Make a dataset with current cohort 1 data;
  # i.e., the cohort of patients used to fit working models
  number = length(names(select(data, contains(".r_"))))
  dataCoh1 = data[which(data[,paste(".r_",number,sep='')]==1),]
  
  # Fit working models under control and treatment
  y0_mod = glm(y0_formula, family = family, data = dataCoh1[dataCoh1$treatment==0,])
  y1_mod = glm(y1_formula, family = family, data = dataCoh1[dataCoh1$treatment==1,])
  
  
  # Make predictions under control and treatment for all patients in the dataset
  y0_pred = predict(y0_mod, newdata = data, type = "response")
  y1_pred = predict(y1_mod, newdata = data, type = "response")
  
  # Estimate treatment effect
  estimate = mean(y1_pred) - mean(y0_pred)
  
  list(estimate, y1_pred, y0_pred)
}


### Function: data_at_time_t
# This function determines the dataset at time 'analysis_time'
# Input: data, a data frame containing all observed data;
# id_column, column name of identifier;
# analysis_time, time of the analysis;
# enrollment_time, column name of the enrollment times;
# treatment_column, column name of treatment variable;
# covariate_columns, column names of covariates;
# outcome_columns, column names of outcomes;
# outcome_times, column names of outcome times.
# Output: data, a data frame with the observed data at time 'analysis_time'

data_at_time_t <-
  function(
    data,
    id_column,
    analysis_time,
    enrollment_time,
    treatment_column,
    covariate_columns,
    outcome_columns,
    outcome_times
  ) {
    
    # Select only relevant columns
    data <-
      data[ which(data[, enrollment_time] <= analysis_time),
            c(id_column, covariate_columns, enrollment_time, 
              treatment_column, outcome_times, outcome_columns)
      ]
    
    r_matrix <- 1*(!is.na(data[, outcome_columns]))
    r_matrix[which(data[, outcome_times] > analysis_time, arr.ind = TRUE)] <- NA
    
    for(i in 1:length(outcome_times)){
      data[which(data[, outcome_times[i]] > analysis_time),
           outcome_columns[i]] <- NA
    }
    
    data <-
      data.frame(
        data,
        setNames(
          object = data.frame(r_matrix),
          nm = paste0(".r_", 1:length(outcome_columns))
        )
      ) %>% 
      as_tibble()
    
    return(data)
  }