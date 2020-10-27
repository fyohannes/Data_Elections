# Shocks

# Packages

library(readr)
library(tidyr)
library(ggplot2)
library(dplyr)
library(maps)
library(cowplot)
library(grid)
library(gridExtra)
library(statebins)
library(janitor)
library(ggrepel)

# For the labeling of my map graph

library(broom)
library(gt)

# For the regression summary table 

library(tidyverse)


# Loading the data, 

COVID <- read.csv("United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv")

World_Covid <- read_csv("owid-covid-data.csv",col_types = cols(
  .default = col_double(),
  iso_code = col_character(),
  continent = col_character(),
  location = col_factor(),
  date = col_date(format = ""),
  total_tests = col_logical(),
  new_tests = col_logical(),
  total_tests_per_thousand = col_logical(),
  new_tests_per_thousand = col_logical(),
  new_tests_smoothed = col_logical(),
  new_tests_smoothed_per_thousand = col_logical(),
  tests_per_case = col_logical(),
  positive_rate = col_logical(),
  tests_units = col_logical()
))



# COVID State Data,prediction data using polls as the dependent variable

COVID <- COVID %>%
  mutate(submission_date=as.character(submission_date))

# made the submission date into a character variable

COVID <- COVID %>%
  
  # Mutating the months 
  
  mutate(date= ifelse(startsWith(submission_date,"02"), "Feb", 
                      ifelse(startsWith(submission_date,"03"), "Mar",
                      ifelse(startsWith(submission_date,"04"), "Apr", 
                      ifelse(startsWith(submission_date,"05"), "May",
                      ifelse(startsWith(submission_date,"06"), "Jun",
                      ifelse(startsWith(submission_date,"07"), "Jul",
                      ifelse(startsWith(submission_date,"08"), "Aug",
                      ifelse(startsWith(submission_date,"09"), "Sept",
                      ifelse(startsWith(submission_date,"10"), "Oct",NA))))))))))

COVID <- COVID %>%
  group_by(state,date) %>%
  mutate(total_cases_month=sum(conf_cases)) %>%
  mutate(total_deaths_month=sum(conf_death))


# Creating numeric variables for conf cases 


# Covid Cases in Swing States,North Carolina, WI, Arizona, USA, from May onwards

data1 <- COVID %>%
  group_by(date,state) %>%
  mutate(US =sum(total_cases_month))

# Fixing the months 

  data1$date <- factor(data1$date, levels = c("Mar", "Apr", "May", "Jun", "Jul", "Aug", 
                                                "Sept", "Oct", "Nov"))
  
  
  

Data1 <- data1 %>%
filter(state %in% c("NC","WI","AZ")) %>%
group_by(state)

Data1 %>%
  na.omit() %>%
  distinct(total_cases_month, .keep_all = TRUE) %>%
  ggplot(aes(x=date,y=total_cases_month)) +geom_line(group=1)+ geom_point(size=12) +facet_grid(~state) +
  scale_y_continuous(labels = scales::comma) +
  labs(title ="Total Number of COVID Cases by Month in 3 Swing States ",
       subtitle="Arizona, North Carolina and Wisconsin experience rise in COVID cases",
       x="Month",y= "Total Number of Confirmed Covid Cases ")  +
  theme(plot.title = element_text(face = "bold",size=35))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 32),
        axis.title.y = element_text(size = 32)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 22, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 29, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(strip.text = element_text(size = 27))


ggsave("swingstates_covid.png", height = 15, width = 21)



### Comparing the United States with other countries


World_Covid <- World_Covid %>%
  mutate(death_total_by_country = sum(new_deaths)) %>%
  mutate(tests_by_country= sum(total_tests)) 


data2 <- World_Covid %>%
  group_by(location) %>%
  arrange(desc(total_cases)) %>%
  slice(1:10)



# Sweden 

graph1<- World_Covid %>%
  filter(location=="Sweden") %>%
  mutate(cases_pop= (total_cases/population)) %>%
  ggplot(aes(x=date,y=cases_pop)) +geom_point() + geom_line(color="yellow") +
  labs(title ="Number of COVID Cases Per Capita by Month",
       subtitle="Sweden",
       x="Month",y= "Confirmed Covid Cases Per Capita") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain",angle=0),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  

# USA

graph2 <-World_Covid %>%
  filter(location=="United States") %>%
  mutate(cases_pop= (total_cases/population)) %>%
  ggplot(aes(x=date,y=cases_pop)) +geom_point() + geom_line(color="blue") +
  labs(title ="Number of COVID Cases Per Capita by Month",
       subtitle = "United States of America",
       x="Month",y= "Confirmed Covid Cases Per Capita") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain",angle=0),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))


# South Korea


graph3 <-World_Covid %>%
  filter(location=="South Korea") %>%
  mutate(cases_pop= (total_cases/population)) %>%
  ggplot(aes(x=date,y=cases_pop)) +geom_point() + geom_line(color="red") + 
  scale_y_continuous(labels = scales::comma)  +
  labs(title ="Number of COVID Cases Per Capita by Month",
       subtitle = "South Korea",
       x="Month",y= "Confirmed Covid Cases Per Capita") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain",angle=0),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  
  
  
  
# Putting the Country Comparison Graphs together

plot_grid(graph1,graph2,graph3)

ggsave("country_comparison.png", height = 14, width = 19)



# Graph 

COVID %>%
  ggplot(aes(x=date,y=)) + geom_histogram(stat=count)


# Use new conf,new deaths for prediction models


# Predictions

# Merging the data

pollstate_df <- read_csv("pollavg_bystate_1968-2016.csv",col_types=cols(
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


pollstate_df$state <- state.abb[match(pollstate_df$state, state.name)]


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


poll_2020$state <- state.abb[match(poll_2020$state, state.name)]

poll_2020 <- poll_2020 %>%
  # filter(ends_with(start_date,"20")) %>%
  mutate(date= ifelse(startsWith(start_date,"2"), "February", 
                      ifelse(startsWith(start_date,"3"), "March",
                      ifelse(startsWith(start_date,"4"), "April", 
                      ifelse(startsWith(start_date,"5"), "May",
                      ifelse(startsWith(start_date,"6"), "June",
                      ifelse(startsWith(start_date,"7"), "July",
                      ifelse(startsWith(start_date,"8"), "August",
                      ifelse(startsWith(start_date,"9"), "September",
                      ifelse(startsWith(start_date,"10"), "October",NA)))))))))) %>%
  group_by(candidate_name,state,date) %>%
  mutate(avg_poll= mean(pct)) 


#Economy data

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

economy_local<- economy_local %>%
  clean_names() %>%
  filter(year=="2019")


economy_local$state_and_area <- state.abb[match(economy_local$state_and_area, state.name)]


economy_local<- economy_local %>%
  
  # Mutating the months 
  
  mutate(date= ifelse(startsWith(month,"02"), "February", 
                      ifelse(startsWith(month,"03"), "March",
                      ifelse(startsWith(month,"04"), "April", 
                      ifelse(startsWith(month,"05"), "May",
                      ifelse(startsWith(month,"06"), "June",
                      ifelse(startsWith(month,"07"), "July",
                      ifelse(startsWith(month,"08"), "August",
                      ifelse(startsWith(month,"09"), "September",
                      ifelse(startsWith(month,"10"), "October",NA)))))))))) %>%
rename("state"=state_and_area) 

economy_local <- economy_local %>%
  drop_na(date)

economy_local<- economy_local %>%
  group_by(state) %>%
  mutate(unemployment_change = unemployed_prce - lag(unemployed_prce, order_by = month))

COVID <- COVID %>%
  group_by(state,date) %>%
  mutate(new_case_1000= new_case/1000) %>%
  drop_na(date) %>%
  group_by(state) %>%
  mutate(total_cases_change = total_cases_month - lag(total_cases_month, order_by = date))

  

# Joined Poll Data and COVID data

model_data <- poll_2020 %>%
  select(candidate_name,pct,date,avg_poll,state) %>%
  left_join(COVID,by="state","date")

model_data <- model_data %>%
  rename("date"=date.x)

economy_local <- economy_local %>%
 filter(month %in% c("09","10","11","12"))

# Used economic data from 2019, September,October,November,December

# Filtering for one month per state

  
model_data <- model_data %>%
  left_join(economy_local,by=c("state"))
  

# Filtering the data for prediction model

model_AZ <- model_data %>%
  filter(state=="AZ") %>%
  filter(candidate_name== "Donald Trump") %>%
  distinct(date.y, .keep_all = TRUE)
 

  

model_AZ_1 <- lm(avg_poll ~ new_case, data=model_AZ)
summary(model_AZ_1)



# Pop vote by county and COVID

popvote_county <- read_csv("popvote_bycounty_2000-2016.csv",col_types=cols(
  year = col_double(),
  state = col_character(),
  state_abb = col_character(),
  county = col_character(),
  fips = col_double(),
  D_win_margin = col_double()
))


### New model

demog <- read_csv("demographic_1990-2018.csv",col_types = cols(
  year = col_double(),
  state = col_character(),
  Asian = col_double(),
  Black = col_double(),
  Hispanic = col_double(),
  Indigenous = col_double(),
  White = col_double(),
  Female = col_double(),
  Male = col_double(),
  age20 = col_double(),
  age3045 = col_double(),
  age4565 = col_double(),
  age65 = col_double(),
  total = col_double()
))

demog <- demog %>%
  group_by(state) %>%
  mutate(Asian_change = Asian - lag(Asian, order_by = year),
         Black_change = Black - lag(Black, order_by = year),
         Hispanic_change = Hispanic - lag(Hispanic, order_by = year),
         Indigenous_change = Indigenous - lag(Indigenous, order_by = year),
         White_change = White - lag(White, order_by = year),
         Female_change = Female - lag(Female, order_by = year),
         Male_change = Male - lag(Male, order_by = year),
         age20_change = age20 - lag(age20, order_by = year),
         age3045_change = age3045 - lag(age3045, order_by = year),
         age4565_change = age4565 - lag(age4565, order_by = year),
         age65_change = age65 - lag(age65, order_by = year)
  )


# Adding a year 

Covid <- COVID %>%
  mutate(year= ifelse(endsWith(submission_date,"20"), "2016", NA)) %>%
  distinct(total_cases_change,.keep_all = TRUE)
  

popvote_county <- popvote_county %>%
  rename("state_name"=state) %>%
  rename("state" =state_abb)

model_data <- demog %>%
  left_join(popvote_county,by=c("state","year"))

# Filtering for year

model_data <- model_data %>%
  filter(year>1999)

# Average D win margin by state

model_data <- model_data %>%
  group_by(state,year) %>%
  mutate(avg_Dmargin=mean(D_win_margin)) %>%
  distinct(avg_Dmargin,.keep_all = TRUE)

# model_data <- as.numeric(model_data$year)

model_data2 <- model_data %>%
  left_join(Covid,by=c("state","year"))

Covid %>%
  as.numeric(year)
  

# Prediction without COVID

model <- lm(avg_Dmargin~ Black +Hispanic +Female, data=model_data)
summary(model)

pvstate_df <- read_csv("popvote_bystate_1948-2016.csv",col_types = cols(
  state = col_character(),
  year = col_double(),
  total = col_double(),
  D = col_double(),
  R = col_double(),
  R_pv2p = col_double(),
  D_pv2p = col_double()
))

pvstate_df$state <- state.abb[match(pvstate_df$state, state.name)]

pvstate <- pvstate_df %>%
  filter(year>1989)

model_data <- demog %>%
  left_join(pvstate,by=c("state","year"))


# Prediction for Arizona

model_AZ_data <- model_data %>%
  filter(state=="AZ") %>%
  filter(year %in% c("2000","2004","2008","2012","2016"))


model_AZ <- lm(D_pv2p ~ Black_change + Hispanic_change, data=model_AZ_data)
summary(model_AZ)


# Prediction for Florida

model_FL_data <- model_data %>%
  filter(state=="FL") %>%
  filter(year %in% c("2000","2004","2008","2012","2016"))


model_FL <- lm(D_pv2p ~ Black_change +Hispanic_change, data=model_FL_data)
summary(model_FL)


# Covid Assumptions 

#109/100,000 black Americans have died --0.00109

109/100000

#73.5/100,000 Latino Americans have died---0.000735

73.5/100000


# Predicting 2020, Arizona = 46.65555

46.6474 + -7.70077*(-0.00109) +0.3311*(-0.000735) 


# Predicting 2020, Florida = 49.19602

49.2034 + 7.0639*(-0.00109) -0.4386*(-0.000735) 



















  