Biofeedback Proof of Concept Study
================
2023-09-19

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

![unnamed-chunk-3-1](https://github.com/lucied-w/biofeedback-concept-paper/assets/145454288/acaef536-3c1c-4e3b-b95b-d1ef0eb11747)
![unnamed-chunk-3-2](https://github.com/lucied-w/biofeedback-concept-paper/assets/145454288/c26cc860-963f-4b0b-a922-9b11055bbf21)


## HR And cvSDNN for baseline/stressor

![unnamed-chunk-4-1](https://github.com/lucied-w/biofeedback-concept-paper/assets/145454288/913d3082-ff23-426d-87cd-f16fc29adf1a)

# Respiratory analysis

## Respiration change baseline to stressor

![unnamed-chunk-5-1](https://github.com/lucied-w/biofeedback-concept-paper/assets/145454288/5881bc6e-7d63-4fd2-b594-adbc1e2784c6)


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


![unnamed-chunk-6-1](https://github.com/lucied-w/biofeedback-concept-paper/assets/145454288/ccada796-fc56-414e-8f60-3e3b9a6d87bd)

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
    
![unnamed-chunk-7-1](https://github.com/lucied-w/biofeedback-concept-paper/assets/145454288/083f8b13-2d6f-4e6c-8a68-349d2c174e8d)





    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  cardio_quest$stress_diff and cardio_quest$SDNN_training_stress_diff
    ## t = 3.5549, df = 42, p-value = 0.0009513
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  0.2147043 0.6806305
    ## sample estimates:
    ##       cor 
    ## 0.4809295

![](biofeedback_concept_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

