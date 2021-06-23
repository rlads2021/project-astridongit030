library(tidyverse)
library(tidytext)
library(readr)
library(jiebaR)

# 讀入以計算績效之所有發文檔案並計算年化報酬率
stock <- read.csv("stock_return.csv", encoding = "utf-8") %>%
    mutate(Date = as.Date(Date, "%Y/%m/%d"),
           Year = str_sub(Date, 1, 4), .after = Date) %>%
    mutate(Return_yr = ifelse(Long_or_short == "Short", Return * 50, Return), .after = Return)
            

s18 <- stock %>% filter(Year == "2018")
s19 <- stock %>% filter(Year == "2019")
s20 <- stock %>% filter(Year == "2020")
s21 <- stock %>% filter(Year == "2021")

# 各年度作者/發文篇數/年化平均報酬率
count_yr <- stock %>%
    group_by(Author, Year) %>%
    count(Title) %>%
    summarise(Post_num = sum(n))

Yearly_data <- stock %>%
    group_by(Author, Year) %>%
    summarise(Avr_return = mean(Return_yr), Avr_sent1 = mean(Sent1),
              Avr_sent2 = mean(Sent2)) %>%
    ungroup() %>%
    add_column(Post_num = count_yr$Post_num, .after = "Year") %>%
    mutate(Org_return = Post_num * Avr_return, .after = "Avr_return")

Year18 <- Yearly_data %>% filter(Year == "2018")
Year18_p50 <- rank(Year18, "P", 50)
Year18_r50 <- rank(Year18, "R", 50)

Year19 <- Yearly_data %>% filter(Year == "2019")
Year19_p50 <- rank(Year19, "P", 50)
Year19_r50 <- rank(Year19, "R", 50)

Year20 <- Yearly_data %>% filter(Year == "2020")
Year20_p50 <- rank(Year20, "P", 50)
Year20_r50 <- rank(Year20, "R", 50)

Year21 <- Yearly_data %>% filter(Year == "2021")
Year21_p50 <- rank(Year21, "P", 50)
Year21_r50 <- rank(Year21, "R", 50)

# 每天作者/發文篇數/年化平均報酬率
count_day <- stock %>%
    group_by(Date) %>%
    count(Title) %>%
    summarise(Post_num = sum(n))

Daily_data <- stock %>%
    group_by(Date) %>%
    summarise(Avr_return = mean(Return_yr), Avr_sent1 = mean(Sent1),
              Avr_sent2 = mean(Sent2)) %>%
    add_column(Post_num = count_day$Post_num)

s18d <- Daily_data %>% filter(str_detect(Date, "2018"))
s19d <- Daily_data %>% filter(str_detect(Date, "2019"))
s20d <- Daily_data %>% filter(str_detect(Date, "2020"))
s21d <- Daily_data %>% filter(str_detect(Date, "2021"))

# functions
# generating ranks
rank <- function(data, type, n) {
    result <- "Wrong Input"
    
    if (type == "P") {
        df <- data %>%
            top_n(n, Post_num)
        result <- df %>%
            arrange(desc(Post_num))
    } else if (type == "R") {
        df <- data %>%
            top_n(n, Avr_return)
        result <- df %>%
            arrange(desc(Avr_return))
    }
    return(result)
}

# generating avr. return
avr_return <- function(data) {
    result <- sum(data$Org_return) / sum(data$Post_num)
    return(result)
}

# generating avr. sentiment scores
avr_sent <- function(data) {
    one <- sum(data$Avr_sent1 * data$Post_num) / sum(data$Post_num)
    two <- sum(data$Avr_sent2 * data$Post_num) / sum(data$Post_num)
    result <- c(one, two)
    return(result)
}

# yearly plots of daily average return & daily average sentiment scores
g18 <- ggplot(data = s18d) +
    geom_line(mapping = aes(x = Date, y = Avr_return * 0.01), color = "grey50", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent1), color = "skyblue", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent2), color = "orange", size = 1) +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent1), color = "deepskyblue3") +
    geom_smooth(mapping = aes(x = Date, y = Avr_return * 0.01), color = "black") +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent2), color = "darkorange3") +
    theme_minimal() + labs(title = "Line chart of Average daily return and Sentiment scores",
                           subtitle = "2018",
                           y = "Average daily return(%)")

g19 <- ggplot(data = s19d) +
    geom_line(mapping = aes(x = Date, y = Avr_return * 0.01), color = "grey50", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent1), color = "skyblue", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent2), color = "orange", size = 1) +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent1), color = "deepskyblue3") +
    geom_smooth(mapping = aes(x = Date, y = Avr_return * 0.01), color = "black") +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent2), color = "darkorange3") +
    theme_minimal() + labs(title = "Line chart of Average daily return and Sentiment scores",
                           subtitle = "2019",
                           y = "Average daily return(%)")

g20 <- ggplot(data = s20d) +
    geom_line(mapping = aes(x = Date, y = Avr_return * 0.01), color = "grey50", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent1), color = "skyblue", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent2), color = "orange", size = 1) +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent1), color = "deepskyblue3") +
    geom_smooth(mapping = aes(x = Date, y = Avr_return * 0.01), color = "black") +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent2), color = "darkorange3") +
    theme_minimal() + labs(title = "Line chart of Average daily return and Sentiment scores",
                           subtitle = "2020",
                           y = "Average daily return(%)")

g21 <- ggplot(data = s21d) +
    geom_line(mapping = aes(x = Date, y = Avr_return * 0.01), color = "grey50", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent1), color = "skyblue", size = 1) +
    geom_line(mapping = aes(x = Date, y = Avr_sent2), color = "orange", size = 1) +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent1), color = "deepskyblue3") +
    geom_smooth(mapping = aes(x = Date, y = Avr_return * 0.01), color = "black") +
    geom_smooth(mapping = aes(x = Date, y = Avr_sent2), color = "darkorange3") +
    theme_minimal() + labs(title = "Line chart of Average daily return and Sentiment scores",
                           subtitle = "2021",
                           y = "Average daily return(%)")

# 讀入最熱門55名股票之每日股價檔案 & 保留最熱門10名資料
price <- read.csv("1-55stock_price.csv", encoding = "utf-8") %>%
    mutate(Date = as.Date(Date, "%Y/%m/%d"),
           Year = str_sub(Date, 1, 4)) %>%
    filter(Name %in% c("2330 台積電", "0050 大盤", "2603 長榮",
                       "2317 鴻海", "2327 國巨", "3105 穩懋",
                       "2303 聯電", "2454 聯發科", "2492 華新科", "3481 群創" ))

# 計算每日平均股價
Daily_price <- price %>%
    group_by(Date) %>%
    summarise(Avr_price = mean(Price_day, na.rm = T))

# plot of popular stock daily average prices & daily average sentiment score2
price_sent <- ggplot() +
    geom_line(Daily_data, mapping = aes(x = Date, y = Avr_sent2 * 10),
              size = 0.8, color = "orange") +
    geom_line(Daily_price, mapping = aes(x = Date, y = Avr_price), size = 0.8) +
    theme_minimal() +
    labs(title = "Line chart of Sentiment score2 and Stock price of the 10 most popular stocks on PTT",
         subtitle = "2018-2021")

