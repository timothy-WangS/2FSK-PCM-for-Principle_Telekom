function [signal_out] = SignalSend(xt, txPluto, head, Fs, f1, f2, tao)
%SIGNALSEND send 2FSK
    % 2FSK generate
    signal_out = TwoFskSend(head, xt, tao, Fs, f1, f2);
    
    figure(1); subplot(2,2,3);
    plot(signal_out);
    axis([0 1200 -1.1 1.1]);
    title('2FSK signal'); grid on;
    
    % 2FSK send
    Signal = exp(i*signal_out)';
    
    figure(1); subplot(2,2,4);
    plot(Signal);
    title('Signal'); grid on;
    
    play = 5;
    while play
        txPluto(Signal);
        play = play-1;
    end
end

