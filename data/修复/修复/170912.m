clc;
clear;
%{
该程序的主要目的是对道路交通长时段修复的结果进一步进行单点修复
%}
%%
[~, ~, raw] = xlsread('C:\Users\asus\Desktop\lane.xlsx','Sheet1','A2:I567');   %读取车道关系表
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[2,3,4,9]);
raw = raw(:,[1,5,6,7,8]);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));
VarName1 = data(:,1);
VarName2 = cellVectors(:,1);
VarName3 = cellVectors(:,2);
VarName4 = cellVectors(:,3);
VarName5 = data(:,2);
VarName6 = data(:,3);
VarName7 = data(:,4);
VarName8 = data(:,5);
VarName9 = cellVectors(:,4);
clearvars data raw cellVectors R;
%%

file = dir(['E:\项目\警企江干区\修复工作\stepone\']);  %从第3个开始有数据\
filename = {file.name}';                             %路口名
for i = 1:length(file)                                  %循环路口名
    file1 = dir(['E:\项目\警企江干区\修复工作\stepone\',num2str(filename{i}),'\']);
    filename1 = {file1.name}';  %路口下面的文件名
    str = regexp(filename1,'\d+','match');     %解析出文件名，分别对应：日期、路口、线圈
    for j = 3:length(filename1)   %length(filename1)     %循环文件名
        data1 = xlsread(['E:\项目\警企江干区\修复工作\stepone\',num2str(filename{i}),'\',filename1{j}]);  %读取该路口、某人、某线圈对应的数据
        date = datenum(str{j}{1},'yyyymmdd');   %将日期转为数值型数据
        temp = [];
        for i1 = 736847:736876  % 分别表示日期20170601-20170630
            if date ~= i1 && mod(abs(i1-date),7)==0
                temp = [temp i1];       %找出具有相同星期的日期对应的数值
            end
        end
        
        if ~exist(['E:\项目\警企江干区\修复工作\单点修复\',filename{i}])   %不存在路口名文件夹，则创建
            mkdir(['E:\项目\警企江干区\修复工作\单点修复\',filename{i}]);
        end
        
        for k = 28:88   %修复的主要时段是7:00~22:00
            flag = 0;
            if max(data1(:,1))<30  %判断最大值是否小于30，是的话，该时段不用修复
                flag =1;
                %    xlswrite(['E:\项目\警企江干区\修复工作\单点修复\',filename{i},'\',str{j}{1},'_',str{j}{2},'_',str{j}{3},'.xlsx'],data1);    %将数据写入对应的路口名文件夹下，
                break;                                                                      %同时，跳出循环
            elseif data1(k,1)>=15
                flag =1;
            elseif data1(k,1)<15  %利用相同星期修复
                for i2 = 1:length(temp)
                    if exist(['E:\项目\警企江干区\修复工作\stepone\',num2str(filename{i}),'\',datestr(temp(i2),'yyyymmdd'),'+',str{j}{2},'+',str{j}{3},'.xlsx'])==1
                        data2 = xlsread(['E:\项目\警企江干区\修复工作\stepone\',num2str(filename{i}),'\',datestr(temp(i2),'yyyymmdd'),'+',str{j}{2},'+',str{j}{3},'.xlsx']);
                        if data2(k,1)>15
                            data1(k,1) = data2(k,1);
                            data1(k,2) = data2(k,2);
                            flag = 1;
                            break;
                        end
                    end
                end
            end
            
            if flag==0   %表示利用相同星期没有修复好，此时考虑利用该点上下游时刻点进行修复
                data1(k,1) = data1(k-1,1);
                data1(k,2) = data1(k-1,2);
            end
        end
        xlswrite(['E:\项目\警企江干区\修复工作\单点修复\',filename{i},'\',str{j}{1},'_',str{j}{2},'_',str{j}{3},'.xlsx'],data1);
    end
    pause(1);
end
