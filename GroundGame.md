**<font size="5"> Ground War: What impact does it have?? </font>**

_**<font size="2"> October 18th 2020 </font>**_



**<font size="3"> Field Offices in 2014 and 2016 </font>**

Deciding where to campaign is a key question for many campaign teams. What states should they campaign in? How many offices should they open? The graph below investigates some of the differences in campaign strategy for field offices between Democrats and Republicans.




![Field Offices](field_offices_number.png)


In the last two elections, Democrats have completely dominated the field office arena. In 2012, Obama had close to 800 field offices and Romney had around 300. In the 2016 election, Clinton had a little over 500 field offices and Trump had less than 200. Part of the decline in overall field offices between 2012 and 2016 could be due to the prominence of social media in campaign strategy and perhaps its impact on reducing the number of field offices needed. Nevertheless, over the last two elections, Democrats have had many more field offices in comparison to their opponents. But what does this mean in terms of the election outcome? Do field offices matter?



**<font size="3"> Field Offices in Swing States in 2016 </font>**

Field offices are an integral part of the campaign strategy. Deciding where to place a field office comes with great thought and consideration. Do you place a field office in a safe state such as Massachusetts or Lousianna, as a way to further induce the wave of blue and red, respectively? Or do you put it in a swing state and concentrate more on your efforts there?




![Field Offices Swing 2016](field_offices_2016_swing.png)

Generally, candidates end up allocating more time and resources into swing states, which also results in increased field offices. The graph above compares field office allocations for Trump and Clinton in eight swing states mentioned in the first blog post. As one would expect, Clinton had more field offices in swing states. The only state that Trump had more field offices was Arizona. Otherwise, Clinton generally had more field offices. She particularly had increased field offices in Florida, Pennsylvania, Wisconsin, and North Carolina. However, despite the number of field offices, she lost all four states. Thus, do field office numbers make a difference? Or are there other aspects of the ground game that have a larger impact?




**<font size="3"> Arizona Demographics since 2000 </font>**

Throughout the entire 2020 election, Arizona has been deemed a swing state. A historically red state that has not voted for a Democratic candidate in over 24 years is now [purple](https://www.nytimes.com/2020/10/15/opinion/arizona-biden-trump-2020.html). There are multiple plausible reasons for this, such as Arizona's overwhelmingly moderate stance on both the right and the left; however, some state that Arizona's shift could be due to demographic shifts. These demographic shifts include increased relocation to Arizona for employment purposes, as well as the increase in the Hispanic/Latino community.




![AZ Demographics](AZ_demographics.png)

The graph above shows the change in Arizona's demographics from 2000-2016. In 2000, white people made up around _**69**_ percent of the population, black people _**3**_ percent, and Hispanics _**22**_ percent. By 2018, white people made up only _**59**_ percent of the population, black people around _**4.6**_ percent, and Hispanics around _**29**_ percent. Over the last 18 years, the population of Hispanic people has increased, while the population of white people has decreased. Since Hispanics are more likely to vote for Democrats, this could be one of the reasons why Arizona has now become a swing state. But how can one attribute demographic statistics to election outcomes? Does it matter?




**<font size="3"> Election Model with Demographic Data </font>**

To measure the relationship between demographics and election outcome, I created a model with demographic variables and poll support as the predictor variables for the two-party Democratic vote share. My first model only looked at demographic variables, particularly the change in population for those who are Black, Hispanic, as well as Female. 


![Model 1](Screen Shot 2020-10-19 at 10.02.06 AM.png)



In this model, the coefficients of our predictor variables are positive, thus we can see a positive correlation between increases in the population of Black, Hispanic, and female individuals. This model tells us that these individuals generally vote for the Democratic party and increased representation in the population for these groups will lead to increased votes for Democrats.



In my second model, I wanted to combine these predictor variables with poll support to predict the outcome of the election. I used the predictor variables change in black and Hispanic populations as well as poll support to predict the outcome of Arizona, Florida, and Pennsylvania.


![Model 2 PART A ](Screen Shot 2020-10-19 at 10.30.30 AM.png)

![Model 2 PART B ](Screen Shot 2020-10-19 at 10.30.41 AM.png)

This model shows us again, that there's a positive correlation with the change in population for black and Hispanic people with the Democratic vote share. Besides these two variables, it also includes variables for each region in the United States and their average support (or lack of support) for the Democratic candidate. For example, a state that is in the South East Central will have a decrease in Democratic vote shares by around _**17**_ points, in comparison to the North East, which will only have a decrease in democratic vote shares by around _**7**_ points on average. 

I used [data](https://www.kff.org/other/state-indicator/distribution-by-raceethnicity/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D) to calculate the difference in demographics from 2016 to 2018 (the year with the most recent data). Then I looked at [270 to win](https://www.270towin.com/2020-polls-biden-trump/) to look at the most recent poll data. After receiving /calculating all of the relevant information, I filtered my model for each state and imputed these numbers into the model. My model predicted around _**41.9**_ percent of the Democratic two-party vote share for Arizona, _**41.8**_ for Florida, and _**56.8**_ percent for Pennsylvania. This model predicts that Biden will win Pennsylvania, but will lose Arizona and Florida.

In 2016, Clinton received around _**48**_ percent of the two-party vote share in Arizona, _**49**_ percent in Florida, and _**49.6**_ in Pennsylvania. While this model may be correct, something that makes me skeptical is the decrease in vote shares in Arizona. The race in Arizona is thought to be very tight in this upcoming race, thus, I would expect Biden to get a larger vote share.

To look at the validity of this model, I did an out of sample prediction for 2016. My out of sample prediction predicted that for 2016, Clinton would receive _**46.7**_ percent of the vote share in Arizona, _**48**_ percent in Florida, and _**57.**_5 in Pennsylvania. The model's out of sample prediction for Arizona and Florida was around _**1-2_** points off for Arizona and Florida. However, the model's out of sample prediction was almost _**8**_ points higher for Clinton's vote share in Pennsylvania. Thus, this model does not seem to be a good fit for Pennsylvania. 


**<font size="3"> Conclusion </font>**


Demographic changes are very interesting to consider in light of presidential elections. As the makeup of our country changes, I am interested to see how demographics will continue to impact politics and election outcomes.





