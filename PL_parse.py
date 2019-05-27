'''
DS 饱和度求平均
AV 流量求和
根据DetectorID分类，频率为freq,计算流量AV,饱和度DS,和这段freq内的PL
'''
import numpy as np
import pandas as pd
from pandas import to_datetime
import os


def parse(Int='157', date='2018-11-01', freq='15min'):
    file_path = './output_1/{}.csv'.format(Int)
    output_df = pd.read_csv(file_path, header=0)

    # 15min
    time_list = [str(x)[-8:] for x in pd.timedelta_range(start='00:00:00', end='24:00:00', freq=freq)]
    # date_list=[str(x)[:10] for x in pd.date_range(start='20181101',end='20181130',freq='1d')]
    # 最后一个时间节点为00:00:00 需要注意

    DetectorID_list = list(set(output_df['DetectorID']))

    # 依次遍历 time_list 用pd的语法直接计算
    for detector in DetectorID_list:
        print(detector)
        detector_df = output_df[(output_df['DetectorID'] == detector) & (output_df['date'] == date)]
        data = []
        for i in range(len(time_list) - 1):
            start_node = time_list[i]
            end_node = time_list[i + 1]
            if i != len(time_list) - 2:
                temp_df = detector_df[(to_datetime(start_node) <= to_datetime(detector_df['StartTime_Cycle'])) \
                                      & (to_datetime(detector_df['StartTime_Cycle']) <= to_datetime(end_node))]
                # 最后一个节点特殊比较
            else:
                temp_df = detector_df[(to_datetime(start_node) <= to_datetime(detector_df['StartTime_Cycle']))]
            AV = sum(temp_df['ActualVolume'])
            DS = np.average(temp_df['DS'])
            PL = set()
            for _pl in temp_df['PL']:
                PL.add(_pl)
            data.append([AV, DS, PL])
        save_df = pd.DataFrame(data=data, columns=['DS', 'AV', 'PL'])
        os.makedirs(exist_ok=True, name='./output_2/{}/temp/'.format(freq))
        save_df.to_csv('./output_2/{}/temp/{}-{}-{}.csv'.format(freq, Int, date, detector), index=False)


def lazy_parse(Int, detector, date, freq, pattern):
    file_path = './output_2/{}/temp/{}-{}-{}.csv'.format(freq, Int, date, detector)
    if not os.path.isfile(file_path):
        parse(Int, date, freq)

    df = pd.read_csv(file_path, header=0)
    # 1:DS+AV
    # 2:DS+AV+PL
    # 3:PL
    if pattern == '1':
        pattern_df = df.iloc[:, :2]
    elif pattern == '2':
        pattern_df = df
    else:
        pattern_df = df.iloc[:, 2]
    pattern_df_path = './output_2/{}/{}/{}-{}-{}.csv'.format(freq, pattern, Int, date, detector)
    if not os.path.isfile((pattern_df_path)):
        os.makedirs(exist_ok=True, name='./output_2/{}/{}/'.format(freq, pattern))
        pattern_df.to_csv(pattern_df_path, index=False)
    return pattern_df_path
