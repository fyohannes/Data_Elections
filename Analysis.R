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
  mutate(D_pv2p= D_pv2p * 100) %>%
  mutate(fit2= 100- fit) %>%
  mutate(rdifference= R_pv2p-fit2) %>%
  mutate(d_difference=D_pv2p-fit)

# Making a graph 

# Mutate to get colors for graph

merged_1 <-  merged_1 %>%
  mutate(Color = ifelse(D_pv2p> R_pv2p, "blue", "red")) 

# Republican graph 

merged_1 %>%
  filter(Color=="red") %>%
  ggplot(aes(x=state,y=rdifference,fill="red")) +geom_col() +
  labs(title ="Difference in Popular Vote for Republican States",
       subtitle="Comparing my Model with the Election Outcome",
       x="State Abbreviations",y= "Difference in Popular Vote (%)") +
  theme(legend.position = "none") +
  theme(plot.title = element_text(face = "bold",size=30))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 24, hjust = .5, angle= 20, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain")) 


ggsave("PV_difference_republicans.png", height = 13, width = 28)


# Democrat graph 

merged_1 %>%
  filter(Color=="blue") %>%
  ggplot(aes(x=state,y=d_difference)) +geom_col(fill="mediumblue") +
  labs(title ="Difference in Popular Vote for Democratic States",
       subtitle="Comparing my Model with the Election Outcome",
       x="State Abbreviations",y= "Difference in Popular Vote (%)") +
  theme(legend.position = "none") +
  theme(plot.title = element_text(face = "bold",size=30))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 24, hjust = .5, angle= 20, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain")) 


ggsave("PV_difference_democrats.png", height = 13, width = 28)



# Average difference, democrats vs republicans

merged_1$difference<- as.numeric(merged_1$difference)

merged_1 %>%
  filter(Color=="red") %>%
  mutate(rdifference=abs(rdifference)) %>%
  summarize(Mean=mean(rdifference))

merged_1 %>%
  filter(Color=="blue") %>%
  mutate(d_difference=abs(d_difference)) %>%
  summarize(Mean2=mean(d_difference))



# Republicans-- 15.8639, Democrats-- 6.379644


#Finding the standard error 



# Real Election Electoral College Results 

# New data frame 

map_prediction_dataframe_new <- merged_1 %>%
  mutate(D_pv2p= D_pv2p * 100) %>%
  mutate(win_margin = (D_pv2p -R_pv2p)) %>%
  mutate(dem_win = ifelse(win_margin >= 0, TRUE, FALSE))

ggplot(map_prediction_dataframe_new, aes(state = state, fill =dem_win)) + 
  geom_statebins(lbl_size = 10) + 
  theme_statebins() +
  scale_fill_manual(values=c("#F8766D","#619CFF")) +
  labs(title = "2020 Presidential Electoral College Map- Real Outcomes",
       fill = "") + 
  theme(plot.title = element_text(size = 38, hjust = 0.5),
        plot.subtitle = element_text(size = 32, hjust = 0.5)) +
guides(fill=FALSE)


ggsave("actual_map.png", height = 16, width = 22)


# Residual Graph 

res_popular <- qplot(fitted(national_model), resid(national_model),size=I(11)) +
  geom_smooth()
res_popular+geom_hline(yintercept=0) 



