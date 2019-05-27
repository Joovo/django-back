clc;
clear;
%{
思路：该程序的主要目的是对实时数据的异常数据进行判别
异常数据的判别方法：主要判断7:00-22:00，出现数据为0的情况，如果出现即为异常数据；
%}
path1 = 'E:\项目\交通小脑\168路口';
% file = dir('E:\项目\警企江干区\江干区95个路口6月份数据\实时数据流量和饱和度\'); %读取文件夹下路口文件
% filename={file.name}';
% for i =1:length(filename) %路口文件
%     file1 = dir(['E:\项目\警企江干区\江干区95个路口6月份数据\实时数据流量和饱和度\',filename{i},'\','*.xlsx']); %读取文件夹下全部流量和饱和度文件
file1 = dir([path1,'\','*.xlsx']);   
filename1 = {file1.name}';
    for j = 1:length(filename1)   %每个路口文件夹下，对应的各个文件
        str = regexp(filename1{j}, '\d+', 'match'); %提取每个文件对应的日期、路口、现券编号信息
%         m=find(str2num(str{2})==VarName1(:));
%         n=[VarName6 VarName7 VarName8 VarName9];
%         [m1,m2]=find(n(m,:)==str2num(str{3}));  %在选定的路口中，找出当前线圈所在的位置； m(m1),n(m2)为当前位置线圈的绝对位置；
%         %n(m(m1),m2)可以选择当前的线圈编号
        data1 = xlsread([path1,'\',filename1{j}]);      
        %修复的主要时段是7:00~22:00
        if max(data1(28:88,1))<=30         
            fid = fopen([path1,'\','non_need_repair.txt'],'a');
            fprintf(fid, '%s %s %s\r\n',str{1:3});
            fclose(fid);
            continue;
        elseif min(data1(28:88,1))>=15         
            fid = fopen([path1,'\','non_need_repair.txt'],'a');
            fprintf(fid, '%s %s %s\r\n',str{1:3});
            fclose(fid);
            continue;
        else
            fid = fopen([path1,'\','need_repair.txt'],'a');
            fprintf(fid, '%s %s %s\r\n',str{1:3});
            fclose(fid);
            continue;
        end
    end
% end
