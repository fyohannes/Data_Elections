# Analysis 

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
library(plotrix)

# Need for standard error 

library(statebins)
library(googlesheets4)
library(gt)

# For the regression summary table 

library(tidyverse)

# Downloading the data 

popvote_2020 <- read.csv("popvote_bystate_1948-2020.csv")

# Filtering for 2020

popvote_2020 <- popvote_2020 %>%
  filter(year==2020)

accuracy$change <- states_predictions$fit - popvote_2020$R_pv2p

# Change Popvote 2020 states into abbreviations

popvote_2020$state <- state.abb[match(popvote_2020$state, state.name)]

# Merging data

merged <- states_predictions %>%
  left_join(popvote_2020,by="state")

# Mutating 

merged_1 <-merged %>%
  mutate(R_pv2p= R_pv2p * 100) %>%
  mutate(difference = R_pv2p - fit)

# Making a graph 

# Mutate to get colors for graph

merged_1 <-  merged_1 %>%
  mutate(Color = ifelse(difference > 0, "red", "blue")) 

merged_1 %>%
  ggplot(aes(x=state,y=difference,fill=Color)) +geom_col() +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) + 
  labs(title ="Difference in Popular Vote",
       subtitle="Comparing my Model with the Election Outcome",
       x="State Abbreviations",y= "Difference in Popular Vote (%)") +
  labs(fill = "Party") +
  theme(plot.title = element_text(face = "bold",size=30))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 26, hjust = .5, angle= 45, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain")) 


ggsave("PV_difference.png", height = 13, width = 21)



# Average difference, democrats vs republicans

merged_1$difference<- as.numeric(merged_1$difference)

merged_1 %>%
  filter(Color=="red") %>%
  summarize(Mean=mean(difference))

merged_1 %>%
  filter(Color=="blue") %>%
  summarize(Mean2=mean(difference))



# Republicans-- 15.8639, Democrats-- 10.9319


#Finding the standard error 


