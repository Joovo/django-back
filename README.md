计算 H 市上城区一段时间内每天交叉口，车道交通流量和饱和度信息的Django后端代码。

项目地址：http://106.14.148.118:8000

# 主要页面：

3个静态页面，index1/,index2/,pic/.

7个请求，index1,index2,download,submit,fix,fix_download,pic.

# 文件说明：

## 1.output.py

计算配置表即程序1。

## 2.PL_parse.py 

计算交叉口、日期、车道、频率、模式下的饱和度和流量即程序2。

## 3.fix_data.py

检测数据是否有效及修复过程。

# 文件夹说明：

output_1 :保存程序一输出。

output_2 :保存程序二输出，避免多次运算。

data: 保存原始数据及配置表信息等。

------------------------------

2019.5.26 添加了绘图功能，使用pyecharts库的demo。
