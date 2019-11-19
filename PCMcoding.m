function code=PCMcoding(S)
    z=sign(S);                                %判断S的正负
    MaxS=max(abs(S));                         %求S的最大值 
    S=abs(S/MaxS);                            %归一化
    Q=2048*S;                                 %量化
    code=zeros(length(S),8);                  %代码存储矩阵（全零）
    
    % 段落码判断程序
    for i=1:length(S)
        if (Q(i)>=128)&&(Q(i)<=2048)
            code(i,2)=1;            %在第五段与第八段之间，段位码第一位都为"1"
        end
        if (Q(i)>32)&&(Q(i)<128)||(Q(i)>=512)&&(Q(i)<=2048)
            code(i,3)=1;            %在第三四七八段内，段位码第二位为"1"
        end
        if (Q(i)>=16)&&(Q(i)<32)||(Q(i)>=64)&&(Q(i)<128)||(Q(i)>=256)&&(Q(i)<512)||(Q(i)>=1024)&&(Q(i)<=2048)
            code(i,4)=1;            %在二四六八段内，段位码第三位为"1"
        end
    end
    
    N=zeros(length(S));                              %段内码判断程序
    
    for i=1:length(S)
        N(i)=bin2dec(num2str(code(i,2:4)))+1;        %找到code位于第几段
    end
    
    a=[0,16,32,64,128,256,512,1024];                 %量化间隔
    b=[1,1,2,4,8,16,32,64];                          %除以16，得到每段的最小量化间隔
    for i=1:length(S)  
        q=ceil((Q(i)-a(N(i)))/b(N(i)));              %求出在段内的位置
        if q==0
            code(i,(5:8))=[0,0,0,0];                 %如果输入为零则输出"0"
        else k=num2str(dec2bin(q-1,4));              %编码段内码为二进制
            code(i,5)=str2num(k(1));
            code(i,6)=str2num(k(2));
            code(i,7)=str2num(k(3));
            code(i,8)=str2num(k(4));
        end
        if z(i)>0
            code(i,1)=1;
        elseif z(i)<0
            code(i,1)=0;
        end                                           %符号位的判断
    end
    code = reshape(code', 1, []);
end