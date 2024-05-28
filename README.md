Biofeedback Proof of Concept Study
================
2024-05-28

# Background

This study provides a proof of concept of two virtual reality
mini-games, to both teach participants a physiological regulation
technique and subsequently to apply this technique in a stressful
biofefeedback environment.

### Code

Analysis was conducted using R version 4.3.1. The main results are reported here, but can also be run indepdently by downloading the data files (in the /data folder) and the biofeedback-concept-paper.R script. 

Raw data are available, and analysis can be run using the biofeedback_systole.py script. There is also a short reshaping R script that transforms the Systole ouput into the csv files available in the /data folder.

### Study Design

Participants physiological measurements were taken at baseline (seated
at rest) as well as during the training (paced breathing training) and
stressor (biofeedback horror).

The physiological measurements reported here are Heart Rate (HR), heart
rate variability as indexed by SDNN, and respiration rate (resp).

Initial analysis was conducted using paired T tests for the HR, 
SDNN and respiratory differences from baseline to stressor.

        ## 
        ##  Paired t-test
        ## 
        ## data:  SDNN$SDNN_baseline and SDNN$SDNN_stress
        ## t = -4.6496, df = 43, p-value = 0.0000316
        ## alternative hypothesis: true mean difference is not equal to 0
        ## 95 percent confidence interval:
        ##  -4.199607 -1.658689
        ## sample estimates:
        ## mean difference 
        ##       -2.929148
        
        ## 
        ##  Paired t-test
        ## 
        ## data:  HR$HR_baseline and HR$HR_stress
        ## t = -3.3451, df = 43, p-value = 0.001714
        ## alternative hypothesis: true mean difference is not equal to 0
        ## 95 percent confidence interval:
        ##  -10.531906  -2.609312
        ## sample estimates:
        ## mean difference 
        ##       -6.570609
        
        ## 
        ##  Paired t-test
        ## 
        ## data:  resp$resp_baseline and resp$resp_stress
        ## t = 7.6115, df = 28, p-value = 0.00000002724
        ## alternative hypothesis: true mean difference is not equal to 0
        ## 95 percent confidence interval:
        ##  5.205657 9.039254
        ## sample estimates:
        ## mean difference 
        ##        7.122455

# Plots for Physiological change

## HR and cvSDNN change: baseline, training, stressor

![unnamed-chunk-3-1](figure-gfm/unnamed-chunk-3-1.png)
![unnamed-chunk-3-2](figure-gfm/unnamed-chunk-3-2.png)


## ANOVA for SDNN between conditions (supplement)

        ## ANOVA Table (type III tests)
        ## 
        ##     Effect DFn DFd      F           p p<.05  ges
        ## 1 category   2  86 17.289 0.000000489     * 0.13
        ## # A tibble: 3 × 10
        ##   .y.   group1   group2    n1    n2 statistic    df       p   p.adj p.adj.signif
        ## * <chr> <chr>    <chr>  <int> <int>     <dbl> <dbl>   <dbl>   <dbl> <chr>       
        ## 1 value baseline train…    44    44   -5.88      43 5.43e-7 1.63e-6 ****        
        ## 2 value baseline stres…    44    44   -4.65      43 3.16e-5 9.48e-5 ****        
        ## 3 value training stres…    44    44   -0.0636    43 9.5 e-1 1   e+0 ns

## HR And cvSDNN for baseline/stressor

![unnamed-chunk-5-1](figure-gfm/unnamed-chunk-5-1.png)

# Respiratory analysis

## Respiration change baseline to stressor

![unnamed-chunk-6-1](figure-gfm/unnamed-chunk-6-1.png)

## Histogram for respiratory adherence (4 breaths/min - actual breaths/min)

![unnamed-chunk-7-1](figure-gfm/unnamed-chunk-7-1.png)


## Correlation between the difference in respiration (stressor - baseline) 
## and the difference in SDNN (stressor - baseline)


    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  resp_cardio$resp_stress_bl_diff and resp_cardio$SDNN_stress_BL_diff
    ## t = 2.3725, df = 24, p-value = 0.02603
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  0.05835787 0.70430180
    ## sample estimates:
    ##       cor 
    ## 0.4358572


![unnamed-chunk-7-2](figure-gfm/unnamed-chunk-7-2.png)

# Questionnaire results

Showing the difference in stress score between the training and stressor
sessions, as well as correlations between self-reported stress score and
SDNN

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  quest$boat_score and quest$dungeon_score
    ## t = -11.341, df = 78.019, p-value < 2.2e-16
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -4.657785 -3.266744
    ## sample estimates:
    ## mean of x mean of y 
    ##  1.547170  5.509434
    
![unnamed-chunk-8-1](figure-gfm/unnamed-chunk-8-1.png)





