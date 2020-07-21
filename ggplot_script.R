#### Data Visualization with ggplot #####

#load packages
library(tidyverse)

#Basic Structure of ggplot command
#ggplot(data = <DATA>) +  ## Telling R you are using ggplot, Telling object name where data is stored
#<GEOM_FUNCTION>(         ## Adding layer for type of ggplot
# mapping = aes(<MAPPINGS>), ## Specifying variables
  # stat = <STAT>,        ## Perform statistical transformation
 # position = <POSITION>  ## Perform a position adjustment
#) +
 # <COORDINATE_FUNCTION> + ## Change default coordinate system
 # <FACET_FUNCTION> +     ## Make faceted graph
 # <THEME_FUNCTION>       ## Change style of graph


# Inspect our data frame
## A few ways to do this:

#type name of data frame
cars
# View()
View(mpg)
# head() and tail()
head(mpg)
tail(mpg)
# ?

# str(), is(), dim(), colnames(), summary()
str(mpg)

## Simple Scatter plot
ggplot(data=mpg) +
  geom_point(mapping= aes(x=displ, y=hwy))

## Make size of points correspond to number of cylinders, and color correspond to type of car
ggplot(data = mpg) + 
  geom_point(mapping = aes(x=displ, y=hwy, color=class, size=cyl))

## Change the shape of the points
ggplot(data = mpg) + 
  geom_point(mapping = aes(x=displ, y=hwy, color=class, size=cyl), shape=1)

# Overlay two geometric objects (smoothing line)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x=displ, y=hwy, color=class, size=cyl), shape=1) +
  geom_smooth(mapping = aes(x=displ, y=hwy))

#We can move the variables to the ggplot argument so we don't have to type them twice
ggplot(data = mpg, mapping = aes(x=displ, y=hwy)) + 
  geom_point(mapping = aes(color=class, size=cyl), shape=1) +
  geom_smooth()

#Display different year in different facets
ggplot(data = mpg, mapping = aes(x=displ, y=hwy)) + 
  geom_point(mapping = aes(color=class, size=cyl), shape=1) +
  geom_smooth() +
  facet_wrap(~year, nrow=1)

#Adjust figure size using chunk option in RMarkdown (I'm currently in a script so I will skip)
#Would use fig.height and fig.width

#Change the theme of the graph
ggplot(data = mpg, mapping = aes(x=displ, y=hwy)) + 
  geom_point(mapping = aes(color=class, size=cyl), shape=1) +
  geom_smooth() +
  facet_wrap(~year, nrow=1) +
  theme_bw()

####Important Arguments and Functions to Know ####
## Geometries

#geom_point

#geom_boxplot
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x=class, y=hwy))

#geom_bar
ggplot(mpg) +
  geom_bar(aes(x=class))

#geom_histogram
ggplot(mpg) +
  geom_histogram(aes(x=hwy))

#geom_density
ggplot(mpg) +
  geom_density(aes(x=hwy))

#geom_smooth (displayed linearly, and w/o confidence interval)
ggplot(mpg, aes(x=displ, y=hwy))+
  geom_point() +
  geom_smooth(method="lm", se=F)

#geom_text (with cyl as the label)
ggplot(mpg, aes(x=displ, y=hwy))+
  geom_text(aes(label=cyl))

#geom_label (model as the label but only label points with hwy > 40)
ggplot(mpg)+
  geom_point(aes(x=displ, y=hwy)) +
  geom_label(data=filter(mpg, hwy>40), mapping = aes(label=model, y=hwy, x=displ+0.8))

#geom_line (change in mean hwy for each car model over time, grouped by model, colored by class, faceted by manufacturer)
group_by(mpg, manufacturer, year, class, model) %>%
  summarize(mean_hwy=mean(hwy)) %>%
  ggplot(aes(x=year, y=mean_hwy, color=class, group=model)) +
  geom_point() +
  geom_line() +
  facet_wrap(~manufacturer)


## Aesthetics 
# x,y, size, label, group, color, fill, alpha, shape, line_type

#plot hwy distribution with geom_density, color by drv
ggplot(mpg) +
  geom_density(aes(color=drv, x=hwy))

#fill by drv
ggplot(mpg) +
  geom_density(aes(fill=drv, x=hwy))

#change transparency with alpha
#plot hwy distribution with geom_density, fill by drv, set alpha to 0.5)
ggplot(mpg) +
  geom_density(aes(fill=drv, x=hwy), alpha=0.5)

#use shape and line_type
#hwy vs. displ, geom_point and geom_line, map drv to color, shape, linetype
ggplot(mpg, aes(x=displ, y=hwy, color=drv, shape=drv)) +
  geom_point()+
  geom_smooth(aes(linetype=drv))


## Facet
#facet_wrap, facet_grid

#hwy vs. displ. faceted by cyl and drv
ggplot(mpg, aes(x=displ, y=hwy)) +
  geom_point() +
  facet_grid(drv~cyl)
