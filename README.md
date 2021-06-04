# UDMPPM

This app displays the Persistence Probability model results for each year as a table and a separate table with persistence probabilities for the most recent years for each location.

## Single Species Persistence Probability Model

To obtain persistence probabilities use could consider annual occurrence data for the time period. The Bayesian formulation of Solow's (1993) equation was used to calculate the posterior probability (p) of the species being extant (Ree and McCarthy, 2005).

```r
 p = 1/(1+(1+[(T/t)^(N-1)-1])/((N-1)))
 
```

Assumed that the prior probability of the species being extant in the last year is 0.5. This prior probability is the probability of the species being extant in the last year of recording prior to considering the count data. In this formula, N is the number of years in which the species was recorded between year 0 and year T and the t is the year when the species was last recorded. The probability of persistence (p) is a score between 0 and 1.0 which is assessed in each area. The probability of persistence (p = 1) means the species  certain to be persistent at the end of the recording period, (p >= 0.5) means it is more likely to be extant in that area rather than extinct, and (p < 0.5) means it is more likely to be extinct than extant.

## Reference

van der Ree, Rodney & Mccarthy, Michael. (2005). Inferring persistence of indigenous mammals in response to urbanisation. Animal Conservation. 8. 309 - 319. 10.1017/S1367943005002258. 

## Installation:

- Users can launch the application by https://udani-wijewardhana.shinyapps.io/UDMPPM/.
- Users can access the GitHub repository by https://github.com/uwijewardhana/UDMPPM.

```r
Authors:

Udani A. Wijewardhana1, Madawa Jayawardana1, 2, 3, Denny Meyer1

1 Department of Statistics, Data Science and Epidemiology, Swinburne University of Technology, Hawthorn, Victoria, Australia
2 Peter MacCallum Cancer Centre, Melbourne 3000 Victoria, Australia
3 Sir Peter MacCallum Department of Oncology, The University of Melbourne, Parkville 3010 Victoria, Australia

* uwijewardhana@swin.edu.au
```

