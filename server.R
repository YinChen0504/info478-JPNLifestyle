library(dplyr)
library(shiny)
library(plotly)
library(lettercase)
library(RColorBrewer)
source("analysis.R")

shinyServer(function(input, output) {
   # Comparison plot
  output$comp_plot = renderPlot({
    shiny:: validate(need(!is.null(input$metric),'Please select an option'))
    data = data_df
     if (input$metric != "ALL") {
       data = data_df %>% filter(metric %in% input$metric)
     }
    
    return(build_comp_plot(data))
    
  })
  
  # Smoking plot
  output$smo_plot = renderPlotly({
    smo_data = smo_age_gen %>% select(`Age group`,Country,input$gender)
    colnames(smo_data)[3] = 'gender'
    
    plot_ly(smo_data, x=~`Age group`, y=~gender, color=~Country,
            text = '% of smokers',
            type='bar', colors='Set1')    %>%
               layout(
                 title = str_title_case(paste0("Smoking across age groups")),
                 yaxis = list(title = str_title_case(paste0("Percentage"))), 
                 xaxis = list(title = "Age group")
               )
  })
  # Sleep pattern plot
  output$sle_plot = renderPlotly({
    sle_data = sle_age_gen %>% select(`Age group`,Country,input$sex)
    colnames(sle_data)[3] = 'sex'
    
    plot_ly(sle_data, x=~`Age group`, y=~sex, color=~Country,
            text = '% reported enough sleep',
            type='bar', colors='Set1')    %>%
      layout(
        title = str_title_case(paste0("Sleep behavior across age groups")),
        yaxis = list(title = str_title_case(paste0("Percentage"))), 
        xaxis = list(title = "Age group")
      )
    
  })
})