function s=PCMdecoding(encode)
    encode=(reshape(encode',8,length(encode)/8))';
    l=size(encode,1);
    a=[0,16,32,64,128,256,512,1024];
    b=[1 1 2 4 8 16 32 64];
    c=[0 1.5:15.5];
    for i=1:l
        x=encode(i,1);
        T=bin2dec(num2str(encode(i,(2:4))))+1;
        Y=bin2dec(num2str(encode(i,(5:8))));
        if Y==0
            k(i)=a(T)/2048;
        else
            k(i)=(a(T)+b(T)*c(Y))/2048;
        end
        if x==0
            s(i)=-k(i);
        else
            s(i)=k(i);
        end
    end
%     s = s*maxim;
end