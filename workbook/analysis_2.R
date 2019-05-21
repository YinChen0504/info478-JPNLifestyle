library(dplyr)
library(ggplot2)

world_data <- read.csv("../data/worldData.csv")

japan_us_switzerland_data <- world_data %>%
  filter(Country == "Japan" | Country == "United States of America" |
    Country == "Switzerland") %>%
  select(Country, Year, Adult.Mortality)

adult_mortality_chart <-
  ggplot(japan_us_switzerland_data, aes(
    x = Year, y = Adult.Mortality,
    color = Country
  )) +
  geom_point(stat = "identity") +
  labs(
    title = "Adult Mortality Rate of Japan, Switzerland and US From 2000 - 2015",
    x = "Year",
    y = "Adult Mortality"
  )

adult_mortality_chart
