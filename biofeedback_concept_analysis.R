library(tidyr)
library(stats)
library(tidyverse)
library(ggpubr)
library(cowplot)
library(corrplot)
library(psych)
library(dplyr)
library(DescTools)
library(ggrain)


################## Read in data, normalise SDNN values ######

setwd("path")
resp <- read.csv("resp_percentages.csv")
quest <- read.csv("biofeedbackQuestionnaires.csv")

SDNN <- read.csv("SDNN.csv")
HR <- read.csv("HR.csv")
MeanRR <- read.csv("MeanRR.csv")

###cardiac measures are listed with ids from lowest to highest 
##so it's important to make sure that the other dataframes are too
##this is definitely not something I messed up before 
resp <- resp[order(resp$p_id),]
quest <- quest[order(quest$p_id),]


###normalising the SDNN data according to the calculation supplied in 
## de Geus et al 2019, psychophysiology 

SDNNnorm <- data.frame(p_id = SDNN$p_id)
SDNNnorm$SDNN_baseline <- 100 * (SDNN$SDNN_baseline / MeanRR$baseline)
SDNNnorm$SDNN_training <- 100 * (SDNN$SDNN_training / MeanRR$boat)
SDNNnorm$SDNN_stress <- 100 * (SDNN$SDNN_stress / MeanRR$dungeon)

SDNN <- SDNNnorm

###get rid of things we won't use again 
rm(SDNNnorm, MeanRR)

HR <- HR[complete.cases(HR),]
SDNN <- SDNN[complete.cases(SDNN),]


##### Calculating the difference measures

#Calculate the difference in stress rating between stressor and boat
quest$stress_diff <- quest$dungeon_score - quest$boat_score

#Difference in SDNN between training and baseline, and stressor and baseline
SDNN$SDNN_boat_BL_diff <- SDNN$SDNN_training - SDNN$SDNN_baseline
SDNN$SDNN_stress_BL_diff <- SDNN$SDNN_stress - SDNN$SDNN_baseline
SDNN$SDNN_training_stress_diff <- SDNN$SDNN_stress - SDNN$SDNN_training


#Difference in HR between training and baseline, and stressor and baseline
HR$HR_boat_BL_diff <- HR$HR_training - HR$HR_baseline
HR$HR_stress_BL_diff <- HR$HR_stress - HR$HR_baseline
HR$HR_training_stress_diff <- HR$HR_stress - HR$HR_training


##Paired t tests to see whether the difference from baseline to stress conditions is significant 
t.test(SDNN$SDNN_baseline, SDNN$SDNN_stress, paired = T)
t.test(HR$HR_baseline, HR$HR_stress, paired = T)

###Sign test for SDNN and respiration differences
SignTest(SDNN$SDNN_baseline, SDNN$SDNN_stress)
SignTest(resp$resp_baseline, resp$resp_stress)


################## PLOTS FOR RESP, HR, AND HRV CHANGE #########################
####This section is all ggplots for the graphs showing respiration, HR and HRV
### change.

cbbPalette <- c(  "#F0E442", "#0072B2", "#D55E00")
cbPalette <- c( "#0072B2", "#D55E00")

##ggplot for the heart rate data across the baseline, training and stressor 
gg_HR <- data.frame(value  = c(HR$HR_baseline, HR$HR_training, HR$HR_stress),
                   category = c(rep('baseline', 44), rep('training', 44), rep('stress', 44)),
                   paired = c(1:44, 1:44, 1:44))

##i hate ggplot
gg_HR$category <- factor(gg_HR$category, levels = c("baseline", "training", "stress"))


ggplot(gg_HR, aes(x= category, y=value, fill=category)) +
  geom_boxplot(show.legend = F)+
  # geom_point() is used to make points at data values
  geom_point(show.legend = F)+
  # geom_line() joins the pa"ired datapoints
  scale_fill_manual(values=cbbPalette)+
  ylab("Mean HR") +
  xlab("")+
  ggtitle("Mean HR in Baseline, Training and Stressor")+
  theme(panel.background = element_blank())


###plot for difference in heart rate between the baseline and stressor

gg_HR_stress_bl <- data.frame(value  = c(HR$HR_baseline, HR$HR_stress),
                   category = c(rep('baseline', 44), rep('stress', 44)),
                   paired = c( 1:44, 1:44))


###save the HR and SDNN plots so they can be combined into one image
HR_plot <- ggplot(gg_HR_stress_bl, aes(x=category, y=value, fill=category)) +
  geom_boxplot(show.legend = F)+
  # geom_point() is used to make points at data values
  geom_point(show.legend = F)+
  scale_fill_manual(values=cbPalette)+
  # geom_line() joins the paired datapoints
  geom_line(aes(group=paired),  alpha = 0.4) +
  ylab("Mean HR") +
  xlab("")+
  ggtitle("Mean HR for Baseline and Stressor")+
  theme(panel.background = element_blank())


gg_SDNN_stress_bl <- data.frame(value  = c(SDNN$SDNN_baseline, SDNN$SDNN_stress),
                          category = c(rep('baseline', 44), rep('stress', 44)),
                          paired = c( 1:44, 1:44))


SDNN_plot <- ggplot(gg_SDNN_stress_bl, aes(x=category, y=value, fill=category)) +
  geom_boxplot(show.legend = F)+
  # geom_point() is used to make points at data values
  geom_point(show.legend = F)+
  scale_fill_manual(values=cbPalette)+
  # geom_line() joins the paired datapoints
  geom_line(aes(group=paired),  alpha = 0.4) +
  ylab("SDNN") +
  xlab("")+
  ggtitle("Mean SDNN for Baseline and Stressor")+
  theme(panel.background = element_blank())


plot_grid(HR_plot, SDNN_plot, labels = "AUTO")

###respiration plot for resp change baseline to stressor 

gg_resp <- data.frame(value  = c( resp$resp_baseline, resp$resp_stress),
                   category = c(rep('baseline', 29), rep('stress', 29)),
                   paired = c( 1:29, 1:29))


###plot of all ps for whom we have resp data - change in breathing rate from baseline to dungeon
ggplot(gg_resp, aes(x=category, y=value, fill=category)) +
  geom_boxplot(show.legend = F)+
  # geom_point() is used to make points at data values
  scale_fill_manual(values=cbPalette)+
  geom_point(show.legend = F)+
  # geom_line() joins the paired datapoints
  geom_line(aes(group=paired), alpha = 0.4) +
  ylab("Resp rate") +
  xlab("")+
  ggtitle("Mean Respiration rate for Baseline and Stressor")+
  theme(panel.background = element_blank())


rm(gg_HR, gg_HR_stress_bl, gg_resp, gg_SDNN_stress_bl, HR_plot, SDNN_plot)

##################

################### RESPIRATORY ANALYSIS #############

###calculate adherence - deviation from 4 breaths per min 
adherence <- data.frame("p_id" = resp$p_id)
adherence$ad_training <- 4 - resp$resp_training
adherence$ad_stress <- 4 - resp$resp_stress
adherence$ad_training_stress_diff <- adherence$ad_stress - adherence$ad_training


SDNN_resp <- SDNN[(SDNN$p_id %in% resp$p_id),] ##subset the SDNN dataframe by the ps who have resp
resp_SDNN <- resp[(resp$p_id %in% SDNN$p_id), ] ## make sure the breaths have corresponding cardio measures
HR_resp <- HR[(HR$p_id %in% resp$p_id),] ##ditto with the HR
adherence_resp <- adherence[(adherence$p_id %in% resp_SDNN$p_id),]

##merge together into one dataframe for the correlations/plots
resp_cardio <- merge(SDNN_resp, resp_SDNN, by = 'p_id')
resp_cardio <- merge(resp_cardio, HR_resp, by = 'p_id')
resp_cardio <- merge(resp_cardio, adherence_resp, by = "p_id")

rm(SDNN_resp, resp_SDNN, HR_resp, adherence_resp)

###corrlating the SDNN differences in stressor/baseline condition with resp differences in stress/bl
###neither of these show much 
cor.test(resp_cardio$resp_stress_bl_diff, resp_cardio$SDNN_stress_BL_diff)
cor.test(resp_cardio$resp_stress_bl_diff, resp_cardio$HR_stress_BL_diff)

###plotting the correlation between resp rate and SDNN
ggscatter(resp_cardio, x = 'resp_stress_bl_diff', y = 'SDNN_stress_BL_diff',
          add = "reg.line", conf.int = TRUE,
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Difference in resp rate (dungeon - baseline)", ylab = "SDNN diff (dungeon - baseline)")


###checking ps with/without resp data
no_resp <- SDNN[!(SDNN$p_id %in% resp$p_id),]$p_id ###identify ids of those without resp data
resp_no_dat <- quest[(quest$p_id %in% no_resp),] ###identify ids of those with resp data
HR_no_resp <-  HR[(HR$p_id %in% no_resp),]
HR_resp <- HR[(HR$p_id %in% resp$p_id),]


quest <- quest[complete.cases(quest),]
quest_resp <- quest[(quest$p_id %in% resp$p_id),] ##subset the questionnaire dataframe by the ps who have resp


resp_no_resp <- data.frame('no_resp_anx_mean' = mean(resp_no_dat$trait_anx),
                           'no_resp_anx_sd' = sd(resp_no_dat$trait_anx),
                           'no_resp_age_mean' = mean(resp_no_dat$age),
                           'no_resp_age_sd' = sd(resp_no_dat$age),
                           'no_resp_fem' = sum(resp_no_dat$gender == 1)/(nrow(resp_no_dat)),
                           'no_resp_HR' = mean(HR_no_resp$HR_baseline),
                           'resp_anx_mean' = mean(quest_resp$trait_anx),
                           'resp_anx_sd' = sd(quest_resp$trait_anx),
                           'resp_age_mean' = mean(quest_resp$age),
                           'resp_fem' = sum(resp$gender == 1)/(nrow(resp)),
                           'resp_HR' = mean(HR_resp$HR_baseline, na.rm = T))

rm(no_resp, resp_no_dat, HR_no_resp, HR_resp)                           
                           


################### QUESTIONNAIRE ANALYSES ################

##sanity check - is there a difference in qualitative stressor/training stress ratings? 
t.test(quest$boat_score, quest$dungeon_score)

resp <- merge(resp, quest_resp, by = "p_id")
rm(quest_resp)

##make sure the rest of the questionnaires match up to the cardiac variables
quest <- quest[(quest$p_id %in% SDNN$p_id),]


####plotting the stress scores 
gg_stress <- data.frame(value  = c(quest$boat_score, quest$dungeon_score),
                      category = c(rep('training', 44), rep('stress', 44)),
                      paired = c( 1:44, 1:44))


ggplot(gg_stress, aes(x=reorder(category, value), y=value, fill=category)) +
  geom_boxplot(show.legend = F)+
  scale_fill_manual(values=cbPalette)+
  # geom_point() is used to make points at data values
  # geom_line() joins the paired datapoints
  ylab("Stress score (1-10)") +
  xlab("")+
  ggtitle("Stress scores for training and stress")+
  theme(panel.background = element_blank())

gg_mindset <- data.frame(value  = c(quest$preTOAScore, quest$postTOAScore),
                         category = c(rep('Pre', 44), rep('Post', 44)),
                         paired = c(1:44, 1:44))

ggplot(gg_mindset, aes(x = reorder(category, value), y=value, fill=category)) +
  geom_rain(show.legend = F)+
  scale_fill_manual(values=cbPalette)+
  xlab("Pre/Post biofeedback") +
  ylab("TOA Score") +
  ggtitle("Changes in TOA score pre/post biofeedback")+
  theme(panel.background = element_blank())


t.test(quest$preTOAScore, quest$postTOAScore, paired = T)

##dataframe for cardiac and questionnaire measures
cardio_quest <- merge(SDNN, quest, by = "p_id")
cardio_quest <- merge(cardio_quest, HR, by = "p_id")

##correlating stress difference and SDNN difference 
cor.test(cardio_quest$stress_diff, cardio_quest$SDNN_training_stress_diff)

ggscatter(cardio_quest, x = 'stress_diff', y = 'SDNN_training_stress_diff',
          add = "reg.line", conf.int = TRUE,
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Difference in stress rating (stress - training)", ylab = "SDNN diff (stress - training)")


##correlating the stress rating differences and the HR difference 
cor.test(cardio_quest$stress_diff, cardio_quest$HR_training_stress_diff)


##creating dataframes for the correlation matrices 

SDNN_cor_mtx <- cardio_quest %>% select(SDNN_stress_BL_diff, SDNN_training_stress_diff, bdi,
                                        state_anx, trait_anx, maiaNoticing, maiaNotDistracting, maiaNotWorrying, 
                                        maiaAttentionReg, maiaEmotionalAware, maiaSelfReg, maiaBodyListening,
                                        maiaTrusting, horrorenjoyment, stress_diff)
resp_cor_mtx <- resp %>% select(resp_stress_bl_diff,  bdi, state_anx, trait_anx, maiaNoticing, maiaNotDistracting,
                                maiaNotWorrying, maiaAttentionReg, maiaEmotionalAware, maiaSelfReg, maiaBodyListening,
                                maiaTrusting, stress_diff)

###correlation matrices for the questionnaires and the resp /cardio data 
SDNN_cor_out <- corr.test(SDNN_cor_mtx)

###plot correlation matrix with unadjusted p values 
corrplot(SDNN_cor_out$r, method = "circle", type = "lower", tl.col = "black",
         p.mat = SDNN_cor_out$p, sig.level = 0.05, insig = "blank")

###plot correlation matrix with adjusted p value 
corrplot(SDNN_cor_out$r, method = "circle", type = "upper", tl.col = "black",
         p.mat = SDNN_cor_out$p, sig.level = 0.05, insig = "blank")



##respiration correlation matrix
resp_cor_out <- corr.test(resp_cor_mtx)

###plot correlation matrix without p value adjustment
corrplot(resp_cor_out$r, method = "circle", type = "lower", tl.col = "black",
         p.mat = resp_cor_out$p, sig.level = 0.05, insig = "blank")

cor.test(resp$resp_stress_bl_diff, resp$maiaAttentionReg)

##plot correlation matrix after correction for multiple comparisons 
corrplot(resp_cor_out$r, method = "circle", type = "upper", tl.col = "black",
         p.mat = resp_cor_out$p, sig.level = 0.05, insig = "blank")



###################



