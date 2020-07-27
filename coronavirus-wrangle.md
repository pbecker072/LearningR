coronavirus-wrangle.Rmd
================

library(tidyverse) \#\#install.packages(“tidyverse”)

# read in corona .csv

coronavirus \<-
read\_csv(‘<https://raw.githubusercontent.com/RamiKrispin/coronavirus-csv/master/coronavirus_dataset.csv>’,
col\_types = cols(Province.State = col\_character()))

## explore the coronavirus dataset

coronavirus \# this is super long\! Let’s inspect in different ways

head(coronavirus) \# shows first 6  
tail(coronavirus) \# shows last 6  
head(coronavirus, 10) \# shows first X that you indicate  
tail(coronavirus, 12) \# guess what this does\!

\#Learning basic info on the data.frame names(coronavirus)  
dim(coronavirus) \# ?dim dimension  
ncol(coronavirus) \# ?ncol number of columns  
nrow(coronavirus) \# ?nrow number of rows

# Statistical overview of data.frame

summary(coronavirus)

# Skimr

## If we don’t already have skimr installed, we will need to install it

install.packages(‘skimr’)  
library(skimr)  
skim(coronavirus)

# Look at variables inside the data.frame

## Use $ to extract a single variable

coronavirus$cases \# very long\! hard to make sense of…

head(coronavirus$cases) \# can do the same tests we tried before

str(coronavirus$cases) \# it is a single numeric vector

summary(coronavirus$cases) \# same information, formatted slightly
differently

# dplyr basics

## 5 common functions

1.  filter()

<!-- end list -->

  - pick observations by their values

<!-- end list -->

2.  select()

<!-- end list -->

  - pick variables by their names

<!-- end list -->

3.  mutate()

<!-- end list -->

  - create new variables with functions of existing variables

<!-- end list -->

4.  arrange()

<!-- end list -->

  - reorder the rows

<!-- end list -->

5.  summarise()

<!-- end list -->

  - collapse many values down to a single summary

# filter() subsets data row-wise (observations)

## filter() is a function in dplyr that takes logical expressions and returns the rows for which all are TRUE.

filter(coronavirus, cases \> 0)

### Records for the US only

filter(coronavirus, Country.Region == “US”)

coronavirus\_us \<- filter(coronavirus, Country.Region == “US”)

### Records for both the US and Canada

filter(coronavirus, Country.Region == “US” | Country.Region == “Canada”)

###### Shorthand

filter(coronavirus, Country.Region %in% c(“US”, “Canada”))

### Death count in the US

###### We can use either of these notations:

filter(coronavirus, Country.Region == “US”, type == “death”)  
filter(coronavirus, Country.Region == “US” & type == “death”)

## Total number of deaths in the US in the data.frame time region

x \<- filter(coronavirus, Country.Region == “US”, type == “death”)  
sum(x$cases)

# select() subsets data column-wise (variables)

## We can select multiple columns with a comma, after we specify the data frame (coronavirus).

select(coronavirus, date, Country.Region, type, cases)

## can also use - to deselect columns

select(coronavirus, -Lat, -Long) \# you can use - to deselect columns

# Use select() and filter() together

#### Combine and filter data to retain only records for the US and remove the Lat, Long and Province.State columns. We will save this as a subsetted variable

coronavirus\_us \<- filter(coronavirus, Country.Region == “US”)  
coronavirus\_us2 \<- select(coronavirus\_us, -Lat, -Long,
-Province.State)

# Pipe operator %\>%

##### Equivalent to head(coronavirus)

coronavirus %\>% head()

##### Can still specify other arguments to this function

###### First 3 rows of data

coronavirus %\>% head(3)

## Think “and then” when you see %\>%

### instead of this…

coronavirus\_us \<- filter(coronavirus, Country.Region == “US”)  
coronavirus\_us2 \<- select(coronavirus\_us, -Lat, -Long,
-Province.State)  
\#\#\# …we can do this  
coronavirus\_us \<- coronavirus %\>% filter(Country.Region == “US”)  
coronavirus\_us2 \<- coronavirus\_us %\>% select(-Lat, -Long,
-Province.State)

## We can use the pipe to chain these 2 operations together

coronavirus\_us \<- coronavirus %\>% filter(Country.Region == “US”) %\>%
select(-Lat, -Long, -Province.State)

# mutate() adds new variables

### Useful to add new columns that are functions of existing columns

## Rearranging the data set to make it easier to mutate

coronavirus\_ttd \<- coronavirus %\>% select(country = Country.Region,
type, cases) %\>% group\_by(country, type) %\>% summarise(total\_cases =
sum(cases)) %\>% pivot\_wider(names\_from = type, values\_from =
total\_cases) %\>% arrange(-confirmed)

## Let’s have a look at the structure of that new rearranged dataset

coronavirus\_ttd

## Comparing the total death count to confirmed cases by country by dividing death/confirmed

coronavirus\_ttd %\>% mutate(deathrate = death / confirmed)

#### We can modify the mutate equation in many ways. For example, if we want to adjust the number of significant digits printed, we can type:

coronavirus\_ttd %\>% mutate(deathrate = round(death / confirmed, 2))

## Create a new variavble that shows proportion of confirmed cases for which the outcome is unknown

coronavirus\_ttd %\>% mutate(unknown\_outcome =
confirmed-death-recovered/ confirmed) %\>% filter(confirmed \< 20000)

# arrange() orders rows

## We may want to rearrange countries in acending order for the proportion of unknown cases

coronavirus\_ttd %\>% mutate(unknown\_outcome = (confirmed - death -
recovered)/confirmed) %\>% filter(confirmed \> 20000) %\>%
arrange(unknown\_outcome)

### How many countries have suffered more than 3,000 deaths so far and which three countries have the highes recorded death counts?

coronavirus\_ttd %\>% filter(death \> 3000) %\>% arrange(-death)

### When and where was the highest death count observed? (Go back to orginal dataset)

coronavirus %\>% filter(type == “death”) %\>% arrange(-cases)

### Identify the first recorded case in Denmark

coronavirus %\>% filter(Country.Region == “Denmark”, cases \> 0) %\>%
arrange(date)

# Grouped summaries with summarize() and group\_by()

### Collapses a data frame to a single row

## Calculate the total number of confirmed cases detected globally since 1-20-2020

coronavirus %\>% filter(type == “confirmed”) %\>% summarize(sum=
sum(cases))

## Use group\_by to calculate the total number of confirmed cases by region

coronavirus %\>% filter(type == “confirmed”) %\>%
group\_by(Country.Region) %\>% summarize(total\_cases = sum(cases))

## We can also summarize() to check how many observations (dates) we have for each country

coronavirus %\>% filter(type == “confirmed”) %\>%
group\_by(Country.Region) %\>% summarize(n = n())

## We can do mutli-level grouping. How many each type of case there were globally on a Monday, we chain these functions together:

coronavirus %\>% group\_by(date, type) %\>% summarize(total =
sum(cases)) %\>% \# sums the count across countries filter(date ==
“2020-04-06”)

## Which day had the highest total death count globally so far?

coronavirus %\>% filter(type == “death”) %\>% group\_by(date) %\>%
summarize(total\_cases = sum(cases)) %\>% arrange(-total\_cases)

# Optional question

## How many countries already have more than 1000 deaths in April?

library(lubridate)

coronavirus %\>% mutate(month= month(date)) %\>% filter( type ==
“death”, month == 4) %\>% group\_by(Country.Region) %\>%
summarize(total\_death = sum(cases)) %\>% filter(total\_death \> 1000)
