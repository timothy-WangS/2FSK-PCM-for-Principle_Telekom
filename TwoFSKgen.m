function [signal_out] = TwoFSKgen(pcm_send, Fs, f1, f2)
%TwoFSKgen generate 2fsk signal with given pcm(or other 0-1 digital signal)
%   [signal_out] = TwoFSKgen(pcm_send, Fs, f1, f2)
%   pcm_send: the digital signal to send as 2fsk
%   Fs: signal sample rate
%   f1, f2: frequency of 1 and 0, f1 > f2
%   return signal_out is 2fsk signal

    N = length(pcm_send);
    n = (1:N)/Fs;
    carry1 = cos(2*pi*f1*n);
    carry2 = cos(2*pi*f2*n);
    
    s1 = pcm_send;
    s2 = abs(pcm_send-1);
    
    signal_out = s1.*carry1 + s2.*carry2;
    
end

