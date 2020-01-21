bankruptcy %>% 
  group_by(state) %>% 
  summarise(total_assets = sum(total_gross_receipts)) %>% 
  mutate(State = fct_reorder(state, total_assets)) %>% 
  plot_ly() %>% 
  add_markers(
    x = ~total_assets, y = ~State
  ) %>% 
  layout(xaxis = list(title = 'Total Assets 2001 - 2018'))
