library(plotly)

#find count of asset cases by each state #includes Puerto Rico and Guam, does NOT include North Carolina and Alabama 

cases_by_state <- bankruptcy %>% 
  group_by(state) %>% 
  summarize(case_count = n(),
            category = case_when(
              case_count < 2000 ~ 'Under 2000', 
              case_count < 4999 ~ '2,000 - 4,999',
              case_count < 9999 ~ '5,000 - 9,999', 
              case_count >= 10000 ~ '10,000 OR MORE', 
              TRUE ~ 'NOT SERVED BY THE USTP'
            )) 


#create chloropleth of case count for each state 

cases_by_state %>% 
plot_geo(locationmode = 'USA-states') %>% 
  add_trace(z = ~case_count, 
            locations = ~state) %>% 
  layout(title = 'ASSET CASES BY STATE \n(TOTAL NUMBER CLOSED 2001-2018)', geo = list(scope = 'usa'))
