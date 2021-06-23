import urllib.request as req
from bs4 import BeautifulSoup
import pandas as pd

#股版標題&網址爬蟲，多頁

title_all = []
url_all = []
#635,5011 total
#635(含)-1702(含) 2018
#1703(含)-2591(含) 2019
#2592(含)-4061(含) 2020
#4062(含)-5011(含) 2021

#5011-4500
#4500-4061
#4061-3500
#3500-3000
#3000-2591
#2591-2000
#2000-1702
#1702-1000
#1000-634
for page in range(1000,634,-1):

    url = f"https://www.ptt.cc/bbs/Stock/index{page}.html"

    requests = req.Request(url, headers={
    "User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36"
    })

    with req.urlopen(requests) as response:
        data = response.read()

    root = BeautifulSoup(data, "html.parser")
    titles = root.find_all("div", class_="title")

    #爬標題跟網址
    for title in titles:
        try:
            if title.a != None:
                if "標的" in title.a.string and "R" not in title.a.string:
                    title_all.append(title.a.string)
                    url_all.append("https://www.ptt.cc"+title.a["href"])
        except:
            pass

#分批爬蟲不然電腦會當機
all_stock = pd.DataFrame()
all_stock["title"] = title_all
all_stock["URL"] = url_all
all_stock.to_csv('stock.csv',encoding="utf-8-sig")


df = pd.read_csv("stock.csv")
new = pd.DataFrame({
    "title":title_all,
    "URL":url_all
})
df = df.append(new)
df.to_csv('stock.csv',encoding="utf-8-sig",index=False)

print("完成!")