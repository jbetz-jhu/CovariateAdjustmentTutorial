## Estimands of Interest


### Notation

Let $A$ denote a binary treatment assignment: $A = 1$ indicates assignment to receive the treatment of interest, and $A = 0$ indicates assignment to the control or comparator group. Let $Y$ denote the outcome of interest, and $X$ denote a vector of baseline covariates. Each participant's data is assumed to be independent, identically distributed (iid) draws from an unknown distribution. All analyses follow the intention-to-treat (ITT) principle: all participants are analyzed according to how they were randomized, irrespective of what treatment was received during the trial. 

### Difference in Means

When an outcome is continuous or binary, one meaningful summary may be the mean of the outcome, and a meaningful comparison may be the difference in means estimand:

$$\theta_{DIM} = E[Y \vert A = 1] - E[Y \vert A = 0]$$

This estimand compares the mean outcome in the population of interest if all individuals received the treatment of interest to the the mean outcome in the population of interest if all individuals received the control or comparator intervention.
