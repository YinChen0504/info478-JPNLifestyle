library(dplyr)
library(ggplot2)
library(plotly)

#load data
world = read.csv('worldData.csv')
dim(world)
str(world)

# Countries with life expectancy(>80) in 2013 
p = world %>% filter(Year == 2013 & percentage.expenditure > 0 & Life.expectancy > 82 ) %>%
  select(Country, Status, Life.expectancy, percentage.expenditure) %>% 
  arrange(percentage.expenditure) %>%
  ggplot(aes(x= reorder(Country,-percentage.expenditure), y = Life.expectancy)) +
  geom_bar(stat='identity', aes(fill=percentage.expenditure))+
  xlab('Country')+
  ylab('Life expectancy in years')+
  coord_flip()+
  ggtitle('Which country is spending less and has higher life expectancy?')+
  labs(fill = 'Percentage Expenditure')
#convert to interactive plot
 pp = ggplotly(p, tooltip = c('y','fill'))
 #view plot
 pp


#compare life expectancy of Japan and USA
df = world %>% filter(Year == 2013 & (Country == 'Japan' | 
                                        Country == 'United States of America'))
df$hover = with(df, paste(Country,'<br>','Life expectancy', Life.expectancy,'<br>',
                          'Total expenditure', Total.expenditure))
p1 = plot_ly(df, x=~Country, y=~Life.expectancy, type='bar', 
        color=~Country, text=~hover, hoverinfo='text') %>%
  layout(title = 'Life expectancy comparision in 2013', 
         xaxis = list(title = 'Country', showticklabels = FALSE),
         yaxis = list(title = 'Life expectancy'))
p1
