# Average Under 5 Deaths Percentage in different levels from 2012 - 2014
# (Japan, national average, developed country average, developing country average)

library(dplyr)
library(ggplot2)

world_data <- read.csv("../data/worldData.csv")

# filter out data from 2012 - 2014 because that's the years used in our other dataset
data12_14 <- world_data %>% filter(Year == 2012 | Year == 2013 | Year == 2014)

data12_14 <- data12_14 %>%
              mutate(total_under5_death = Population / 1000 * under.five.deaths) %>% 
              mutate(percent_under5_death = total_under5_death / Population * 100)

# calculate average under 5 deaths from 2012 - 2014
under_5_death <- data12_14 %>%
                  group_by(Country, Status) %>%
                  summarise(avg_under5death_percent = mean(percent_under5_death)) %>% 
                  filter(!is.na(avg_under5death_percent))

# Japan average
jpn_avg <- (under_5_death %>% filter(Country == "Japan"))$avg_under5death_percent

# national average
national_avg <- mean(under_5_death$avg_under5death_percent)

# developed country average
developed <- under_5_death %>% filter(Status == "Developed")
developed_avg <- mean(developed$avg_under5death_percent)

# developing country average
developing <- under_5_death %>% filter(Status == "Developing")
developing_avg <- mean(developing$avg_under5death_percent)

#create data frame for all four variables
category <- c("Japan", "National_Average", "Developed_Country_Average", "Developing_Country_Average") 
percent_under_5_deaths <- c(jpn_avg, national_avg, developed_avg, developing_avg)
under5_death_df <- data.frame(category, percent_under_5_deaths, stringsAsFactors=FALSE)


under5_death_chart <- ggplot(under5_death_df, aes(x = reorder(category, percent_under_5_deaths), y = percent_under_5_deaths)) +
                        geom_bar(stat = "identity") +
                        geom_text(label = paste0(round(percent_under_5_deaths, 2), "%"), vjust = -0.5) +
                        labs(title = "Average Under 5 Deaths Percentage from 2012 - 2014",
                             x = "Category",
                             y = "Under 5 Deaths Percentage")

under5_death_chart





                  


