##文字雲
library(jiebaR)
library(stringr)
library(quanteda)
library(wordcloud)

#斷詞
seg <- worker(symbol = T, bylines = F, user = "./斷詞.txt", stop_word = "./stopwords.txt")


#2018文字雲
seg_data2018 <- seg[as.character(stock2018$內文)]
clean_data2018 <- str_remove_all(seg_data2018, "/s")
df2018 <- as.data.frame(sort(table(clean_data2018), decreasing = T)[1:100])

wordcloud(words = df2018$clean_data2018,
          freq = df2018$Freq,
          scale = c(3,0.65),
          random.order = F,
          rot.per = F,
          min.freq = 100,
          colors = brewer.pal(5, "Set1"))
#2019文字雲
seg_data2019 <- seg[as.character(stock2019$內文)]
clean_data2019 <- str_remove_all(seg_data2019, "/s")

df2019 <- as.data.frame(sort(table(clean_data2019), decreasing = T)[1:100])

wordcloud(words = df2019$clean_data2019,
          freq = df2019$Freq,
          scale = c(3,0.65),
          random.order = F,
          rot.per = F,
          min.freq = 100,
          colors = brewer.pal(5, "Set1"))
#2020文字雲
seg_data2020 <- seg[stock2020$Analysis]
clean_data2020 <- str_remove_all(seg_data2020, "/s")

df2020 <- as.data.frame(sort(table(clean_data2020), decreasing = T)[1:100])

wordcloud(words = df2020$clean_data2020,
          freq = df2020$Freq,
          scale = c(3,0.65),
          random.order = F,
          rot.per = F,
          min.freq = 100,
          colors = brewer.pal(5, "Set1"))
#2021文字雲
seg_data2021 <- seg[stock2021$Analysis]
clean_data2021 <- str_remove_all(seg_data2021, "/s")
df2021 <- as.data.frame(sort(table(clean_data2021), decreasing = T)[1:100])

wordcloud(words = df2021$clean_data2021,
          freq = df2021$Freq,
          scale = c(3,0.65),
          random.order = F,
          rot.per = F,
          min.freq = 100,
          colors = brewer.pal(5, "Set1"))

