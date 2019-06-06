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
library(ggrepel)
library(survey)
library(Hmisc)
library(scales)

## READ IN FILES
us_data <- read.csv("data/usa_data.csv", stringsAsFactors = FALSE)
jpn_data <- read_xlsx("data/Japan2013.xlsx")
world <- read.csv('data/worldData.csv', stringsAsFactors = FALSE)

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

japan_hypertension_total <- full_hypertension[1, "Total"] + full_hypertension[2, "Total"]
usa_Hypertension_total <- full_hypertension[3, "Total"] + full_hypertension[4, "Total"]

full_hypertension[1, "Total"] <- full_hypertension[1, "Total"] / japan_hypertension_total * 100
full_hypertension[2, "Total"] <- full_hypertension[2, "Total"] / japan_hypertension_total * 100
full_hypertension[3, "Total"] <- full_hypertension[3, "Total"] / usa_Hypertension_total * 100
full_hypertension[4, "Total"] <- full_hypertension[4, "Total"] / usa_Hypertension_total * 100

japan_diabetes_total <- full_diabetes[1, "Total"] + full_diabetes[2, "Total"]
usa_diabetes_total <- full_diabetes[3, "Total"] + full_diabetes[4, "Total"]

full_diabetes[1, "Total"] <- full_diabetes[1, "Total"] / japan_diabetes_total  * 100
full_diabetes[2, "Total"] <- full_diabetes[2, "Total"] / japan_diabetes_total  * 100
full_diabetes[3, "Total"] <- full_diabetes[3, "Total"] / usa_diabetes_total * 100
full_diabetes[4, "Total"] <- full_diabetes[4, "Total"] / usa_diabetes_total * 100

japan_bp_total <- full_bp[1, "Total"] + full_bp[2, "Total"]
usa_bp_total <- full_bp[3, "Total"] + full_bp[4, "Total"]

full_bp[1, "Total"] <- full_bp[1, "Total"] / japan_bp_total * 100
full_bp[2, "Total"] <- full_bp[2, "Total"] / japan_bp_total * 100
full_bp[3, "Total"] <- full_bp[3, "Total"] / usa_bp_total * 100
full_bp[4, "Total"] <- full_bp[4, "Total"] / usa_bp_total * 100

list.of.data.frames = list(data.frame(full_hypertension), data.frame(full_diabetes), data.frame(full_bp))

## FOR INPUT-ID 
Issues <- c("Hypertension", "Diabetes", "Blood Pressure")

#######################################################################################################################################################################################

# KIRAN

#######################################################################################################################################################################################

#filter world data for year 2013
world_2013 <- world %>% filter(Year == 2013 & 
                                (Country == 'Japan' | Country == 'United States of America'))

# Data cleaning and transformation
# Modify alcohol drinking category 2 to 1 and 3 to 0 in Japan data
japan_2013 <- jpn_data %>% mutate(
  `Alcohol drinking-category` = replace(`Alcohol drinking-category`,
                                        `Alcohol drinking-category` == 2, 1),
  `Alcohol drinking-category` = replace(`Alcohol drinking-category`, 
                                        `Alcohol drinking-category` == 3, 0))
# Assign levels to columns in data
cols <- c('Sex','Smoking status','Enough sleep','Taking medication for hypertenstion',
         'Taking medication for diabetes', 'Alcohol drinking-category', 
         'Walking or physical activity-category')
japan_2013[cols] = lapply(japan_2013[cols], as.factor)

# Replace unknown categories and modify USA data
usa_2013 <- us_data %>% mutate(
  sleptim1 = replace(sleptim1, sleptim1 < 7, 2),
  sleptim1 = replace(sleptim1, sleptim1 >= 7, 1),
  sleptim1 = replace(sleptim1, sleptim1 == 77 | sleptim1 == 99, NA),
  bphigh4 = replace(bphigh4, bphigh4 == 2 | bphigh4 == 3 | bphigh4 == 4, 0),
  bphigh4 = replace(bphigh4, bphigh4 == 7 | bphigh4 == 9, NA ),
  diabete3 = replace(diabete3, diabete3 == 2 | diabete3 == 3 | diabete3 == 4, 0),
  diabete3 = replace(diabete3, diabete3 == 7 | diabete3 == 9, NA),
  drnkany5 = replace(drnkany5, drnkany5 == 2, 0),
  drnkany5 = replace(drnkany5, drnkany5 == 7 | drnkany5 == 9, NA),
  x.totinda = replace(x.totinda, x.totinda == 9, NA),
  exerhmm1 = replace(exerhmm1, exerhmm1 == 777 | exerhmm1 == 999, NA),
  exerhmm1 = replace(exerhmm1, exerhmm1 <= 210, 2),
  exerhmm1 = replace(exerhmm1, exerhmm1 > 210, 1)
)

# Assign Male and Female values instead of numbers for sex
japan_2013$gender <- ifelse(japan_2013$Sex == 0, 'Female', 'Male')
usa_2013$sex <- ifelse(usa_2013$sex == 1, 'Male', 'Female')

# Function to create age groups in Japan data
age_fun <-  function(x){
  if (x < 45) {
    y <- '40-44'
  } else if (x >= 45 & x < 50){
    y <- '45-49'
  } else if (x >= 50 & x < 55){
    y <- '50-54'
  } else if (x >= 55 & x < 60){
    y <- '55-59'
  } else if (x >= 60 & x < 65){
    y <- '60-64'
  } else if (x >= 65 & x < 70){
    y <- '65-69'
  } else {
    y <- '70+'
  }
}

#Create age groups in Japan data
japan_2013$age_group = lapply(japan_2013$Age, age_fun )
japan_2013$age_group = as.character(japan_2013$age_group)

# Function to assign readable age groups to USA data
age_fun_usa <- function(x){
  if (x == 5) {
    y <- '40-44'
  } else if (x == 6){
    y <- '45-49'
  } else if (x == 7){
    y <- '50-54'
  } else if (x == 8){
    y <- '55-59'
  } else if (x == 9){
    y <- '60-64'
  } else if (x == 10){
    y <- '65-69'
  } else {
    y <- '70+'
  }
}

# Assign readable age groups to USA data
usa_2013$age_group <- lapply(usa_2013$x.ageg5yr, age_fun_usa)
usa_2013$age_group <- as.character(usa_2013$age_group)

# survey design for USA data
brfss_design = svydesign(data = usa_2013,
                         weights = ~x.llcpwt,
                         ids = ~1,
                         nest = T)

# Function to convert data frame into proper pformat for plotting
convert_fun <- function(df, metric, country){
  x <- c(metric, 'percentage')
  colnames(df) <- c(metric, 'percentage')
  df$Country <- country
  df[1] <- ifelse(df[1] == "1.0" | df[1] == 1, 'Yes', 'No')
  df$percentage = round(df$percentage * 100, 2)
  df
}

# Enough sleep percentage across USA and Japan
per_sleep_usa <- data.frame(prop.table(svytable(~sleptim1, brfss_design)))
per_sleep_usa <- convert_fun(per_sleep_usa,'% reported enough sleep','USA')
#per_sleep_usa
per_sleep_japan <- data.frame(prop.table(table(japan_2013$`Enough sleep`)))
per_sleep_japan <- convert_fun(per_sleep_japan, '% reported enough sleep', 'Japan')
#per_sleep_japan
per_sleep <- rbind(per_sleep_usa, per_sleep_japan)
per_sleep <- per_sleep %>% gather('metric', 'status', 1)
#per_sleep

# Hypertension percentages across USA and Japan
per_ht_japan <- data.frame(prop.table(table(japan_2013$`Taking medication for hypertenstion`)))
per_ht_japan <- convert_fun(per_ht_japan, '% with hypertension', 'Japan')
#per_ht_japan
per_ht_usa <- data.frame(prop.table(svytable(~bphigh4, brfss_design)))
per_ht_usa <- convert_fun(per_ht_usa, '% with hypertension', 'USA')
#per_ht_usa
per_ht <- rbind(per_ht_usa, per_ht_japan)
per_ht <- per_ht %>% gather('metric', 'status', 1)
#per_ht

# Diabetes percentages across USA and Japan
per_dia_japan <- data.frame(prop.table(table(japan_2013$`Taking medication for diabetes`)))
per_dia_japan <- convert_fun(per_dia_japan, '% with diabetes', 'Japan')
#per_dia_japan
per_dia_usa <- data.frame(prop.table(svytable(~diabete3, brfss_design)))
per_dia_usa <- convert_fun(per_dia_usa,'% with diabetes', 'USA')
#per_dia_usa
per_dia <- rbind(per_dia_japan, per_dia_usa)
per_dia <- per_dia %>% gather('metric', 'status', 1)
#per_dia

# Alcohol drinking percentages across USA and Japan
per_alc_japan <- data.frame(prop.table(table(japan_2013$`Alcohol drinking-category`)))
per_alc_japan <- convert_fun(per_alc_japan, '% drinking alcohol*', 'Japan')
#per_alc_japan
per_alc_usa <- data.frame(prop.table(svytable(~drnkany5, brfss_design)))
per_alc_usa <- convert_fun(per_alc_usa, '% drinking alcohol*', 'USA')
#per_alc_usa
per_alc <- rbind(per_alc_japan, per_alc_usa)
per_alc <- per_alc %>% gather('metric', 'status', 1)
#per_alc

#Smoking percentages across USA and Japan
per_smo_usa <- data.frame(prop.table(svytable(~x.rfsmok3, brfss_design)))
per_smo_usa <- convert_fun(per_smo_usa, '% smoking','USA')
#per_smo_usa
per_smo_japan <- data.frame(prop.table(table(japan_2013$`Smoking status`)))
per_smo_japan <- convert_fun(per_smo_japan, '% smoking', 'Japan')
#per_smo_japan
per_smo <- rbind(per_smo_japan, per_smo_usa)
per_smo <- per_smo %>% gather('metric', 'status', 1)

#Physical activity percentages across USA and Japan
per_phy_usa <- data.frame(prop.table(svytable(~exerhmm1, brfss_design)))
per_phy_usa <- convert_fun(per_phy_usa, '% exercised more than 30 min**', 'USA' )
#per_phy_usa
per_phy_japan <- data.frame(prop.table(table(japan_2013$`Exercise more than 30 minutes-category`)))
per_phy_japan <- convert_fun(per_phy_japan[-3,], '% exercised more than 30 min**', 'Japan')
#per_phy_japan
per_phy <- rbind(do.call(data.frame, per_phy_japan), do.call(data.frame, per_phy_usa))
colnames(per_phy)[1] <- '% exercised more than 30 min**'


per_phy <- per_phy %>% gather('metric', 'status', 1)

#combine as metrics into data frame
metrics_df <- do.call('rbind', list(per_sleep, per_dia, per_smo, per_ht, per_alc, per_phy))
metrics_yes_df <- metrics_df %>% filter(status == 'Yes') 
metrics_yes_df$status <- NULL
colnames(metrics_yes_df)[1] <- 'value'
#metrics_yes_df

# Life expectancy and average BMI of USA and Japan
new_df <- world_2013 %>% select(Country, Life.expectancy)
a <- c(mean(japan_2013$BMI),svymean(~x.bmi5, brfss_design, na.rm = T) / 100)
new_df['Average BMI'] <- round(a,2)
new_df$Country <- as.character(new_df$Country)
new_df$Country <- replace(new_df$Country, new_df$Country == 'United States of America', 'USA')
#new_df

# Transform dataframe to plot
new_df <- new_df %>% gather('metric', 'value', 2:3)
#new_df
# Final dataframe for plotting
data_df <- rbind(new_df, metrics_yes_df)
data_df <- data_df %>% spread(Country, value)
#data_df

# Plot
build_comp_plot <- function(data_df) {
  
  theme_set(theme_classic())
  
  left_label <- paste(data_df$metric, data_df$USA,sep = ", ")
  right_label <- paste(data_df$metric, data_df$Japan,sep = ", ")
  data_df$class <- ifelse(data_df$metric == '% exercised more than 30 min**' |
                            data_df$metric == '% drinking alcohol*', "green", "red")
  
  p <- ggplot(data_df) + geom_segment(aes(x=1, xend=2, y=USA, yend=Japan, col=class),
                                     size=.75, show.legend=F) + 
    geom_vline(xintercept=1, linetype="dashed", size=.1) + 
    geom_vline(xintercept=2, linetype="dashed", size=.1) +
    scale_color_manual(labels = c("Up", "Down"), 
                       values = c("green"="#00ba38", "red"="#f8766d")) +  # color of lines
    labs(x="", y="") +  # Axis labels
    ggtitle('Lifestyle Habits and Metrics Comparison')+
    xlim(0, 3) + ylim(0,90)  # X and Y axis limits
  
  # Add texts
  p = p + geom_text_repel(label=left_label, y=data_df$USA, x=rep(1, NROW(data_df)), hjust=1.1, size=3.5)
  p = p + geom_text_repel(label=right_label, y=data_df$Japan, x=rep(2, NROW(data_df)), hjust=-0.1, size=3.5)
  p = p + geom_text(label="USA", x=1, y= 90, hjust=1.2, size=5)  # title
  p = p + geom_text(label="Japan", x=2, y=90, hjust=-0.1, size=5)  # title
  
  # Minify theme
  p = p + theme(panel.background = element_blank(), 
                panel.grid = element_blank(),
                axis.ticks = element_blank(),
                axis.text.x = element_blank(),
                panel.border = element_blank())
  p
  
}

#smoking percentages across age and gender in USA
#filter male and female data 
female_usa = usa_2013 %>% filter(sex == 'Female')
male_usa = usa_2013 %>% filter(sex=='Male')
fem_japan = japan_2013 %>% filter(gender == 'Female')
mal_japan = japan_2013 %>% filter(gender == 'Male')

#create survey designs for male and female
female_design = svydesign(data = female_usa,
                          weights = ~x.llcpwt,
                          ids = ~1,
                          nest=T)
male_design = svydesign(data = male_usa,
                        weights = ~x.llcpwt,
                        ids = ~1,
                        nest=T)


# percentage of smokers across population
smo_age_usa = data.frame(prop.table(svytable(~x.rfsmok3+age_group,
                                             design=brfss_design),margin=2))
smo_age_usa = smo_age_usa %>% filter(x.rfsmok3==1) %>% select(-c(x.rfsmok3)) 

# percentage of smokers among males and females
smo_fem_usa = data.frame(prop.table(svytable(~x.rfsmok3+age_group,female_design),
                                    margin = 2))
smo_fem_usa$sex = 'Female'

smo_mal_usa = data.frame(prop.table(svytable(~x.rfsmok3+age_group,male_design),
                                    margin = 2))
smo_mal_usa$sex = 'Male'
smo_usa_gen = rbind(smo_fem_usa,smo_mal_usa)
smo_usa_gen = smo_usa_gen %>% spread(sex,Freq)
smo_usa_gen = smo_usa_gen %>% filter(x.rfsmok3==1) %>% select(-c(x.rfsmok3))

smo_age_gen_usa = left_join(smo_age_usa, smo_usa_gen)
smo_age_gen_usa$country = 'USA'
colnames(smo_age_gen_usa) = c('Age group', 'Both', 'Female','Male','Country')
#smo_age_gen_usa

#smoking percentages across population in Japan
smo_age_japan = data.frame(prop.table(table(japan_2013$`Smoking status`,
                                            japan_2013$age_group),margin=2))
smo_age_japan = smo_age_japan %>% filter(Var1 == 1) %>% select(-c(Var1))

#smoking percentages across males and females
smo_fem_japan = data.frame(prop.table(table(fem_japan$`Smoking status`,
                                            fem_japan$age_group), margin = 2))
smo_fem_japan$Var3 = 'Female'

smo_mal_japan = data.frame(prop.table(table(mal_japan$`Smoking status`,
                                            mal_japan$age_group), margin = 2))
smo_mal_japan$Var3 = 'Male'
smo_gen_japan = rbind(smo_fem_japan,smo_mal_japan)
smo_gen_japan
smo_gen_japan = smo_gen_japan %>% filter(Var1 == 1) %>% select(-c(Var1))
smo_gen_japan = smo_gen_japan %>% spread(Var3,Freq)
smo_age_gen_japan = left_join(smo_age_japan,smo_gen_japan)
smo_age_gen_japan$country = 'Japan'
colnames(smo_age_gen_japan) =  c('Age group', 'Both', 'Female','Male','Country')

smo_age_gen = rbind(smo_age_gen_usa, smo_age_gen_japan)
smo_age_gen$Both = round(smo_age_gen$Both*100,2)
smo_age_gen$Female = round(smo_age_gen$Female*100,2)
smo_age_gen$Male = round(smo_age_gen$Male*100, 2)
smo_age_gen

#plot
#plot_ly(smo_age_gen, x=~`Age group`, y=~Both, color=~Country, text = '% of smokers',
 #       type='bar', colors='Set1')

# enough sleep percentages across population in USA
sle_age_usa = data.frame(prop.table(svytable(~sleptim1+age_group,
                                             design=brfss_design),margin=2))
sle_age_usa = sle_age_usa %>% filter(sleptim1==1) %>% select(-c(sleptim1)) 

#enough sleep percentages across males and females in USA
sle_fem_usa = data.frame(prop.table(svytable(~sleptim1+age_group,female_design),
                                    margin = 2))
sle_fem_usa$sex = 'Female'
sle_mal_usa = data.frame(prop.table(svytable(~sleptim1+age_group,male_design),
                                    margin = 2))
sle_mal_usa$sex = 'Male'
sle_usa_gen = rbind(sle_fem_usa,sle_mal_usa)
sle_usa_gen

sle_usa_gen = sle_usa_gen %>% spread(sex,Freq)
sle_usa_gen = sle_usa_gen %>% filter(sleptim1==1) %>% select(-c(sleptim1))
sle_age_gen_usa = left_join(sle_age_usa, sle_usa_gen)
sle_age_gen_usa$country = 'USA'
colnames(sle_age_gen_usa) = c('Age group', 'Both', 'Female','Male','Country')
sle_age_gen_usa

#enough sleep percentages across population in Japan
sle_age_japan = data.frame(prop.table(table(japan_2013$`Enough sleep`,
                                            japan_2013$age_group),margin=2))
sle_age_japan <- sle_age_japan %>% filter(Var1 == "1.0") %>% select(-c(Var1))

#enough sleep percentages across males and females in Japan
sle_fem_japan = data.frame(prop.table(table(fem_japan$`Enough sleep`,
                                            fem_japan$age_group), margin = 2))
sle_fem_japan$Var3 = 'Female'
sle_mal_japan = data.frame(prop.table(table(mal_japan$`Enough sleep`,
                                            mal_japan$age_group), margin = 2))
sle_mal_japan$Var3 = 'Male'
sle_gen_japan = rbind(sle_fem_japan,sle_mal_japan)
sle_gen_japan
sle_gen_japan = sle_gen_japan %>% filter(Var1 == "1.0") %>% select(-c(Var1))
sle_gen_japan = sle_gen_japan %>% spread(Var3,Freq)
sle_age_gen_japan = left_join(sle_age_japan,sle_gen_japan)
sle_age_gen_japan$country = 'Japan'
colnames(sle_age_gen_japan) =  c('Age group', 'Both', 'Female','Male','Country')
sle_age_gen_japan

sle_age_gen = rbind(sle_age_gen_usa, sle_age_gen_japan)
sle_age_gen$Both = round(sle_age_gen$Both*100,2)
sle_age_gen$Female = round(sle_age_gen$Female*100,2)
sle_age_gen$Male = round(sle_age_gen$Male*100, 2)
sle_age_gen

#plots
# plot_ly(sle_age_gen, x=~`Age group`, y=~Both, color=~Country, text = '% reported enough sleep',
#         type='bar', colors='Set1')
# plot_ly(sle_age_gen, x=~`Age group`, y=~Male, color=~Country, text = '% reported enough sleep',
#         type='bar', colors='Set1')
# plot_ly(sle_age_gen, x=~`Age group`, y=~Female, color=~Country, text = '% reported enough sleep',
#         type='bar', colors='Set1')

















