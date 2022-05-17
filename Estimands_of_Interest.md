## Estimands of Interest


### Notation

Let $A$ denote a binary treatment assignment: $A = 1$ indicates assignment to receive the treatment of interest, and $A = 0$ indicates assignment to the control or comparator group. Let $Y$ denote the outcome of interest, and $X$ denote a vector of baseline covariates. Each participant's data is assumed to be independent, identically distributed (iid) draws from an unknown distribution. All analyses follow the intention-to-treat (ITT) principle: all participants are analyzed according to how they were randomized, irrespective of what treatment was received during the trial. 

## Estimands for Continuous and Binary Outcomes

### Difference in Means

When an outcome is continuous or binary, one meaningful summary may be the mean of the outcome, and a meaningful comparison may be the difference in means estimand:

$$\theta_{DIM} = E[Y \vert A = 1] - E[Y \vert A = 0]$$

This estimand compares the mean outcome in the population of interest if all individuals received the treatment of interest to the the mean outcome in the population of interest if all individuals received the control or comparator intervention. Note that in binary outcomes, this is a difference in proportions (or risk difference) between the population where all individuals received the treatment of interest compared to receiving the control or comparator intervention.


## Estimands for Ordinal Outcomes

Let $Y$ be an ordinal outcome with $k$ ordered categories. For each outcome category $j \in \{1, \ldots, K\}$, the cumulative distribution function of $Y$ given treatment $A$ is denoted as $Pr\\{Y \le j\\} = F(j \vert a)$, and the probability mass function of $Y$ given treatment $A$ is $Pr\\{Y = j\\} = f(j \vert a) = F(j \vert a) - F(j-1 \vert a)$. 

Although this notation involves numeric labels for levels, this is merely to simplify notation. Clarifications will be made as needed when distinguishing between outcomes with and without a numeric levels.

### Difference in Mean Utility

If the levels of $Y$ have numeric labels, and the mean value of this ordinal variable is meaningful, the difference in means estimand may still be meaningful and useful. Alternatively, if either the labels do not have a numeric interpretation, or the mean of these values is not particularly meaningful, it may be possible to create a meaningful numeric value by assigning 'utilities' or 'weights' to each level of the outcome. The quantitative and clinical meanings of the difference in means estimator will depend on the utilities assigned to the outcome scale. This allows the difference in means to be used, even if the levels of the outcome are not numeric (e.g. the Glasgow Outcome Scale, ranging from 'Dead', 'Vegetative state', 'Severely disabled', 'Moderately disabled', and 'Good recovery').

Let $u(\cdot)$ denote a pre-specified mapping of the outcome, mapping the outcome label to a utility value. The estimand is defined as:

$$\theta_{DIM} = E[u(Y) \vert A=1] - E[u(Y) \vert A=0] = \sum_{i=1}^{k}u(j)\left(f( j \vert 1) - f(j \vert 0)\right)$$

When all outcomes at or above a threshold $t \in \{2, \ldots, k\}$ are given a utility of 1, and all others are given a utility of 0, this collapses the ordinal outcome into a binary one. The resulting estimand is the risk difference estimator of the outcome being at or above $t$:

\\[
    u(Y)= 
\begin{cases}
    1: & Y \geq t \\
    0: & Y < t
\end{cases}
\\]
