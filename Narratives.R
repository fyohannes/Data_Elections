# Narratives--- Black Mobilization in Georgia 

# Packages

library(readr)
library(scales)
library(janitor)
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

      # Pop vote by county 


county_vote <- read_csv("popvote_bycounty_2000-2016.csv",col_types = cols(
  year = col_double(),
  state = col_character(),
  state_abb = col_character(),
  county = col_character(),
  fips = col_double(),
  D_win_margin = col_double()
))

# Filter County Vote Data for Gerogia, 2016

county_vote <- county_vote %>%
  filter(year==2016) %>%
  filter(state=="Georgia")

    # County Demographics 

county_demographics <- read_csv("cc-est2019-alldata-13.csv",col_types=cols(
  .default = col_double(),
  SUMLEV = col_character(),
  COUNTY = col_character(),
  STNAME = col_character(),
  CTYNAME = col_character()
))

county_demographics <- county_demographics %>%
  select("AGEGRP","STNAME","CTYNAME","YEAR","TOT_POP","TOT_MALE","TOT_FEMALE","WA_MALE","WA_FEMALE","BA_MALE","BA_FEMALE","HIA_MALE","HIA_FEMALE")

# Filtering for Year 9--- 2016

county_demographics1 <- county_demographics %>%
  filter(YEAR==9) 
  

# Adding Across Races and Gender, and then total race

county_demographics1 <- county_demographics1 %>%
  group_by(CTYNAME) %>%
  mutate(total_population=sum(TOT_POP)) %>%
  mutate(total_female_black=sum(BA_FEMALE)) %>%
  mutate(total_male_black=sum(BA_MALE)) %>%
  mutate(total_female_white=sum(WA_FEMALE)) %>%
  mutate(total_male_white=sum(WA_MALE)) %>%
  mutate(total_male_HIA=sum(HIA_MALE)) %>%
  mutate(total_female_HIA=sum(HIA_FEMALE)) %>%
  
  county_demographics1 <- county_demographics1 %>%
  mutate(total_population=(total_population/2)) %>%
  mutate(total_female_black=(total_female_black/2)) %>%
  mutate(total_male_black=(total_male_black/2)) %>%
  mutate(total_female_white=(total_female_white/2)) %>%
  mutate(total_male_white=(total_male_white/2)) %>%
  mutate(total_male_HIA=(total_male_HIA/2)) %>%
  mutate(total_female_HIA=(total_female_HIA/2)) 
  
  # Need to filter for one row, before calculating other numbers
  
  county_demographics1 <- county_demographics1 %>%
  filter(AGEGRP==0) %>%
  mutate(black_pop=sum(total_male_black,total_female_black)) %>%
  mutate(white_pop=sum(total_female_white,total_male_white)) %>%
  mutate(h_pop=sum(total_male_HIA,total_female_HIA)) %>%
  mutate(white_percentage=white_pop/total_population) %>%
  mutate(H_percentage=h_pop/total_population) %>%
  mutate(black_percentage=black_pop/total_population) 
  



# Altering the Data

# County Vote--- Added column to denote D Counties

county_vote <- county_vote %>%
  mutate(Dwin= ifelse(D_win_margin > 0, 1, 0))


# Making the Blank County Map


plot_usmap("counties", include ="GA",labels = TRUE) 

ggsave("Blank_Georgia_County", height = 13, width = 28)




# Making the Vote Map 2016


plot_usmap(include ="Georgia",data=county_vote,values="Dwin") + 
  scale_fill_continuous(
    low = "red", high = "blue", name = "Party Vote", label = scales::comma
  ) + theme(legend.position = "right") +
  labs(title= "The 2016 Election in Georgia",
       subtitle="Republican vs Democratic Counties")  +
  theme(plot.title = element_text(face = "bold",size=45))+
  theme(plot.subtitle = element_text(face = "bold",size=42)) +
  theme(plot.caption =element_text(face = "bold",size=35))+
  theme(
    legend.title = element_text(color = "black", size = 35),
    legend.text = element_text(color = "black", size = 35)
  )

ggsave("2016_Georgia_Vote.png", height = 18, width = 38)


# Making the Demographics Map 2016

# Renaming the State Columns


county_demographics1 <- county_demographics1 %>%
  rename(state=STNAME) %>%
  rename(county=CTYNAME)
  
# Trying to get rid of County in the Name

  
county_demographics1 <- county_demographics1 %>%
  ungroup() %>%
  mutate(county= gsub("\\s*\\w*$", "",county)) 



# Making the Actual Map


plot_usmap(include ="Georgia",data=county_demographics1,values="black_percentage") + 
  scale_fill_continuous(
    low = "yellow", high = "blue", name = "Percentage of Black Residents", label = scales::comma
  ) + theme(legend.position = "right")



### 2020 Data County Demographics 

county_demographics2 <- county_demographics %>%
  filter(YEAR==12) 

# Adding Across Races and Gender, and then total race

county_demographics2 <- county_demographics2 %>%
  group_by(CTYNAME) %>%
  mutate(total_population=sum(TOT_POP)) %>%
  mutate(total_female_black=sum(BA_FEMALE)) %>%
  mutate(total_male_black=sum(BA_MALE)) %>%
  mutate(total_female_white=sum(WA_FEMALE)) %>%
  mutate(total_male_white=sum(WA_MALE)) 
  
  county_demographics2 <- county_demographics2 %>%
  mutate(total_population=(total_population/2)) %>%
  mutate(total_female_black=(total_female_black/2)) %>%
  mutate(total_male_black=(total_male_black/2)) %>%
  mutate(total_female_white=(total_female_white/2)) %>%
  mutate(total_male_white=(total_male_white/2)) %>%

  
  # Need to filter for one row, before calculating other numbers
  
  filter(AGEGRP==0) %>%
  mutate(black_pop=sum(total_male_black,total_female_black)) %>%
  mutate(white_pop=sum(total_female_white,total_male_white)) %>%
  mutate(black_percentage=black_pop/total_population)



county_demographics2 <- county_demographics2 %>%
  rename(state=STNAME) %>%
  rename(county=CTYNAME)

# Trying to get rid of County in the Name


county_demographics2 <- county_demographics2 %>%
  ungroup()  %>%
  mutate(county= gsub("\\s*\\w*$", "",county))

# Making the Map for 2020 Demographics 

county_demographics2 %>%
  mutate(state=state.abb(state))


plot_usmap("counties",include ="Georgia",data=county_demographics2,values="black_percentage") + 
  scale_fill_continuous(
    low = "yellow", high = "blue", name = "Percentage of Black Residents", label = scales::comma
  ) + theme(legend.position = "right")




# Regression for 2016 Data

#Join the Data sets

# Mutate black percentage column first

county_demographics1 <- county_demographics1 %>%
  mutate(black_percentage= black_percentage*100) %>%
  mutate(white_percentage= white_percentage*100) %>%
  mutate(H_percentage=H_percentage*100)

# Join

data <- county_demographics1 %>%
  left_join(county_vote,by="county") 
  

# Creating Regression, preciting D win margin with black percentages


model <- lm(D_win_margin ~ black_percentage,data=data)
summary(model)

#Making the table for the 2016 Model


table_2016_model <- tidy(model)

gt(table_2016_model) %>%
  tab_header(
    title = "Black Demographics on Demoratic Vote Shares in Gerogia Counties",
    subtitle = "2016 Presidential Election"
  ) %>%
  fmt_number(columns=2:4,decimals = 2) 

table_2016_model


# Creating Graph to look at Black Percentages at D Margin

data %>%
  ggplot(aes(x=black_percentage,y=D_win_margin)) +geom_point() + 
  geom_smooth(method='lm', formula= y~x) +
  labs(title ="Investigating Democratic Win Margins in Gerogia Counties in 2016 Election",
       subtitle = "Are Majority Black Counties more likely to be Blue?",
       x="Percentage of Black People in a County",y= "Democratic Win Margin") +
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


ggsave("2016_black_vote.png", height = 13, width = 21)

# Creating Graphic to look at 2016 White Vote

data %>%
  ggplot(aes(x=white_percentage,y=D_win_margin)) +geom_point() + 
  geom_smooth(method='lm', formula= y~x) +
  labs(title ="Investigating Democratic Win Margins in Gerogia Counties in 2016 Election",
       subtitle = "Are Majority White Counties more likely to be Red?",
       x="Percentage of White People in a County",y= "Democratic Win Margin")+
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


ggsave("2016_white_vote.png", height = 13, width = 21)



# 2020 Data Set

# Reading in the 2020 county vote data

county_vote_2020_original <- read_csv("2020_US_County_Level_Presidential_Results.csv",col_types = cols(
  state_name = col_character(),
  county_fips = col_character(),
  county_name = col_character(),
  votes_gop = col_double(),
  votes_dem = col_double(),
  total_votes = col_double(),
  diff = col_double(),
  per_gop = col_double(),
  per_dem = col_double(),
  per_point_diff = col_double()
))

# Prepping the dataset

county_vote_2020 <- county_vote_2020_original %>%
  filter(state_name=="Georgia") %>%
  rename(state=state_name) %>%
  rename(county=county_name) %>%
  mutate(county= gsub("\\s*\\w*$", "",county)) %>%
  mutate(per_gop=per_gop*100) %>%
  mutate(per_dem=per_dem*100) %>%
  mutate(per_point_diff=per_point_diff*100) # this is GOP win margin


  

# Making 2020 final dataset with votes and demographics


data2 <- county_demographics2 %>%
  left_join(county_vote_2020,by="county") 

data2 <- data2 %>%
  mutate(black_percentage=black_percentage*100)

# Altering data

data2 <- data2 %>%
  mutate(D_win_margin=per_dem-per_gop)


# Making a graph of black demographics and 2020 vote share


data2 %>%
  ggplot(aes(x=black_percentage,y=D_win_margin)) +geom_point() + 
  geom_smooth(method='lm', formula= y~x) +
  labs(title ="Investigating Democratic Win Margins in Gerogia Counties in 2020 Election",
       subtitle = "Are Majority Black Counties more likely to be Blue?",
       x="Percentage of Black People in a County",y= "Democratic Win Margin") +
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


ggsave("2020_black_vote.png", height = 13, width = 21)


# Creating 2020 Regression 


model2 <- lm(D_win_margin ~ black_percentage,data=data2)
summary(model2)

  #Making the table for the 2020 Model


table_2020_model <- tidy(model2)


gt(table_2020_model) %>%
  tab_header(
    title = "Black Demographics on Demoratic Vote Shares in Gerogia Counties",
    subtitle = "2020 Presidential Election"
  ) %>%
  fmt_number(columns=2:4,decimals = 2) 

table_2020_model


# Making a Graph of 2016 Counties with the Most Black People

  county_demographics1 %>%
  arrange(desc(black_pop)) %>%
  head(7) %>%
  ggplot(aes(x=county,y=black_pop)) +geom_col(fill="lightcoral") + 
  labs(title ="The Georgia Counties with the Highest Black Population ",
       subtitle="2016 Demographic Data",
       x="County",y= "Black Population") +
   scale_y_continuous(labels = comma) +
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

  
  ggsave("2016_most_black_counties.png", height = 13, width = 21)
  
  
 # Making a Graph of 2020 Counties with the Most Black People
  
county_demographics2 %>%
    arrange(desc(black_pop))%>%
    head(7) %>%
    ggplot(aes(x=county,y=black_pop)) +geom_col(fill="violet") + 
    labs(title ="The Georgia Counties with the Highest Black Population",
         subtitle = "2019 Demographic Data",
         x="County",y= "Black Population") +
    scale_y_continuous(labels = comma) +
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
  
  
  ggsave("2020_most_black_counties.png", height = 13, width = 21)
  
  
# Making a graph of 2016 Most Democratic Counties--- 31 counties in which Democrats won

county_vote %>%
    filter(D_win_margin>0) %>%
    ggplot(aes(x=county,y=D_win_margin)) +geom_col(fill="blue") +
    coord_flip() +
  labs(title ="The Georgia Counties with Democratic Win Margins Over 25 Percent",
       subtitle = "2016 Election",
       x="County",y= "Democratic Win Margins") +
  scale_y_continuous(labels = comma) +
  theme(plot.title = element_text(face = "bold",size=30)) +
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


ggsave("2016_most_democratic_counties.png", height = 13, width = 21)


# Making a 2020 Graph of the most Democratic Counties, 30 blue counties

county_vote_2020 %>%
  filter(per_point_diff< 0) %>%
  ggplot(aes(x=county,y=per_dem)) +geom_col(fill="blue") + coord_flip() +
  labs(title ="The Georgia Counties with Democratic Win Margins Over 25 Percent",
       subtitle = "2020 Election",
       x="County",y= "Democratic Win Margins") +
  scale_y_continuous(labels = comma) +
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


ggsave("2020_most_democratic_counties.png", height = 13, width = 21)


# Change in Votes for the most black counties from 2016 to 2020

# Set up the data

  # Download the new 2016 county data

county_vote_2016 <- read_csv("2016_US_County_Level_Presidential_Results.csv",col_types=cols(
  X1 = col_double(),
  votes_dem = col_double(),
  votes_gop = col_double(),
  total_votes = col_double(),
  per_dem = col_double(),
  per_gop = col_double(),
  diff = col_number(),
  per_point_diff = col_character(),
  state_abbr = col_character(),
  county_name = col_character(),
  combined_fips = col_double()
))

    # Altering the Data 

county_vote_2016 <- county_vote_2016 %>%
  filter(state_abbr=="GA") %>%
  rename(county=county_name) %>%
  mutate(county= gsub("\\s*\\w*$", "",county)) %>%
  mutate(per_gop=per_gop*100) %>%
  mutate(per_dem=per_dem*100) %>%
  # mutate(per_point_diff=per_point_diff*100) %>% # this is GOP win margin 
  rename(votes_dem_2016=votes_dem) %>%
  rename(per_dem_2016=per_dem) %>%
  rename(per_gop_2016=per_gop) %>%
  rename(per_point_diff_2016=per_point_diff)



final_data <- county_vote_2020 %>%
  left_join(county_vote_2016,by="county") 

# Altering Final Data and Making Diffference Graph 

final_data %>%
  filter(county %in% c("Clarke","Clayton","DeKalb","Dougherty","Douglas","Fulton","Hancock","Richmond","Rockdale")) %>%
  mutate(difference= votes_dem-votes_dem_2016) %>%
  ggplot(aes(x=county,y=difference)) +geom_col(fill="skyblue2") + 
  labs(title ="Difference in Democratic Votes in Georgia Counties with the Highest Black Population",
       subtitle = "2020 Election- Georgia Goes Blue",
       x="County",y= "Democratic Vote") +
  scale_y_continuous(labels = comma) +
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


ggsave("final_graph.png", height = 13, width = 21)


# Graph---- What Counties Did go Blue

  final_data %>%  # 158 counties had more democratic votes than in comparison to 2016
  mutate(difference= votes_dem -votes_dem_2016) %>%
  filter(difference>0) %>%
  arrange(desc(difference)) %>%
  head(10) %>%
  ggplot(aes(x=county,y=difference)) +geom_col(fill="skyblue2") + 
    labs(title ="Difference in Democratic Votes between the 2016 and 2020 Election in Georgia",
         subtitle = "Top 10 Counties with the Largest Incease in Democratic Votes",
         x="County",y= "Democratic Vote") +
    scale_y_continuous(labels = comma) +
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
  
  
  ggsave("final_graph_2.png", height = 13, width = 21)



  # Making the Vote Map 2020 
  
county_vote_2020 <- county_vote_2020 %>%
  mutate(Dwin= ifelse(per_point_diff < 0, 1, 0)) %>%
  as.numeric("Dwin") %>%
  group_by(county) 
  
  
  plot_usmap(include ="Georgia",data=county_vote_2020,values="Dwin") + 
    scale_fill_continuous(
      low = "red", high = "blue", name = "Party Vote", label = scales::comma
    ) + theme(legend.position = "right") +
    labs(title= "The 2020 Election in Georgia",
         subtitle="Republican vs Democratic Counties")  +
    theme(plot.title = element_text(face = "bold",size=30))+
    theme(plot.subtitle = element_text(face = "bold",size=29)) +
    theme(plot.caption =element_text(face = "bold",size=27))+
    theme(
      legend.title = element_text(color = "black", size = 29),
      legend.text = element_text(color = "black", size = 29)
    )
  
  ggsave("2016_Georgia_Vote.png", height = 13, width = 28)

  

  
  
  








