
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



# Reading in the local economy

economy_local <- read_csv("local.csv",col_types = cols(
  X1 = col_double(),
  `FIPS Code` = col_character(),
  `State and area` = col_character(),
  Year = col_double(),
  Month = col_character(),
  Population = col_double(),
  LaborForce = col_double(),
  LaborForce_prct = col_double(),
  Employed = col_double(),
  Employed_prct = col_double(),
  Unemployed = col_double(),
  Unemployed_prce = col_double()
))

# Reading in the national economy 

economy <- read_csv("econ.csv",col_types = cols(
  year = col_double(),
  quarter = col_double(),
  date = col_date(format = ""),
  GDP = col_double(),
  GDP_growth_qt = col_double(),
  GDP_growth_yr = col_double(),
  RDI = col_double(),
  RDI_growth = col_double(),
  inflation = col_double(),
  unemployment = col_double(),
  stock_open = col_double(),
  stock_close = col_double(),
  stock_volume = col_double()
))


# Merged data for incumbant party

data1 <- popvote %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p,party) %>%
  left_join(economy %>% filter(quarter == 2)) %>%
  
  
  # Mutate to get colors for graph
  
  mutate(Color = ifelse(party == "democrat", "blue", "red"))

# Graphing first graph 


 data1 %>%
  ggplot(aes(x=GDP_growth_qt,y=pv2p,label=year,color=party)) +
  labs(title ="Quarter 2 GDP Growth Rate and Re-Election for Incumbent Parties ",
       subtitle="Presidential Elections 1948-2016",
       x="Q2 GDP Growth Rate (%)",y= "Popular Vote Share (%)",
       caption= "Source: Economic Analysis, US Bureau of Department of Commerce \n Caption: Democrats noted by blue, Republicans by red")+
  geom_text(size=14,show.legend = FALSE) +
  geom_smooth(method = "lm", se = FALSE,formula = y ~ x,aes(group=1),colour="black") +
  scale_color_manual(values = c("democrat" = "blue", "republican" = "red")) + 
  labs(color = "Party") +
theme(plot.title = element_text(face = "bold",size=30))+
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


ggsave("incumbant_economy.png", height = 13, width = 21)


# Make Predictions

# Create Model 1 

lm_econ1 <- lm(pv2p ~ GDP_growth_qt, data = data1)

# Create Dataset 1

data1_new <-economy %>%
  subset(year == 2020 & quarter == 2) %>%
  select(GDP_growth_qt)

# Make Prediction 1

predict(lm_econ1, data1_new)


# Predictions Pre-Corona

# Make Predictions

# Create Model 1 

lm_econ1b <- lm(pv2p ~ GDP_growth_qt, data = data1)

# Create Dataset 1

data1_newb <-economy %>%
  subset(year == 2019 & quarter == 4) %>%
  select(GDP_growth_qt)

# Make Prediction 1

predict(lm_econ1b, data1_newb)




# Dataset for Incumbant Party= FALSE

data2 <- popvote %>% 
  filter(incumbent_party == FALSE) %>%
  select(year, winner, pv2p,party) %>%
  left_join(economy %>% filter(quarter == 2)) %>%
  
  mutate(Color = ifelse(party == "democrat", "blue", "red"))

 # Creating Graph 2


data2 %>%
  ggplot(aes(x=GDP_growth_qt,y=pv2p,label=year,color=party))  +
  labs(title ="Quarter 2 GDP Growth Rate and Elections for Non-Incumbent Parties",
       subtitle="Presidential Elections 1948-2016",
       x=" Q2 GDP Growth Rate (%)",y= "Popular Vote Share(%)",
       caption= "Source:Economic Analysis, US Bureau of Department of Commerce \n Caption: Democrats noted by blue, Republicans by red") +
  scale_fill_manual(labels=c("Democrat", "Republican"),values = c("democrat", "republican")) +
  labs(color="Party")+
  geom_text(size=14,show.legend = FALSE) +
  geom_smooth(method = "lm", se = FALSE,formula=y~x,aes(group=1),colour="black") +
  scale_color_manual(values = c("democrat" = "blue", "republican" = "red")) + 
  theme(plot.title = element_text(face = "bold",size=30))+
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
  

ggsave("nonincumbant_economy.png", height = 13, width = 21)



# Looking at Regression Summary for Data 1 and 2

lm_econ1 <- lm(pv2p ~ GDP_growth_qt, data = data1)
summary(lm_econ1)

# Creating table 1



table1 <- tidy(lm_econ1) 

  gt(table1) %>%
  tab_header(
    title = "Quarter 2 GDP Growth Rate and Re-Election for Incumbant Parties",
    subtitle = "1948-2016"
  ) %>%
    fmt_number(columns=2:4,decimals = 2) 
  

table1


# Creating table 2

# Regression Summary

lm_econ2 <- lm(pv2p ~ GDP_growth_qt, data = data2)
summary(lm_econ2)

# Table Creation 


table2<- tidy(lm_econ2)

# Making a gt table

gt(table2) %>%
  tab_header(
    title = "Quarter 2 GDP Growth Rate and Re-Election for Non-Incumbant Parties",
    subtitle = "1948-2016"
  ) %>%
  fmt_number(columns=2:4,decimals = 2) 

table2


# Real income and Election

# Setting up the data

data3 <- popvote %>% 
  filter(incumbent_party==TRUE) %>%
  select(year, winner, pv2p,party) %>%
  
# Filter for year greater than 1959 because that's when disposable income data is available
  
  left_join(economy %>% filter(quarter == 2)) %>%

# Get rid of NA's 

na.omit()

# Making Graph 3

data3 %>%
  ggplot(aes(x=unemployment,y=pv2p,label=year,color=party)) +
  labs(title ="Unemployment Rate and Incumbent Popular Vote Shares",
       subtitle="Presidential Elections 1948-2016",
       x="Unemployment Rates (%)",y= "Popular Vote Share (%)") + geom_point(size=10) +
  geom_smooth(method = "lm", se = FALSE,formula = y ~ x,aes(group=1),colour="black") +
  scale_color_manual(values = c("democrat" = "blue", "republican" = "red")) +
  labs(color="Party") +
  theme_bw() + 
  theme(plot.title = element_text(face = "bold",size=30))+
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

ggsave("rdi_growth.png", height = 13, width = 21)


# Prediction 2


lm_econ3 <- lm(pv2p ~ unemployment, data = data3)


# Create New Dataset 3

data3_new <-economy %>%
  subset(year == 2020 & quarter == 2) %>%
  select(unemployment)

# Make Prediction 3

predict(lm_econ3, data3_new)


# Pre-Corona Unemployment Prediciton


lm_econ3 <- lm(pv2p ~ unemployment, data = data3)


# Create New Dataset 3 for Pre-Corona

data3_newb <-economy %>%
  subset(year == 2019 & quarter == 1) %>%
  select(unemployment)

# Make Prediction 3 for Pre-Corona

predict(lm_econ3, data3_newb)




