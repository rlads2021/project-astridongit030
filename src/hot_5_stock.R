#設定工作目錄匯入資料
stock_final <- read.csv("./stock_final.csv")

#為要盡量保留原始文本用詞習慣，故設定不使用stopwords之斷詞公式
seg_no_stopwords <- worker(symbol = T, bylines = F, user = "./斷詞.txt")

#計算相似度cos公式
cos_sim <- function(x,y){
    result <- (x %*% y) /(sqrt(x %*% x) * (sqrt(y %*% y)))
    return(result[1])
}

##熱門度前五股票
stock_top5 <- stock_final %>%
    group_by(Target_number) %>%
    summarise(count = n())%>%
    arrange(desc(count)) %>%
    top_n(n = 5)

##台積電2330
stock_final_1 <- stock_final %>%
    filter(Target_number == 2330)

docs_segged_1 <- vector("character", length = length(stock_final_1$Analysis))
for(i in seq_along(stock_final_1$Analysis)){
    segged <- segment(stock_final_1$Analysis[i], seg_no_stopwords)
    docs_segged_1[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_1 <- tibble(number = seq_along(docs_segged_1), content = docs_segged_1)
q_corpus_1 <- corpus(df_1, docid_field = "number", text_field = "content")
q_tokens_1 <- tokenizers::tokenize_regex(q_corpus_1 , " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_1 <- vector("character", 100000)
for(i in 1:length(q_tokens_1)){
    stock_all_1 <- union(stock_all_1, q_tokens_1[[i]])
}
length(stock_all_1)

# 製作出dtm
stock_dtm_1 <- matrix(nrow = length(q_tokens_1), ncol = length(stock_all_1))

for(i in 1:length(q_tokens_1)){
    stock_num <- vector("numeric", length(stock_all_1))
    temp = q_tokens_1[[i]]
    for(j in 1:length(stock_all_1)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_1[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_1[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_1 <- vector("numeric", length(stock_final_1$Analysis)*(length(stock_final_1$Analysis)-1)/2)
stock_index_1 <- 1

for(i in 1:(length(stock_final_1$Analysis)-1)){
    for(j in (i+1):length(stock_final_1$Analysis)){
        stock_cos_1[stock_index_1] <- cos_sim(stock_dtm_1[i, ], stock_dtm_1[j,])
        stock_index_1 <- stock_index_1 + 1
    }
}

##大盤50
stock_final_2 <- stock_final %>%
    filter(Target_number == 50)
docs_segged_2 <- vector("character", length = length(stock_final_2$Analysis))
for(i in seq_along(stock_final_2$Analysis)){
    segged <- segment(stock_final_2$Analysis[i], seg_no_stopwords)
    docs_segged_2[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_2 <- tibble(number = seq_along(docs_segged_2), content = docs_segged_2)
q_corpus_2 <- corpus(df_2, docid_field = "number", text_field = "content")
q_tokens_2 <- tokenizers::tokenize_regex(q_corpus_2 , " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_2 <- vector("character", 100000)
for(i in 1:length(q_tokens_2)){
    stock_all_2 <- union(stock_all_2, q_tokens_2[[i]])
}

# 製作出dtm
stock_dtm_2 <- matrix(nrow = length(q_tokens_2), ncol = length(stock_all_2))

for(i in 1:length(q_tokens_2)){
    stock_num <- vector("numeric", length(stock_all_2))
    temp = q_tokens_2[[i]]
    for(j in 1:length(stock_all_2)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_2[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_2[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_2 <- vector("numeric", length(stock_final_2$Analysis)*(length(stock_final_2$Analysis)-1)/2)
stock_index_2 <- 1

for(i in 1:(length(stock_final_2$Analysis)-1)){
    for(j in (i+1):length(stock_final_2$Analysis)){
        stock_cos_2[stock_index_2] <- cos_sim(stock_dtm_2[i, ], stock_dtm_2[j,])
        stock_index_2 <- stock_index_2 + 1
    }
}

##長榮2603
stock_final_3 <- stock_final %>%
    filter(Target_number == 2603 & Not_Push != 0)

docs_segged_3 <- vector("character", length = length(stock_final_3$Analysis))
for(i in seq_along(stock_final_3$Analysis)){
    segged <- segment(stock_final_3$Analysis[i], seg_no_stopwords)
    docs_segged_3[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_3 <- tibble(number = seq_along(docs_segged_3), content = docs_segged_3)
q_corpus_3 <- corpus(df_3, docid_field = "number", text_field = "content")
q_tokens_3 <- tokenizers::tokenize_regex(q_corpus_3, " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_3 <- vector("character", 100000)
for(i in 1:length(q_tokens_3)){
    stock_all_3 <- union(stock_all_3, q_tokens_3[[i]])
}

# 製作出dtm
stock_dtm_3<- matrix(nrow = length(q_tokens_3), ncol = length(stock_all_3))

for(i in 1:length(q_tokens_3)){
    stock_num <- vector("numeric", length(stock_all_3))
    temp = q_tokens_3[[i]]
    for(j in 1:length(stock_all_3)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_3[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_3[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_3 <- vector("numeric", length(stock_final_3$Analysis)*(length(stock_final_3$Analysis)-1)/2)
stock_index_3 <- 1

for(i in 1:(length(stock_final_3$Analysis)-1)){
    for(j in (i+1):length(stock_final_3$Analysis)){
        stock_cos_3[stock_index_3] <- cos_sim(stock_dtm_3[i, ], stock_dtm_3[j,])
        stock_index_3 <- stock_index_3 + 1
    }
}

##鴻海2317
stock_final_4 <- stock_final %>%
    filter(Target_number == 2317)
docs_segged_4 <- vector("character", length = length(stock_final_4$Analysis))
for(i in seq_along(stock_final_4$Analysis)){
    segged <- segment(stock_final_4$Analysis[i], seg_no_stopwords)
    docs_segged_4[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_4 <- tibble(number = seq_along(docs_segged_4), content = docs_segged_4)
q_corpus_4 <- corpus(df_4, docid_field = "number", text_field = "content")
q_tokens_4 <- tokenizers::tokenize_regex(q_corpus_4 , " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_4 <- vector("character", 100000)
for(i in 1:length(q_tokens_4)){
    stock_all_4<- union(stock_all_4, q_tokens_4[[i]])
}

# 製作出dtm
stock_dtm_4 <- matrix(nrow = length(q_tokens_4), ncol = length(stock_all_4))

for(i in 1:length(q_tokens_4)){
    stock_num <- vector("numeric", length(stock_all_4))
    temp = q_tokens_4[[i]]
    for(j in 1:length(stock_all_4)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_4[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_4[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_4 <- vector("numeric", length(stock_final_4$Analysis)*(length(stock_final_4$Analysis)-1)/2)
stock_index_4 <- 1

for(i in 1:(length(stock_final_4$Analysis)-1)){
    for(j in (i+1):length(stock_final_4$Analysis)){
        stock_cos_4[stock_index_4] <- cos_sim(stock_dtm_4[i, ], stock_dtm_4[j,])
        stock_index_4 <- stock_index_4 + 1
    }
}

##國巨2327
stock_final_5 <- stock_final %>%
    filter(Target_number == 2327)
docs_segged_5 <- vector("character", length = length(stock_final_5$Analysis))
for(i in seq_along(stock_final_5$Analysis)){
    segged <- segment(stock_final_2$Analysis[i], seg_no_stopwords)
    docs_segged_5[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_5 <- tibble(number = seq_along(docs_segged_5), content = docs_segged_5)
q_corpus_5 <- corpus(df_5, docid_field = "number", text_field = "content")
q_tokens_5 <- tokenizers::tokenize_regex(q_corpus_5, " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_5 <- vector("character", 100000)
for(i in 1:length(q_tokens_5)){
    stock_all_5 <- union(stock_all_5, q_tokens_5[[i]])
}

# 製作出dtm
stock_dtm_5 <- matrix(nrow = length(q_tokens_5), ncol = length(stock_all_5))

for(i in 1:length(q_tokens_5)){
    stock_num <- vector("numeric", length(stock_all_5))
    temp = q_tokens_5[[i]]
    for(j in 1:length(stock_all_5)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_5[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_5[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_5 <- vector("numeric", length(stock_final_5$Analysis)*(length(stock_final_5$Analysis)-1)/2)
stock_index_5 <- 1

for(i in 1:(length(stock_final_5$Analysis)-1)){
    for(j in (i+1):length(stock_final_5$Analysis)){
        stock_cos_5[stock_index_5] <- cos_sim(stock_dtm_5[i, ], stock_dtm_5[j,])
        stock_index_5 <- stock_index_5 + 1
    }
}



#察看結果，對應圖(2)
list("台積電2330文本相似度" = summary(stock_cos_1),
     "大盤50文本相似度" = summary(stock_cos_2),
     "長榮2603文本相似度" = summary(stock_cos_3),
     "鴻海2317" = summary(stock_cos_4),
     "國巨2327文本相似度" = summary(stock_cos_5))
