# Final Predictions

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
library(statebins)
library(gt)

# For the regression summary table 

library(tidyverse)




# Creating the Final model--- using poll averages, economic data, and change in federal grants

# Merging the data

data_ <- popvote %>% 
  full_join(poll_national %>% 
              group_by(year,party) %>% 
              
# Filtering for 9 weeks or less 
  
              filter(weeks_left < 9) %>%
              summarise(avg_support=mean(avg_support))) %>% 
  left_join(economy %>% 
              filter(quarter == 4))

# Question, does this mean q4 for 2019 or for 2020?

# Changing dataset for fed grants so its at a national level, data fedgrants 2 was altered in the Incumbency.R file, look at that file to see creation of new variables

fedgrants_2 <- fedgrants_df %>% 
  filter(!is.na(state_year_type)) %>%
  
  # Calculating change in percentages 
  
  mutate(growth_rate= grant_mil - lag(grant_mil)) %>%
  
  # Filtering for only election years
  
  filter(elxn_year==1) %>%
  group_by(year,state_year_type) %>%
  
  # Calculating 
  mutate(total_growth_rate=mean(growth_rate)) 

# Distinct Growth Rate for Nationally 

fed_grants <-fedgrants_2 %>%
  distinct(total_growth_rate,.keep_all = TRUE)

# Merging final dataset together

data_final <- full_join(fed_grants,data_,by="year")

# Filtering for Incumbent Parties Only

data_final <- data_final %>%
filter(incumbent_party=="TRUE")


# Create Model

national_model <- lm(pv~avg_support + total_growth_rate + GDP_growth_qt ,data=data_final)
summary(national_model)

# Creating Table for National Model

table_national_model<- tidy(national_model)

gt(table_national_model) %>%
  tab_header(
    title = "Economic and Poll Support variables on Presidential Outcomes",
    subtitle = "1948-2016"
  ) %>%
  fmt_number(columns=2:4,decimals = 4) 

table_national_model


##2020 Outcome, 44.95451 for the PV for Trump

-3.00172 + 1.096*(43.1) + 0.06789*(8.9) +0.05448*(2.1)


# Out of Sample Validation for Gore, prediction: 44.0366, true 48.1

national_model <- lm(pv~avg_support + total_growth_rate + GDP_growth_qt ,data=data_final)
outsamp_mod  <- lm(pv ~ avg_support+total_growth_rate +GDP_growth_qt,data_final[data_final$year!= 2000,])
outsamp_pred <- predict(outsamp_mod, data_final[data_final$year == 2000,])

# Averaging the prediction vote share values

outsamp <- mean(outsamp_pred)
outsamp_true <- data_final$pv[data_final$year == 2000] 


# Out of Sample Validation for Bush, prediction: 45.0366, true 50.6


outsamp_mod3  <- lm(pv ~ avg_support+total_growth_rate +GDP_growth_qt,data_final[data_final$year!= 2004,])
outsamp_pred3 <- predict(outsamp_mod, data_final[data_final$year == 2004,])

# Averaging the prediction vote share values

outsamp3 <- mean(outsamp_pred3)
outsamp_true3 <- data_final$pv[data_final$year == 2004] 



# Out of Sample Validation 2008 McCain, prediction:45.3866, true: 45.4


outsamp_mod2  <- lm(pv ~ avg_support+total_growth_rate +GDP_growth_qt,data_final[data_final$year!= 2008,])
outsamp_pred2 <- predict(outsamp_mod, data_final[data_final$year == 2008,])

# Averaging the prediction vote share values

outsamp2 <- mean(outsamp_pred2)
outsamp_true2 <- data_final$pv[data_final$year == 2008] 


# Out of Sample Validation 2012 Obama, prediction:, true: 45.4


outsamp_mod4  <- lm(pv ~ avg_support+total_growth_rate +GDP_growth_qt,data_final[data_final$year!= 1996,])
outsamp_pred4 <- predict(outsamp_mod, data_final[data_final$year == 1996,])

# Averaging the prediction vote share values

outsamp4 <- mean(outsamp_pred4)
outsamp_true4 <- data_final$pv[data_final$year == 1996] 


# Looking at Fitted Variables

res_national <- qplot(fitted(national_model), resid(national_model),size=I(11)) +
  geom_smooth()
res_national+geom_hline(yintercept=0) + 
  labs(title ="Fitted vs. Residuals",
       subtitle="Exploring Fit for National Model of 2020 Presidential Outcome Outcome",
       x="Fitted",y= "Residuals") +
  theme(plot.title = element_text(face = "bold",size=35))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 26, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain")) 

ggsave("national_residuals.png", height = 13, width = 21)



# Confidence Intervals Graph and Models for 2020

# Creating 2020 data frame

dat_2020_inc <- data.frame(GDP_growth_qt = 2.1, avg_support = 43.1,total_growth_rate=8.9)


## Point predictions for 2020 using our national model

predict(national_model, newdata = dat_2020_inc)


## Prediction intervals for Trump Vote Share

(pred_plus_inc <- predict(national_model, dat_2020_inc, 
                          interval = "prediction", level=0.95))





### STATE BY STATE MODEL


# Merging the data 

data2 <- pvstate_df %>% 
  full_join(poll_state_df %>% 
              group_by(year,party) %>% 
              filter(weeks_left<9) %>%
              summarise(avg_support=mean(avg_poll))) %>% 
  left_join(economy %>% 
              filter(quarter == 4))

# Joined data becuase I wanted a variable for incumbent party

data3 <- data2 %>%
  full_join(popvote)

# Changing state name for fedgrants

fedgrants_3 <- fedgrants_2 %>%
  rename("state"=state_abb)

# Merging fed grants into the data

data_state <- data3 %>%
  left_join(fedgrants_3,by=c("state","year"))

data_state <- data_state %>%
  filter(incumbent_party=="TRUE")
  


# Creating State by State Model

state_model <- lm(D_pv2p~avg_support + growth_rate + GDP_growth_qt ,data=data_state)
summary(state_model)


# Creating a new data frame 

GDP_growth_qt <- c(2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1)
growth_rate <- c(8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9)
avg_support <- c(39,44,47,35,62,52,64,58,50,49,64,39,60,42,47,42,40,37,51,60,67,51,50,40,45,45,45,49,53,57,53,61,48,39,47,39,60,51,68,43,42,40,46,39,67,53,58,38,52,33)


# Trying Cass Code

states_list <- c("AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY")

new_data<- data.frame(states_list,GDP_growth_qt,growth_rate,avg_support)


result <- data.frame(state = states_list, predict_lower_bound = rep(NA, length(states_list)), predict_higher_bound = rep(NA,length(states_list)))

for (i in states_list){
  data_x <- subset(data_state,state==i)
  model <-lm(state_model,data_state)
  
  # new_data <- subset(data_state, state==i & year == 2020)
  result[states_list == i, 2:3] <- predict(state_model, newdata = new_data)
}

result


# State Prediction Interval
















predict_function <- function(s){
  s_glm_covid <- state_model
  
  Scovid <- day7_covid_rates %>%
    filter(state == s)
  
  state_prediction <- predict(s_glm_covid, Scovid)
}

# loop through all the states
for (s in states_list){
  state_prediction <- predict_function(s)
  states_predictions$predictions[states_predictions$state == s] <- state_prediction
  
}














# Map data

states_map <- ggplot2::map_data("state")

map_theme = function() {
  theme(axis.title = element_blank()) +
    theme(axis.text = element_blank()) +
    theme(axis.ticks = element_blank()) + 
    theme(legend.title = element_blank()) +
    theme(panel.grid.major = element_blank())
  
}

states_list <- c("AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY")
                 
                 








