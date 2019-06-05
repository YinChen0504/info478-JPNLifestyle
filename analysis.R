# 478 FINAL PROJECT (ANALYSIS)
#######################################################################################################################################################################################
## LOAD LIBRARIES 
library(dplyr)
library(tidyr)
library(sp)
library(shiny)
library(ggplot2)
library(plotly)
library(readxl)
library(scales)
library(tidyverse)
library(reshape)
library(shinyjs)

## READ IN FILES
us_data <- read.csv("data/usa_data.csv", stringsAsFactors = FALSE)
jpn_data <- read_xlsx("data/Japan2013.xlsx")

# usa_data <- us_data %>%
#   select(sex, x.ageg5yr, avedrnk2, x.ageg5yr, exerany2, exerhmm1, bpmeds, diabete3, bphigh4)
# write.csv(usa_data, file = "usa_data.csv")
#######################################################################################################################################################################################

# YIN

#######################################################################################################################################################################################
# AMERICA 
# SELECTS sex, age, and average drinks columns
usa_data_2013_drink_amount <- us_data %>%
  select(sex, x.ageg5yr, avedrnk2) %>%
  filter(avedrnk2 >= 1 & avedrnk2 <= 76)

colnames(usa_data_2013_drink_amount) <- c("sex", "age", "avg_drinks")

usa_data_2013_drink_amount$sex[usa_data_2013_drink_amount$sex == 1] <- "Male"
usa_data_2013_drink_amount$sex[usa_data_2013_drink_amount$sex == 2] <- "Female"

usa_data_2013_drink_amount$country <- "US"

# ADDS THE AGE-GROUP COLUMNS
labs <- c(
  paste(seq(40, 60, by = 10), seq(49, 69, by = 10), sep = "-"),
  paste(70, "+", sep = "")
)

usa_data_2013_drink_amount$age_group <-
  cut(usa_data_2013_drink_amount$age, breaks = c(
    seq(5, 11, by = 2),
    Inf
  ), labels = labs, right = FALSE)

##########################################################################################
# JAPAN 
# SELECTS SEX, AGE AND AVERAGE DRINKS COLUMN 
japan_data_2013_drink_amount <- jpn_data %>%
  select(Sex, Age, `Alcohol amount-category`) %>%
  filter(`Alcohol amount-category` != "NA")


colnames(japan_data_2013_drink_amount) <- c("sex", "age", "avg_drinks")

japan_data_2013_drink_amount$sex[japan_data_2013_drink_amount$sex == 0] <- "Female"
japan_data_2013_drink_amount$sex[japan_data_2013_drink_amount$sex == 1] <- "Male"

japan_data_2013_drink_amount$country <- "Japan"

japan_data_2013_drink_amount$avg_drinks <- as.numeric(japan_data_2013_drink_amount$avg_drinks)


# ADDS THE AGE-GROUP COLUMN 
japan_labs <- c(
  paste(seq(40, 60, by = 10), seq(49, 69, by = 10), sep = "-"),
  paste(70, "+", sep = "")
)

japan_data_2013_drink_amount$age_group <-
  cut(japan_data_2013_drink_amount$age,
        breaks = c(seq(40, 70, by = 10), Inf),
        labels = labs, right = FALSE
  )

##########################################################################################
# COMBINES THE JAPAN + US DATASETS 
data_2013_drink_amount <- rbind(
  usa_data_2013_drink_amount, japan_data_2013_drink_amount
)

data_2013_drink_amount <- data_2013_drink_amount %>%
  group_by(sex, country, age_group) %>% summarise(avg_drinks = mean(avg_drinks))

#######################################################################################################################################################################################

# MICHELLE

#######################################################################################################################################################################################
# JAPAN 
# CLEAN JAPAN DATA
jpn_exercise <- jpn_data %>% 
  select(Age, `Exercise more than 30 minutes-category`) %>%
  filter(`Exercise more than 30 minutes-category` != 'NA')

colnames(jpn_exercise)[colnames(jpn_exercise) == "Exercise more than 30 minutes-category"] <- "if_more_than_30"

jpn_exercise <- jpn_exercise %>% 
  mutate(
    if_more_than_30 = replace(if_more_than_30, if_more_than_30 == "1.0", "physically_active"),
    if_more_than_30 = replace(if_more_than_30, if_more_than_30 == "2.0", "not_physically_active")
  )

jpn_labs <- c(paste(seq(40, 60, by = 10), seq(49, 69, by = 10), sep = "-"), paste(70, "+", sep = ""))

jpn_exercise$age_group <- cut(jpn_exercise$Age, breaks = c(seq(40, 70, by = 10), Inf), labels = jpn_labs, right = FALSE)

jpn_total <- jpn_exercise %>% group_by(age_group, Age) %>% summarise(n = n())
jpn_active <- jpn_exercise %>% filter(if_more_than_30 == "physically_active") %>% group_by(Age) %>% summarise(active = n())
jpn_merged <- merge(jpn_total, jpn_active) %>% mutate(rate = active / n) %>% mutate(percentage = rate * 100)

jpn_all <- data.frame(
  type = c("> 30 min daily", "<= 30 min daily"),
  percent = c(sum(jpn_merged$active) / sum(jpn_merged$n) * 100, 100 - (sum(jpn_merged$active) / sum(jpn_merged$n) * 100))
)

##########################################################################################
# AMERICA
# CLEAN US DATA
us_exercise <- us_data %>% select(x.ageg5yr, exerany2, exerhmm1)

labs <- c(paste(18, 29, sep = "-"), paste(seq(30, 60, by = 10), seq(39, 69, by = 10), sep = "-"), paste(70, "+", sep = ""))

us_exercise$age_group <- cut(us_exercise$x.ageg5yr, breaks = c(seq(1, 2, by = 2), seq(3, 11, by = 2), Inf), labels = labs, right = FALSE)

us_exercise <- us_exercise %>% 
  mutate(
    exerany2 = replace(exerany2, exerany2 == 1, "physically_active"),
    exerany2 = replace(exerany2, exerany2 == 2, "not_physically_active")
  )

us_exercise <- us_exercise %>% 
  mutate(
    exerhmm1 = replace(exerhmm1, exerhmm1 > 210 & exerhmm1 != 777 & exerhmm1 != 999, "more_than_30")
  )

us_total <- us_exercise %>%
  filter(!is.na(exerhmm1) & exerhmm1 != 777 & exerhmm1 != 999) %>%
  group_by(age_group) %>%
  summarise(n = n())

us_active <- us_exercise %>% filter(exerhmm1 == "more_than_30") %>% group_by(age_group) %>% summarise(active = n())

us_merged <- merge(us_total, us_active) %>% mutate(rate = active / n) %>% mutate(percentage = rate * 100)

us_all <- data.frame(
  type = c("> 30 min daily", "<= 30 min daily"),
  percent = c(sum(us_merged$active) / sum(us_merged$n) * 100, 100 - (sum(us_merged$active) / sum(us_merged$n) * 100))
)

us_percent <- us_merged %>% select(age_group, percentage) %>% mutate(percent_inactive = 100 - percentage)

#######################################################################################################################################################################################

# RANI

#######################################################################################################################################################################################
# JAPAN
## FILTER FOR NEEDED COLUMNS
japan_health_issues <- 
  jpn_data %>% 
  select(`Taking medication for hypertenstion`, `Taking medication for diabetes`, `Blood pressure_category`
  )

## CHANGE NAMES
colnames(japan_health_issues) <- c("Hypertension", "Diabetes", "BP")

## MUTATE HYPERTENSION + DIABETES + BP
japan_health_issues <- japan_health_issues %>% 
  mutate(
    BP = replace(BP, BP == 1, "No")
  )

japan_health_issues <- japan_health_issues %>% 
  mutate(
    BP = replace(BP, BP == 2, "No")
  )

japan_health_issues <- japan_health_issues %>% 
  mutate(
    BP = replace(BP, BP == 3, "Yes")
  )

japan_health_issues[japan_health_issues == "1.0"] <- "Yes"
japan_health_issues[japan_health_issues == "0.0"] <- "No"
japan_health_issues[japan_health_issues == "NA"] <- NA

## SELECT TOP 100 ROWS
japan_health_issues <- head(japan_health_issues, 600)

## NEW HYPERTENSION DATAFRAME
japanHypertension <- table(japan_health_issues$Hypertension)
japanHypertension <- as.data.frame(japanHypertension)
colnames(japanHypertension) <- c("Hypertension", "Total")
japanHypertension$Country <- rep("Japan")

## NEW DIABETES DATAFRAME
japanDiabetes <- table(japan_health_issues$Diabetes)
japanDiabetes <- as.data.frame(japanDiabetes)
colnames(japanDiabetes) <- c("Diabetes", "Total")
japanDiabetes$Country <- rep("Japan")

## NEW BLOOD PRESSURE DATAFRAME
japanBP <- table(japan_health_issues$BP)
japanBP <- as.data.frame(japanBP)
colnames(japanBP) <- c("BP", "Total")
japanBP$Country <- rep("Japan")

##########################################################################################
# AMERICA 
## FILTER FOR NEEDED COLUMNS
usa_health_issues <- 
  us_data %>% 
  select(bpmeds, diabete3, bphigh4
  )

## CHANGE NAMES
colnames(usa_health_issues) <- c("Hypertension", "Diabetes", "BP")

## MUTATE HYPERTENSION 
usa_health_issues <- usa_health_issues %>%
  mutate(
    Hypertension = replace(Hypertension, Hypertension == 1, "Yes"),
  )

usa_health_issues <- usa_health_issues %>%
  mutate(
    Hypertension = replace(Hypertension, Hypertension == 2, "No")
  )

usa_health_issues <- usa_health_issues %>%
  mutate(
    Hypertension = replace(Hypertension, Hypertension == 7 | Hypertension == 9, NA)
  )

## MUTATE DIABETES
usa_health_issues <- usa_health_issues %>% 
  mutate(
    Diabetes = replace(Diabetes, Diabetes == 1 | Diabetes == 2, "Yes"),
  )

usa_health_issues <- usa_health_issues %>% 
  mutate(
    Diabetes = replace(Diabetes, Diabetes == 3 | Diabetes == 4, "No")
  )

usa_health_issues <- usa_health_issues %>% 
  mutate(
    Diabetes = replace(Diabetes, Diabetes == 7 | Diabetes == 9, NA)
  )

## MUTATE BLOOD PRESSURE
usa_health_issues <- usa_health_issues %>% 
  mutate(
    BP = replace(BP, BP == 1 | BP == 2, "Yes"),
  )

usa_health_issues <- usa_health_issues %>% 
  mutate(
    BP= replace(BP, BP == 3 | BP == 4, "No")
  )

usa_health_issues <- usa_health_issues %>% 
  mutate(
    BP = replace(BP, BP == 7 | BP == 9, NA)
  )

## SELECT TOP 100 ROWS
usa_health_issues <- head(usa_health_issues, 600)

## NEW HYPERTENSION DATAFRAME
usaHypertension <- table(usa_health_issues$Hypertension)
usaHypertension <- as.data.frame(usaHypertension)
colnames(usaHypertension) <- c("Hypertension", "Total")
usaHypertension$Country <- rep("USA")

## NEW DIABETES DATAFRAME
usaDiabetes <- table(usa_health_issues$Diabetes)
usaDiabetes <- as.data.frame(usaDiabetes)
colnames(usaDiabetes) <- c("Diabetes", "Total")
usaDiabetes$Country <- rep("USA")

## NEW BLOOD PRESSURE DATAFRAME
usaBP <- table(usa_health_issues$BP)
usaBP <- as.data.frame(usaBP)
colnames(usaBP) <- c("BP", "Total")
usaBP$Country <- rep("USA")

##########################################################################################
## JOIN TWO COUNTRIES DATAFRAMES (BY = H / D / BP)
full_hypertension <- full_join(japanHypertension, usaHypertension)
full_diabetes <- full_join(japanDiabetes, usaDiabetes)
full_bp <- full_join(japanBP, usaBP)

list.of.data.frames = list(data.frame(full_hypertension), data.frame(full_diabetes), data.frame(full_bp))

## MERGE THEM TOGETHER
merged_dataFrame = Reduce(function(...) merge(..., all = T), list.of.data.frames)
merged_dataFrame_data <- melt(merged_dataFrame, id = c("Country", "Total"))

## FOR INPUT-ID 
Issues <- unique(merged_dataFrame_data$variable)

#######################################################################################################################################################################################

# KIRAN

#######################################################################################################################################################################################


















