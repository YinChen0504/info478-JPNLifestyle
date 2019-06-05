library(shiny)
library(ggplot2)
library(ggrepel)
source("analysis.R")


shinyUI(navbarPage(
  theme = "style.css",
  "Longer Life",
  id = "tabs",
  
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
))