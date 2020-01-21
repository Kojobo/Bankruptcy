bankruptcy %>% 
  group_by(state) %>% 
  summarise(cases = n()) %>% 
  mutate(state = fct_reorder(state, cases)) %>% 
  plot_ly() %>% 
  add_markers(
    x = ~cases, y = ~state
  ) %>% 
  layout(xaxis = list(title = 'Asset Cases Closed 2001 - 2018'))
