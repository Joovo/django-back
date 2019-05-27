%{
说明：该程序的主要目的是对170918.m检查到的异常数据进行修复。
异常数据的修复方法：1.利用相同星期的数据进行修复；2.利用模板进行修复
%}
clc;
clear;
%首先利用完好的数据记录修复有问题的数据。
filename1 = 'E:\项目\警企江干区\实时数据修复工作\non_need_repair.txt';
filename2 = 'E:\项目\警企江干区\实时数据修复工作\need_repair.txt';
fid1=fopen(filename1);
k1=1;
while ~feof(fid1)
    tline = fgetl(fid1);
    if ~ischar(tline)
        break;
    end
    s1{k1} = tline;
    k1 = k1+1;
end
fclose(fid1);
s1=s1';
s1=regexp(s1,' ','split');

fid2=fopen(filename2);
k1=1;
while ~feof(fid2)
    tline = fgetl(fid2);
    if ~ischar(tline)
        break;
    end
    s2{k1} = tline;
    k1 = k1+1;
end
fclose(fid2);
s2=s2';
s2=regexp(s2,' ','split');

for i1 = 1:length(s2)
    veh = [];
    for i2 = 736847:736876
        if mod(i3-datenum(s2{i2}{1},'yyyymmdd'),7)==0 && i2-datenum(s2{i2}{1},'yyyymmdd')~=0
            veh =[veh i2];
        end
    end
    data2=xlsread(['E:\项目\警企江干区\实时数据修复工作\',s2{i1}{1},'+',s2{i1}{2},'+',s2{i1}{3},'.xlsx']);%读取需要修复的记录
    flag = 0;
    for j1=1:length(s1)
        a =find((veh==datenum(s1{j1}{1},'yyyymmdd'))==1);  %判断是否具有相同星期
        if (~isempty(a)) && strcmp(s2{i1}{2},s1{j1}{2}) && strcmp(s2{i1}{3},s1{j1}{3})  %是否具有相同星期、路口编号、线圈编号
            data1=xlsread(['E:\项目\警企江干区\\实时数据修复工作\',s1{i1}{1},'\',datestr(veh(a),'yyyymmdd'),...
                '_',s1{i1}{2},'_',s1{i1}{3},'.xlsx']);    %读取正常数据
            for i2 = 28:88
                if data2(i2)<15
                    data(i2,:) = data1(i2,:);
                end
            end
            xlswrite(['E:\项目\警企江干区\实时数据修复工作\',s2{i1}{1},'\',s2{i1}{1},'_',s2{i1}{2},'_',s2{i}{3},'.xlsx'],data2);
        else
            %%%利用模板进行修复
            a =find((veh==datenum(s1{j1}{1},'yyyymmdd'))==1);  %判断是否具有相同星期
            if (~isempty(a)) && strcmp(s2{i1}{2},s1{j1}{2}) && strcmp(s2{i1}{3},s1{j1}{3})  %是否具有相同星期、路口编号、线圈编号
                data1=xlsread(['E:\项目\警企江干区\修复工作\单点修复\',s1{i1}{1},'\',datestr(veh(a),'yyyymmdd'),'_',s1{i1}{2},'_',s1{i1}{3},'.xlsx']);    %读取正常数据
                for i2 = 28:88
                    if data2(i2)<15
                        data(i2,:) = data1(i2,:);
                    end
                end
                xlswrite(['E:\项目\警企江干区\实时数据修复工作\',s2{i1}{1},'\',s2{i1}{1},'_',s2{i1}{2},'_',s2{i}{3},'.xlsx'],data2);
            end
        end
    end
end
