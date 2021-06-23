# 原始碼說明文件  

### 1.爬蟲 
 + title&url.py - 使用python從PTT的標題頁面爬取標題以及網址
 + pttstock.py - 從PTT的標題頁面爬取作者、URL、日期、推數、噓數、留言數、內文以及圖片網址
 + 2018stock.csv、2019stock.csv、2020stock.csv、2021stock.csv 資料原始檔

### 2.資料清洗   
 + cleanr.Rmd - R部分
 + cleanpy.py - python 部分
 + unify.Rmd - 統整
 + finalclean2018.csv、finalclean2019.csv、finalclean2020.csv、finalclean2021.csv 清洗完成的原始檔
 + finalclean_all.csv 合併檔

### 3.資料分析
 + return.rmd 計算報酬率、敏感度分析
 + statistics.rmd 計算簡易敘述型統計、作者排名、績效與留言數、績效與推&噓、績效與有無附圖
 + Sent_related_graph.r 計算績效與情緒分數、股價與情緒分數
 + frequency.rmd 詞頻表、Topic Modeling
 + wordcloud.r 文字雲
 + hot_5_stock.r 前五大熱門股票相似度
 + head_six_author.r 前六多發文作者相似度
 + 1-55stock_price.csv、56-100stock_price.csv、101-150stock_price.csv、151-200stock_price.csv 標的被發文數前200名的股票的2018-2021.06.01股價
 + Sensitivity_long.csv 長線敏感度分析的報酬率
 + Sensitivity_short.csv 短線敏感度分析的報酬率
 + stock_return 以長線250天、短線5天所做的報酬率及情緒分數(sent1:用詞強烈程度/sent2:情緒正向/負向程度)
 + stopwords、股票斷詞 內含金融專有名詞的斷詞辭典
 
 ### 4.其他  
  + google_scraping.py 原本計畫要爬一家店的所有標的，受限於本地瀏覽器載入限制無法載入所有的評論故放棄的前專案嘗試

