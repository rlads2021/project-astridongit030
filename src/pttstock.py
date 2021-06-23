import urllib.request as req
from bs4 import BeautifulSoup
import pandas as pd
from lxml import etree

all_author = []
all_date = []
all_push = []
all_notpush = []
all_comment = []
all_content = []
all_pic_url = []

file = "2018stock.csv"
df = pd.read_csv(file)

for f in range(0, len(df[['URL']])):
    url = df.loc[f, 'URL']

    requests = req.Request(url, headers={
    "User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36"
    })

    with req.urlopen(requests) as response:
        data = response.read()

    root = BeautifulSoup(data, "html.parser")
    soup = BeautifulSoup(data, "lxml")
    #爬作者
    try:
        author = root.select('span.article-meta-value')[0].text
        all_author.append(author)
    except:
        all_author.append("")
    #爬時間
    try:
        date = root.select('span.article-meta-value')[3].text
        all_date.append(date)
    except:
        all_date.append("")

    #留言數/推噓數
    try:
        comment = root.select('span.hl.push-tag')
        num = len(comment)
        push_num = 0
        not_push = 0
        for push in comment:
            if push.text.strip() == "推":
                push_num += 1
            elif push.text.strip() == "噓":
                not_push += 1
        all_push.append(push_num)
        all_notpush.append(not_push)
        all_comment.append(num) 
    except:
        all_push.append("")
        all_notpush.append("")
        all_comment.append("") 

    #爬內文
    def checkformat(soup, class_tag, index):
        try:
            content = soup.select(class_tag)[index].text
        except:
            content='null'
        return content
    try:
        date = checkformat(soup, '.article-meta-value', 3)
        #content 文章內文
        content = soup.find(id="main-content").text
        target_content = u'※ 發信站: 批踢踢實業坊(ptt.cc),'
        #去除掉 target_content
        content = content.split(target_content)
        #print(content)
        content = content[0].split(date)
        #print(content)
        #去除掉文末 --
        main_content = content[1].replace('--', '').strip()
        #加入內文
        all_content.append(main_content)
    except:
        all_content.append("")
    

    #如果有圖片
    try:
        pic = root.find_all("div", class_="richcontent")
        all_pic = []
        for i in range(0,len(pic)):
            all_pic.append(pic[i].a["href"])
        all_pic_url.append(all_pic)
    except:
        all_pic_url.append("")

    print(f)

df["Author"] = all_author
df["Date"] = all_date
df["Push"] = all_push
df["Not Push"] = all_notpush
df["Comments"] = all_comment
df["Content"] = all_content
df["Pictures URLs"] = all_pic_url
df.to_csv(file,encoding="utf-8-sig",index=False)

print("完成!")