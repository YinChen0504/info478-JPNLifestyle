# Final project (Subset)
## Enough Sleep Vs Gender 

##################################################################################################################
# Set up + library 
library(readxl)
library(dplyr)
library(ggplot2)
library(scales)

##################################################################################################################
# Load Dataset 
japanese_data <- read_xlsx("../data/lifestyle dataset.xlsx", 2)

## Filter for Sex and Amount of replies on "If they have enough sleep" 
gender_sleep_data <- japanese_data %>% 
  select(Sex, `Enough sleep`)

## Mutate to change Sex == 1 to MALES
gender_sleep_data<- gender_sleep_data %>% 
  mutate(
    Sex = replace(Sex, Sex == 1, "Male")
  )

## Mutate to change Sex == 0 to FEMALES
gender_sleep_data <- gender_sleep_data %>% 
  mutate(
    Sex = replace(Sex, Sex == 0, "Female")
  )

## Mutate to change Enough Sleep == 1 to YES
gender_sleep_data <- gender_sleep_data %>% 
  mutate(
    `Enough sleep` = replace(`Enough sleep`, `Enough sleep` == 1, "Yes")
  )

## Mutate to change Enough Sleep == 2 to NO
gender_sleep_data <- gender_sleep_data %>% 
  mutate(
    `Enough sleep` = replace(`Enough sleep`, `Enough sleep` == 2, "No")
  )

## View the mutated data
View(gender_sleep_data)

## Create a table then convert it to a dataframe + change colnames 
sleep_data <- table(gender_sleep_data)
sleep_data <- as.data.frame(sleep_data)
colnames(sleep_data) <- c("Gender", "Enough_Sleep", "Amount_of_People")

## Plot a grouped bar graph of dataset 
gender_sleep_plot <- ggplot(sleep_data, aes(fill = Gender, y = Amount_of_People, x = Enough_Sleep)) + 
  geom_bar(position="dodge", stat="identity") + 
  scale_y_continuous(labels = comma) + 
  ggtitle("Which gender in Japan get's enough sleep?")


## View dataset
gender_sleep_plot

##################################################################################################################
