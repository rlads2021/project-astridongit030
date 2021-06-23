##查看發文數前五多作者，對應圖(1-1)
stock_account_5 <- stock_final %>%
    group_by(Author) %>%
    summarise(count = n())%>%
    arrange(desc(count)) %>%
    top_n(n = 5)

stock_account_5

#為要盡量保留原始文本用詞習慣，故設定不使用stopwords之斷詞公式
seg_no_stopwords <- worker(symbol = T, bylines = F, user = "./斷詞.txt")

##Author_1
stock_author_1 <- stock_final %>%
    filter(Author == "Zyldr ()")

author_segged_1 <- vector("character", length = length(stock_author_1$Analysis))
for(i in seq_along(stock_author_1$Analysis)){
    segged <- segment(stock_author_1$Analysis[i], seg_no_stopwords)
    author_segged_1[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_a1 <- tibble(number = seq_along(author_segged_1), content = author_segged_1)
q_corpus_a1 <- corpus(df_a1, docid_field = "number", text_field = "content")
q_tokens_a1 <- tokenizers::tokenize_regex(q_corpus_a1 , " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_a1 <- vector("character", 100000)
for(i in 1:length(q_tokens_a1)){
    stock_all_a1 <- union(stock_all_a1, q_tokens_a1[[i]])
}


# 製作出dtm
stock_dtm_a1 <- matrix(nrow = length(q_tokens_a1), ncol = length(stock_all_a1))

for(i in 1:length(q_tokens_a1)){
    stock_num <- vector("numeric", length(stock_all_a1))
    temp = q_tokens_a1[[i]]
    for(j in 1:length(stock_all_a1)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_a1[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_a1[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_a1 <- vector("numeric", length(stock_author_1$Analysis)*(length(stock_author_1$Analysis)-1)/2)
stock_index_a1 <- 1

for(i in 1:(length(stock_author_1$Analysis)-1)){
    for(j in (i+1):length(stock_author_1$Analysis)){
        stock_cos_a1[stock_index_a1] <- cos_sim(stock_dtm_a1[i, ], stock_dtm_a1[j,])
        stock_index_a1 <- stock_index_a1 + 1
    }
}
summary(stock_cos_a1)

##Author_2
stock_author_2 <- stock_final %>%
    filter(Author == "kksis (流浪人生)")

author_segged_2 <- vector("character", length = length(stock_author_2$Analysis))
for(i in seq_along(stock_author_2$Analysis)){
    segged <- segment(stock_author_2$Analysis[i], seg_no_stopwords)
    author_segged_2[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_a2 <- tibble(number = seq_along(author_segged_2), content = author_segged_2)
q_corpus_a2 <- corpus(df_a2, docid_field = "number", text_field = "content")
q_tokens_a2 <- tokenizers::tokenize_regex(q_corpus_a2 , " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_a2 <- vector("character", 100000)
for(i in 1:length(q_tokens_a2)){
    stock_all_a2 <- union(stock_all_a2, q_tokens_a2[[i]])
}


# 製作出dtm
stock_dtm_a2 <- matrix(nrow = length(q_tokens_a2), ncol = length(stock_all_a2))

for(i in 1:length(q_tokens_a2)){
    stock_num <- vector("numeric", length(stock_all_a2))
    temp = q_tokens_a2[[i]]
    for(j in 1:length(stock_all_a2)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_a2[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_a2[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_a2 <- vector("numeric", length(stock_author_2$Analysis)*(length(stock_author_2$Analysis)-1)/2)
stock_index_a2 <- 1

for(i in 1:(length(stock_author_2$Analysis)-1)){
    for(j in (i+1):length(stock_author_2$Analysis)){
        stock_cos_a2[stock_index_a2] <- cos_sim(stock_dtm_a2[i, ], stock_dtm_a2[j,])
        stock_index_a2 <- stock_index_a2 + 1
    }
}
summary(stock_cos_a2)

##Author_3
stock_author_3 <- stock_final %>%
    filter(Author == "drgon (蔡阿飛)")

author_segged_3 <- vector("character", length = length(stock_author_3$Analysis))
for(i in seq_along(stock_author_3$Analysis)){
    segged <- segment(stock_author_3$Analysis[i], seg_no_stopwords)
    author_segged_3[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_a3 <- tibble(number = seq_along(author_segged_3), content = author_segged_3)
q_corpus_a3 <- corpus(df_a3, docid_field = "number", text_field = "content")
q_tokens_a3 <- tokenizers::tokenize_regex(q_corpus_a3, " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_a3 <- vector("character", 100000)
for(i in 1:length(q_tokens_a3)){
    stock_all_a3 <- union(stock_all_a3, q_tokens_a3[[i]])
}


# 製作出dtm
stock_dtm_a3 <- matrix(nrow = length(q_tokens_a3), ncol = length(stock_all_a3))

for(i in 1:length(q_tokens_a3)){
    stock_num <- vector("numeric", length(stock_all_a3))
    temp = q_tokens_a3[[i]]
    for(j in 1:length(stock_all_a3)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_a3[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_a3[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_a3 <- vector("numeric", length(stock_author_3$Analysis)*(length(stock_author_3$Analysis)-1)/2)
stock_index_a3 <- 1

for(i in 1:(length(stock_author_3$Analysis)-1)){
    for(j in (i+1):length(stock_author_3$Analysis)){
        stock_cos_a3[stock_index_a3] <- cos_sim(stock_dtm_a3[i, ], stock_dtm_a3[j,])
        stock_index_a3 <- stock_index_a3 + 1
    }
}
summary(stock_cos_a3)
##Author_4
stock_author_4 <- stock_final %>%
    filter(Author == "hrma (資深象迷)")

author_segged_4 <- vector("character", length = length(stock_author_4$Analysis))
for(i in seq_along(stock_author_4$Analysis)){
    segged <- segment(stock_author_4$Analysis[i], seg_no_stopwords)
    author_segged_4[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_a4 <- tibble(number = seq_along(author_segged_4), content = author_segged_4)
q_corpus_a4 <- corpus(df_a4, docid_field = "number", text_field = "content")
q_tokens_a4 <- tokenizers::tokenize_regex(q_corpus_a4, " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_a4 <- vector("character", 100000)
for(i in 1:length(q_tokens_a4)){
    stock_all_a4 <- union(stock_all_a4, q_tokens_a4[[i]])
}


# 製作出dtm
stock_dtm_a4 <- matrix(nrow = length(q_tokens_a4), ncol = length(stock_all_a4))

for(i in 1:length(q_tokens_a4)){
    stock_num <- vector("numeric", length(stock_all_a4))
    temp = q_tokens_a4[[i]]
    for(j in 1:length(stock_all_a4)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_a4[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_a4[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_a4 <- vector("numeric", length(stock_author_4$Analysis)*(length(stock_author_4$Analysis)-1)/2)
stock_index_a4 <- 1

for(i in 1:(length(stock_author_4$Analysis)-1)){
    for(j in (i+1):length(stock_author_4$Analysis)){
        stock_cos_a4[stock_index_a4] <- cos_sim(stock_dtm_a4[i, ], stock_dtm_a4[j,])
        stock_index_a4 <- stock_index_a4 + 1
    }
}
summary(stock_cos_a4)
##Author_5
stock_author_5 <- stock_final %>%
    filter(Author == "komica (糟糕島)")

author_segged_5 <- vector("character", length = length(stock_author_5$Analysis))
for(i in seq_along(stock_author_5$Analysis)){
    segged <- segment(stock_author_5$Analysis[i], seg_no_stopwords)
    author_segged_5[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_a5 <- tibble(number = seq_along(author_segged_5), content = author_segged_5)
q_corpus_a5 <- corpus(df_a5, docid_field = "number", text_field = "content")
q_tokens_a5 <- tokenizers::tokenize_regex(q_corpus_a5, " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_a5 <- vector("character", 100000)
for(i in 1:length(q_tokens_a5)){
    stock_all_a5 <- union(stock_all_a5, q_tokens_a5[[i]])
}


# 製作出dtm
stock_dtm_a5 <- matrix(nrow = length(q_tokens_a5), ncol = length(stock_all_a5))

for(i in 1:length(q_tokens_a5)){
    stock_num <- vector("numeric", length(stock_all_a5))
    temp = q_tokens_a5[[i]]
    for(j in 1:length(stock_all_a5)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_a5[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_a5[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_a5 <- vector("numeric", length(stock_author_5$Analysis)*(length(stock_author_5$Analysis)-1)/2)
stock_index_a5 <- 1

for(i in 1:(length(stock_author_5$Analysis)-1)){
    for(j in (i+1):length(stock_author_5$Analysis)){
        stock_cos_a5[stock_index_a5] <- cos_sim(stock_dtm_a5[i, ], stock_dtm_a5[j,])
        stock_index_a5 <- stock_index_a5 + 1
    }
}
summary(stock_cos_a5)

##Author6
stock_author_6 <- stock_final %>%
    filter(Author == "mayingnine (個性決定能否投資賺大錢)")

author_segged_6 <- vector("character", length = length(stock_author_6$Analysis))
for(i in seq_along(stock_author_6$Analysis)){
    segged <- segment(stock_author_6$Analysis[i], seg_no_stopwords)
    author_segged_6[i] <- paste0(segged, collapse = " ")
}


#製作dataframe
df_a6 <- tibble(number = seq_along(author_segged_6), content = author_segged_6)
q_corpus_a6 <- corpus(df_a6, docid_field = "number", text_field = "content")
q_tokens_a6 <- tokenizers::tokenize_regex(q_corpus_a6 , " ") %>% tokens()

# 將每篇文章的詞彙取聯集，存入變數"stock_all"
stock_all_a6 <- vector("character", 100000)
for(i in 1:length(q_tokens_a6)){
    stock_all_a6 <- union(stock_all_a6, q_tokens_a6[[i]])
}


# 製作出dtm
stock_dtm_a6 <- matrix(nrow = length(q_tokens_a6), ncol = length(stock_all_a6))

for(i in 1:length(q_tokens_a6)){
    stock_num <- vector("numeric", length(stock_all_a6))
    temp = q_tokens_a6[[i]]
    for(j in 1:length(stock_all_a6)){
        for(k in 1:length(temp)){
            if(temp[k] == stock_all_a6[j]){
                stock_num[j] <- stock_num[j] + 1
            }
        }
    }
    stock_num <- stock_num/sum(stock_num)
    stock_dtm_a6[i, ] <- stock_num
}
#r計算距離和平均值
stock_cos_a6 <- vector("numeric", length(stock_author_6$Analysis)*(length(stock_author_6$Analysis)-1)/2)
stock_index_a6 <- 1

for(i in 1:(length(stock_author_6$Analysis)-1)){
    for(j in (i+1):length(stock_author_6$Analysis)){
        stock_cos_a6[stock_index_a6] <- cos_sim(stock_dtm_a6[i, ], stock_dtm_a6[j,])
        stock_index_a6 <- stock_index_a6 + 1
    }
}
summary(stock_cos_a6)


#察看結果，對應圖1-2
list("Zyldr () 發本相似度" = summary(stock_cos_a1),
     "kksis (流浪人生) 發文相似度" = summary(stock_cos_a2),
     "drgon (蔡阿飛) 發文相似度" = summary(stock_cos_a3),
     "hrma (資深象迷) 發文相似度" = summary(stock_cos_a4),
     "komica (糟糕島) 發文相似度" = summary(stock_cos_a5),
     "mayingnine (個性決定能否投資賺大錢) 發文相似度" = summary(stock_cos_a6))
