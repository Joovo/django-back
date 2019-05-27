import re
import pandas as pd
from datetime import datetime, timedelta
from time import time
import os
from os import path


def choose_txt(INT, txt_name, all_data):
    try:
        t1 = time()
        txt_path = './data/11月下城战略运行记录文件/' + INT + '/' + txt_name
        # XC_SM_20181101.txt
        end_date = txt_name[-12:-4]
        data = open(txt_path, 'r', encoding='utf-8').readlines()

        # 读取配置表
        configue_path = './data/配置表/' + INT + '.xlsx'
        configue_df = pd.read_excel(configue_path, header=0)

        # 去除前2行
        data = data[2:]
        # 计算data里的文本周期 T
        for i in range(1, len(data)):
            if data[i][:3] == data[0][:3]:
                T = i
                break
        # 第一个'00'出现的字符位置
        idx = data[0].find('00')
        # 处理每个文本周期 T ，起始 i，末尾 j
        weekday_dir = {0: 'Monday', 1: 'Tuesday', 2: 'Wednesday', 3: 'Thursday', 4: 'Friday', 5: 'Saturday', 6: 'Sunday'}
        for i in range(0, len(data) - 1):
            if data[i][:3]!=data[0][:3]:
                continue
            j = i + T
            if data[i][idx + 38] == '+':
                # 周期时长
                Length_Cycle = int(data[i][idx + 33:idx + 37]) + int(data[i][idx + 39])
            else:
                Length_Cycle = int(data[i][idx + 33:idx + 37]) - int(data[i][idx + 39])
            # PL 字段
            PL = data[i][idx + 17:idx + 21]
            # 周期结束时间
            _EndTime_Cycle = pd.to_datetime(end_date + ' ' + data[i][idx:idx + 5]).strftime('%Y-%m-%d %H:%M:%S')
            EndTime_Cycle = _EndTime_Cycle[-8:]
            # 周期开始时间
            _StartTime_Cycle = (pd.to_datetime(_EndTime_Cycle) - timedelta(seconds=int(Length_Cycle))).strftime(
                '%Y-%m-%d %H:%M:%S')
            StartTime_Cycle = _StartTime_Cycle[-8:]
            date = _StartTime_Cycle[:10]
            week_day = weekday_dir[pd.to_datetime(date).weekday()]

            # 读取绿信比
            last_line = data[j - 1]
            _Phase_List = [int(_) for _ in re.findall('\d+', last_line)]
            Phase_List = []
            for x in _Phase_List:
                Phase_List.append(round(x * Length_Cycle / 100.0) if x != 1 else 0)
                # Phase_List.append(x * Length_Cycle / sum(_Phase_List))
            temp_data = []
            configue_index = 0
            for each in range(i + 2, j - 1):
                line = data[each]

                if line[6] == 'L':
                    continue

                # 交叉口
                Int = int(line[2:5])
                # 通道
                S = int(line[8:11])
                # 相位
                Phase = line[16:18].strip()
                # 周期时长
                Length_Phase = int(line[20:22])

                if Phase[0] == 'A':
                    StartTime_Phase = StartTime_Cycle
                else:
                    StartTime_Phase = pd.to_datetime(StartTime_Cycle) + timedelta(
                        seconds=sum(Phase_List[:ord(Phase[0]) - ord('A')]))
                    StartTime_Phase = StartTime_Phase.strftime('%H:%M:%S')
                # temp_data 临时保存这个周期T下的若干行数据，为了和配置表的产生顺序相一致，后面要排序再加入all_data

                try:
                    # DS1 饱和度
                    DS1 = int(line[25:27])
                    # VO1 ActualVolumn
                    VO1 = int(line[29:31])
                    # 车道编号
                    DetectorID1 = int(configue_df.iloc[configue_index, 2:].values[0])
                    # 写入文件
                    temp_data.append([Int, S, DetectorID1, StartTime_Cycle, StartTime_Phase, EndTime_Cycle, \
                                      Phase, Length_Phase, Length_Cycle, DS1, VO1, date, week_day, PL])
                except:
                    pass

                try:
                    # DS2
                    DS2 = int(line[38:40])
                    # VO2
                    VO2 = int(line[42:44])
                    # 车道编号
                    DetectorID2 = int(configue_df.iloc[configue_index, 2:].values[1])
                    temp_data.append([Int, S, DetectorID2, StartTime_Cycle, StartTime_Phase, EndTime_Cycle, \
                                      Phase, Length_Phase, Length_Cycle, DS2, VO2, date, week_day, PL])
                except:
                    pass

                try:
                    # DS3
                    DS3 = int(line[51:53])
                    # VO3
                    VO3 = int(line[55:57])
                    # 车道编号
                    DetectorID3 = int(configue_df.iloc[configue_index, 2:].values[2])
                    temp_data.append([Int, S, DetectorID3, StartTime_Cycle, StartTime_Phase, EndTime_Cycle, \
                                      Phase, Length_Phase, Length_Cycle, DS3, VO3, date, week_day, PL])
                except:
                    pass

                try:
                    # DS4
                    DS4 = int(line[64:66])
                    # VO4
                    VO4 = int(line[68:70])
                    # 车道编号
                    DetectorID4 = int(configue_df.iloc[configue_index, 2:].values[3])
                    temp_data.append([Int, S, DetectorID4, StartTime_Cycle, StartTime_Phase, EndTime_Cycle, \
                                      Phase, Length_Phase, Length_Cycle, DS4, VO4, date, week_day, PL])
                except:
                    pass
                # 按照配置表对temp的数据排序
                configue_index += 1
            # rule = configue_df['涉及相位'].values
            # rule = dict(zip(rule, range(len(rule))))
            # temp_data.sort(key=lambda x: rule[x[6]])
            all_data.extend(temp_data)

        t2 = time()
        print(t2 - t1)
    except:
        print(i,T,idx)
        print(idx+38)


def choose_Int(INT='157'):
    all_data = []
    txt_files = os.listdir('./data/11月下城战略运行记录文件/' + INT)
    txt_files.sort()
    for txt_name in txt_files:
        txt_path = './data/11月下城战略运行记录文件/' + INT + txt_name
        # XC_SM_20181101.txt
        print(txt_name)
        choose_txt(INT, txt_name, all_data)
    _columns = ['Int', 'SA', 'DetectorID', 'StartTime_Cycle', 'StartTime_Phase', 'EndTime_Cycle', 'Phase',
                'Length_Phase', 'Length_Cycle', 'DS', 'ActualVolume', 'date', 'weekday', 'PL']
    df = pd.DataFrame(columns=_columns, data=all_data)
    os.makedirs(name='output_1', exist_ok='True')
    df_path = './output_1/{}.csv'.format(INT)
    df.to_csv(df_path, index=False)
    return df_path


if __name__ == '__main__':
    choose_Int('157')
