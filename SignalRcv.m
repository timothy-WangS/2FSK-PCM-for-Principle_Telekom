function [pcm_decode] = SignalRcv(rxPluto, head, Fs, f1, f2, tao, frame_length, maxim)
%SIGNALRCV reveive 2FSK
    [data,datavalid,overflow] = rxPluto();
    data = 3.*real(data);
    
    figure(2); subplot(2,2,1);
    plot(data);
    axis([4000 5200 -1.1 1.1]);
    title('Data receive'); grid on;
    
    % 2FSK demodulate
    pcm_receive = TwoFSKrcv(data, Fs, f1, f2, tao);

    % get data frame
    m = strfind(pcm_receive, head);
    if isempty(m)
        disp('NULL');
    end
    pcm_receive = pcm_receive(m+length(head):m+length(head)+frame_length-1);
    
    figure(2); subplot(2,2,3);
    stairs(pcm_receive);
    axis([500 600 -0.1 1.1]);
    title('PCM received'); grid on;

    % PCM decode
%     pcm_decode = PCMdecoding(pcm_receive, maxim);
    pcm_decode = PCMdecoding(pcm_receive);
    
end

