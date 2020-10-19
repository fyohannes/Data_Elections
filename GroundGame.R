# Ground Game

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
library(ggrepel)

# For the labeling of my map graph

library(broom)
library(gt)

# For the regression summary table 

library(tidyverse)


# Loading the data

fo_2012 <- read_csv("fieldoffice_2012_bycounty.csv",col_types = cols(
  state = col_character(),
  fips = col_double(),
  obama12fo = col_double(),
  romney12fo = col_double(),
  battle = col_logical(),
  swing = col_logical(),
  core_dem = col_logical(),
  core_rep = col_logical(),
  normal = col_double(),
  medage08 = col_double(),
  pop2008 = col_double(),
  medinc08 = col_double(),
  black = col_double(),
  hispanic = col_double(),
  pc_less_hs00 = col_double(),
  pc_degree00 = col_double()
))

fo_dem <- read_csv("fieldoffice_2004-2012_dems.csv",col_types = cols(
  year = col_double(),
  candidate = col_character(),
  state = col_character(),
  fips = col_double(),
  battle = col_logical(),
  number_fo = col_double(),
  dummy_fo = col_double(),
  population = col_double(),
  totalvote = col_double(),
  demvote = col_double(),
  dempct = col_double(),
  turnout = col_double(),
  turnout_lag = col_double(),
  turnout_change = col_double(),
  dummy_fo_lag = col_double(),
  dummy_fo_change = col_double(),
  dempct_lag = col_double(),
  dempct_change = col_double()
))

fo_add <- read_csv("fieldoffice_2012-2016_byaddress.csv",col_types = cols(
  year = col_double(),
  party = col_character(),
  candidate = col_character(),
  state = col_character(),
  city = col_character(),
  latitude = col_double(),
  longitude = col_double(),
  full_address = col_character()
))

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


# Field Offices 2012 and 2016

fo_add %>%
  select(candidate,year,state,party) %>% 
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  group_by(candidate) %>%
  ggplot(aes(x=candidate,fill=Color)) +geom_histogram(stat="count") +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Number of Field Offices in the 2012 and 2016 Presidential Election",
       subtitle = "Democrats tend to have more field offices than Republicans",
       x="Candidate",y= "Number of Field Offices") +
  labs(fill = "Party") +
  theme(plot.title = element_text(face = "bold",size=35)) +
  theme(legend.title = element_text(color = "gray1", size = 29),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 29)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))


ggsave("field_offices_number.png", height = 13, width = 21)




# Field Offices Swing States 2016

fo_add %>%
  filter(year==2016) %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  filter(state %in% c("FL","AZ","PA","GA","MN","NC","WI","MI")) %>%
  group_by(candidate,state) %>%
  ggplot(aes(x=state,fill=Color)) +geom_histogram(stat="count") + facet_grid(~candidate)  +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red"))  +
  labs(title ="Number of Field Offices in the 2012 and 2016 Presidential Election",
       subtitle = "Investigating Field Office Numbers for 2020 Swing States",
       x="State",y= "Number of Field Offices") +
  labs(fill = "Party")  +
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


ggsave("field_offices_2016_swing.png", height = 13, width = 21)



# Demographics Arizona

 a <- demog %>%
  filter(state=="AZ") %>%
  filter(year>1999)

# Gathering columns 

demographics <- demog %>% gather(race, pop,Black,Hispanic,Indigenous,White,Asian)

# Creating demographic change graph

demographics %>%
  filter(state=="AZ") %>%
  filter(year>1999) %>% 
  filter(!year %in% c("2001", "2003","2005","2007","2009","2011","2013","2015","2017")) %>%
  filter(race != "Indigenous") %>%
  group_by(race) %>%
  ggplot(aes(x=race,y=pop)) +geom_col() +facet_wrap(~year,scales = "free_x")  +
  labs(title ="Change in Arizona's Demographic 2000-2018",
       subtitle = "Former Red State turned Swing. Does Demographics come into Play?",
       x="Race",y= "Percentage of the Population")  +
  theme(plot.title = element_text(face = "bold",size=35))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 26, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(strip.text.x = element_text(size = 26))

  
ggsave("AZ_demographics.png", height = 15, width = 21)


# Merging the data 

pvstate_df <- read_csv("popvote_bystate_1948-2016.csv",col_types = cols(
  state = col_character(),
  year = col_double(),
  total = col_double(),
  D = col_double(),
  R = col_double(),
  R_pv2p = col_double(),
  D_pv2p = col_double()
))


hi <- pvstate_df %>%
  filter(year==2016) %>%
  filter(state=="PA")

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

pvstate_df$state <- state.abb[match(pvstate_df$state, state.name)]

pollstate_df$state <- state.abb[match(pollstate_df$state, state.name)]

# Data

dat <- pvstate_df %>% 
  full_join(pollstate_df %>% 
              filter(weeks_left == 3) %>% 
              group_by(year,party,state) %>% 
              summarise(avg_poll=mean(avg_poll)),
            by = c("year" ,"state")) %>%
  left_join(demog %>%
              select(-c("total")),
            by = c("year" ,"state"))

# Data Change 

dat_change <- dat %>%
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


# Election Model

dat_change$region <- state.division[match(dat_change$state, state.abb)]
demog$region <- state.division[match(demog$state, state.abb)]


mod_demog_change <- lm(D_pv2p ~ Black_change + Hispanic_change +
                         Female_change + as.factor(region),data = dat_change)

summary(mod_demog_change)

table_demographics <- tidy(mod_demog_change)

gt(table_demographics) %>%
  tab_header(
    title = "Demographic Change on Demoratic Vote Shares in Presidential Elections",
    subtitle = "1976-2016"
  ) %>%
  fmt_number(columns=2:4,decimals = 2) 

table_demographics 


# Election Model with Multiple Variables

modeltrial <-lm(D_pv2p ~ Black_change + Hispanic_change,data = dat_change)
summary(modeltrial)

model <- lm(D_pv2p ~ Black_change + Hispanic_change +avg_poll + as.factor(region),data = dat_change)
summary(model)

# GT Table

table_model <- tidy(model)

gt(table_model) %>%
  tab_header(
    title = "Demographic Change and Poll Support on Demoratic Vote Shares in Presidential Elections",
    subtitle = "1976-2016"
  ) %>%
  fmt_number(columns=2:4,decimals = 3) 

table_model

# Election Model for Swing States 


### Arizona

A <- dat_change %>%
  filter(state=="AZ") %>%
  filter(year==2016)

#Change in hispanic

(32-27.94139)/27.94139 = 0.1452544

# Change in black

(4-3.82)/3.82 =  0.04712042
  
  

59.074 +2.194*( 0.04712042) + 0.349*(0.1452544) -0.004*(49) =  59.03208

59.03208 -17.171 =  41.86108


### Florida

FL <- dat_change %>%
  filter(state=="FL") %>%
  filter(year==2016)


#Change in hispanic

(26-23.9)/23.9 = 0.08786611



# Change in black

(15-14.94)/14.94 = 0.004016064



59.074 + 2.194*(0.004016064) + 0.349*(0.08786611) -0.004*(49) =  58.91748

58.91748 - 17.125 = 41.79248




#### PA


PA <- dat_change %>%
  filter(state=="PA") %>%
  filter(year==2016)

#Change in hispanic

(8-6.02)/6.02 = 0.3289037


# Change in black

(10-10.69)/10.69 =  -0.0645463


59.074 + 2.194*(-0.0645463) + 0.349*(0.3289037) -0.004*(49) = 58.85117

58.85117 - 2.041 = 56.81017


# Out of Sample Prediction 


model <- lm(D_pv2p ~ Black_change + Hispanic_change +avg_poll + as.factor(region),data = dat_change)

model_AZ <- dat_change %>%
  filter(state=="AZ")

#### Arizona 

outsamp_mod  <- lm(D_pv2p ~ Black_change +Hispanic_change + avg_poll + as.factor(region),model_AZ[model_AZ$year!= 2016,])
outsamp_pred <- predict(outsamp_mod, model_AZ[model_AZ$year == 2016,])

# Averaging the prediction vote share values

outsamp <- mean(outsamp_pred)
outsamp_true <- model_AZ$D_pv2p[model_AZ$year == 2016] 


### Florida

model_FL <- dat_change %>%
  filter(state=="FL")


outsamp_mod  <- lm(D_pv2p ~ Black_change +Hispanic_change + avg_poll + as.factor(region),model_FL[model_FL$year!= 2016,])
outsamp_pred <- predict(outsamp_mod, model_FL[model_FL$year == 2016,])

# Averaging the prediction vote share values

outsamp <- mean(outsamp_pred)
outsamp_true <- model_FL$D_pv2p[model_FL$year == 2016] 


### PA

model_PA <- dat_change %>%
  filter(state=="PA")


outsamp_mod  <- lm(D_pv2p ~ Black_change +Hispanic_change + avg_poll + as.factor(region),model_PA[model_PA$year!= 2016,])
outsamp_pred <- predict(outsamp_mod, model_PA[model_PA$year == 2016,])

# Averaging the prediction vote share values

outsamp <- mean(outsamp_pred)
outsamp_true <- model_PA$D_pv2p[model_PA$year == 2016] 
















