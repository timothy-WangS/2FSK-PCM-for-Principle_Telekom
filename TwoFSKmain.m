%%
clear;clc;close all;

%%
Fs = 48e3;
f1 = 16e3;
f2 = 8e3;
T = 1/Fs;
t = -0.01:T:0.01;
xt=cos(2*pi*30*t)+sin(2*pi*120*t);
max = max(abs(xt));

%%
% original signal
figure(1); subplot(2,2,1);
plot(t,xt);title('org');grid on;

%%
% PCM encode
pcm_encode = PCMcoding(xt);

% PCM expand at each point
tao = 15*Fs/f1;  % 15 period of f1 or 5 period of f2
pcm_send = reshape(repmat(pcm_encode, [tao, 1]), 1, tao*length(pcm_encode));

figure(1); subplot(2,2,2);
plot(pcm_send);
axis([0 1200 -0.1 1.1]);
title('PCM encode'); grid on;

%%
% 2FSK generate
signal_out = TwoFSKgen(pcm_send, Fs, f1, f2);

figure(1); subplot(2,2,3)
plot(signal_out);
axis([0 1200 -1.1 1.1]);
title('2FSK'); grid on;

%%
% send 2FSK

%%
% receive 2FSK

%%
% 2FSK demodulate
pcm_receive = TwoFSKrcv(signal_out, Fs, f1, f2, tao);

% PCM decode
pcm_decode = PCMdecoding(pcm_receive, max);

figure(1); subplot(2,2,4);
plot(t, pcm_decode);
title('PCM decode'); grid on;

%%
% compute lost
da=0; 
for i=1:length(t)
    dc=(xt(i)-pcm_decode(i))^2/length(t);
    da=da+dc;
end
fprintf(' ß’Ê∂» «£∫%.6f\n',da);
