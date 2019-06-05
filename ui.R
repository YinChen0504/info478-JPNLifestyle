# 478 FINAL PROJECT (UI)
#######################################################################################################################################################################################
# LOAD LIBRARIES
library(shiny)
library(shinythemes)
library(lettercase)
library(RColorBrewer)

navbarPage("Lifestyle",
           
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
                        p("Major Libraries used: ", tags$b("Plotly, DPLYR, ShinyThemes")),
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
                        p("..."),
                        
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
           tabPanel("Drinking Comparison",
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
                        p("From the chart, we can see that people of either gender in the US had
                          consumed a higher number of drinks on average compared to that of
                          Japan in any given age group in 2013. Of all the age groups for both
                          genders, the difference in the number of drinks of the 40 - 49 year
                          old age group between the two countries was the greatest. The average
                          number of drinks that were consumed by either gender for both
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
                        tabsetPanel(
                          id = "tabset",
                          type = "tabs",
                          
                          ## HEALTH ISSUE PANNEL
                          tabPanel(
                            "Health Issues",
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
                        )
                      )
                    ),
           
           
           # Create a tab panel for displaying a comparison of different 
           #metrics across Japan and USA
           
           tabPanel(
             "Comparison across USA and Japan",
             titlePanel("Lifestlye habits and metrics comparison"),
             
             sidebarLayout(
               sidebarPanel(
                 conditionalPanel(condition = "input.tabset == 1",
                                  checkboxGroupInput("metric", "Select habit/outcome/metric:",
                                                     c("ALL", data_df$metric),
                                                     selected = c("Life.expectancy",'Average BMI'))  
                 )
               ),
               mainPanel(
                 tabsetPanel(
                   id = "tabset",
                   type = "tabs",
                   
                   # overview
                   tabPanel(
                     "Comparison across countries",
                     value = 1, 
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
               )
             )
           ),
           
           # Create a tab panel for displaying a comparison of smoking habits 
           # across Japan and USA
           tabPanel(
             "Smoking",
             titlePanel("Smoking across gender and age groups"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 conditionalPanel(condition = "input.tabset == 1",
                                  radioButtons("gender", "Select gender",
                                               c("Both", "Male", "Female")))
               ),
               mainPanel(
                 tabsetPanel(
                   id = "tabset",
                   type = "tabs",
                   
                   # percentage breakdown by age
                   tabPanel(
                     "Percentage of people smoking",
                     value=1,
                     plotlyOutput("smo_plot"),
                     br(),
                     h4(tags$b("Summary:")),
                     p(paste0("The charts above represent the percentage of smokers, male smokers 
            and female smokers across different age groups in Japan and USA. When considering 
            both male and female, from 40 to 54, the percentages are similar. But from age 55,
            percentage of smokers decreases more steeply in Japan than USA. When considering 
            only male smokers until age 54, higher percentages of men are smokers in Japan than
            USA. From age 55, the difference reduced. When considering only females, higher 
            proportion of women smoked across all age groups."))
                   )
                 )
               )
             )
           ),
           
           # Create a tab panel for displaying a comparison of sleep behavior 
           # across Japan and USA
           tabPanel(
             "Enough sleep",
             titlePanel("Sleep behavior across gender and age groups"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 conditionalPanel(condition = "input.tabset == 1", 
                                  radioButtons("sex", "Select gender",
                                               c("Both", "Male", "Female")))
               ),
               mainPanel(
                 tabsetPanel(
                   id = "tabset",
                   type = "tabs",
                   
                   
                   tabPanel(
                     "Percentage of people reporting enough sleep",
                     plotlyOutput("sle_plot"),
                     value=1,
                     br(),
                     h4(tags$b("Summary:")),
                     p(paste0("The charts above represent the percentage of population, males and females
                     reporting enough sleep across different age groups in Japan and USA.
                     When considering both males and females, until age 64 higher 
                     percentage of Japanese reported enough sleep than Americans.
                     For the age group 55-59 and after 65 years the difference is lesser than
                     other age groups. Japanese men have interesting sleep pattern. As age 
                     increases, the percentage of men having enough sleep decreases and their 
                     lowest is at age group 55-59. From age 60 onwards, the percentage steadily 
                     increases but is lesser than men of USA. For American males, until 
                     age 54, the percentage having enough sleep is similar. But from 54 onwards,
                     the percentage increases. When considering only females, higher 
                     percentage of Japanese women across all age groups reported enough sleep 
                     than American women. Women across age group 55-59 reported lower percentages
                     than neighboring age groups in Japan. From 65 years, there in decrease in 
                     percentage reporting enough sleep. In USA, the percentage of women reporting
                     enough sleep increases steadily with age."))
                   )
                 )
               )
             )
           )
           
           
           )
























