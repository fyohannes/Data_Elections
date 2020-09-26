
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

library(lubridate))

# Need this for my mutate with the date


# Downloading the CSV

popvote <- read_csv("popvote_1948-2016.csv",col_types = cols(
  year = col_double(),
  party = col_character(),
  winner = col_logical(),
  candidate = col_character(),
  pv = col_double(),
  pv2p = col_double(),
  incumbent = col_logical(),
  incumbent_party = col_logical(),
  prev_admin = col_logical()
))


poll_state <- read_csv("pollavg_bystate_1968-2016.csv",col_types = cols(
  year = col_double(),
  state = col_character(),
  party = col_character(),
  candidate_name = col_character(),
  poll_date = col_date(format = ""),
  weeks_left = col_double(),
  days_left = col_double(),
  before_convention = col_logical(),
  avg_poll = col_double()
))

# National 

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


poll_2016 <- read_csv("polls_2016.csv",col_types = cols(
  .default = col_character(),
  cycle = col_double(),
  samplesize = col_double(),
  poll_wt = col_double(),
  rawpoll_clinton = col_double(),
  rawpoll_trump = col_double(),
  rawpoll_johnson = col_double(),
  rawpoll_mcmullin = col_double(),
  adjpoll_clinton = col_double(),
  adjpoll_trump = col_double(),
  adjpoll_johnson = col_double(),
  adjpoll_mcmullin = col_double(),
  poll_id = col_double(),
  question_id = col_double()
))


poll_2020 <- read_csv("polls_2020.csv",col_types = cols(
  .default = col_character(),
  question_id = col_double(),
  poll_id = col_double(),
  cycle = col_double(),
  pollster_id = col_double(),
  sponsor_ids = col_number(),
  pollster_rating_id = col_double(),
  sample_size = col_double(),
  seat_number = col_double(),
  seat_name = col_logical(),
  internal = col_logical(),
  tracking = col_logical(),
  nationwide_batch = col_logical(),
  ranked_choice_reallocated = col_logical(),
  race_id = col_double(),
  candidate_id = col_double(),
  pct = col_double()
))


# Set up code from class

data_ <- popvote %>% 
  full_join(poll_national %>% 
              group_by(year,party) %>% 
              summarise(avg_support=mean(avg_support))) %>% 
  left_join(economy %>% 
              filter(quarter == 2))

# Data for incumbent party

data_incumbent <- data_ %>%
  filter(incumbent_party==TRUE)



# Create Historical Popvote and Poll Graph

data_ %>%
  ggplot(aes(x=avg_support,y=pv2p,label=year))  +geom_text()
  labs(title ="Historical Poll Data and Presidential Vote Shares",
       subtitle="Presidential Elections 1968-2016",
       x=" Average Support from Polls (%)",y= "Popular Vote Share(%)",
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


  
# Creating Regression for Historical Poll and Pop Vote Share data, Incumbent party

lm_poll_historical <- lm(pv~ avg_support, data = data_incumbent)
summary(lm_poll_historical)



# Data 1 for 2016


# Renaming the column cycle


poll_2016 <- rename(poll_2016,year=cycle)


poll1 <- poll_2016 %>%
  filter(state=="U.S.") %>%
  select("pollster","poll_wt","rawpoll_clinton","rawpoll_trump","startdate","grade","year") %>%
  
  # Mutating the months 
  
  mutate(Months= ifelse(grepl(startdate,"11")), "November"
         ifelse(startsWith(startdate,"10")), "October"
         ifelse(startsWith(startdate,"9")), September, NA) 
                                  
                                  
    
  # Full joining two datasets
  
  popvote <- popvote %>% 
    filter(year==2016)
  
  data <- full_join(popvote,poll1,by="year")
  
  # Prepping variables for graph 
  
  data <- data %>%
    mutate(avg_support_clinton= mean(pv2p))
  
  
  # Data, filetering for quality 
  
 data1 <- data %>%
    filter(str_detect(grade,"A")) %>%
   
  # Creating popvote and poll vote average variables 
   
    mutate(avg_poll_clinton= mean(rawpoll_clinton)) %>%
    mutate(avg_vote_clinton=mean(pv)) %>%
    mutate(avg_poll_trump=mean(rawpoll_trump))
 
 data2 <- data %>%
   filter(str_detect(grade,"B")) %>%

   # Creating popvote and poll vote average variables 
   
   mutate(avg_poll_clinton= mean(rawpoll_clinton)) %>%
   mutate(avg_vote_clinton=mean(pv)) %>%
   mutate(avg_poll_trump=mean(rawpoll_trump))
 


    # Making Graphs, Clinton 2016
    
    a <- data1 %>%
      ggplot(aes(x=rawpoll_clinton)) + geom_histogram(fill="blue") + geom_vline(xintercept=47.05,col="black") +
      labs(title =" Clinton's Poll Vote Outcome in the 2016 Presidential Election",
           subtitle="Includes only Grade A Pollsters",
           x="Poll Votes (%)",y= "Count",
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
    
  
     # Creating Clinton 2016 Regression Model
  
    
lm_poll1 <- lm(pv~ avg_support_clinton , data = data1)

    # Summary poll 1

summary(lm_poll1)
    
    
    
# Donald Trump 2016
    
  b <- data1 %>%
ggplot(aes(x=rawpoll_trump)) + geom_histogram(fill="red") + geom_vline(xintercept=44.91,col="black") +
    labs(title =" Trump's Poll Vote Outcome in the 2016 Presidential Election",
         subtitle="Includes only Grade A Pollsters",
         x="Poll Votes (%)",y= "Count",
         caption= "Source: Economic Analysis, US Bureau of Department of Commerce \n Caption: Democrats noted by blue, Republicans by red")
  
  # Trump Regression for 2016
  
  lm_poll2 <- lm(avg_poll_trump ~ pv , data = data1)
  summary(lm_poll2)
  
  
  
  # Grade B Pollster 
  
  # Clinton 2016
  
  
  c <- data2 %>%
    ggplot(aes(x=rawpoll_clinton)) + geom_histogram(fill="blue") + geom_vline(xintercept=47.05,col="black")
  
  
  # Clinton Grade B regression 
  
  lm_poll3 <- lm(avg_support_clinton ~ pv , data = data2)
  
  # Summary poll 3
  
  summary(lm_poll3)
  
  
  # Trump 2016
  
  d <- data2 %>%
    ggplot(aes(x=rawpoll_trump)) + geom_histogram(fill="red") + geom_vline(xintercept=44.91,col="black") +
    labs(title =" Trump's Poll Vote Outcome in the 2016 Presidential Election",
         subtitle="Includes only Grade B Pollsters",
         x="Poll Votes (%)",y= "Count",
         caption= "Source: Economic Analysis, US Bureau of Department of Commerce \n Caption: Democrats noted by blue, Republicans by red")
  
  
  # Poll by Date
  
  
  
  
    


