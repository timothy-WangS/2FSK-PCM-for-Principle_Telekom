function code = PCMcoding(S)
    z = sign(S);                                % judege if S is negative or positive
    MaxS = max(abs(S));                         % the max of S
    S = abs(S/MaxS);                            % normalization
    Q = 2048*S;                                 % quantification
    code = zeros(length(S),8);                  % save space
    
    % each paragraph
    for i = 1:length(S)
        if (Q(i)>=128)&&(Q(i)<=2048)
            code(i,2) = 1;            % 5-8, 1st = 1
        end
        if (Q(i)>32)&&(Q(i)<128)||(Q(i)>=512)&&(Q(i)<=2048)
            code(i,3) = 1;            % 3,4,7,8, 2st = 1
        end
        if (Q(i)>=16)&&(Q(i)<32)||(Q(i)>=64)&&(Q(i)<128)||(Q(i)>=256)&&(Q(i)<512)||(Q(i)>=1024)&&(Q(i)<=2048)
            code(i,4) = 1;            % 2,4,6,8, 3st = 1
        end
    end
    
%     N=zeros(length(S));  
    N = zeros(1, length(S));                           % in paragraph
    
    for i = 1:length(S)
        N(i) = bin2dec(num2str(code(i,2:4)))+1;        % find code in which paragraph
    end
    
    a = [0,16,32,64,128,256,512,1024];                 % uniform quantization
    b = [1,1,2,4,8,16,32,64];                          % the minimum of each uniform quantization
    for i = 1:length(S)  
        q = ceil((Q(i)-a(N(i)))/b(N(i)));              % get the position in each paragraph
        if q==0
            code(i,(5:8)) = [0,0,0,0];                 % in zero, out zero
        else k = num2str(dec2bin(q-1,4));              % change to 0-1 code
%             code(i,5) = str2num(k(1));
%             code(i,6) = str2num(k(2));
%             code(i,7) = str2num(k(3));
%             code(i,8) = str2num(k(4));
            code(i,5) = str2double(k(1));
            code(i,6) = str2double(k(2));
            code(i,7) = str2double(k(3));
            code(i,8) = str2double(k(4));
        end
        if z(i)>0
            code(i,1) = 1;
        elseif z(i)<0
            code(i,1) = 0;
        end                                           % judge the signal
    end
    code = reshape(code', 1, []);
end
