function code=PCMcoding(S)
    z=sign(S);                                %�ж�S������
    MaxS=max(abs(S));                         %��S�����ֵ 
    S=abs(S/MaxS);                            %��һ��
    Q=2048*S;                                 %����
    code=zeros(length(S),8);                  %����洢����ȫ�㣩
    
    % �������жϳ���
    for i=1:length(S)
        if (Q(i)>=128)&&(Q(i)<=2048)
            code(i,2)=1;            %�ڵ������ڰ˶�֮�䣬��λ���һλ��Ϊ"1"
        end
        if (Q(i)>32)&&(Q(i)<128)||(Q(i)>=512)&&(Q(i)<=2048)
            code(i,3)=1;            %�ڵ������߰˶��ڣ���λ��ڶ�λΪ"1"
        end
        if (Q(i)>=16)&&(Q(i)<32)||(Q(i)>=64)&&(Q(i)<128)||(Q(i)>=256)&&(Q(i)<512)||(Q(i)>=1024)&&(Q(i)<=2048)
            code(i,4)=1;            %�ڶ������˶��ڣ���λ�����λΪ"1"
        end
    end
    
    N=zeros(length(S));                              %�������жϳ���
    
    for i=1:length(S)
        N(i)=bin2dec(num2str(code(i,2:4)))+1;        %�ҵ�codeλ�ڵڼ���
    end
    
    a=[0,16,32,64,128,256,512,1024];                 %�������
    b=[1,1,2,4,8,16,32,64];                          %����16���õ�ÿ�ε���С�������
    for i=1:length(S)  
        q=ceil((Q(i)-a(N(i)))/b(N(i)));              %����ڶ��ڵ�λ��
        if q==0
            code(i,(5:8))=[0,0,0,0];                 %�������Ϊ�������"0"
        else k=num2str(dec2bin(q-1,4));              %���������Ϊ������
            code(i,5)=str2num(k(1));
            code(i,6)=str2num(k(2));
            code(i,7)=str2num(k(3));
            code(i,8)=str2num(k(4));
        end
        if z(i)>0
            code(i,1)=1;
        elseif z(i)<0
            code(i,1)=0;
        end                                           %����λ���ж�
    end
    code = reshape(code', 1, []);
end