
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

library(lubridate)

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
  ggplot(aes(x=avg_support,y=pv2p,label=year,color=party))+
  labs(title ="Historical Poll Data and Presidential Vote Shares",
       subtitle="Presidential Elections 1968-2016",
       x=" Average Support from Polls (%)",y= "Popular Vote Share(%)") +
  scale_fill_manual(labels=c("Democrat", "Republican"),values = c("democrat", "republican")) +
  labs(color="Party")+
  geom_point(size=12) +
  geom_smooth(method = "lm", se = FALSE,formula=y~x,aes(group=1),colour="black") +
  scale_color_manual(values = c("democrat" = "blue", "republican" = "red")) + 
  theme(plot.title = element_text(face = "bold",size=35))+
  theme(plot.subtitle = element_text(face = "bold",size=32)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 26, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain"))

ggsave("historical_poll.png", height = 13, width = 21)

  
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

mutate(date= ifelse(startsWith(startdate,"11"), "November", 
            ifelse(startsWith(startdate,"10"), "October",
            ifelse(startsWith(startdate,"9"), "September", NA))))
         
         
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
      labs(title =" Clinton's Poll Vote Outcome in 2016",
           subtitle="Includes only Grade A Pollsters",
           x="Poll Votes (%)",y= "Count")+
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
     
     ggsave("clinton_A_poll.png", height = 13, width = 21)
    
  
     # Finding Poll Average Vote Share for Clinton 2016, 43.689
  
    
data1$avg_poll_clinton

sd(data1$rawpoll_clinton)

data1%>%
  filter(rawpoll_clinton > 46 | rawpoll_clinton < 48) %>%
  count()




data1 %>%

    
# Donald Trump 2016
    
b  <- data1 %>%
ggplot(aes(x=rawpoll_trump)) + geom_histogram(fill="red") + geom_vline(xintercept=44.91,col="black") +
    labs(title =" Trump's Poll Vote Outcome in 2016",
         subtitle="Includes only Grade A Pollsters",
         x="Poll Votes (%)",y= "Count") +
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
          axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0))
  
  
  ggsave("trump_A_poll.png", height = 13, width = 21)
  
  # Finding Vote Average Vote Share for Donald Trump, 37.35
  
  data1$avg_poll_trump
  
  
  # Grade B Pollster 
  
  # Clinton 2016
  
  
  c <- data2 %>%
    ggplot(aes(x=rawpoll_clinton)) + geom_histogram(fill="blue") + geom_vline(xintercept=47.05,col="black")+
    labs(title =" Clinton's Poll Vote Outcome in 2016",
         subtitle="Includes only Grade B Pollsters",
         x="Poll Votes (%)",y= "Count")+
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
          axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0))
  
  
  # Clinton Grade B Average Poll Vote Share,43.465
  
  data2$avg_poll_clinton
  

  
  # Trump 2016
  
  d <- data2 %>%
    ggplot(aes(x=rawpoll_trump)) + geom_histogram(fill="red") + geom_vline(xintercept=44.91,col="black") +
    labs(title =" Trump's Poll Vote Outcome in 2016",
         subtitle="Includes only Grade B Pollsters",
         x="Poll Votes (%)",y= "Number of Pollsters") +
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
          axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0))
  
  
  
  # Trump Grade B Poll Averages,39.16
  
  data2$avg_poll_trump
  
  
  # Poll Grids by Quality for Clinton and Trump
  
# Grade A
  
  plot_grid(a,b)
  
  ggsave("poll_gradeA.png", height = 12, width = 18)
  
# Grade B
  
  plot_grid(c,d)
  
  ggsave("poll_gradeB.png",height=12,width=18)
  
  
  
  # Muting Poll1
  
  poll1 <- poll1 %>%
    mutate(avg_poll_clinton= mean(rawpoll_clinton)) %>%
    mutate(avg_poll_trump=mean(rawpoll_trump))
  
  # Clinton 2016 Poll by Months
  
  poll1 %>%
    na.omit() %>%
    ggplot(aes(x=rawpoll_clinton)) + geom_histogram(fill="blue") + geom_vline(xintercept=47.05,col="black") + facet_wrap(~date) +
    labs(title =" Clinton's  Poll Vote Outcome in the 2016 Presidential Election",
         subtitle="Separating Pollsters by Month",
         x="Poll Votes (%)",y= "Number of Pollsters") +
    theme(plot.title = element_text(face = "bold",size=30))+
    theme(plot.subtitle = element_text(face = "bold",size=29)) +
    theme(plot.caption =element_text(face = "bold",size=27))+
    theme(axis.title.x = element_text(size = 30),
          axis.title.y = element_text(size = 30)) +
    theme(
      legend.title = element_text(color = "black", size = 29),
      legend.text = element_text(color = "black", size = 29)
    ) +
      theme(axis.text.x = element_text(size = 20),
           axis.text.y = element_text(size = 30))+
    theme(strip.text.x = element_text(size=34),
          strip.text.y = element_text(size=30))
  
  ggsave("clinton_months_poll.png", height = 13, width = 21)
  
  
  # Finding Poll Date Averages, November=45.4, October=44.7, September = 43
  
  poll1%>%
    filter(date=="November") %>%
    mutate(avg_November_Clinton =mean(rawpoll_clinton)) %>%
    select(avg_November_Clinton)
  
  poll1%>%
    filter(date=="October") %>%
    mutate(avg_october_clinton=mean(rawpoll_clinton)) %>%
    select(avg_october_clinton)
  
  poll1%>%
    filter(date=="September") %>%
    mutate(avg_september_clinton=mean(rawpoll_clinton)) %>%
    select(avg_september_clinton)
  
  
  # Donald Trump Poll Votes 2016
  
  # Creating Graph 
  
  poll1 %>%
    na.omit() %>%
    ggplot(aes(x=rawpoll_trump)) + geom_histogram(fill="red") + geom_vline(xintercept=47.05,col="black") + facet_wrap(~date) +
    labs(title ="Trump's Poll Vote Outcome in the 2016 Presidential Election",
         subtitle="Separting Pollsters by Month",
         x="Poll Votes (%)",y= "Number of Pollsters") +
    theme(plot.title = element_text(face = "bold",size=30))+
    theme(plot.subtitle = element_text(face = "bold",size=29)) +
    theme(plot.caption =element_text(face = "bold",size=27))+
    theme(axis.title.x = element_text(size = 30),
          axis.title.y = element_text(size = 30)) +
    theme(
      legend.title = element_text(color = "black", size = 29),
      legend.text = element_text(color = "black", size = 29)
    ) +
    theme(axis.text.x = element_text(size = 25),
          axis.text.y = element_text(size = 30)) + 
    theme(strip.text.x = element_text(size = 34),
          strip.text.y = element_text(size = 30))
  
  ggsave("trump_months_poll.png", height = 13, width = 21)
  
  
  # Finding Poll Date Averages, November=42.3, October=41.1, September = 41.4
  
  poll1%>%
    filter(date=="November") %>%
    mutate(avg_November_trump =mean(rawpoll_trump)) %>%
    select(avg_November_trump)
  
  poll1%>%
    filter(date=="October") %>%
    mutate(avg_october_trump=mean(rawpoll_trump)) %>%
    select(avg_october_trump)
  
  poll1%>%
    filter(date=="September") %>%
    mutate(avg_september_trump=mean(rawpoll_trump)) %>%
    select(avg_september_trump)
  
  
  
  
    
########### CREATING MODELS ############
  
  
# Data 
  
# Filter for November and Grade A and Grade B po
  
 

  poll1 %>%
    filter(date =="November") %>%
    filter(grade %in% c("A+","A","A-"))
  

  
  # Use this data with economy to create a model for 2016, for both Hiliary and Trump
  
  
    
    
  data_model <- popvote %>% 
    full_join(poll_national %>% 
                group_by(year,party) %>% 
                
    # Filtering for 9 weeks
      
                filter(weeks_left==9) %>%
                summarise(avg_support=mean(avg_support))) %>% 
    left_join(economy %>% 
                filter(quarter == 2))
  
  
  # Making the general model 
  
  data_model_incumbent<-data_model %>%
    filter(incumbent_party=="TRUE")
  
  model_2016 <- glm(pv~avg_support + GDP_growth_qt,data=data_model_incumbent)
  
  
  # Summary of the model
  
  summary(model_2016)
  
  
  # R squared and Standard Error of the model
  
  summary(model_2016)$r.squared # 0.64
  
  R2 <- rsq(model_2016)
  
  std.error
  
  
  # Making a table
  
  table_poll<- tidy(model_2016)
  
  gt(table_poll) %>%
    tab_header(
      title = "Quarter 2 GDP Growth Rate and Polls for Re-Election for Incumbant Parties",
      subtitle = "1968-2016"
    ) %>%
    fmt_number(columns=2:4,decimals = 2) 
  
  table_poll
  
  
  

# Testing Hiliary Clinton

  outsamp_mod  <- lm(pv ~ GDP_growth_qt, data_model_incumbent[data_model_incumbent$year != 2016,])
  outsamp_pred <- predict(outsamp_mod, data_model_incumbent[data_model_incumbent$year == 2016,])
  outsamp_true <- data_model_incumbent$pv2p[data_model_incumbent$year == 2016] 
  

  # For Hiliary Clinton should have predicted 51.16 percent
  
  
  # Trump average support 2020
  
  poll_2020 %>%
    filter(startsWith(start_date,"9")) %>%
    count(answer=="Biden")
  
  # 251/(613+251), 0.29
  
  poll_2020 %>%
    filter(startsWith(start_date,"9")) %>%
    count(answer=="Trump")
  
 # 353/(353+511), 0.408
  
  
  
  # Predicting Trump
  
# 41 pollster vote shares
# -9.49 percent Q2 
  
# Trump Predict Numbers
  
17.38 + (0.67*41) - (9.49*0.49)

#40.19
  

# Comparing Trump's Numbers with Historical Model

4.98516 + (0.96362*41)

# Calculating the Difference 

44.49358 - 40.1999




  

  
  
  
  
  
  
  
  
  
    


