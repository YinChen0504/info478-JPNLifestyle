# 478 FINAL PROJECT (UI)
#######################################################################################################################################################################################
# LOAD LIBRARIES
library(shiny)
library(shinythemes)
library(lettercase)
library(RColorBrewer)

# SOURCE IN FILES 
source("analysis.R")

# NAVBAR
navbarPage("Lifestyle",
           theme = shinytheme("united"),
           
           # NAV-TAB (OVERVIEW)
           tabPanel("Overview",
                    sidebarLayout(
                      sidebarPanel(
                        p("The Datasets we used are from ", 
                          a("Mendeley,", href = "https://data.mendeley.com/datasets/g7gzwd4c7h/1"),
                          a("Centers for Disease Control and Prevention,", href = "https://www.cdc.gov/brfss/annual_data/annual_2013.html"),
                          "and ", 
                          a("Kaggle", href = "https://www.kaggle.com/kumarajarshi/life-expectancy-who/version/1")),
                        
                        p("Our code can be accessed on ", a("GitHub.", href = "https://github.com/YinChen0504/info478-JPNLifestyle")),
                        p("Major Libraries used: ", tags$b("Plotly, Dplyr, ShinyThemes")),
                        p("Data Reading: ", tags$b("CSV, XLSX"))
                      ),
                      
                      mainPanel(
                        h3("Project Overview"),
                        p("The purpose of our research project is to understand how and why the Japanese are able to live so long and have the highest life expectancy in the whole entire world. 
                          The dataset that we have found contains the lifestyle of middle-aged and elderly people of Japanese descent. Through health checkups and visits to the doctors, they were able 
                          to gather lifestyle and personal details such as their BMI, the diet of said participants and any occurrences of health issues. Lifestyle factors include any instances of 
                          fast eating, skipping breakfast, eating a midnight snack, smoking, alcohol drinking, doing exercise, active lifestyle, and biophysical status were age, height, weight, BMI, 
                          blood components, and medical examination history."),
                        br(),
                        
                        h3("Target Audience"),
                        p("The target audience for our research can extend around the world. It is a known fact that Japan has the highest life expectancy, so it would be wise for the rest of the 
                          world to observe them and figure out their secrets if they would like to live a longer life. But our goal is to help the people at home first, so our target is the people 
                          at the University of Washington. If we are able to figure out some ground-breaking information, we hope it will be able to help DAWGS live a happy healthy life!"),
                        br(),
                        
                        h3("Central Questions"),
                        tags$ul(
                          tags$li("How do health outcomes (including diabetes, hypertension, blood pressure) compare across the United States and Japan?"),
                          tags$li("How do different lifestyle factors (including smoking, drinking, sleeping patterns, physical activities) vary among people in the United States and Japan?"),
                          tags$li("Which lifestyle factor is most likely related to Japan having a longer life expectancy than the United States?")
                        ),
                        br(),
                        
                        h3("Summary Findings"),
                        tags$ul(
                          tags$li("From the marplot for hypertenion / diabetes / blood pressure, we can see that for any given type of disease, including hypertension, diabetes, and blood
                                  pressure, people in the US had outnumbered people in Japan, meaning that more people in the US were having health issues in 2013 compared to that of Japan.
                                  A greater number of years to live implies that a person has to live a relatively healthy lifestyle without performing many risky behaviors, such as smoking,
                                  drinking, not being physically active, etc, because they contribute to lot os health issues, including the ones we conducted analysis on. Since people in 
                                  Japan generally have higher life expectancy than people in the US and fewer people had health issues, we can say that having fewer health issues due to a 
                                  healthier lifestyle is significant for people to have a longer life expectancy."),
                          
                          br(), 
                          tags$li(
                          tags$ul(
                          tags$li(tags$b("Physical Exercise"),
                                  br(),
                                  "From the daily exercise duration pie charts for both countries, we can see clearly that in 2013, a higher percentage of people in Japan had exercised more than 
                                  30 minutes than that of the US, meaning that people in Japan were more physically active than people in the US. Looking at the physical exercise factor broken 
                                  down by ages, we can see that people in all age groups in Japan were more physically active than that of the US. The most active age group in the US was 70+, 
                                  while for Japan it was the 60-69 year-old age group. In general, older people in both countries exercised more, it is perhaps due to the fact that they had more 
                                  time to exercise than younger people, or that they realized the importance of exercise to better body health. It is a common knowledge that physical exercise is 
                                  significant in maintaining physical health, especially for older people, the more active they remain, the healthier their bodies will be, therefore leading to a 
                                  greater number of years to live. Overall, we can say that physical exercise plays an important role in Japanese having longer life expectancy because compared to 
                                  people in the US, there were more people who were physically active in 2013."),
                          
                          br(),
                          tags$li(tags$b("Drinking"),
                                  br(),
                                  "From the drinking plot that compares the average number of drinks per day consumed by people in the US and Japan in 2013, we saw that for both females and 
                                  males, the average number of drinks consumed by the US was greater than that of Japan. The data files we used only contain people with age from 40 to 70+, 
                                  and we divided the ages to age groups, including 40-49, 50-59, 60-69, and 70+. Of all the age groups, both genders in both countries had consumed the 
                                  greatest average number of drinks in the 40-49 year-old age group, the difference between both countries for males was also the greatest in the 40-49 
                                  year-old age group, so as females. Based on the pattern we drew from the 2013 data files for Japan and the US, because drinking plays a big role in
                                  influencing a person’s physical health, in more serious cases, it directly impacts the number of years a person lives, we can say that Japan having a long 
                                  life expectancy than the US is closely related to consuming less number of drinks on average. "),
                        
                          br(),
                          tags$li(tags$b("Smoking"),
                                  br(),
                                  "From the smoking plot, it represents the percentages of smokers by gender and age groups across both Japan and the USA. We saw that when considering both 
                                  genders, from the age between 40-54, the percentages are very analogous. The highest occurrences/percentages of smokers for both genders was between the 
                                  age group of 50-54 by the U.S with a percentage of 21.98%. But when we are comparing only males, higher percentages of men in Japan are smokers than males
                                  in the U.S with their highest percentage of 48.39% in age group 50-54. Across all age groups, males in Japan have higher smoking percentages than 
                                  males in the US, but for females in the U.S, they have higher smoking percentages than women in Japan. From the age of 55, the percentage of female smokers 
                                  in Japan and the USA begin to reduce, but reduces more among Japanese women.The graph shows us that at younger ages, people in Japan and the U.S tend to smoke 
                                  more but as time goes on, the percentages begin to decrease. Overall, we can say that smoking in general has a great impact on life expectancy."),
                          
                          br(),
                          tags$li(tags$b("Sleeping"),
                                  br(),
                                  "The bar plot represents the percentage of population between males and females reporting enough sleep across a diverse set of age groups in the U.S and 
                                  Japan. When we are considering both genders, until the age of 64, there are higher percentages of Japanese who reported getting enough sleep than Americans.
                                  For the age group of 55-59 and after 65, the difference is lesser than other age groups. From the graph, it shows that Japanese men have fluctuating sleeping 
                                  patterns. In the age group 60-64, highest percentage of men reported enough sleep at 75% and their lowest is at age group 55-59
                                  (64.1%). From 65 years, the percentages are slightly less than men in the U.S. For males in America, until the age of 54, the percentages of enough 
                                  sleep is similar but after the age of 54, the percentages begin to increase. But when we are considering only females, higher percentages of 
                                  Japanese women across all the age groups reported getting more sleep than females in the U.S. Similar to the case between Japanese males and American 
                                  males, in the U.S, the percentage of women reporting getting enough sleep increases with age.")
                          )),
                          
                          br(),
                          tags$li("The lifestyle factor that is most likely related to Japan having a longer life expectancy, based off of our data; is exercising more than 30 minutes each day. 
                                  By exercising, physical activity or exercise can improve your health and reduce the risk of developing several diseases like type 2 diabetes, cancer and 
                                  cardiovascular disease. Physical activity and exercise can have immediate and long-term health benefits. Most importantly, regular activity can improve your 
                                  quality of life. From our physical activities tab, you can see a beautifully made pie chart that showcases the fact that 91.6% of the surveyed American citizens 
                                  reported getting less than 30 minutes of exercise per day. Whereas, in Japan; almost 50% of the surveyed people reported of exercising for more than 30 minutes per 
                                  day. This tells us that in 2013, there was a much higher percentage of people in Japan that were physically active than in the United States. When you exercise, it 
                                  reduces your risk of a heart attack, lowers blood cholesterol level, lowers blood pressure, strengthens your bones, muscles and joints and lowers the risk of 
                                  developing osteoporosis and it also makes you feel better – with more energy, and a better mood it will make you feel more relaxed and thus, get better sleep. 
                                  In conclusion, our data and calculations shows that exercising is very important and is the cause of higher life expectancies for Japanese people in the year of 2013.")
                        ),
                        
                        h3("Methods Used"),
                        p("We collected and used 3 files to answer our questions, including data files for US, Japan and world for year 2013. Because the files were relatively big,
                           we cleaned the data first by taking out variables we needed for analysis and used those to create new data frames. In order to find common variables that
                           could be used to perform analysis for both the US and Japan, we examined the data carefully and did some conversion between numbers and strings, as well
                           as taking care of data that were missing, eventually the data became appropriate to use. After cleaning up the data values, we still had to reformat the
                           data frames so they could be used to plot. We did a lot of percentage calculation, we also utilized the survey package from R by using the svytable function."),
                        br(),
                        
                        h3("Project Creators"),
                        tags$ul(
                          tags$li("Rani Chang"),
                          tags$li("Michelle Chen"),
                          tags$li("Yin Chen"),
                          tags$li("Kiranmayi Klc")
                        )
                      )
                    )
                    ),
           
           # CREATE A TAB PANEL FOR DISPLAYING A COMPARISON OF DIFFERENT
           # METRICS ACROSS JAPAN AND THE US
           
           tabPanel(
             "Comparison Across USA and Japan",
             titlePanel("Lifestlye Habits and Metrics Comparison"),
             
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput("metric", "Select habit/outcome/metric:",
                                    c("ALL", data_df$metric),
                                    selected = c("Life.expectancy",'Average BMI')  
                 )
               ),
               mainPanel(
                 plotOutput("comp_plot"),
                 tags$i("% drinking alcohol*- For USA, the value corresponds to percentage
                     who reported drinking alcohol in last 30 days. For Japan, the value
                            corresponds to percentage who reported drinking alcohol currently."),
                 br(),
                 tags$i("% had physical activity**- For USA, the value corresponds to percentage
                     who reported having a physical activity other than work in last 30 days.
                     For Japan, the value corresponds to the percentage who reported having a regular
                            physical activity."),
                 br(),
                 h4(tags$b("Summary:")),
                 p(paste0("The chart above presents comparison of metrics, percentages of people
                     exhibiting lifestyle habits like smoking, drinking alcohol, having enough 
                     sleep, having physical activity and percentages of people having 
                     outcomes like hypertension and diabetes. The factors among which Japan
                     is better than USA are in red. The factors at which USA is better than
                     Japan is in green. We can observe than Japan is better than USA in all
                     the aspects except at physical activity. But, as the survey questions
                     for this value are formed differently it is necessary to investigate 
                     further in this area. Excluding that, the major difference can be seen in
                     percentage of people drinking alcohol followed by percentage of people 
                     reporting enough sleep. As major difference can be observed in these 
                     habits, these might be associated with longer life expectancy of Japanese
                     people."))
                 )
               )
             ),
           
           
           # NEW NAV-TAB (PHYSICAL ACTIVITY)
           tabPanel("Physical Activities",
                    titlePanel("Physical Activities"),
                    
                    sidebarLayout(
                      sidebarPanel(
                        conditionalPanel(condition = "input.tabset == 1",
                                         radioButtons("overall_country", "Select country",
                                                      c("United States", "Japan"))
                                         ),
                        conditionalPanel(condition = "input.tabset == 2",
                                         radioButtons("age_country", "Select Country",
                                                      c("United States", "Japan")),
                                         checkboxGroupInput("age_exercise", "Select Age Group",
                                                            c("40-49", "50-59", "60-69", "70+"), selected = "40-49")
                                         )
                        ),
                      
                      mainPanel(
                        tabsetPanel(
                          id = "tabset",
                          type = "tabs",
                          
                          # OVERALL PERCENTAGE
                          tabPanel(
                            "Overall Percentage",
                            value = 1,
                            htmlOutput("heading"),
                            textOutput("BackInfo"),
                            plotlyOutput("exercise_overview_plot"),
                            br(),

                            h4(tags$b("Summary")),
                            p(paste0("The charts show that in 2013 in the United States, only 8.38% of the people exercised more than 30 ",
                                     "minutes per day on average, while the rest exercised less than 30 minutes or did not exercise at all. ",
                                     "Whereas in Japan, 47.3% exercised more than 30 minutes per day, and 52.7% exercised less than 30 ",
                                     "minutes or did not exercise at all. This tells us that in 2013, there was a much higher percentage of ",
                                     "people in Japan that were physically active than in the United States."))
                            ),
                          
                          # PERCENTAGE BREAKDOWN BY AGE
                          tabPanel(
                            "Age Breakdown",
                            value = 2,
                            htmlOutput("bghtml"),
                            plotlyOutput("exercise_age_plot"),
                            br(),

                            h4(tags$b("Summary")),
                            p(paste0("The charts show that in 2013 in the United States, across all the age groups that reported their exercise ",
                                     "behaviors, only 6.92% in age group 40-49, 7.61% in 50 - 59, 9.49% in 60-69, and 10.06% in 70+ age group ",
                                     "exercised more than 30 minutes per day on average. This tells us that on average, only around 8% of people ",
                                     "in each age group were physically active in the United States; the most active age group was 70+. In ",
                                     "Japan, across all the age groups, the percentage of people that exercised more than 30 minutes per day ",
                                     "was significantly higher than in United States. On average, 40% of people in each age group were physically ",
                                     "active in Japan; the age group that was the most active was 60-69."))
                            )
                          )
                        )
                      )
                    ),
           
           # NEW NAV-TAB (DRINKING COMPARISON)
           tabPanel("Drinking",
                    titlePanel("Average Alcoholic Drinks Per day"),
                    sidebarLayout(
                      sidebarPanel(
                        radioButtons("gender", "Select Gender",
                                     c("Both", "Male", "Female")),
                        checkboxGroupInput("age_group", "Select Age Group",
                                           c("40-49", "50-59", "60-69", "70+"),
                                           selected = "40-49")
                        ),
                      
                      mainPanel(
                        plotlyOutput("scatter"),
                        br(),
                        h4(tags$b("Summary:")),
                        p("From the chart, we can see that people of either gender in the US had consumed a higher number of drinks on average compared to that of
                        Japan in any given age group in 2013. Of all the age groups for both genders, the difference in the number of drinks of the 40 - 49 year
                        old age group between the two countries was the greatest. The average number of drinks that were consumed by either gender for both
                        countries was also the greatest in the 40 - 49 year old age group.")
                        )
                      )
                    ),
           
           # NEW NAV-TAB (HEALTH ISSUES)
           tabPanel("Health Issues",
                    titlePanel("Hypertension | Diabetes | Blood Pressure"),
                    
                    sidebarLayout(
                      sidebarPanel(
                        selectInput(
                          inputId = 'HealthIssues',
                          label = 'Health Issues',
                          choices = Issues
                          )
                        ),
                      
                      mainPanel(
                        htmlOutput("header"),
                        plotOutput("Graphs"),
                        br(),
                        h4(tags$b("Summary:")),
                        p("These graphs show the outcome between America and Japan. There are three health issues to choose from; Hypertension, Diabetes, and Blood Pressure.
                        There is a option of selecting one of the health issues just by selecting the dropdown menu on the left side. From each graph, you notice that in each graph 
                        Japan tended to have answered `yes` less than Americans. When people answer yes, it means that they have been told by a professional doctor that they have 
                        symptoms or do have these specific health issues. It was clear that on each graph, Japanese people answered more `No` than Americans. From all of this, we 
                        can say that, Japanese people live healthier lives and this may be due to the fact that they drink less and smoke less.")
                        )
                      )
                    ),
           
           # NEW TAB-PANLE (SMOKING HABITS)
           # CREATE A TAB PANEL FOR DISPLAYING A COMPARISON OF SMOKING HABITS ACROSS
           # JAPAN AND USA
           tabPanel(
             "Smoking",
             titlePanel("Smoking across gender and age groups"),
             
             sidebarLayout(
               sidebarPanel(
                  radioButtons("smoking_gender", "Select gender",
                              c("Both", "Male", "Female"))
               ),
               
               mainPanel(
                 plotlyOutput("smo_plot"),
                 br(),
                 h4(tags$b("Summary:")),
                 p(paste0("The charts above represent the percentage of smokers, male smokers and female smokers across different age groups in Japan and USA. When considering 
                 both male and female, from 40 to 54, the percentages are similar. But from age 55, percentage of smokers decreases more steeply in Japan than USA. When considering 
                 only male smokers, higher percentages of men are smokers in Japan than in USA, the difference increasing from 40 to 54 years. In the age group 50-54, 
                 48% of males in Japan reported smoking and is the highest. While only 24% of men in USA reported smoking in that age group.From age 55, the difference reduced and also the 
                 percentages males smoking decreased. When considering only females, higher proportion of women smoked in USA across all age groups. The highest difference can be observed 
                 in 50-54 age group. In Japan after 59 years and in USA after 54 years, the percentages decreased."))
                 )
               )
             ),
           
           # NEW TAB-PANEL (SLEEP BEHAVIOR)
           # CREATE A TAB PANEL FOR DISPLAYING A COMPARISON OF SLEEP BEHAVIOR ACROSS 
           # JAPAN AND USA
           tabPanel(
             "Sleep",
             titlePanel("Sleep Behavior Across Gender and Age Groups"),
             
             sidebarLayout(
               sidebarPanel(
                 radioButtons("sex", "Select gender",
                              c("Both", "Male", "Female"))
               ),
               mainPanel(
                 plotlyOutput("sle_plot"),
                 br(),
                 h4(tags$b("Summary:")),
                 p(paste0("The charts above represent the percentage of population, males and females reporting enough sleep across different age groups in Japan and USA.
                 When considering both males and females, until age 64 higher percentage of Japanese reported enough sleep than Americans.
                 For the age group 55-59 and after 65 years the difference is lesser than other age groups. The pattern is fluctuating for Japanese men, their lowest is 64.1%
                 across age group 55-59 and highest is 75% across age group 60-64.For American males, the percentage is steadily increasing from age 45. Both countries' males have similar
                 sleep percentages across age groups. Higher percentages of females reported enough sleep in Japan than USA across all age groups. The percentages are fluctuating across
                 Japanese women with their lowest of 67.16% in 55-59 age group and highest of 79.31% in 40-44 age group. In USA, after 54 years, the percentage of women reported enough 
                 sleep steadily increases."))
                 )
               )
             )
           )
























