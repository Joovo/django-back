%{
˵�����ó������ҪĿ���Ƕ�170918.m��鵽���쳣���ݽ����޸���
�쳣���ݵ��޸�������1.������ͬ���ڵ����ݽ����޸���2.����ģ������޸�
%}
clc;
clear;
%����������õ����ݼ�¼�޸�����������ݡ�
filename1 = 'E:\��Ŀ\���󽭸���\ʵʱ�����޸�����\non_need_repair.txt';
filename2 = 'E:\��Ŀ\���󽭸���\ʵʱ�����޸�����\need_repair.txt';
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
    data2=xlsread(['E:\��Ŀ\���󽭸���\ʵʱ�����޸�����\',s2{i1}{1},'+',s2{i1}{2},'+',s2{i1}{3},'.xlsx']);%��ȡ��Ҫ�޸��ļ�¼
    flag = 0;
    for j1=1:length(s1)
        a =find((veh==datenum(s1{j1}{1},'yyyymmdd'))==1);  %�ж��Ƿ������ͬ����
        if (~isempty(a)) && strcmp(s2{i1}{2},s1{j1}{2}) && strcmp(s2{i1}{3},s1{j1}{3})  %�Ƿ������ͬ���ڡ�·�ڱ�š���Ȧ���
            data1=xlsread(['E:\��Ŀ\���󽭸���\\ʵʱ�����޸�����\',s1{i1}{1},'\',datestr(veh(a),'yyyymmdd'),...
                '_',s1{i1}{2},'_',s1{i1}{3},'.xlsx']);    %��ȡ��������
            for i2 = 28:88
                if data2(i2)<15
                    data(i2,:) = data1(i2,:);
                end
            end
            xlswrite(['E:\��Ŀ\���󽭸���\ʵʱ�����޸�����\',s2{i1}{1},'\',s2{i1}{1},'_',s2{i1}{2},'_',s2{i}{3},'.xlsx'],data2);
        else
            %%%����ģ������޸�
            a =find((veh==datenum(s1{j1}{1},'yyyymmdd'))==1);  %�ж��Ƿ������ͬ����
            if (~isempty(a)) && strcmp(s2{i1}{2},s1{j1}{2}) && strcmp(s2{i1}{3},s1{j1}{3})  %�Ƿ������ͬ���ڡ�·�ڱ�š���Ȧ���
                data1=xlsread(['E:\��Ŀ\���󽭸���\�޸�����\�����޸�\',s1{i1}{1},'\',datestr(veh(a),'yyyymmdd'),'_',s1{i1}{2},'_',s1{i1}{3},'.xlsx']);    %��ȡ��������
                for i2 = 28:88
                    if data2(i2)<15
                        data(i2,:) = data1(i2,:);
                    end
                end
                xlswrite(['E:\��Ŀ\���󽭸���\ʵʱ�����޸�����\',s2{i1}{1},'\',s2{i1}{1},'_',s2{i1}{2},'_',s2{i}{3},'.xlsx'],data2);
            end
        end
    end
end
