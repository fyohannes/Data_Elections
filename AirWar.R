# Air War

# Packages

library(readr)
library(tidyr)
library(ggplot2)
library(dplyr)
library(maps)
library(cowplot)
library(grid)
library(gridExtra)
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
  count(ad_issue) %>% 
  arrange(desc(n)) %>% 
  slice(1:5)
  


c_2000 <- creative1 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,y=n, fill=Color)) +geom_col() + 
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2000 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain",angle = 80),
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
  count(ad_issue) %>% 
  arrange(desc(n)) %>% 
  slice(1:5)





c_2004 <- creative2 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,y=n, fill=Color)) +geom_col() +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2004 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain",angle = 80),
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
  count(ad_issue) %>% 
  arrange(desc(n)) %>% 
  slice(1:3)

rename.variable(creative3, "economy", "ecpolicy")
creative3<- creative3 %>%
  mutate(Economy="ecpolicy")
rename(creative3$Economy==creative3$ecpolicy) %>%
  rename(Other= "othpolicy") %>%
  rename(Social_Welfare= "swpolicy") %>%


c_2008 <- creative3 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,y=n,fill=Color)) +geom_col() +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2008 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain",angle = 80),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  +
  labs(fill = "Party") 

###### plot 3,2012

creative4 <- creative %>%
  filter(cycle==2012) %>%
  group_by(party,cycle) %>%
  count(ad_issue) %>% 
  arrange(desc(n)) %>% 
  slice(1:3)


c_2012 <- creative4 %>%
  mutate(Color = ifelse(party == "democrat", "blue", "red")) %>%
  ggplot(aes(x=ad_issue,y=n, fill=Color)) +geom_col() +
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  labs(title ="Most Popular Ad Issues in the 2012 Election",
       subtitle = "Democrats vs Republicans",
       x="Issue Area",y= "Number of References") +
  theme(plot.title = element_text(face = "bold",size=25)) +
  theme(legend.title = element_text(color = "gray1", size = 18),legend.key.width = unit(0.8,"cm"),legend.key.size = unit(0.8, "cm")) +
  theme(
    legend.text = element_text(color = "black", size = 17)
  )+
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain",angle=80),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain"))+
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))+
  theme(plot.subtitle = element_text(face = "bold",size=24))  +
  labs(fill = "Party") 



# Plot grid 2000,2004

plot_grid(c_2000,c_2004)

ggsave("ad_issues_00_04.png", height = 12, width = 18)

# Plot grid 2008,2012

plot_grid(c_2008,c_2012)

ggsave("ad_issues_08.png", height = 12, width = 18)




###### Biden,Trump 2020 total costs and airings

ad_2020_1 <- ad_2020 %>%
  mutate(total_airings_all = sum(total_airings)) 

ad_2020_1 <- ad_2020_1 %>%
  gather(candidate, "biden_airings", "trump_airings")

ad_2020 %>%
  ggplot(aes(x=total_airings, y=value, fill=group))+
  geom_bar(width = 1, stat = "identity")
bp


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


#### National Model for spending

### Mutating Campaign dataset

campaign1 <- campaign %>%
  group_by(party,cycle) %>%
  mutate(sum= sum(total_cost)) %>%
  distinct(sum) %>%
  rename(year="cycle")


campaign_new <- campaign1 %>%
  filter(cycle==2000) %>%
  distinct(party,sum) %>%
  
### Pie Chart
  
p2000 <- campaign_new %>%
  ggplot(aes(x=party,y=sum,fill=party)) +
  geom_bar(width = 1, stat = "identity") + 
  scale_fill_manual(labels=c("Democrat", "Republican"), values = c("blue", "red")) +
  scale_y_continuous(labels = scales::comma)

p2000 + coord_polar("y", start=0)
  

#### National Regression 

poll_pvstate_vep_df <- popvote %>% filter(year>1996) %>%
  inner_join(poll_national %>% filter(weeks_left == 5)) %>%
  left_join(vep_df %>% filter(state=="United States")) %>%
  left_join(campaign1,by = c("year", "party"))


# Cleaning data 

data1 <- poll_pvstate_vep_df %>%
  distinct(candidate, .keep_all = TRUE) %>%
  mutate(total= (VEP + VAP)) 


# Model 1, national 

  model1_df <- 
    poll_pvstate_vep_df %>%
    filter(incumbent_party=="TRUE") %>%
    mutate(total= (VEP + VAP)) %>%
    mutate(D= (VEP/total)) %>%
    as_factor(D)
  

# Need this for regression, specific to Republicans 
  
# Model for Trump 2020

  cbind(total, VEP-total)

  model_airwar <- lm(pv~avg_support +sum,data=data1)
  summary(model_airwar)
  
data1 <- data1 %>%
  filter(party=="republican")
  


# Predictions 
  
  # 2000 out of sampling 
  
  outsamp_mod  <- lm(pv ~ avg_support+sum,data1[data1$year!= 2000,])
  outsamp_pred <- predict(outsamp_mod, data1[data1$year == 2000,])
  outsamp_true <- data1$pv[data1$year == 2000] 
  
  
  # 2004 out of sampling
  
  
  outsamp_mod1  <- lm(pv ~ avg_support+sum,data1[data1$year!= 2004,])
  outsamp_pred1 <- predict(outsamp_mod, data1[data1$year == 2004,])
  outsamp_true1 <- data1$pv[data1$year == 2004] 
  
  

# Not a good model, adjusted R squared is around 0.1731, insignificant
  
  
###### State by State, Swing States identitfied in first blog
  
pollstate_df <- read_csv("pollavg_bystate_1968-2016.csv",col_types = cols(
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


poll_pvstate_vep_df <- pvstate_df %>%
    inner_join(pollstate_df %>% filter(weeks_left == 5)) %>%
    left_join(vep_df)

poll_pvstate_df <- pvstate_df %>%
  inner_join(pollstate_df %>% 
      filter(weeks_left == 5))
  
ND_D <- poll_pvstate_vep_df %>%filter(state=="North Dakota", party=="democrat")
ND_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, ND_D,family = binomial)


  
### Social Media Spending 

social_media <- read_csv("wmp-table-2.csv",col_types = cols(
  X1 = col_double(),
  X2 = col_character(),
  `Page Name` = col_character(),
  `Page ID` = col_double(),
  Democrats = col_double(),
  Republicans = col_double(),
  `Candidates Mentioned+` = col_character(),
  `Approx. Spend on Mentions^` = col_character(),
  `# of Ads Mentioning` = col_number(),
  `Sponsor Name(s)` = col_character(),
  `Candidate Page` = col_double(),
  `Approx. Democrat Spend` = col_character(),
  `Approx. Republican Spend` = col_character()
))

library("janitor")

social_media <- social_media %>%
  clean_names()

social_media$approx_spend_on_mentions = as.numeric(gsub("\\$", "", social_media$approx_spend_on_mentions))

social_media %>%
  arrange(desc(number_of_ads_mentioning)) %>% 
  slice(1:12) %>%
  ggplot(aes(x=page_name, y=number_of_ads_mentioning)) +geom_col(fill="palegreen4") +
  labs(title ="Page Teams that Sponsored the Most Ads in the 2020 Election",
       subtitle = "Top 12 Page Teams",
       x="Page Name",y= "Number of Ads") +
  theme(plot.title = element_text(face = "bold",size=35))+
  theme(plot.subtitle = element_text(face = "bold",size=29)) +
  theme(plot.caption =element_text(face = "bold",size=27))+
  theme(axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 30)) +
  theme(
    legend.title = element_text(color = "black", size = 29),
    legend.text = element_text(color = "black", size = 29)
  ) +
  theme(axis.text.x = element_text(color = "black", size = 26, hjust = .5, vjust = .5, face = "plain",angle=60),
        axis.text.y = element_text(color = "black", size = 26, angle = 0, hjust = 1, vjust = 0, face = "plain")) 


ggsave("social_media.png", height = 13, width = 21)


### Swing States Ad War ---- Arizona, Florida, Georgia,Minnesota, Michigan, Wisconsin,Pennsylvania, Wisconsin


# Merge Datasets


poll_state_df <- read.csv("pollavg_bystate_1968-2016.csv")
pvstate_df    <- read_csv("popvote_bystate_1948-2016.csv",col_types = cols(
  state = col_character(),
  year = col_double(),
  total = col_double(),
  D = col_double(),
  R = col_double(),
  R_pv2p = col_double(),
  D_pv2p = col_double()
))

poll_pvstate_df <- pvstate_df %>%
  inner_join(
    pollstate_df %>% 
      filter(weeks_left == 5)
  ) 

poll_pvstate_vep_df <- poll_pvstate_df %>%
  left_join(vep_df,by = c("year", "state"))
    
    
#Pennsylvania 

VEP_PA_2020 <- as.integer(vep_df$VEP[vep_df$state == "Pennsylvania" & vep_df$year == 2016])

PA_R <- poll_pvstate_vep_df %>% filter(state=="Pennsylvania", party=="republican")
PA_D <- poll_pvstate_vep_df %>% filter(state=="Pennsylvania", party=="democrat")

## Fit D and R models
PA_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, PA_R, family = binomial)
PA_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, PA_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_PA_2020 <- predict(PA_R_glm, newdata = data.frame(avg_poll=44.5), type="response")[[1]]
prob_Dvote_PA_2020 <- predict(PA_D_glm, newdata = data.frame(avg_poll=50), type="response")[[1]]

## Get predicted distribution of draws from the population

sim_Rvotes_PA_2020 <- rbinom(n = 10000, size = VEP_PA_2020, prob = prob_Rvote_PA_2020)
sim_Dvotes_PA_2020 <- rbinom(n = 10000, size = VEP_PA_2020, prob = prob_Dvote_PA_2020)

sim_elxns_PA_2020 <- ((sim_Dvotes_PA_2020-sim_Rvotes_PA_2020)/(sim_Dvotes_PA_2020+sim_Rvotes_PA_2020))*100
PA <- hist(sim_elxns_PA_2020, xlab="Predicted Draws of Biden win margin (% pts)",main = "Pennsylvania Historgram of Biden Win Margin\n10,000 Binomial Process Simulations",xlim=c(2, 7.5)) +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))


## how much 1000 GRP buys in % votes + how much it costs
GRP1000.buy_fx.huber     <- 7.5
GRP1000.buy_fx.huber_se  <- 2.5
GRP1000.buy_fx.gerber    <- 5
GRP1000.buy_fx.gerber_se <- 1.5
GRP1000.price            <- 300


## How much $ for Trump to get ~2% win margin?
## --> Trump needs to gain 10% 
((10/GRP1000.buy_fx.huber) * GRP1000.price * 1000)  ## price according to Huber et al
((10/GRP1000.buy_fx.gerber) * GRP1000.price * 1000) ## price according to Gerber et al

sim_elxns_PA_2020_shift.b <- sim_elxns_PA_2020 - rnorm(10000, 10, GRP1000.buy_fx.huber_se) ## shift from that buy according to Huber et al
sim_elxns_PA_2020_shift.a <- sim_elxns_PA_2020 - rnorm(10000, 10, GRP1000.buy_fx.gerber_se) ## shift from that buy according to Huber et al



#### Arizona 

VEP_AZ_2020 <- as.integer(vep_df$VEP[vep_df$state == "Arizona" & vep_df$year == 2016])

AZ_R <- poll_pvstate_vep_df %>% filter(state=="Arizona", party=="republican")
AZ_D <- poll_pvstate_vep_df %>% filter(state=="Arizona", party=="democrat")

## Fit D and R models
AZ_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, AZ_R, family = binomial)
AZ_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, AZ_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_AZ_2020 <- predict(AZ_R_glm, newdata = data.frame(avg_poll=45), type="response")[[1]]
prob_Dvote_AZ_2020 <- predict(AZ_D_glm, newdata = data.frame(avg_poll=48), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_AZ_2020 <- rbinom(n = 10000, size = VEP_AZ_2020, prob = prob_Rvote_AZ_2020)
sim_Dvotes_AZ_2020 <- rbinom(n = 10000, size = VEP_AZ_2020, prob = prob_Dvote_AZ_2020)

sim_elxns_AZ_2020 <- ((sim_Rvotes_AZ_2020-sim_Dvotes_AZ_2020)/(sim_Dvotes_AZ_2020+sim_Rvotes_AZ_2020))*100
AZ <- hist(sim_elxns_AZ_2020, xlab="Predicted draws of Trump win margin (% pts)",main = "Arizona Historgram of Trump Win Margin\n10,000 Binomial Process Simulations") +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))



#### Georgia

VEP_GA_2020 <- as.integer(vep_df$VEP[vep_df$state == "Georgia" & vep_df$year == 2016])

GA_R <- poll_pvstate_vep_df %>% filter(state=="Georgia", party=="republican")
GA_D <- poll_pvstate_vep_df %>% filter(state=="Georgia", party=="democrat")

## Fit D and R models
GA_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, GA_R, family = binomial)
GA_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, GA_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_GA_2020 <- predict(GA_R_glm, newdata = data.frame(avg_poll=47), type="response")[[1]]
prob_Dvote_GA_2020 <- predict(GA_D_glm, newdata = data.frame(avg_poll=48), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_GA_2020 <- rbinom(n = 10000, size = VEP_GA_2020, prob = prob_Rvote_GA_2020)
sim_Dvotes_GA_2020 <- rbinom(n = 10000, size = VEP_GA_2020, prob = prob_Dvote_GA_2020)

sim_elxns_GA_2020 <- ((sim_Dvotes_GA_2020 -sim_Rvotes_GA_2020)/(sim_Dvotes_GA_2020+sim_Rvotes_GA_2020))*100
GA <- hist(sim_elxns_GA_2020, xlab="Predicted draws of Biden win margin (% pts)",main = "Georgia Historgram of Biden Win Margin\n10,000 Binomial Process Simulations")  +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))




#### Florida

VEP_FL_2020 <- as.integer(vep_df$VEP[vep_df$state == "Florida" & vep_df$year == 2016])

FL_R <- poll_pvstate_vep_df %>% filter(state=="Florida", party=="republican")
FL_D <- poll_pvstate_vep_df %>% filter(state=="Florida", party=="democrat")

## Fit D and R models
FL_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, FL_R, family = binomial)
FL_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, FL_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_FL_2020 <- predict(FL_R_glm, newdata = data.frame(avg_poll=44), type="response")[[1]]
prob_Dvote_FL_2020 <- predict(FL_D_glm, newdata = data.frame(avg_poll=48), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_FL_2020 <- rbinom(n = 10000, size = VEP_FL_2020, prob = prob_Rvote_FL_2020)
sim_Dvotes_FL_2020 <- rbinom(n = 10000, size = VEP_FL_2020, prob = prob_Dvote_FL_2020)

sim_elxns_FL_2020 <- ((sim_Dvotes_FL_2020 -sim_Rvotes_FL_2020)/(sim_Dvotes_FL_2020+sim_Rvotes_FL_2020))*100
FL <- hist(sim_elxns_FL_2020, xlab="Predicted draws of Biden win margin (% pts)",main = "Florida Historgram of Biden Win Margin\n10,000 Binomial Process Simulations")  +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))


###Advertisements


## how much 1000 GRP buys in % votes + how much it costs
GRP1000.buy_fx.huber     <- 7.5
GRP1000.buy_fx.huber_se  <- 2.5
GRP1000.buy_fx.gerber    <- 5
GRP1000.buy_fx.gerber_se <- 1.5
GRP1000.price            <- 300


## How much $ for Trump to get ~2% win margin?
## --> Trump needs to gain 10% 
((10/GRP1000.buy_fx.huber) * GRP1000.price * 1000)  ## price according to Huber et al
((10/GRP1000.buy_fx.gerber) * GRP1000.price * 1000) ## price according to Gerber et al

sim_elxns_FL_2020_shift.b <- sim_elxns_FL_2020 - rnorm(10000, 10, GRP1000.buy_fx.huber_se) ## shift from that buy according to Huber et al
sim_elxns_FL_2020_shift.a <- sim_elxns_FL_2020 - rnorm(10000, 10, GRP1000.buy_fx.gerber_se) ## shift from that buy according to Huber et al




#### MINNESOTA

VEP_MN_2020 <- as.integer(vep_df$VEP[vep_df$state == "Minnesota" & vep_df$year == 2016])

MN_R <- poll_pvstate_vep_df %>% filter(state=="Minnesota", party=="republican")
MN_D <- poll_pvstate_vep_df %>% filter(state=="Minnesota", party=="democrat")

## Fit D and R models
MN_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, MN_R, family = binomial)
MN_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, MN_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_MN_2020 <- predict(MN_R_glm, newdata = data.frame(avg_poll=44), type="response")[[1]]
prob_Dvote_MN_2020 <- predict(MN_D_glm, newdata = data.frame(avg_poll=48), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_MN_2020 <- rbinom(n = 10000, size = VEP_MN_2020, prob = prob_Rvote_MN_2020)
sim_Dvotes_MN_2020 <- rbinom(n = 10000, size = VEP_MN_2020, prob = prob_Dvote_MN_2020)

sim_elxns_MN_2020 <- ((sim_Dvotes_MN_2020 -sim_Rvotes_MN_2020)/(sim_Dvotes_MN_2020+sim_Rvotes_MN_2020))*100
MN <- hist(sim_elxns_MN_2020, xlab="Predicted draws of Biden win margin (% pts)",main = "Minnesota Historgram of Biden Win Margin\n10,000 Binomial Process Simulations")  +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))




#### Wisconsin

VEP_WI_2020 <- as.integer(vep_df$VEP[vep_df$state == "Wisconsin" & vep_df$year == 2016])

WI_R <- poll_pvstate_vep_df %>% filter(state=="Wisconsin", party=="republican")
WI_D <- poll_pvstate_vep_df %>% filter(state=="Wisconsin", party=="democrat")

## Fit D and R models
WI_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, WI_R, family = binomial)
WI_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, WI_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_WI_2020 <- predict(WI_R_glm, newdata = data.frame(avg_poll=43), type="response")[[1]]
prob_Dvote_WI_2020 <- predict(WI_D_glm, newdata = data.frame(avg_poll=50), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_WI_2020 <- rbinom(n = 10000, size = VEP_WI_2020, prob = prob_Rvote_WI_2020)
sim_Dvotes_WI_2020 <- rbinom(n = 10000, size = VEP_WI_2020, prob = prob_Dvote_WI_2020)

sim_elxns_WI_2020 <- ((sim_Dvotes_WI_2020 -sim_Rvotes_WI_2020)/(sim_Dvotes_WI_2020+sim_Rvotes_WI_2020))*100
WI <- hist(sim_elxns_WI_2020, xlab="Predicted draws of Biden win margin (% pts)",main = "Wisconsin Historgram of Biden Win Margin\n10,000 Binomial Process Simulations")  +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))




#### Michigan

VEP_MI_2020 <- as.integer(vep_df$VEP[vep_df$state == "Michigan" & vep_df$year == 2016])

MI_R <- poll_pvstate_vep_df %>% filter(state=="Michigan", party=="republican")
MI_D <- poll_pvstate_vep_df %>% filter(state=="Michigan", party=="democrat")

## Fit D and R models
MI_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, MI_R, family = binomial)
MI_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, MI_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_MI_2020 <- predict(MI_R_glm, newdata = data.frame(avg_poll=43), type="response")[[1]]
prob_Dvote_MI_2020 <- predict(MI_D_glm, newdata = data.frame(avg_poll=51), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_MI_2020 <- rbinom(n = 10000, size = VEP_MI_2020, prob = prob_Rvote_MI_2020)
sim_Dvotes_MI_2020 <- rbinom(n = 10000, size = VEP_MI_2020, prob = prob_Dvote_MI_2020)

sim_elxns_MI_2020 <- ((sim_Dvotes_MI_2020 -sim_Rvotes_MI_2020)/(sim_Dvotes_MI_2020+sim_Rvotes_MI_2020))*100
MI <- hist(sim_elxns_MI_2020, xlab="Predicted draws of Biden win margin (% pts)",main = "Michigan Historgram of Biden Win Margin\n10,000 Binomial Process Simulations")  +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))




#### North Carolina 

VEP_NC_2020 <- as.integer(vep_df$VEP[vep_df$state == "North Carolina" & vep_df$year == 2016])

NC_R <- poll_pvstate_vep_df %>% filter(state=="North Carolina", party=="republican")
NC_D <- poll_pvstate_vep_df %>% filter(state=="North Carolina", party=="democrat")

## Fit D and R models
NC_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, NC_R, family = binomial)
NC_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, NC_D, family = binomial)

## Get predicted draw probabilities for D and R
prob_Rvote_NC_2020 <- predict(NC_R_glm, newdata = data.frame(avg_poll=46), type="response")[[1]]
prob_Dvote_NC_2020 <- predict(NC_D_glm, newdata = data.frame(avg_poll=59), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_NC_2020 <- rbinom(n = 10000, size = VEP_NC_2020, prob = prob_Rvote_NC_2020)
sim_Dvotes_NC_2020 <- rbinom(n = 10000, size = VEP_NC_2020, prob = prob_Dvote_NC_2020)

sim_elxns_NC_2020 <- ((sim_Dvotes_NC_2020 -sim_Rvotes_NC_2020)/(sim_Dvotes_NC_2020+sim_Rvotes_NC_2020))*100
NC <- hist(sim_elxns_NC_2020, xlab="Predicted draws of Biden win margin (% pts)",main = "North Carolina  Historgram of Biden Win Margin\n10,000 Binomial Process Simulations")  +
  theme(plot.title = element_text(face = "bold",size=22)) +
  theme(axis.text.x = element_text(color = "black", size = 27, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 27, angle = 0, hjust = 1, vjust = 0, face = "plain")) +
  theme(
    axis.title.x = element_text(size = 28),
    axis.title.y = element_text(size = 28))




### Plot Grid together 


grid.arrange(grobs = list(AZ, FL,GA, nrow = 1,top="Main Title"))

par(mfrow = c(3, 1))
AZ
FL
GA
par(mfrow = c(3, 1))

ggsave("air_war_states1.png", height = 12, width = 18)

plot_grid(MN,WI,MI)

ggsave("air_war_states2.png", height = 12, width = 18)

plot_grid(PA,NC)

ggsave("air_war_states3.png", height = 12, width = 18)












