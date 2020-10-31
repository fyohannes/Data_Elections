**<font size="5"> Final Predictions for the 2020 Election </font>**

_**<font size="2"> October 28th 2020 </font>**_



**<font size="3"> Introduction </font>**

Throughout the last couple of months, I have created predicitive models for the 2020 outcome. I have looked at variables including GDP growth, unemployment, poll support, campaign advertisements, federal spending, incumbency, and COVID-19 deaths. In this Final Prediction Blog post, I will be choosing a few variables that I deem to be of the most significance and incorporating them in a model that can hopefully predict the not too far away election.

In my model, I decided to use GDP growth, poll support, and change in federal spending as my predicitve variables, with incumbency as my control. I decided to use these three variables for a multiutde of reasons. First, I , wanted to have a model that primarily focused on fundamentals,such as incumbency and the economy. The economic variable that I used in this model is GDP growth, a variable that has historically has had a strong correlation with presidential outcomes (citation). For example, if GDP increases in the quarter right before the election, voters may reward the incumbent or incumbent party by re-electing them. The opposite effect would expect to happen if GDP declined. Furthermore, I wanted to use poll support, as it seemed to be a good predictor of popular vote shares for my previous models. It is one of the only variables that somewhat measures public opinion, besides presidential approval, and is a good way to gauge people's sentiment on a particular candidate. Besides GDP growth and poll support, I also wanted to look at another economic variable tied to incumbency, federal grants. In previous models, I particulary looked at the effect of change in federal grant spending on presidential outcomes. Similiar to GDP growth, an increase in federal grant spending correlated with higher support for the incumbent candidate/party. 

Overall, I used these three variables in my model to predict the national and state by state outcome for this upcoming presidential election.


**<font size="3"> National Model </font>**

As I mentioned in my introudction, I operationalized the variables, GDP growth, change in federal spending, and poll support in my model to predict the presidential election of 2020.


**<font size="2"> Explaining the Variables Further </font>**

While historically, there has been a strong correlation with 2nd quarter GDP growth and presidnetial outcomes, I actually decided to use 2019 quarter 4 GDP as my variable of choice. The main reason why I decided to do this was because of the effect that COVID has had on the economy, both in the first quarter and in the second quarter of 2020 (mostly in the second quarter). Becuase the economy has declined due to a public health crisis and not a financial crisis, people's perception of the impact of this current recession may be different. Quarter 2 GDP growth has been a good predictor variable historically because it allows for voters to attribute blame and success to the incumbent or incumbent party. However, if voters percieve this economic crisis as an independent and uncontrollable event, it attributing blame and success becomes much more difficult. Thus, some voters may weigh economic conditions from end of 2019 more heavily than that of 2020. It is for this reason, why I decided to use 2019 Q4 data rather than 2020 Q2.

Additionally, I used change in federal spending as my other economic predictor variable.  For the federal grant spending, I used data to calculate the difference in spending from 2019 (4.4 trillion) and 2020 (4.79 trillion), disregarding additional federal spending on COVID. I decided to disregard the increase in federal spending data due to COVID because of the difficulty to weight its impact. Federal spending on COVID is used as a way to combat the nation's economic decline in the wake of a public health crisis, thus, it may be perceived differently than transfers such as Social Security or federal grants for better schools. Furthermore, I think including federal data for COVID would greatly skew our preedicitions. When I calculated the federal spending growth rate with the inclusion of federal aid for COVID, it amounted to an additional 2.59 trillion. Given this, the change in spending between 2019 and 2020 was not 8.9 percent, but rather close to 67 percent. If I were to include this 67 percent increase, predictions would highly favor the incumbent party, since federal grant growth rates have a positive relationship with vote shares for incumbent parties.

The last variable that I used was poll support averages. I used all poll data, regardless of grade, with an equal weight; however, I did filter, for poll data from the last 9 weeks. Then from that poll data, I found the average poll support for each state and for the country as a whole.



**<font size="2"> The Model </font>**

As I've mentioned the national model uses GDP growth, federal spending, and poll support to predict election outcomes. 


![National Model Summary](Screen Shot 2020-10-30 at 10.40.07 PM.png)


The summary of the regression model shows an intercept of -3 percent. Thus, if an incumbent has no support from the polls, if there's no GDP growth, and no increase in federal spending, an incumbent candidate can expect to recieve -3 percent of the vote (this of course isn't physically possible, but goes to show how little incumbent presidents would recieve in popular vote shares. The coefficent for average poll support is 1.096, thus every point increase in poll support will lead to a 1.096 increase in popular vote share. Additionally, the coefficent for total growth rate is 0.0679, thus every point increase in yearly federal spending will amount to an increase in the popular vote share by 0.0679. Finally, the last coefficent, GDP growth qt, is 0.0545, showing that a one point percentage increase will lead to a 0.0545 increase in the popular vote share.

The adjusted R squared of this model is around 0.91, thus showing that the model seems to be quite a good fit for the data. While the in model validation seems to show that this is a good model, I also did an out of sample validation test. 

I created an out of sample validation test to see if this model was a good predictor for years prior. I conducted an out of sample validation for each election year from 1996-2008 (as some of my datasets ony include data until 2008). In 1996, my model predicted that Clinton would recieve 50.84 percent of the vote when he actually recieved 49.1 percent of the vote.For the year 2000, my model predicted, that Al Gore recieved 44.033 percent of the popular vote, when in reality he recieved 48.1 percent of the vote. In 2004, my model predicted that Bush would recieve 50.33 percent of the vote when he recieved 50.6 percent of the vote. In 2008, my model predicted that John McCain would recieve 45.38 of the popular vote and he recieved 45.4 of the popular vote. 

Besides conducting an out of sample prediction, I also looked at the fitted values versus residual values in my model. I used this as another way to measure the accuracy of my model and to visualize the variation between predicted and actual values.



![National Residuals](national_residuals.png)



The graph above shows 



**<font size="2"> 2020 National Outcome </font>**





**<font size="3"> State by State Predictions </font>**



**<font size="2"> State by State Model </font>**




**<font size="2"> State by State Predictions</font>**







**<font size="3"> Some Limitations of the Model </font>**




**<font size="3"> Sources</font>**

[data](https://www.kff.org/other/state-indicator/distribution-by-raceethnicity/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D)

[Data source for GDP data](https://www.bea.gov/news/2020/gross-domestic-product-fourth-quarter-and-year-2019-advance-estimate#:~:text=Real%20gross%20domestic%20product%20(GDP,real%20GDP%20increased%202.1%20percent)

[Data source federal spending data]()

[Data source for COVID spending](https://datalab.usaspending.gov/federal-covid-funding/)

[Poll Data: 270 to Win](https://www.270towin.com/2020-polls-biden-trump/)





**<font size="3"> Final Thoughts </font>**

