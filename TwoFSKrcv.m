function [signal_in] = TwoFSKrcv(signal_out, Fs, f1, f2, tao)
%TwoFSKrcv demodulate 2fsk signal with given 2fsk signal
%   [signal_in] = TwoFSKrcv(signal_out, Fs, f1, f2)
%   signal_ou: the 2fsk 2fsk signal received
%   Fs: signal sample rate
%   f1, f2: frequency of 1 and 0, f1 > f2
%   tao: the number of digit data points of one bit
%   return signal_in is digital signal(pcm or other 0-1 digital signal)
    Hdf2 = f2passFilter(Fs, f2);
    sig_f2 = filter(Hdf2, signal_out);
    env_f2 = abs(hilbert(sig_f2));
    
    Hdf1 = f1passFilter(Fs, f1);
    sig_f1 = filter(Hdf1, signal_out);
    env_f1 = abs(hilbert(sig_f1));
%     plot(sig_f1);
%     axis([0 1200 -1.1 1.1]);
    env_all = env_f1 - env_f2;
    
    figure(2); subplot(2,2,2);
    plot(env_all);
    axis([102500 104500 -1.5 1.5]);
    title('Envelope'); grid on;
    
%     [~, strt] = findpeaks(abs(env_all), 'minpeakheight', 0.1);
%     disp([strt(1), strt(2), strt(3)]);
    bit = 110:tao:length(env_all);  % 110 is the first peak of env_all, need to be compute
    dig_sample = env_all(bit);
    dig1 = dig_sample>0;
    dig0 = dig_sample<=0;
    
    dig = ones(1, length(dig_sample));
    dig(dig1) = 1;
    dig(dig0) = 0;
    
    if rem(length(dig), 8) ~= 0
        rem_length = 8-rem(length(dig), 8);  % add zeros at the end
        add_rem = zeros(1, rem_length);
        signal_in = [dig, add_rem];
    else
        signal_in = dig;
    end
end

