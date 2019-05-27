clc;clear;
%{
该程序的主要目的是：对所有的线圈质量进行检测，最终形成3个文档：
线圈数据可用文档说明.txt、线圈数据部分可用说明文档.txt、线圈数据完全不可用文档说明.txt。 
%}
%% Import the data
[~, ~, raw] = xlsread('C:\Users\asus\Desktop\lane.xlsx','Sheet1','A2:I568'); %该文件是所有交叉口对应的车道及其转向关系
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[2,3,4]);
raw = raw(:,[1,5,6,7,8,9]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
VarName1 = data(:,1);
VarName2 = cellVectors(:,1);
VarName3 = cellVectors(:,2);
VarName4 = cellVectors(:,3);
VarName5 = data(:,2);
VarName6 = data(:,3);
VarName7 = data(:,4);
VarName8 = data(:,5);
VarName9 = data(:,6);
%% Clear temporary variables
clearvars data raw cellVectors R;
%%
file = dir('E:\项目\警企江干区\江干区95个路口6月份数据\单车道流量和饱和度\'); %读取文件夹下路口文件
filename={file.name}';
for i =1:length(filename)      %当前所有的路口名文件个数
    file1 = dir(['E:\项目\警企江干区\江干区95个路口6月份数据\单车道流量和饱和度\',filename{i},'\','*.xlsx']); %读取文件夹下全部流量和饱和度文件
    filename1 = {file1.name}';
    for j = 1:length(filename1)
        d = regexp(filename1{j}, '\d+', 'match'); %提取每个文件对应的日期、路口、线圈编号等信息
        m=find(str2num(d{2})==VarName1(:));
        n=[VarName6 VarName7 VarName8 VarName9];
        [m1,m2]=find(n(m,:)==str2num(d{3}));  %在选定的路口中，找出当前线圈所在的位置； m(m1),n(m2)为当前位置线圈的绝对位置；
        %n(m(m1),m2)可以选择当前的线圈编号
        data = xlsread(['E:\项目\警企江干区\江干区95个路口6月份数据\单车道流量和饱和度\',filename{i},'\',filename1{j}]);
        if sum(data(:,1)==0)<=10   %判断线圈数据可靠
            fid = fopen('线圈数据可用文档说明.txt','a');
            fprintf(fid,'%d %s %s %d %s %s\r\n',VarName1(m(m1)),VarName2{m(m1)},VarName4{m(m1)},n(m(m1),m2),d{1},'1');
            fclose(fid);
        elseif(10<sum(data(:,1)==0)) && (sum(data(:,1)==0)<90)     %判断线圈数据部分可用
            fid = fopen('线圈数据部分可用说明文档.txt','a');
            fprintf(fid,'%d %s %s %d %s %s\r\n',VarName1(m(m1)),VarName2{m(m1)},VarName4{m(m1)},n(m(m1),m2),d{1},'2');
            fclose(fid);
        elseif sum(data(:,1)==0)>=90   %判断线圈数据完全不可用
            fid = fopen('线圈数据完全不可用文档说明.txt','a');
            fprintf(fid,'%d %s %s %d %s %s\r\n',VarName1(m(m1)),VarName2{m(m1)},VarName4{m(m1)},n(m(m1),m2),d{1},'3');
            fclose(fid);            
        end
    end
end





