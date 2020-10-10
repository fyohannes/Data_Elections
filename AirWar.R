# Air War

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

creative <- read_csv("ad_creative_2000-2012.csv",col_types = cols(
  creative = col_character(),
  party = col_character(),
  ad_issue = col_character(),
  cycle = col_double(),
  ad_purpose = col_character(),
  ad_tone = col_character()
))
  
campaign <- read_csv("ad_campaigns_2000-2012.csv",col_types = cols(
  air_date = col_date(format = ""),
  party = col_character(),
  sponsor = col_character(),
  state = col_character(),
  creative = col_character(),
  n_markets = col_double(),
  n_stations = col_double(),
  total_cost = col_double(),
  after_primary = col_double(),
  cycle = col_double()
))

# Ad Issue by Party and by Year
# Selecting top 8

creative1 <- creative %>%
  filter(cycle==2000) %>%
  group_by(party,cycle) %>%
  select(ad_issue) %>%
  top_n(n=8) 

c_2000 <- creative1 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,fill=Color)) +geom_bar(stat = "count") +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2000 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  +
  labs(fill = "Party") 


###### plot 2,2004

creative2 <- creative %>%
  filter(cycle==2004) %>%
  group_by(party,cycle) %>%
  select(ad_issue) %>%
  top_n(n=8) 




c_2004 <- creative2 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,fill=Color)) +geom_bar(stat = "count") +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2004 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  +
  labs(fill = "Party") 

###### plot 3,2008

creative3 <- creative %>%
  filter(cycle==2008) %>%
  group_by(party,cycle) %>%
  select(ad_issue) %>%
  top_n(n=8) 

c_2008 <- creative3 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,fill=Color)) +geom_bar(stat = "count") +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2008 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  +
  labs(fill = "Party") 

###### plot 3,2008

creative4 <- creative %>%
  filter(cycle==2012) %>%
  group_by(party,cycle) %>%
  select(ad_issue) %>%
  top_n(n=8) 

c_2012 <- creative4 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,fill=Color)) +geom_bar(stat = "count") +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2008 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  +
  labs(fill = "Party") 



# Plot grid 2000,2004

plot_grid(c2000,c2004)

ggsave("ad_issues_00_04.png", height = 12, width = 18)

# Plot grid 2008,2012

plot_grid(c_2008,c_2012)

ggsave("ad_issues_08.png", height = 12, width = 18)


########################### Using Partial Data for 2020

ad_2020 <- read_csv("ads_2020.csv",col_types = cols(
  state = col_character(),
  period_startdate = col_date(format = ""),
  period_enddate = col_date(format = ""),
  biden_airings = col_double(),
  trump_airings = col_double(),
  total_airings = col_double(),
  total_cost = col_double()
))

vep_df <- read_csv("vep_1980-2016.csv",col_types = cols(
  year = col_double(),
  state = col_character(),
  VEP = col_double(),
  VAP = col_double()
))

#### National model, filtering for just the United States

pvstate_df %>%
  


poll_pvstate_vep_df <- popvote %>%
  inner_join(poll_national %>% filter(weeks_left == 5)) %>%
  left_join(vep_df %>% filter(state=="United States"))

# Model 1, national 

  model1_df <- 
    poll_pvstate_vep_df %>%
    filter(incumbent_party=="TRUE") %>%
    mutate(total= (VEP + VAP)) %>%
    mutate(D= (VEP/total)) %>%
    as_factor(D)
  
  mode1_df$
    
    
# Need this for regression, specific to Republicans 
  
# Model for Trump 2020

  model_fedgrants <- glm(pv~avg_support + grant_mil,data=model1_df)


glm(pv~ avg_support + D,model1_df, family = binomial)

