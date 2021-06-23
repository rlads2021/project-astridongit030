# coding=utf-8
import pandas as pd

file = "clean2018.csv"
df = pd.read_csv(file)

#空格
df['Content'] = df['Content'].str.replace(" ",'')
#換行
df['Content'] = df['Content'].str.replace("\n",'')


# 內文冒號一致:
df["Content"] = df["Content"].str.replace(":","：")

#拆內文
new = df['Content'].str.extract('(1.標的：.+)(2.分類：.+)(3.分析/正文：.+)(4.進退場機制：.+)',expand=False)

df["標的"] = new[0]
df["分類"] = new[1]
df["內文"] = new[2]
df["進退場機制"] = new[3]

new2 = df['Content'].str.extract('(1.標的：.+)(2.分類：.+)(3.分析/正文：.+)',expand=False)

df["標的"] = new2[0]
df["分類"] = new2[1]
df["內文"] = new2[2]


#刪除標題字
df["標的"] = df["標的"].str.replace("1.標的：","")
df["分類"] = df["分類"].str.replace("2.分類：","")
df["內文"] = df["內文"].str.replace("3.分析/正文：","")
df["進退場機制"] = df["進退場機制"].str.replace("4.進退場機制：","")
df["進退場機制"] = df["進退場機制"].str.replace("(非長期投資者，必須有停損機制)","")
df["進退場機制"] = df["進退場機制"].str.replace("\(\)","")
df["內文"] = df["內文"].str.replace("(4.進退場機制：.+)","")

#轉換日期
df["Date"] = pd.to_datetime(df["Date"],format="%a %b %d %H:%M:%S %Y")

#清掉picture url 的中括號
df["Pictures URLs"] = df["Pictures URLs"].str.replace("\[\]","")
df["Pictures URLs"] = df["Pictures URLs"].str.replace("\[","")
df["Pictures URLs"] = df["Pictures URLs"].str.replace("\]","")


# #多空請益心得刪掉
df["分類"] = df["分類"].str.replace("多/空/請益/心得","")

#清除空格
df['標的'] = df['標的'].str.replace(" ",'')

#拆標的
#數字
new3 = df['標的'].str.extract('([0-9]{4})',expand=False)
df["標的數字"] = new3
#中文
new4 = df['標的'].str.extract('([\u4e00-\u9fa5]{2,3})',expand=False)
df["標的中文"] = new4

# # 有長嗎
new5 = df['分類'].str.extract('(長)',expand=False)
df["有長嗎"] = new5

# # 有短嗎
new6 = df['分類'].str.extract('(短)',expand=False)
df["有短嗎"] = new6

# # 有多嗎
new7 = df['分類'].str.extract('(多)',expand=False)
df["有多嗎"] = new7

# # 有空嗎
new8 = df['分類'].str.extract('(空)',expand=False)
df["有空嗎"] = new8

# #進退場機制#長
f = df['進退場機制'].str.extract('(長線|長期投資|長期|不停利|不停損)',expand=False)
df["長線"] = f


# #進退場機制#短
d = df['進退場機制'].str.extract('(短線|放空|停利|停損)',expand=False)
df["短線"] = d


# #進退場機制#退場、出場
f = df['進退場機制'].str.extract('(退場|出場|放空)',expand=False)
df["退場出場"] = f

# #進退場機制#長投、放
s = df['進退場機制'].str.extract('(長投|放)',expand=False)
df["長投/放"] = s

#把請益、心得刪掉
df = df[ ~ df['分類'].str.contains('請益')]
df = df[ ~ df['分類'].str.contains('心得')]

df.to_csv(file,encoding="utf-8-sig",index=False)

