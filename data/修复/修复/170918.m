clc;
clear;
%{
˼·���ó������ҪĿ���Ƕ�ʵʱ���ݵ��쳣���ݽ����б�
�쳣���ݵ��б𷽷�����Ҫ�ж�7:00-22:00����������Ϊ0�������������ּ�Ϊ�쳣���ݣ�
%}
path1 = 'E:\��Ŀ\��ͨС��\168·��';
% file = dir('E:\��Ŀ\���󽭸���\������95��·��6�·�����\ʵʱ���������ͱ��Ͷ�\'); %��ȡ�ļ�����·���ļ�
% filename={file.name}';
% for i =1:length(filename) %·���ļ�
%     file1 = dir(['E:\��Ŀ\���󽭸���\������95��·��6�·�����\ʵʱ���������ͱ��Ͷ�\',filename{i},'\','*.xlsx']); %��ȡ�ļ�����ȫ�������ͱ��Ͷ��ļ�
file1 = dir([path1,'\','*.xlsx']);   
filename1 = {file1.name}';
    for j = 1:length(filename1)   %ÿ��·���ļ����£���Ӧ�ĸ����ļ�
        str = regexp(filename1{j}, '\d+', 'match'); %��ȡÿ���ļ���Ӧ�����ڡ�·�ڡ���ȯ�����Ϣ
%         m=find(str2num(str{2})==VarName1(:));
%         n=[VarName6 VarName7 VarName8 VarName9];
%         [m1,m2]=find(n(m,:)==str2num(str{3}));  %��ѡ����·���У��ҳ���ǰ��Ȧ���ڵ�λ�ã� m(m1),n(m2)Ϊ��ǰλ����Ȧ�ľ���λ�ã�
%         %n(m(m1),m2)����ѡ��ǰ����Ȧ���
        data1 = xlsread([path1,'\',filename1{j}]);      
        %�޸�����Ҫʱ����7:00~22:00
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
