clc;
clear;
filename1 = 'E:\��Ŀ\���󽭸���\�޸�����\��Ȧ���ݿ����ĵ�˵��.txt';
filename2 = 'C:\Users\asus\Desktop\SCATSС��ģ���м�¼\SCATSС��ģ���м�¼\��Ȧ���ݲ��ֿ���˵���ĵ�.txt';
filename3 = 'C:\Users\asus\Desktop\SCATSС��ģ���м�¼\SCATSС��ģ���м�¼\��Ȧ������ȫ�������ĵ�˵��.txt';
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

%���ڲ������ݿ�����Ȧ�����޸�
for i = 1:length(s2)
    veh = [];
    for i3 = 736847:736876  %����2017.06.01-2017.06.30
        if mod(i3-datenum(s2{i}{5},'yyyymmdd'),7)==0 && i3-datenum(s2{i}{5},'yyyymmdd')~=0  %������ͬ���ڽ����޸�
            veh =[veh i3];
        end
    end
    
    %�޸�����1��ͨ����ͬ·�ڱ�š���ͬ��Ȧ��š���ͬ���ڵ����ݽ����޸�
    flag = 0;
    for j1=1:length(s1)
        a =find((veh==datenum(s1{j1}{5},'yyyymmdd'))==1);  %�ж��Ƿ������ͬ����
        if (~isempty(a)) && strcmp(s2{i}{1},s1{j1}{1}) && strcmp(s2{i}{4},s1{j1}{4})  %�Ƿ������ͬ���ڡ�·�ڱ�š���Ȧ���
            data=xlsread(['E:\��Ŀ\���󽭸���\������95��·��6�·�����\�����������ͱ��Ͷ�\',s2{i}{1},'\',datestr(veh(a),'yyyymmdd'),...
                '+',s2{i}{1},'+',s2{i}{4},'.xlsx']);
            xlswrite(['E:\��Ŀ\���󽭸���\�޸�����1\',s2{i}{5},'+',s2{i}{1},'+',s2{i}{4},'.xlsx'],data);
            fid = fopen('E:\��Ŀ\���󽭸���\�޸�����1\repair.txt','a');
            fprintf(fid, '%s %s %s %s %s %s\r\n',s2{i}{1:6});
            fclose(fid);
            flag = 1;
        elseif strcmp(s2{i}{1},s1{j1}{1}) && strcmp(s2{i}{3},s1{j1}{3}) && strcmp(s2{i}{5},s1{j1}{5})
            %�޸�����2��ͨ����ͬ·�ڱ�š���ͬ�г��������Ȧ����ͬ���ڵ����ݽ����޸�
            data = xlsread(['E:\��Ŀ\���󽭸���\������95��·��6�·�����\�����������ͱ��Ͷ�\',s2{i}{1},'\',s2{i}{5},'+',...
                s2{i}{1},'+',s1{j1}{4}]);
            xlswrite(['E:\��Ŀ\���󽭸���\�޸�����1\',s2{i}{5},'+',s2{i}{1},'+',s2{i}{4},'.xlsx'],data);
            fid = fopen('E:\��Ŀ\���󽭸���\�޸�����1\repair.txt','a');
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
        %�޸�����1��2�޷������޸�ʱ�����¼���޷��޸���������Ϣ
        fid = fopen(['E:\��Ŀ\���󽭸���\�޸�����1\','unrepair.txt'],'a');
        fprintf(fid, '%s %s %s %s %s %s\r\n',s2{i}{1:6});
        fclose(fid);
    end
end


%������ȫ���������ݿ�����Ȧ�����޸�
for i = 1:length(s3)
    veh = [];
    for i3 = 736847:736876
        if mod(i3-datenum(s3{i}{5},'yyyymmdd'),7)==0 && i3-datenum(s3{i}{5},'yyyymmdd')~=0  %������ͬ���ڽ����޸�
            veh =[veh i3];
        end
    end
    
    %�޸�����1��ͨ����ͬ·�ڱ�š���ͬ��Ȧ��š���ͬ���ڵ����ݽ����޸�
    flag = 0;
    for j1=1:length(s1)
        a =find((veh==datenum(s1{j1}{5},'yyyymmdd'))==1);  %�ж��Ƿ������ͬ����
        if (~isempty(a)) && strcmp(s3{i}{1},s1{j1}{1}) && strcmp(s3{i}{4},s1{j1}{4})  %�Ƿ������ͬ���ڡ�·�ڱ�š���Ȧ���
            data=xlsread(['E:\��Ŀ\���󽭸���\������95��·��6�·�����\�����������ͱ��Ͷ�\',s3{i}{1},'\',datestr(veh(a),'yyyymmdd'),...
                '+',s3{i}{1},'+',s3{i}{4},'.xlsx']);
            xlswrite(['E:\��Ŀ\���󽭸���\�޸�����1\',s3{i}{5},'+',s3{i}{1},'+',s3{i}{4},'.xlsx'],data);
            fid = fopen('E:\��Ŀ\���󽭸���\�޸�����1\repair.txt','a');
            fprintf(fid, '%s %s %s %s %s %s\r\n',s3{i}{1:6});
            fclose(fid);
            flag = 1;
        elseif strcmp(s2{i}{1},s1{j1}{1}) && strcmp(s3{i}{3},s1{j1}{3}) && strcmp(s3{i}{5},s1{j1}{5})
            %�޸�����2��ͨ����ͬ·�ڱ�š���ͬ�г��������Ȧ����ͬ���ڵ����ݽ����޸�
            data = xlsread(['E:\��Ŀ\���󽭸���\������95��·��6�·�����\�����������ͱ��Ͷ�\',s3{i}{1},'\',s3{i}{5},'+',...
                s3{i}{1},'+',s1{j1}{4}]);
            xlswrite(['E:\��Ŀ\���󽭸���\�޸�����1\',s3{i}{5},'+',s3{i}{1},'+',s3{i}{4},'.xlsx'],data);
            fid = fopen('E:\��Ŀ\���󽭸���\�޸�����1\repair.txt','a');
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
        %�޸�����1��2�޷������޸�ʱ�����¼���޷��޸���������Ϣ
        fid = fopen(['E:\��Ŀ\���󽭸���\�޸�����1\','unrepair.txt'],'a');
        fprintf(fid, '%s %s %s %s %s %s\r\n',s3{i}{1:6});
        fclose(fid);
    end
end


