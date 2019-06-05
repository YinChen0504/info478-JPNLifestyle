## 478 FINAL PROJECT (SERVER)
#######################################################################################################################################################################################
# LOAD LIBRARIES 
library(shiny)
library(readxl)
library(dplyr)
library(tidyr)
library(plotly)

## SOURCE IN FILES 
source("analysis.R")

# SERVER CODE 
server <- function(input, output) {
  
####################################################################################################
## MICHELLE
####################################################################################################
  ## EXERCISE PLOTLY 
  output$exercise_overview_plot <- renderPlotly({
    if (input$overall_country == "United States") {
      plot_ly(us_all, labels = ~type, values = ~percent, type = "pie") %>% 
        layout(title = "Daily Exercise Duration in the US")
    } else {
      plot_ly(jpn_all, labels = ~type, values = ~percent, type = "pie") %>% 
        layout(title = "Daily Exercise Duration in Japan")
    }
  })
  
  ## EXERCISE BY AGE PLOTLY 
  output$exercise_age_plot <- renderPlotly({
    
    ## POST ERROR MESSAGE
    shiny::validate(need(!is.null(input$age_exercise),
                         "Please select an option"))
    
    if (input$age_country == "United States") {
      exercise_df <- filter(us_percent, age_group == input$age_exercise)
      plot_ly(exercise_df, x = ~age_group, y = ~percentage, type = "bar") %>%
        layout(title = "Physically Active by Age in the US", 
               yaxis = list(range = c(0, 100), ticksuffix = "%"))
    } else {
      exercise_df <- filter(jpn_merged, age_group == input$age_exercise)
      plot_ly(exercise_df, x = ~Age, y = ~percentage, type = "bar", color = ~age_group) %>% 
        layout(title = "Physically Active by Age in Japan", 
               yaxis = list(range = c(0, 100), ticksuffix = "%"))
    }
  })
  
####################################################################################################
## YIN
#################################################################################################### 
  ## PLOT OF AGE/DRINKING PER DAY
  output$scatter <- renderPlotly({
    shiny::validate(need(!is.null(input$age_group),
                         "Please select an option"))
   
    ## FILTER DATA (AGE-GROUP) / IF-STATEMENT (FOR BOTH)
    data <- data_2013_drink_amount %>% filter(age_group == input$age_group)
    if (input$gender != "Both") {
      data <- data %>% filter(sex == input$gender)
    }
    
    ## PLOT A SCATTER PLOT 
    plot_ly(data = data, x = ~age_group, y = ~avg_drinks, type = "scatter",
            mode = "markers", color = ~country, colors = brewer.pal(7, "Paired")) %>%
      layout(
        title = str_title_case(paste0("Relationship Between Age and Average Number of Drinks Per Day")),
        yaxis = list(title = str_title_case(paste0("Number of drinks"))), xaxis = list(title = "Age")
      )
  })
  
#################################################################################################### 
# RANI
####################################################################################################  
  output$heading <- renderUI({
    return(h1("Welcome"))
  })
  
  ## HEALTH ISSUE PLOT 
  output$Graphs <- renderPlot({
    if (input$HealthIssues == "Hypertension") {
      hypertension_plot <- ggplot(full_hypertension, aes(fill=Country, y=Total, x=Hypertension)) +
        geom_bar(position="dodge", stat="identity") +
        ggtitle("Hypertension")
      print(hypertension_plot)
    } else if(input$HealthIssues == "BP") {
      bp_plot <- ggplot(full_bp, aes(fill=Country, y=Total, x=BP)) +
        geom_bar(position="dodge", stat="identity") +
        ggtitle("Blood Pressure")
      print(bp_plot)
    } else {
      diabetes_plot <- ggplot(full_diabetes, aes(fill=Country, y=Total, x=Diabetes)) +
        geom_bar(position="dodge", stat="identity") +
        ggtitle("Diabetes")
      print(diabetes_plot)
    }
  })
  
#################################################################################################### 
# KIRAN
####################################################################################################
  
  
   
  
  
  
  
####################################################################################################
}
