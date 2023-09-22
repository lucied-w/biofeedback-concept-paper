library(tidyr)

dat <- read.csv("D:\\PhD\\Biofeedback\\Biofeedback Python Outputs\\Biofeedback_HR_HRV_outputs.csv")

ids<-c() #get IDs
for(i in 1:length(dat$p_id)){
  ids[i] <- substr(dat$p_id[i], 3,5)
}

###this is just a short code to take the data output from systole
## and reshape it into a more intuitive format for doing the analysis

sdnn_dat <- dat[c('p_id', 'SDNN')]
sdnn_dat <-cbind(sdnn_dat, ids)
sdnn_dat$p_id <- sub("PPG", "", sdnn_dat$p_id)
sdnn_dat$p_id <- sub(".csv", "", sdnn_dat$p_id)
sdnn_dat$p_id<-substring(sdnn_dat$p_id, 6)
sdnn<-spread(sdnn_dat, key=p_id, value=SDNN)
sdnn <- sdnn[complete.cases(sdnn),]

write.csv(sdnn, "D:\\PhD\\Biofeedback\\Biofeedback Python Outputs\\SDNN.csv")


hr_dat <- dat[c('p_id', 'MeanBPM')]
hr_dat <-cbind(hr_dat, ids)
hr_dat$p_id <- sub("PPG", "", hr_dat$p_id)
hr_dat$p_id <- sub(".csv", "", hr_dat$p_id)
hr_dat$p_id<-substring(hr_dat$p_id, 6)
HR<-spread(hr_dat, key=p_id, value=MeanBPM)
HR <- HR[complete.cases(HR),]

write.csv(sdnn, "D:\\PhD\\Biofeedback\\Biofeedback Python Outputs\\HR.csv")
