**<font size="5"> Incumbency: Can being an Incumbent Give You an Advantage? </font>**

_**<font size="2"> October 3rd 2020 </font>**_



**<font size="3"> Presidential Elections and Federal Grants  </font>**

Many people wonder if incumbent parties and presidents benefit from incumbency? Is there something uniquely distinct about being an incumbent president and running for president? Is it the name recognition? The ability to use presidential powers to sway voters in the upcoming election? While some scholars such as blank argue that incumbency does not matter as much as we think, because of the Time for Change Model (the theory that after multiple years with the same party, voters are inclined to vote for the party not in office). Nevethless, I will explore the history of a possible incumbency advantage and factor any findings in my model for the 2020 Presidential election.


![Incumbent Federal Grants Historial](incumbent_historical.png)


First, the graph above compares the number of popular vote wins from incumbent parties by party. As we can see from the graph above, in 9 out of the 18 elections since 1948, the incumbent party has won the popular vote share. It's important to note the difference between winning the popular vote vs the actual election as there are times where the winner of the popular vote loses the electoral college, and thus the election, as in the case of 2016. However, this graph doesn't show a signifcant advantage to incumbent parties. They seem to win the popular vote at rates similar those candidates from the opposing candidate. If it is not the incumbent party in itself that gives a comparative advantage? Perhaps, there may be other factors that are important to note when thinking about incumbency.




**<font size="3">  Federal Grants in Election Cycles </font>**

I will now explore if there is any particular incumbency party advantage, particulary with federal grants. I will look at federal grants as a way to analyze if presidential powers, such as increasing federal grants, has any effect on the outcome of the election. Presidents may use the powers of their office to increase federal spending as a way to incentivize voters to vote for them, thus an example of when incumbency could give some sort of advantage. 



![Incumbent Federal Grants in Election Cycles](incumbent_grants.png)


In the graph above, I explore different grant amounts for election years vs non election years and swing states vs core states.For core statees we see 5.7 billion dollars awarded for election years and 16.23 awarded for non election years. For swing states we see 8.75 awarded during an election year and 24.1 during non election years.  When comparing swing states vs core states, we see that swing states on average recieve more federal funding than core states. Furthermore, there also is a considerable amount of federal grants awarded during election year. During election years, states recieve more federal grants than average. We can find this average by dividing the non election years by 3 and comparing it to the federal grants awarded during election years. For core states, they recieved on average around 4.07 billion, while swing states recieved around 8 billion . As we can see 5.7 billion is much higher than 4.07 billion, likewise with 8.75 billion as well. From this, it seems like there is evidence that the amount federal grants during election years, perhaps suggesting that this is one method in which incumbents/incumbent parties use their power to gain more support from the American peple. 

**<font size="3">  Presidential Model: Predicting Outcome </font>**

I wanted to create a model that incorporated both poll support and change in federal grant averages for election years as predictor variables in my model. My first predictor variable is average poll support variable, something that I exlored in great detail in my last blog post. The second predictor variable is the average change in federal grant in election years.In my model, I decided to include federal grants as a predictor variable, alongside poll support averages from my [last blog post](https://fyohannes.github.io/Data_Elections/Poll.html).


#include table

The table above shows that without any poll support and federal aid awarded throughout the coutnry, the incumbent party would expect to recieve -44.75, which of course is not actually possible. Futheremore, for each percentage increase in poll support, the incumbent party would recieve an increase in the popular vote by 1.96 and for every increase in percentage change in federal aid the incumbent could expect an increase of 0.1679 in popular votes. From this model, one can see that, poll support seems to have a much larger impact than the percent change in federal grant dollars. 

Additionally, some other things I explored in regard to the model included the R squared value and a out of sample testing. The model's R squared value, is 0.89, which is quite close to 1 and shows that this model is a good fit for the data. Along with finding the R squared value, I calculated an out of sample testing for the 2004 election. When conducting this out of sample testing, the model predicted that Bush would recieve 51.29 percent of the popular vote,around 0.7 points higher than the true popular vote share, which was 50.57 percent. 

After investigating the R squared value and conducting an out of sample test for my model, I graphed the residuals of my model to get a better sense of variation in the predicted vs true popular vote shares.


![Incumbent Federal Grants Residual Grants](incumbent_residuals.png)



The graph above shows a plot where fitted values are on the x axis and residuals, the difference between the true and predicted value, are on the y axis. In an ideal model, we would want to the points centered around 0 because that would tell us that the residual values are small, which essentially demonstrates that the model is a good predictor. The graph above, is not centered around 0 and does have a great deal of outliers. However, part of this could be due to the small amount of data that we have. Our model uses data from 7 elections and perhaps if we had a larger sample/dataset, our model would be centered around 0. Despite the residuals, our R squared still shows that this model is a good fit for the data, so I still think there's value in using this to predict the 2020 election.



**<font size="3">  Predicting the 2020 Outcome </font>**

To predict the outcome of the 2020 election, I used the above model in two ways. For my first model, I inputted Trump's poll average of 41 percent and change in federal grant spending of 0.089 percent. For the federal grant spending, I used [data](https://www.cbo.gov/publication/56324)to calulate the difference of spending from 2019 (4.4 trillion) and 2020 (4.79 trillion), disregarding additional federal spending on COVID. This model predicted that Trump would recieve around 36 percent of the popular vote. 

I also used this model with slighlty different federal spending data. I used [data](https://datalab.usaspending.gov/federal-covid-funding/) to calculate the federal spending growth rate with the inclusion of federal aid for Covid, which was an additional 2.59 trillion. Given this, the change in spending between 2019 and 2020 was not 8.9 percent, but rather close to 67 percent. Despite this increased spending, the model predicted that Trump would win 36.11 percent. Given this small increase in popular vote shares, one can assume that in this model, federal spending has little impact on popular vote shares.


**<font size="3">  Conclusion </font>**

In conclusion, 







