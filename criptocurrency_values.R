library(dplyr)
library(chromote)
library(rvest)

b <- ChromoteSession$new()

b$Page$navigate("https://goldprice.org/cryptocurrency-price")
b$Page$loadEventFired()

# give JS time to render
Sys.sleep(5)
html <- b$Runtime$evaluate("document.documentElement.outerHTML")$result$value
page <- read_html(html)

tables <- html_table(page, fill = TRUE)
data <- tables[[2]] %>%
  select(-any_of(8)) %>%
  mutate(DateTime = Sys.time())

if (!dir.exists("data")) dir.create("data")

write.table(
  data,"data/data.csv", sep = ",", col.names = !file.exists("data/data.csv"),
  append = TRUE, row.names = FALSE
)
