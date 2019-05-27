clc;
clear;
filename1 = 'E:\项目\警企江干区\修复工作\线圈数据可用文档说明.txt';
filename2 = 'C:\Users\asus\Desktop\SCATS小规模运行记录\SCATS小规模运行记录\线圈数据部分可用说明文档.txt';
filename3 = 'C:\Users\asus\Desktop\SCATS小规模运行记录\SCATS小规模运行记录\线圈数据完全不可用文档说明.txt';
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

fid3=fopen(filename3);
k1=1;
while ~feof(fid3)
    tline = fgetl(fid3);
    if ~ischar(tline)
        break;
    end
    s3{k1} = tline;
    k1 = k1+1;
end
fclose(fid3);
s3=s3';
s3=regexp(s3,' ','split');

%对于部分数据可用线圈进行修复
for i = 1:length(s2)
    veh = [];
    for i3 = 736847:736876  %日期2017.06.01-2017.06.30
        if mod(i3-datenum(s2{i}{5},'yyyymmdd'),7)==0 && i3-datenum(s2{i}{5},'yyyymmdd')~=0  %利用相同星期进行修复
            veh =[veh i3];
        end
    end
    
    %修复方法1：通过相同路口编号、相同线圈编号、相同星期的数据进行修复
    flag = 0;
    for j1=1:length(s1)
        a =find((veh==datenum(s1{j1}{5},'yyyymmdd'))==1);  %判断是否具有相同星期
        if (~isempty(a)) && strcmp(s2{i}{1},s1{j1}{1}) && strcmp(s2{i}{4},s1{j1}{4})  %是否具有相同星期、路口编号、线圈编号
            data=xlsread(['E:\项目\警企江干区\江干区95个路口6月份数据\单车道流量和饱和度\',s2{i}{1},'\',datestr(veh(a),'yyyymmdd'),...
                '+',s2{i}{1},'+',s2{i}{4},'.xlsx']);
            xlswrite(['E:\项目\警企江干区\修复工作1\',s2{i}{5},'+',s2{i}{1},'+',s2{i}{4},'.xlsx'],data);
            fid = fopen('E:\项目\警企江干区\修复工作1\repair.txt','a');
            fprintf(fid, '%s %s %s %s %s %s\r\n',s2{i}{1:6});
            fclose(fid);
            flag = 1;
        elseif strcmp(s2{i}{1},s1{j1}{1}) && strcmp(s2{i}{3},s1{j1}{3}) && strcmp(s2{i}{5},s1{j1}{5})
            %修复方法2：通过相同路口编号、相同行车方向的线圈、相同日期的数据进行修复
            data = xlsread(['E:\项目\警企江干区\江干区95个路口6月份数据\单车道流量和饱和度\',s2{i}{1},'\',s2{i}{5},'+',...
                s2{i}{1},'+',s1{j1}{4}]);
            xlswrite(['E:\项目\警企江干区\修复工作1\',s2{i}{5},'+',s2{i}{1},'+',s2{i}{4},'.xlsx'],data);
            fid = fopen('E:\项目\警企江干区\修复工作1\repair.txt','a');
            fprintf(fid, '%s %s %s %s %s %s\r\n',s2{i}{1:6});
            fclose(fid);
            flag = 1;
        else
            continue;
        end
        
        if flag ==1
            break;
        end
    end
    if mod(i,300)==0
        pause(1);
    end
    if flag==1
        continue;
    else
        %修复方法1和2无法进行修复时，会记录下无法修复的数据信息
        fid = fopen(['E:\项目\警企江干区\修复工作1\','unrepair.txt'],'a');
        fprintf(fid, '%s %s %s %s %s %s\r\n',s2{i}{1:6});
        fclose(fid);
    end
end


%对于完全不可用数据可用线圈进行修复
for i = 1:length(s3)
    veh = [];
    for i3 = 736847:736876
        if mod(i3-datenum(s3{i}{5},'yyyymmdd'),7)==0 && i3-datenum(s3{i}{5},'yyyymmdd')~=0  %利用相同星期进行修复
            veh =[veh i3];
        end
    end
    
    %修复方法1：通过相同路口编号、相同线圈编号、相同星期的数据进行修复
    flag = 0;
    for j1=1:length(s1)
        a =find((veh==datenum(s1{j1}{5},'yyyymmdd'))==1);  %判断是否具有相同星期
        if (~isempty(a)) && strcmp(s3{i}{1},s1{j1}{1}) && strcmp(s3{i}{4},s1{j1}{4})  %是否具有相同星期、路口编号、线圈编号
            data=xlsread(['E:\项目\警企江干区\江干区95个路口6月份数据\单车道流量和饱和度\',s3{i}{1},'\',datestr(veh(a),'yyyymmdd'),...
                '+',s3{i}{1},'+',s3{i}{4},'.xlsx']);
            xlswrite(['E:\项目\警企江干区\修复工作1\',s3{i}{5},'+',s3{i}{1},'+',s3{i}{4},'.xlsx'],data);
            fid = fopen('E:\项目\警企江干区\修复工作1\repair.txt','a');
            fprintf(fid, '%s %s %s %s %s %s\r\n',s3{i}{1:6});
            fclose(fid);
            flag = 1;
        elseif strcmp(s2{i}{1},s1{j1}{1}) && strcmp(s3{i}{3},s1{j1}{3}) && strcmp(s3{i}{5},s1{j1}{5})
            %修复方法2：通过相同路口编号、相同行车方向的线圈、相同日期的数据进行修复
            data = xlsread(['E:\项目\警企江干区\江干区95个路口6月份数据\单车道流量和饱和度\',s3{i}{1},'\',s3{i}{5},'+',...
                s3{i}{1},'+',s1{j1}{4}]);
            xlswrite(['E:\项目\警企江干区\修复工作1\',s3{i}{5},'+',s3{i}{1},'+',s3{i}{4},'.xlsx'],data);
            fid = fopen('E:\项目\警企江干区\修复工作1\repair.txt','a');
            fprintf(fid, '%s %s %s %s %s %s\r\n',s3{i}{1:6});
            fclose(fid);
            flag = 1;
        else
            continue;
        end
        
        if flag ==1
            break;
        end
    end
    if mod(i,300)==0
        pause(1);
    end
    if flag==1
        continue;
    else
        %修复方法1和2无法进行修复时，会记录下无法修复的数据信息
        fid = fopen(['E:\项目\警企江干区\修复工作1\','unrepair.txt'],'a');
        fprintf(fid, '%s %s %s %s %s %s\r\n',s3{i}{1:6});
        fclose(fid);
    end
end


