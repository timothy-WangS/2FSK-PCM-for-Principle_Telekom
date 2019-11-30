%%
% Generate 'Signal'
clear;clc
f = 10;  % carry frequency
Fs = 500;  % sampling rate
n = (1:450000)./Fs;
N = length(n);  % number of samples
CarrySignal = 2*pi*f*n;
% AM
mt = 0.2*sin(2*pi*n*0.1);  % message, 0.1 is message frequency
enve = 0.8*ones(1, length(n))+mt;  % generate envelop
Signal = (enve.*exp(i*CarrySignal))';  % modulate
a = real(Signal);
figure(1);
subplot(2,2,1)
plot(Signal);

xaxis = (0:length(a)-1)./Fs;
subplot(2,2,2)
plot(xaxis, a); axis([0 20 -1 1]);

freqSig = abs(fft(a, N));
freq = Fs*(0:N-1)/N;
subplot(2,2,3);
semilogy(freq, freqSig); axis([0 Fs/2 0 10^(6)]);

subplot(2,2,4)
plot(xaxis, a);

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
    'SamplesPerFrame',length(Signal), ...
    'Gain',30);

%%
i=1;
while i
    txPluto(Signal);
    i=i-1;
end

% disp('send finish');

% data: the Signal received
% datavalid: if data if valid or not
% overflow: if data is overflow or not
[data,datavalid,overflow] = rxPluto();

%%
% the original data received
figure(2)
rd = 3*real(data);
subplot(2,2,1)
plot(data);

subplot(2,2,2)
xaxis = (0:length(rd)-1)./Fs;
plot(xaxis, rd); axis([0 20 -1 1]);

freqSig = abs(fft(rd, N));
freq = Fs*(0:N-1)/N;
subplot(2,2,3);
semilogy(freq, freqSig); axis([0 Fs/2 0 10^(6)]);

subplot(2,2,4)
xaxis = (0:length(rd)-1)./Fs;
plot(xaxis, rd);

%%
% data go through Butter
figure(3)
subplot(2,2,1)
plot(data);

Wn = f*2/Fs;
[butter1, butter2] = butter(2, Wn, 'low');  % 2 Butter
y = filter(butter1, butter2, rd);
subplot(2,2,2)
xaxis = (0:length(rd)-1)./Fs;
plot(xaxis, y); axis([0 20 -1 1]);

freqSig = abs(fft(y, N));
freq = Fs*(0:N-1)/N;
subplot(2,2,3);
semilogy(freq, freqSig); axis([0 Fs/2 0 10^(6)]);

subplot(2,2,4)
xaxis = (0:length(rd)-1)./Fs;
plot(xaxis, y);
