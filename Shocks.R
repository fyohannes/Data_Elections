# Shocks

# Packages

library(readr)
library(tidyr)
library(ggplot2)
library(dplyr)
library(maps)
library(cowplot)
library(grid)
library(gridExtra)
library(statebins)
library(ggrepel)

# For the labeling of my map graph

library(broom)
library(gt)

# For the regression summary table 

library(tidyverse)


# Loading the data, 

COVID <- read.csv("United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv")



# COVID State Data,prediction data using polls as the dependent variable

COVID <- COVID %>%
  mutate(submission_date=as.character(submission_date))

# made the submission date into a character variable

COVID <- COVID %>%
  
  # Mutating the months 
  
  mutate(date= ifelse(startsWith(submission_date,"02"), "February", 
                      ifelse(startsWith(submission_date,"03"), "March",
                      ifelse(startsWith(submission_date,"04"), "April", 
                      ifelse(startsWith(submission_date,"05"), "May",
                      ifelse(startsWith(submission_date,"06"), "June",
                      ifelse(startsWith(submission_date,"07"), "July",
                      ifelse(startsWith(submission_date,"08"), "August",
                      ifelse(startsWith(submission_date,"09"), "September",
                      ifelse(startsWith(submission_date,"10"), "October",NA))))))))))

COVID <- COVID %>%
  group_by(state,date) %>%
  mutate(total_cases_month=sum(conf_cases)) %>%
  mutate(total_deaths_month=sum(conf_death))


# Creating numeric variables for conf cases 


 


# Covid Cases in Swing States,North Carolina, WI, Arizona, USA, from May onwards

data1 <- COVID %>%
  group_by(date,state) %>%
  mutate(US =sum(total_cases_month)) 
  

Data1 <- data1 %>%
filter(state %in% c("NC","WI","AZ")) %>%
group_by(state) 

  
  
# Predictions


# Graph 

COVID %>%
  ggplot(aes(x=date,y=)) + geom_histogram(stat=count)


# Use new conf,new deaths for prediction models