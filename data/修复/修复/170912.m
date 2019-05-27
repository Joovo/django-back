clc;
clear;
%{
�ó������ҪĿ���ǶԵ�·��ͨ��ʱ���޸��Ľ����һ�����е����޸�
%}
%%
[~, ~, raw] = xlsread('C:\Users\asus\Desktop\lane.xlsx','Sheet1','A2:I567');   %��ȡ������ϵ��
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

file = dir(['E:\��Ŀ\���󽭸���\�޸�����\stepone\']);  %�ӵ�3����ʼ������\
filename = {file.name}';                             %·����
for i = 1:length(file)                                  %ѭ��·����
    file1 = dir(['E:\��Ŀ\���󽭸���\�޸�����\stepone\',num2str(filename{i}),'\']);
    filename1 = {file1.name}';  %·��������ļ���
    str = regexp(filename1,'\d+','match');     %�������ļ������ֱ��Ӧ�����ڡ�·�ڡ���Ȧ
    for j = 3:length(filename1)   %length(filename1)     %ѭ���ļ���
        data1 = xlsread(['E:\��Ŀ\���󽭸���\�޸�����\stepone\',num2str(filename{i}),'\',filename1{j}]);  %��ȡ��·�ڡ�ĳ�ˡ�ĳ��Ȧ��Ӧ������
        date = datenum(str{j}{1},'yyyymmdd');   %������תΪ��ֵ������
        temp = [];
        for i1 = 736847:736876  % �ֱ��ʾ����20170601-20170630
            if date ~= i1 && mod(abs(i1-date),7)==0
                temp = [temp i1];       %�ҳ�������ͬ���ڵ����ڶ�Ӧ����ֵ
            end
        end
        
        if ~exist(['E:\��Ŀ\���󽭸���\�޸�����\�����޸�\',filename{i}])   %������·�����ļ��У��򴴽�
            mkdir(['E:\��Ŀ\���󽭸���\�޸�����\�����޸�\',filename{i}]);
        end
        
        for k = 28:88   %�޸�����Ҫʱ����7:00~22:00
            flag = 0;
            if max(data1(:,1))<30  %�ж����ֵ�Ƿ�С��30���ǵĻ�����ʱ�β����޸�
                flag =1;
                %    xlswrite(['E:\��Ŀ\���󽭸���\�޸�����\�����޸�\',filename{i},'\',str{j}{1},'_',str{j}{2},'_',str{j}{3},'.xlsx'],data1);    %������д���Ӧ��·�����ļ����£�
                break;                                                                      %ͬʱ������ѭ��
            elseif data1(k,1)>=15
                flag =1;
            elseif data1(k,1)<15  %������ͬ�����޸�
                for i2 = 1:length(temp)
                    if exist(['E:\��Ŀ\���󽭸���\�޸�����\stepone\',num2str(filename{i}),'\',datestr(temp(i2),'yyyymmdd'),'+',str{j}{2},'+',str{j}{3},'.xlsx'])==1
                        data2 = xlsread(['E:\��Ŀ\���󽭸���\�޸�����\stepone\',num2str(filename{i}),'\',datestr(temp(i2),'yyyymmdd'),'+',str{j}{2},'+',str{j}{3},'.xlsx']);
                        if data2(k,1)>15
                            data1(k,1) = data2(k,1);
                            data1(k,2) = data2(k,2);
                            flag = 1;
                            break;
                        end
                    end
                end
            end
            
            if flag==0   %��ʾ������ͬ����û���޸��ã���ʱ�������øõ�������ʱ�̵�����޸�
                data1(k,1) = data1(k-1,1);
                data1(k,2) = data1(k-1,2);
            end
        end
        xlswrite(['E:\��Ŀ\���󽭸���\�޸�����\�����޸�\',filename{i},'\',str{j}{1},'_',str{j}{2},'_',str{j}{3},'.xlsx'],data1);
    end
    pause(1);
end
