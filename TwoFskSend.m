function [signal_out] = TwoFskSend(head, xt, tao, Fs, f1, f2)
%   [signal_out] = TwoFskSend(xt, tao, Fs, f1, f2)
%   head: the head of each frame
%   xt: the digital signal to send as 2fsk
%   tao: the length of each points expension
%   Fs: signal sample rate
%   f1, f2: frequency of 1 and 0, f1 > f2
%   return signal_out is 2fsk signal
    pcm_encode = [head, PCMcoding(xt)];  % PCM encode add head
  
    pcm_send = reshape(repmat(pcm_encode, [tao, 1]), 1, tao*length(pcm_encode));  % PCM expand at each point
    
    figure(1); subplot(2,2,2);
    plot(pcm_send);
    axis([25000 30000 -0.1 1.1]);
    title('PCM encode'); grid on;
    
    % 2FSK generate
    N = length(pcm_send);
    n = (1:N)/Fs;
    carry1 = cos(2*pi*f1*n);
    carry2 = cos(2*pi*f2*n);
    
    s1 = pcm_send;
    s2 = abs(pcm_send-1);
    
    signal_out = s1.*carry1 + s2.*carry2;
    
%     figure(1); subplot(2,2,3)
%     plot(signal_out);
%     axis([0 1200 -1.1 1.1]);
%     title('2FSK signal'); grid on;

end

