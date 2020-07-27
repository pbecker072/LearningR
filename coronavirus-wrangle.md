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