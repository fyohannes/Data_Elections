
# Packages

library(readr)
library(tidyr)
library(ggplot2)
library(dplyr)
library(maps)
library(cowplot)
library(ggrepel)

# For the labeling of my map graph

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


a<- data1 %>%
  ggplot(aes(x=GDP_growth_qt,y=pv2p,label=year,color=party)) +geom_point() +
  labs(title ="Quarter 2 GDP Growth Rate and Re-election for Incumbant Parties ",
       subtitle="1948-2016",
       x="GDP Growth Rate",y= "Popular Vote Share",
       caption= "Source: Presidential Popular Vote Average 1948-2016 Dataset") +
  labs(fill = "Party that Won the Popular Vote") +  
  geom_text() +
  geom_smooth(method = "lm", se = FALSE,formula = y ~ x) +
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


ggsave("incumbant_economy.png", height = 13, width = 21)



# Looking at Regression Summary for Data 1


lm_econ1 <- lm(pv2p ~ GDP_growth_qt, data = data1)
summary(lm_econ1)



# Dataset for Incumbant Party= FALSE

data2 <- popvote %>% 
  filter(incumbent_party == FALSE) %>%
  select(year, winner, pv2p,party) %>%
  left_join(economy %>% filter(quarter == 2)) %>%
  
  mutate(Color = ifelse(party == "democrat", "blue", "red"))

 # Creating Graph 2


b <- data2 %>%
  ggplot(aes(x=GDP_growth_qt,y=pv2p,label=year,color=party))  +
  labs(title ="Quarter 2 GDP Growth Rate and Re-Election for Non-Incumbant Parties ",
       subtitle="1948-2016",
       x="GDP Growth Rate",y= "Popular Vote Share",
       caption= "Source: Presidential Popular Vote Average 1948-2016 Dataset") +
  labs(fill = "Party that Won the Popular Vote") +  
  geom_text() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_color_manual(values = c("democrat" = "blue", "republican" = "red")) +theme_bw()

# Looking at Regression Summary for Data 2

lm_econ2 <- lm(pv2p ~ GDP_growth_qt, data = data2)
summary(lm_econ2)


