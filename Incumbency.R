Incumbency and Federal Grants


# Packages

library(readr)
library(tidyr)
library(ggplot2)
library(dplyr)
library(maps)
library(cowplot)
library(grid)
library(ggrepel)

# For the labeling of my map graph

library(broom)
library(gt)

# For the regression summary table 

library(tidyverse)


# Loading the data

fedgrants_df  <- read_csv("fedgrants_bystate_1988-2008.csv",col_types = cols(
  state_abb = col_character(),
  year = col_double(),
  elxn_year = col_double(),
  state_year_type = col_character(),
  state_year_type2 = col_character(),
  grant_mil = col_double(),
  state_incvote_avglast3 = col_double()
))

poll_national <- read_csv("pollavg_1968-2016.csv",col_types = cols(
  year = col_double(),
  party = col_character(),
  candidate_name = col_character(),
  poll_date = col_date(format = ""),
  weeks_left = col_double(),
  days_left = col_double(),
  before_convention = col_logical(),
  avg_support = col_double()
))


# First graphic 
 
one <- popvote %>% 
  mutate(Winner=ifelse(winner==TRUE,1,0)) %>%
  mutate(incumbent_wins= ifelse(incumbent_party==TRUE & winner==TRUE,1,0)) %>%
  mutate(wins=sum(winner=TRUE)) %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=party,y=incumbent_wins,fill=Color)) +geom_col() +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red"))  +
  labs(title ="Incumbent Party Wins in Presidential Elections from 1948 to 2016",
       subtitle="Exploring Popular Vote Wins by Democrats and Republicans",
       x="Party",y= "Number of Incumbent Wins") +
  theme(plot.title = element_text(face = "bold",size=30))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  labs(fill = "Party that Won the Popular Vote") +
  theme(axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 26, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain")) 


ggsave("incumbent_historical.png", height = 13, width = 21)

  
  

# Second Graphic

fedgrant1 <- fedgrants_df %>%
  filter(year > 1996) %>%
  filter(!is.na(state_year_type)) %>%
  group_by(state_year_type) %>%
  mutate(average_grant=mean(grant_mil)) %>%
  mutate(new_grant=grant_mil/1000) %>%
  mutate(election_year = ifelse(elxn_year==1,"Election Year","Non Election Year")) %>%
  distinct() %>%
  ggplot(aes(x=state_year_type,y=new_grant)) +geom_col(fill="green4") +
  labs(title ="Total Federal Grants 2000 to 2016",
       subtitle="Why do some years see a spike in Federal Grants?",
       x="Election Year",y= "Total Dollar Amount of Federal Grants in Billions")

# Creating Baseline Data for Model

# Merging the data from last week with economic and poll data  

data_model <- popvote %>% 
  full_join(poll_national %>% 
              group_by(year,party) %>% 
              
              # Filtering for 9 weeks
              
              filter(weeks_left==9) %>%
              summarise(avg_support=mean(avg_support))) %>% 
  left_join(economy %>% 
              filter(quarter == 2))


data <- full_join(fedgrants_df,data_model,by="year")



# Filtering for incumbent party

data <- data %>%
  filter(incumbent_party==TRUE)

# Creating a Model 

model_fedgrants <- lm(pv~avg_support + grant_mil,data=data)
summary(model_fedgrants)


# National Average data

 fedgrants_2 <- fedgrants_df %>% 
   filter(!is.na(state_year_type)) %>%
  group_by(year,state_year_type) %>%
  mutate(total_year_grant=sum(grant_mil)) 
 
 
 # New joined data
 
 data2 <- full_join(fedgrants_2,data_model,by="year")
 
 data2 <- data2 %>%
   filter(incumbent_party==TRUE)
 
 #National Model
 
 model_fedgrants_2 <- lm(pv~avg_support + total_year_grant,data=data2)
 summary(model_fedgrants_2)
 
 

# Table
 
 
 table_poll<- tidy(model_fedgrants_2)
 
 gt(table_poll) %>%
   tab_header(
     title = "Federal Grants and Poll Support for Re-Election for Incumbant Parties",
     subtitle = "1984-2008"
   ) %>%
   fmt_number(columns=2:4,decimals = 4) 
 
 table_poll
 
 
 
 # Model Testing, Bush 2004
 
 as.data.frame(data2)
 
 
 outsamp_mod  <- lm(pv ~ avg_support+total_year_grant,data2[data2$year!= 2004,])
 outsamp_pred <- predict(outsamp_mod, data2[data2$year == 2004,])
 outsamp_true <- data2$pv[data2$year == 2004] 
 
 
 
 # Predicted Bush with 50.57049 of the vote share, reality was 50.57049
 
 
 #Graphing Residuals
 
 res <- qplot(fitted(model_fedgrants_2), resid(model_fedgrants_2)) +
   geom_smooth()
 res+geom_hline(yintercept=0) + 
   labs(title ="Fitted vs. Residuals",
        subtitle="Exploring Fit for Model that uses Fed Grants and Popular Vote Share to Predict Election Outcome",
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
 
 
 ggsave("incumbent_residuals.png", height = 13, width = 21)
 
   


 # Model Prediction for Donald Trump 2020
 
 
 model_fedgrants_2 <- lm(pv~avg_support + total_year_grant,data=data2)
 summary(model_fedgrants_2)
 
 -5.6278266 +  (1.2011186*41) +
 
 




