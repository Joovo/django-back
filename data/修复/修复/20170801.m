clc;clear;
%{
�ó������ҪĿ���ǣ������е���Ȧ�������м�⣬�����γ�3���ĵ���
��Ȧ���ݿ����ĵ�˵��.txt����Ȧ���ݲ��ֿ���˵���ĵ�.txt����Ȧ������ȫ�������ĵ�˵��.txt�� 
%}
%% Import the data
[~, ~, raw] = xlsread('C:\Users\asus\Desktop\lane.xlsx','Sheet1','A2:I568'); %���ļ������н���ڶ�Ӧ�ĳ�������ת���ϵ
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
file = dir('E:\��Ŀ\���󽭸���\������95��·��6�·�����\�����������ͱ��Ͷ�\'); %��ȡ�ļ�����·���ļ�
filename={file.name}';
for i =1:length(filename)      %��ǰ���е�·�����ļ�����
    file1 = dir(['E:\��Ŀ\���󽭸���\������95��·��6�·�����\�����������ͱ��Ͷ�\',filename{i},'\','*.xlsx']); %��ȡ�ļ�����ȫ�������ͱ��Ͷ��ļ�
    filename1 = {file1.name}';
    for j = 1:length(filename1)
        d = regexp(filename1{j}, '\d+', 'match'); %��ȡÿ���ļ���Ӧ�����ڡ�·�ڡ���Ȧ��ŵ���Ϣ
        m=find(str2num(d{2})==VarName1(:));
        n=[VarName6 VarName7 VarName8 VarName9];
        [m1,m2]=find(n(m,:)==str2num(d{3}));  %��ѡ����·���У��ҳ���ǰ��Ȧ���ڵ�λ�ã� m(m1),n(m2)Ϊ��ǰλ����Ȧ�ľ���λ�ã�
        %n(m(m1),m2)����ѡ��ǰ����Ȧ���
        data = xlsread(['E:\��Ŀ\���󽭸���\������95��·��6�·�����\�����������ͱ��Ͷ�\',filename{i},'\',filename1{j}]);
        if sum(data(:,1)==0)<=10   %�ж���Ȧ���ݿɿ�
            fid = fopen('��Ȧ���ݿ����ĵ�˵��.txt','a');
            fprintf(fid,'%d %s %s %d %s %s\r\n',VarName1(m(m1)),VarName2{m(m1)},VarName4{m(m1)},n(m(m1),m2),d{1},'1');
            fclose(fid);
        elseif(10<sum(data(:,1)==0)) && (sum(data(:,1)==0)<90)     %�ж���Ȧ���ݲ��ֿ���
            fid = fopen('��Ȧ���ݲ��ֿ���˵���ĵ�.txt','a');
            fprintf(fid,'%d %s %s %d %s %s\r\n',VarName1(m(m1)),VarName2{m(m1)},VarName4{m(m1)},n(m(m1),m2),d{1},'2');
            fclose(fid);
        elseif sum(data(:,1)==0)>=90   %�ж���Ȧ������ȫ������
            fid = fopen('��Ȧ������ȫ�������ĵ�˵��.txt','a');
            fprintf(fid,'%d %s %s %d %s %s\r\n',VarName1(m(m1)),VarName2{m(m1)},VarName4{m(m1)},n(m(m1),m2),d{1},'3');
            fclose(fid);            
        end
    end
end





