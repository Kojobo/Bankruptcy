library(readxl)
url <- "https://www.uscourts.gov/file/10864/download"
destfile <- "download.xls"
curl::curl_download(url, destfile)
filings_01 <- read_excel(destfile, range = "a7:f136")

library(openxlsx)

url_f2_18 <- "https://www.uscourts.gov/file/25503/download"
destfile_f2_18 <- "filings_18.xlsx"
filings_18 <- openxlsx::read.xlsx(url_f2_18,
                                  sheet = 1, 
                                  rows = 5:110,
                                  cols = 1:6,
                                  colNames = F)

filings_01 <-  na.omit(filings_01)

#change column names #2001

colnames(filings_01) <- c("state", "all_chap", "ch7", "ch11", "ch12", "ch3")

#remove rows that show circuit totals

filings_01 <- filings_01[c(-1,-3, -9, -16, -23, -33, -43, -53, -61, -72, -88, -97), ]

#modify column 1 by removing the district indicator #convert column1 to factors

filings_01$state <- factor(substr(filings_01$state, start = 1, stop = 2))

filings_01 <- filings_01 %>% 
  group_by(state) %>% 
  summarise(filings_2001 = sum(ch7, na.rm = T))

#remove rows that show circuit totals

filings_18 <- filings_18[c(-1,-3, -9, -16, -23, -33, -43, -53, -61, -71, -87, -96), ]

#change column names #2001

colnames(filings_18) <- c("state", "all_chap", "ch7", "ch11", "ch12", "ch3")

#modify column 1 by removing the district indicator #convert column1 to factors

filings_18$state <- factor(substr(filings_18$state, start =1, stop = 2))

#convert column 3 to numeric #2018

filings_18$ch7 <- as.numeric(filings_18$ch7)

filings_18 <- filings_18 %>% 
  group_by(state) %>% 
  summarise(filings_2018 = sum(ch7, na.rm = T))

ch7_filings <- left_join(filings_01, filings_18)

#plotly dumbbell chart

ch7_filings %>% 
  mutate(state = fct_reorder(state, filings_2001)) %>% 
  plot_ly() %>% 
  add_segments(
    x = ~filings_2018, y = ~state, 
    xend = ~filings_2001, yend = ~state, 
    color = I("gray"), showlegend = F
    ) %>% 
  add_markers(
    x = ~filings_2018, y = ~state, 
    color = I('blue'), 
    name = 'Filings in 2018') %>% 
  add_markers(
    x = ~filings_2001, y = ~state, 
    color = I('red'), 
    name = 'Filings in 2001') %>% 
  layout(xaxis = list(title = 'Chapter 7 Filings'))
