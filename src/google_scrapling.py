from selenium import webdriver
import pandas as pd
from datetime import datetime
from bs4 import BeautifulSoup as Soup
import time
from selenium.webdriver.common.keys import Keys


#輸入要搜尋的字
what_search = input()
#使用相對位置執行webdriver
driver = webdriver.Chrome(".\..\chromedriver")
driver.get("https://www.google.com/maps")
search = driver.find_element_by_class_name("tactile-searchbox-input")
search.send_keys(f'{what_search}')
enter = driver.find_element_by_id("searchbox-searchbutton")
enter.click()

wait = 3

#一頁是20個結果，依照xpath，range為(1,39,2)
for h in range(1, 10, 2):
    reviewer_name = []
    reviews_num = []
    reviewer_stars = []
    review_date = []
    review_content = []

    #當爬完前五個才每次向下滾動到底，顯示第一頁的20個結果
    if h > 5:
        time.sleep(5)
        pane = driver.find_element_by_xpath('//*[@id="pane"]/div/div[1]/div/div/div[4]/div[1]')
        for i in range(0, 5):
            time.sleep(1)
            driver.execute_script("arguments[0].scrollTop = arguments[0].scrollHeight", pane)

    #點進搜尋結果
    time.sleep(3)
    find_ = driver.find_element_by_xpath(f'//*[@id="pane"]/div/div[1]/div/div/div[4]/div[1]/div[{h}]/div/a')
    find_.click()

    #得到標題作為檔名
    time.sleep(3)
    title = driver.find_element_by_xpath('//*[@id="pane"]/div/div[1]/div/div/div[2]/div[1]/div[1]/div[1]/h1').text
    if len(title) > 10: 
        title = title[0:11]

    #點進所有評論
    time.sleep(wait)
    driver.find_element_by_class_name("widget-pane-link").click()

    #獲得總評論數量，決定到底要滾輪滾幾次
    time.sleep(wait)
    reviewsnum = driver.find_element_by_xpath('//*[@id="pane"]/div/div[1]/div/div/div[2]/div[2]/div/div[2]/div[2]').text.rstrip(' 篇評論')
    try:
        reviewsnum = int(reviewsnum)
    except:
        reviewsnum = int(reviewsnum.replace(',', ''))
    
    #嘗試過瀏覽器的滾輪極限是115次，可自己改
    if reviewsnum > 1000:
        scroll_num = 10
    elif 1000 > reviewsnum > 500:
        scroll_num = 5
    else:
        scroll_num = 5

    #向下捲動，開始爬蟲
    pane = driver.find_element_by_xpath('//*[@id="pane"]/div/div[1]/div/div/div[2]')
    for i in range(0, scroll_num):
        time.sleep(1)
        driver.execute_script("arguments[0].scrollTop = arguments[0].scrollHeight", pane)

    # 獲得網頁原始碼
    time.sleep(wait)
    soup = Soup(driver.page_source, "lxml")
    all_reviews = soup.find_all(class_='ODSEW-ShBeI NIyLF-haAclf gm2-body-2')

    for i in range(0, len(all_reviews)):
        # 評論者名稱
        try:
            name = all_reviews[i].find(class_="ODSEW-ShBeI-title").text
            name = name.strip(" ")
            reviewer_name.append(name)
        except:
            reviewer_name.append("N/A")

        # 評論者的評論數
        try:
            reviews = all_reviews[i].find(class_="ODSEW-ShBeI-VdSJob").text
            reviews = reviews.strip(" ").strip("在地嚮導")
            reviews_num.append(reviews)
        except:
            reviews_num.append("N/A")

        # 評論星數
        try:
            stars = str(all_reviews[i].find(class_="ODSEW-ShBeI-H1e3jb").get('aria-label').strip().strip("顆星"))
            reviewer_stars.append(stars)
        except:
            reviewer_stars.append("N/A")

        # 評論時間
        try:
            date = all_reviews[i].find(class_ = "ODSEW-ShBeI-RgZmSc-date").text
            date = date.strip(" ")
            review_date.append(date)
        except:
            review_date.append("N/A")

        # 評論內容
        try:
            text = all_reviews[i].find(class_ = "ODSEW-ShBeI-text").text
            text = text.strip(" ")
            review_content.append(text)
        except:
            review_content.append("N/A")  

    #做成dataframe後輸出
    allstuff = pd.DataFrame()
    allstuff["reviewer_name"] = reviewer_name
    allstuff["reviews_num"] = reviews_num
    allstuff["reviewer_stars"] = reviewer_stars
    allstuff["review_date"] = review_date
    allstuff["review_content"] = review_content

    allstuff.to_csv(f'{title}.csv',encoding="utf-8-sig")


    #返回店家主頁
    driver.find_element_by_class_name('hWERUb').click()
    time.sleep(3)
    #返回搜尋結果
    driver.find_element_by_class_name('omnibox-pane-container').click()  

print("爬蟲完畢!")




