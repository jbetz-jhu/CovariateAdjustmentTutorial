## Estimands of Interest


### Notation

Let $A$ denote a binary treatment assignment: $A = 1$ indicates assignment to receive the treatment of interest, and $A = 0$ indicates assignment to the control or comparator group. Let $Y$ denote the outcome of interest, and $X$ denote a vector of baseline covariates. Each participant's data is assumed to be independent, identically distributed (iid) draws from an unknown distribution. All analyses follow the intention-to-treat (ITT) principle: all participants are analyzed according to how they were randomized, irrespective of what treatment was received during the trial. 

## Estimands for Continuous and Binary Outcomes

### Difference in Means

When an outcome is continuous or binary, one meaningful summary may be the mean of the outcome, and a meaningful comparison may be the difference in means estimand:

$$\theta_{DIM} = E[Y \vert A = 1] - E[Y \vert A = 0]$$

This estimand compares the mean outcome in the population of interest if all individuals received the treatment of interest to the the mean outcome in the population of interest if all individuals received the control or comparator intervention. Note that in binary outcomes, this is a difference in proportions (or risk difference) between the population where all individuals received the treatment of interest compared to receiving the control or comparator intervention.


## Estimands for Ordinal Outcomes

Let $Y$ be an ordinal outcome with $k$ ordered categories. For each outcome category $j \in \{1, \ldots, K\}$, the cumulative distribution function of $Y$ given treatment $A$ is denoted as $Pr\left\{Y \le j\right\} = F(j \vert a)$, and the probability mass function of $Y$ given treatment $A$ is $Pr\left\{Y = j\right\} = f(j \vert a) = F(j \vert a) - F(j-1 \vert a)$. 

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

While a risk difference may be more familiar to implement and conceptually easier to interpret, it treats all outcome states either below or above the threshold identically, ignoring potential information in such outcome states.

When utilities can be assigned according to patient preferences or other considerations, the estimand is the difference in mean utility between treatment arms.

\[
    u(Y)= 
\begin{cases}
    u_{1} := \text{utility of } Y = 1\\
    u_{2} := \text{utility of } Y = 2\\
    \vdots \\
    u_{k} := \text{utility of } Y = k
\end{cases}
\]

The utilities will usually be monotone increasing, such that each succesive level of the outcome is associated with equal or better utility. Alternatively, if lower values of the outcome are preferable (such as the NYHA class), utilities will usually be monotone decreasing.

### Mann-Whitney (M-W) Estimand

The Mann-Whitney estimand gives the probability that a randomly-selected person assigned to treatment of interest will have an outcome on the same level or a higher level than a randomly-selected person assigned to the comparator group, with ties broken at random:

$$ \theta_{MW} = P(\tilde{Y} > Y \vert \tilde{A} = 1, A = 0) + \frac{1}{2}P(\tilde{Y} = Y \vert \tilde{A} = 1, A = 0) = \sum_{j=1}^{K} \left\{ F(j-1 \vert 0) + \frac{1}{2} f(j \vert 0) \right\} f(j \vert 1) $$

If there is no difference in treatments, we would expect a randomly selected individual from one group to have a higher outcome than a randomly selected individual from the other group about half the time: the null value for this estimand is $1/2$.

Note that if higher numerical values indicate worse outcomes, like in the NYHA Class, the outcome scale can be reversed prior to analysis, so that the estimand can be interepreted as the probability that a randomly-selected person assigned to treatment of interest will have an outcome as good or better than a randomly-selected person assigned to the comparator group.

This estimand addresses a common concern of those choosing between treatment options, and may be easier to communicate to a lay audience.


### Log Odds Ratio (LOR)

In the case of a binary outcome, the odds ratio of a "good" outcome ($Y=1$) is $OR = odds(Y = 1 \vert A = 1)/odds(Y = 1 \vert A = 0)$: a value greater than 1 indicates a greater likelihood of a "good" outcome in the treatment of interest relative to the comparator group, and the log of the odds ratio will be positive. 

In the case of an ordinal outcome with categories $1, \ldots, K$, these categories can be collapsed into $(K-1)$ binary outcomes: $Y \le j$ for $j \in \{1, \ldots, (K-1) \}$. The odds ratio at threshold $j$ compares the odds of falling at or below level $j$ between the treatment of interest and the comparator group: 

$$ OR_{j} = \frac{odds(Y \le j \vert A = 1)}{odds(Y \le j \vert A = 0)} $$

When this odds ratio is greater than 1, individuals assigned to the treatment of interest are more likely to have outcomes at or below level $j$ than those in the comparator group: the log of this odds ratio will be positive. The log odds ratio estimand combines information across the levels of an ordinal outcome by averaging the log odds of an outcome at or below each threshold across all thresholds of the outcome:

$$ \delta_{LOR} = \frac{1}{K-1} \sum_{j=1}^{K-1} log \left( \frac{odds(Y \le j \vert A = 1)}{odds(Y \le j \vert A = 0)} \right) = \frac{1}{K-1} \sum_{j=1}^{K-1} log \left( \frac{F(j \vert 1)/ \left( 1 - F(j \vert 1) \right) } {F(j \vert 0)/ \left( 1 - F(j \vert 0) \right) } \right) $$

This estimand is related to the proportional odds logistic regression model, a common parametric model for analyzing ordinal outcomes. In the proportional odds model, a regression coefficient for treatment group gives the increase in the odds of being at or below a given level of the outcome associated with a unit increase in that variable holding all else constant:

$$ log(odds(Y \le j \vert A)) = logit \left(P(Y \le j \vert A) \right) =  \alpha_{j} + \beta A: \quad j \in \{1, \ldots, (K-1)\} $$

A positive slope indicates greater likelihood of lower scores in those assigned to receive the treatment of interest relative to the comparator group. The proportional odds assumption involves assuming that the treatment has the same effect across each binary threshold (i.e. that $\beta$ does not vary across the $K-1$ thresholds). When this assumption holds, the log odds ratio estimand is the same as the coefficient in the proportional odds model, but importantly, the validity of the LOR estimand does not depend on this assumption. As in binary and ordinal logistic regression, the null value for this estimand is 0.


Since $-log(a/b) = log(b/a)$ and $odds(Y > j \vert A = 1) = 1/odds(Y \le j \vert A = 1)$, changing the sign of the log odds ratio estimator tells us about the average log odds of having scores higher than level $j$ in the treatment of interest relative to the comparator group:

$$ -\delta_{LOR} = \frac{1}{K-1} \sum_{j=1}^{K-1} log \left( \frac{odds(Y > j \vert A = 1)}{odds(Y > j \vert A = 0)} \right) $$
