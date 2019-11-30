%%
clear; clc; close all;

%%
[y,Fs]=audioread('audio4_lv.wav');
y(:, 2) = [];
f1 = 4e3;
f2 = 1e3;
T = 1/Fs;
xt0 = y(30.6*Fs+1:30.8*Fs);
frag_length = 441;
% tao = 15*Fs/f1;  % 15 period of f1 or 5 period of f2 
tao = 100;  % the length of each points expension
head = (randi(2,2*8,1)-1)';
final = zeros(1, 8);

%%
% original signal
t = 0:T:(length(xt0)-1)*T;
figure(1); subplot(2,2,1);
plot(t,xt0);title('Original Signal');grid on;

%%
% Send 'Signal' parameter
CenterFrequency = 800e6;
BasebandSampleRate = 1e5;
txPluto = sdrtx('Pluto', 'RadioID', 'usb:0', ...
    'CenterFrequency', CenterFrequency, ...
    'BasebandSampleRate', BasebandSampleRate, ...
    'ChannelMapping',1, ...
    'Gain',0);

% receive Signal parameter
rxPluto = sdrrx('Pluto','RadioID','usb:0', ...
    'CenterFrequency', CenterFrequency,...
    'BasebandSampleRate', BasebandSampleRate, ...
    'ChannelMapping',1, ...
    'OutputDataType','double', ...
    'SamplesPerFrame',3*(((frag_length)*8+length(head))*tao), ...
    'Gain',30);

%%
tic
frame_length = frag_length*8;
for ind = 1:frag_length:length(xt0)
    xt = xt0(ind:ind+frag_length-1);
    maxim = max(abs(xt));
    
    SignalSend(xt, txPluto, head, Fs, f1, f2, tao);
    pcm_decode = SignalRcv(rxPluto, head, Fs, f1, f2, tao, frame_length, maxim);

%     figure(1); subplot(2,2,2);
%     plot(t, pcm_decode);
%     title('PCM decode'); grid on;
%     toc
    maxde = max(abs(pcm_decode));
    
    pcm_decode = maxim/maxde.*pcm_decode;
    final = [final, pcm_decode];
    disp('.');
end
final(1:8) = [];
toc

%%
t = 0:T:(length(final)-1)*T;
figure(1); subplot(2,2,2);
plot(t, final);
title('PCM decode'); grid on;

%%
% compute lost
da = 0; 
for i = 1:length(t)
    dc = abs(xt0(i)-final(i))/xt0(i);
    da = da+dc;
end
da = da/length(t);
fprintf('The lost is %.6f\n',da);
