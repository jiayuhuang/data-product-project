setwd("f:/gvis")
cleaned_dat <- read.csv("cleaned_pediatric.csv")
listed_disease <- levels(as.factor(cleaned_dat$disease))
listed_zip <- levels(as.factor(cleaned_dat$zip_code))
