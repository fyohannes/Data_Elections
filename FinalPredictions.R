# Final Predictions

# Packages

library(readr)
library(statebins)
library(tidyr)
library(ggplot2)
library(dplyr)
library(maps)
library(googlesheets4)
library(usmap)
library(cowplot)
library(grid)
library(gridExtra)
library(statebins)
library(ggrepel)

# For the labeling of my map graph

library(broom)
library(statebins)
library(googlesheets4)
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


  


# Creating State by State Model

state_model <- lm(D_pv2p~ avg_support + growth_rate + GDP_growth_qt ,data=data_state)
summary(state_model)


# Creating a new data frame 

GDP_growth_qt <- c(2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1,2.1)
growth_rate <- c(8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9,8.9)
avg_support <- c(39,44,47,35,62,52,64,58,50,49,64,39,60,42,47,42,40,37,51,60,67,51,50,40,45,45,45,49,53,57,53,61,48,39,47,39,60,51,68,43,42,40,46,39,67,53,58,38,52,33)


# Trying Cass and Sun Young Code

states_list <- c("AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY")

new_data<- data.frame(states_list,GDP_growth_qt,growth_rate,avg_support)


result <- data.frame(state = states_list, predict_lower_bound = rep(NA, length(states_list)), predict_higher_bound = rep(NA,length(states_list)))

for (i in states_list){
  data_x <- subset(data_state,state==i)
  model <-lm(state_model,data_state)
  
  new_data1 <- subset(new_data, states_list==i)
  result[states_list == i, 2:3] <- predict(model, newdata = new_data1)
}

result


# Trial for state Alabama

result1 <- data.frame(state = states_list, predict_lower_bound = rep(NA, length(states_list)), predict_higher_bound = rep(NA,length(states_list)), fit = rep(NA,length(states_list)))

for (i in states_list){
  data_x1 <- subset(data_state,state==i)
  model1 <-lm(state_model,data_state)
  
  new_data2 <- subset(new_data, states_list==i)
  result[states_list == i, 2:3] <- predict(model, newdata = new_data1)
}

result


#### Function 

predict_function <- function(i){

trial <- data_state %>%
  filter(state==i)

trial_model <- glm(D_pv2p~avg_support + growth_rate + GDP_growth_qt ,data=trial)
summary(trial_model)

predict(trial_model, newdata = new_Data_trial)

}

for (i in states_list){ state_prediction <- predict_function(i) 
result1$fit[result1$state == i] <- state_prediction}

result1


# Weighted Ensamble with Loop Functions

new_data <- new_data %>%
  rename("state"=states_list)

states_predictions <- data.frame(state = states_list, predict_lower_bound = rep(NA, length(states_list)), predict_higher_bound = rep(NA,length(states_list)), fit = rep(NA,length(states_list)))

# The Model

poll_glm <- function(i){
  ok <- data_state %>%
    select(state,year,avg_support,D_pv2p,party) %>%
    filter(state == i) 
  glm(D_pv2p~ avg_support,data=ok)
}

econ1_glm <- function(i){
  ok <- data_state %>%
    select(state,year,growth_rate,D_pv2p,party) %>%
    filter(state == i) 
  glm(D_pv2p~growth_rate,data=ok)
}

econ2_glm <- function(i){
  ok <- data_state %>%
    select(state,year,GDP_growth_qt,D_pv2p,party) %>%
    filter(state == i) 
  glm(D_pv2p~GDP_growth_qt ,data=ok)
}

predict_function <- function(i){
  s_glm_econ1 <- econ2_glm(i)
  s_glm_poll <- poll_glm(i)
  s_glm_econ2 <- econ1_glm(i)
  
  Spoll <- new_data %>%
    select(state,avg_support)
  
  
  S_GDP <- new_data %>%
    select(state,GDP_growth_qt)

  
  S_fed <- new_data %>%
    select(state,growth_rate)

  
  state_prediction <- 0.92*predict(s_glm_poll,Spoll) + 
    0.02*predict(s_glm_econ1,S_fed) + 0.06*predict(s_glm_econ2,S_GDP) 
  
}

# loop through all states
for (i in states_list){
  state_prediction <- predict_function(i)
  states_predictions$fit[states_predictions$state == i] <- state_prediction
}

states_predictions




# Connecting with the Electoral College

  # Reading in Electoral College data 

gs4_deauth()
electoral_college <- read_sheet("https://docs.google.com/spreadsheets/d/1nOjlGrDkH_EpcqRzWQicLFjX0mo0ymrh8k6FaG0DRdk/edit?usp=sharing") %>%
  slice(1:51) %>%
  select(state, votes)

electoral_college$state <- state.abb[match(electoral_college$state, state.name)]

# Merging with predictons

pred <- states_predictions %>%
  left_join(electoral_college) 

pred1 <- pred %>%
  mutate(dem_win = ifelse(fit > 48, votes, 0)) %>%
  mutate(rep_win = ifelse(fit < 48, votes, 0)) %>%
  mutate(rep_ec = sum(rep_win)) %>%
  mutate(dem_ec = sum(dem_win))

pred1

pred1 %>%
  mutate(avg_dem=mean(fit))


# MAP

states_map <- map_data("state")
unique(states_map$region)


#  states_map$state<- state.abb[match(states_map$state, state.name)]

# Changing Pred dataframe to full state names to merge data

pred1$state <-state.name[match(pred1$state, state.abb)]

pred1$region <- tolower(pred1$state)
  

prediction_map <- pred1 %>%
  left_join(states_map, by = "region")

# Creating win margins 

map_prediction_dataframe <- prediction_map %>%
  mutate(R_pv = (100 - fit)) %>%
  mutate(win_margin = (fit -R_pv)) %>%
  mutate(dem_win = ifelse(win_margin >= -2, TRUE, FALSE))


map <- map_prediction_dataframe %>% ggplot(aes(long, lat, group = group)) +
  geom_polygon(aes(fill = win_margin), color = "black") +
  scale_fill_gradient2(
    high = "steelblue4", 
    name = "win margin",
    low = "red", 
    breaks = c(-50,-25,0,25,50), 
    limits=c(-52,52)
  ) +
  theme_void()  

map


# Adding state abbreivations 

centroids <- data.frame(region=tolower(state.name), long=state.center$x, lat=state.center$y)
centroids$abb<-state.abb[match(centroids$region,tolower(state.name))]

# Extra Map stuff

map2 <- map  +
  
  # Labeling the states so they fit the map and don't overlap
  
  geom_label(data = centroids,
             aes(x = long,y = lat, label = abb),
             force = 5, hjust = 1, size = 11,
             inherit.aes = F
  ) +
  
  
  # Add titles and different additions
  
  labs(fill =" Democratic Win Margin") +
  labs(title ="2020 Electoral College Predictions")+
  ggtitle("2020 Electoral College Predictions") +
  theme(plot.title = element_text(face = "bold",size=38)) +
  theme(plot.caption =element_text(face = "bold",size=32)) +
  theme(legend.title = element_text(color = "gray1", size = 29),legend.key.width = unit(1.9,"cm"),legend.key.size = unit(1.9, "cm")) + theme(legend.text=element_text(size=24)) 


ggsave("Electoral_Map.png", height = 16, width = 21)



# New Electoral Map with State Bins

ggplot(map_prediction_dataframe, aes(state = state, fill = dem_win)) + 
  geom_statebins(lbl_size = 10) + 
  theme_statebins() +
  scale_fill_manual(values=c("#F8766D","#619CFF")) +
  labs(title = "2020 Presidential Electoral College Map",
       subtitle = "Predicted by Poll data and Economic fundamentals",
       fill = "") + 
  theme(plot.title = element_text(size = 38, hjust = 0.5),
        plot.subtitle = element_text(size = 32, hjust = 0.5))
  guides(fill=FALSE)


ggsave("Electoral_Map2.png", height = 16, width = 21)



plot_usmap(data = map_prediction_dataframe, regions = "states", values = "win_margin") + 
  theme_void() +
  scale_fill_gradient2(
    high = "blue",
    mid = "white",
    low = "red", 
    breaks = c(-60, -40, -20, 0, 20, 40), 
    limits = c(-61, 50),
    name = "Win Margin") + 
  labs(title = "Predicted Win Margin of Two-Party Popular Vote Share",
       subtitle = "Weighted ensemble using historical polling accuracy 3-weeks out from 
       election day (0.1) and white population proportion (0.9)",
       caption = "Win margin is difference between Democratic and Republican 
       two-party popular vote share in each state.") + 
  theme(plot.title = element_text(size = 38, hjust = 0.5),
        plot.subtitle = element_text(size = 32, hjust = 0.5))


# Confidence Intervals for state by state prediction 

CI_function_se <- function(i){
  s_glm_econ2 <- econ2_glm(i)
  s_glm_poll <- poll_glm(i)
  s_glm_econ1 <- econ1_glm(i)

  
  Spoll <- new_data %>%
    select(state,avg_support)
  
  
  S_GDP <- new_data %>%
    select(state,GDP_growth_qt)
  
  
  S_fed <- new_data %>%
    select(state,growth_rate)



# loop through all states

prediction_CI_se <- 0.92*predict(s_glm_poll, Spoll, interval = "prediction", level = 0.95, type = "link", se.fit = TRUE)$se.fit + 
  0.02*predict(s_glm_econ1, S_fed, interval = "prediction", level = 0.95, type = "link", se.fit = TRUE)$se.fit + 
  0.06*predict(s_glm_econ2, S_GDP, interval = "prediction", level = 0.95, type = "link", se.fit = TRUE)$se.fit  
  

}

CI_function_fit <- function(i){
  s_glm_econ2 <- econ2_glm(i)
  s_glm_poll <- poll_glm(i)
  s_glm_econ1 <- econ1_glm(i)
  
  
  Spoll <- new_data %>%
    select(state,avg_support)
  
  
  S_GDP <- new_data %>%
    select(state,GDP_growth_qt)
  
  
  S_fed <- new_data %>%
    select(state,growth_rate)

  
  
  # loop through all states
  
  prediction_CI_se <- 0.92*predict(s_glm_poll, Spoll, interval = "prediction", level = 0.95, type = "link", se.fit = TRUE)$se.fit + 
    0.02*predict(s_glm_econ1, S_fed, interval = "prediction", level = 0.95, type = "link", se.fit = TRUE)$se.fit + 
    0.06*predict(s_glm_econ2, S_GDP, interval = "prediction", level = 0.95, type = "link", se.fit = TRUE)$se.fit  
  
  
}

for (i in states_list){
  CI_prediction_se <- CI_function_se(i)
  CI_prediction_fit <- CI_function_fit(i)
  
  critval <- 1.96 ## approx 95% CI
  
  states_predictions$lwr[states_predictions$state == i] <- CI_prediction_fit - (critval * CI_prediction_se)
  states_predictions$uppr[states_predictions$state == i] <- CI_prediction_fit + (critval * CI_prediction_se)
}


# Mutating my state predicitons

states_predictions %>%
  mutate(uppr=as.numeric(uppr)) %>%
  mutate(lwr=as.numeric(lwr)) %>%
  mutate(fit=as.numeric(fit))

states_predictions %>%
  group_by(state) %>%
  mutate(lower= sum(fit,lwr),drop = FALSE) %>%
  mutate(upper= sum(fit,uppr,drop = FALSE))


# Graphing the uncertainity

states_predictions$lwr <- unlist(states_predictions$lwr)

states_predictions$uppr <- unlist(states_predictions$uppr)

plotCI(x=1:num.reps,y=y,li=ci[1,],ui=ci[2,],col=z,lwd=3,ylim=c(2,4))

p1 <- ggplot(states_predictions, aes(x=state,y=fit))+
  geom_point()+
  geom_line(data=states_predictions)+
  geom_ribbon(data=states_predictions,aes(ymin=lwr,ymax=uppr),alpha=0.3)

p1


trial <- states_predictions %>%
  select(state,fit,uppr,lwr)

# GT Table


gt(trial) %>%
  tab_header(
    title = "State Predicitions and Predicted Confidence Intervals",
    subtitle = "2020 Presidential Election"
  ) %>%
  fmt_number(columns=2:4,decimals = 4) 

trial



















