import pandas as pd
import output, PL_parse
import os

fix_filename = 'Invalid'


def lazy_fix(filename, Int, detector, date, freq, pattern, flag=True):
    global fix_filename
    df = pd.read_csv(filename, header=0)
    # print(filename)
    len_zero = len(df[df.iloc[:, 0] < 0.0001])
    # print(len_zero)
    if len_zero <= 0.1 * len(df):
        return 'Valid'
    elif len_zero <= 0.9 * len(df):
        return 'Partially Valid'
    else:
        if flag:
            fix_filename = fix(Int, detector, date, freq, pattern)
        # print(fix_filename)
        if fix_filename[0] == '0':
            return '0 Fix Fail'
        return 'Invalid {}'.format(fix_filename)


def fix(Int, detector, date, freq, pattern):
    before_date = (pd.to_datetime(date) - pd.to_timedelta('7 days')).strftime('%Y-%m-%d')
    after_date = (pd.to_datetime(date) + pd.to_timedelta('7 days')).strftime('%Y-%m-%d')
    try:
        fix_file_path = './output_2/{}/{}/{}-{}-{}.csv'.format(freq, pattern, Int, before_date, detector)
        if not os.path.isfile(fix_file_path):
            PL_parse.lazy_parse(Int, detector, before_date, freq, pattern)
        if lazy_fix(fix_file_path, Int, detector, before_date, freq, pattern, flag=False)[0] == 'I':
            raise FileNotFoundError
        return fix_file_path
    except FileNotFoundError:
        try:
            fix_file_path = './output_2/{}/{}/{}-{}-{}.csv'.format(freq, pattern, Int, after_date, detector)
            print(fix_file_path)
            if not os.path.isfile(fix_file_path):
                PL_parse.lazy_parse(Int, detector, after_date, freq, pattern)
            if lazy_fix(fix_file_path, Int, detector, after_date, freq, pattern, flag=False)[0] == 'I':
                raise FileNotFoundError
            return fix_file_path
        except FileNotFoundError:
            try:
                # file_dir_path = './output_2/{}/{}/'.format(freq, pattern)
                # for i in os.listdir(file_dir_path):
                #     fix_file_path=file_dir_path+i
                #     if '{}-{}'.format(Int, date) in i and '{}-{}-{}'.format(Int, date, detector) not in i:
                #         return fix_file_path
                # else:
                #     return '0 Fix Fail'
                lane = pd.read_csv('lane.csv', header=0)
                straight_way_df = lane[
                    (lane.iloc[:, 3] == '南直') & (lane.iloc[:, 3] == '北直') & (lane.iloc[:, 3] == '西直') & (lane.iloc[:,
                                                                                                         3] == '东直') & (
                            lane.iloc[:, 4] != 0)]

                use_df = straight_way_df[straight_way_df[:, 0] == Int]
                detector_count = use_df[use_df[:, 0] == Int].iloc[0, 4]
                file_dir_path = './output_2/{}/{}/'.format(freq, pattern)
                for d in detector_count:
                    fix_file_path = file_dir_path + '{}-{}-{}.csv'.format(Int, date, detector)
                    if os.path.isfile(fix_file_path):
                        return fix_file_path
                else:
                    return '0 Fix Fail'
            except:
                return '0 Fix Fail'
