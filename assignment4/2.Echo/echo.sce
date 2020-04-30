/* 
    PREPARATION
*/
clear()
clf()
BASE = "/home/sabzirov/Desktop/Spring20/DSP/assignment4/2.Echo/"
exec(BASE + "cshift.sci")
[signal, signal_Fs, signal_bits] = wavread(BASE + "sample_track.wav")
signal = signal(1, :)
[irc_given, irc_Fs, irs_bits] = wavread(BASE + "IRC.wav")
irc_given = irc_given(1, :)


/*
    TIME DOMAIN
*/
figure(1)
plot(signal)
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Original Signal in time domain", 'fontsize', 3)
xs2png(gcf(), BASE +  "signal_time.png")
close() 


figure(2)
plot(irc_given)
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("IRC in time domain", 'fontsize', 3)
xs2png(gcf(), BASE +  "irc_time.png")
close() 


/*
    FREQUENCY DOMAIN
*/
len = length(signal)
frequencies = (0:len-1) / len * signal_Fs
figure(3)
plot2d("nl", frequencies, abs(fft(signal)), color("blue"))
xlabel("Frequency component, n", "fontsize", 2)
ylabel("Freq Amplitude", "fontsize", 2)
title("Signal in frequency domain", 'fontsize', 3)
xs2png(gcf(), BASE + "signal_freq")
close()


len = length(irc_given)
frequencies = (0:len-1) / len * irc_Fs
figure(4)
plot2d("nl", frequencies, abs(fft(irc_given)), color("blue"))
xlabel("Frequency component, n", "fontsize", 2)
ylabel("Freq Amplitude", "fontsize", 2)
title("IRC in frequency domain", 'fontsize', 3)
xs2png(gcf(), BASE + "irc_freq")
close()


/*
    ADDING THE ECHO
*/
signal_added_echo = convol(signal, irc_given) 
len = length(signal_added_echo)
frequencies = (0:len-1) / len * signal_Fs
figure(5)
plot2d("nl", frequencies, abs(ifft(signal_added_echo)) ./ 55, color("blue"))
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Convolved signal and irc", 'fontsize', 3)
xs2png(gcf(), BASE + "signal_added_echo")
close()
savewave(BASE + "signal_added_echo", signal_added_echo, 44100)


/*
    REMOVING THE ECHO
*/
function [out] = calculate_inv_irc(irc)
    irc_inv = 1./fft(irc)
    irc_inv(1, find(isinf(irc_inv))) = 0.
    h = ifft(irc_inv)
    
    h_len = length(h)
    h = cshift(h, [0 (h_len-modulo(h_len, 2))/2])
    h = h .* window('kr', length(h), 16)
    out = h
endfunction


filt = calculate_inv_irc(irc_given)
figure(7)
plot2d("nn", 1:length(filt), filt, color("blue"))
title("Filter for canceling echo", 'fontsize', 3)
xlabel("Time, t", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
xs2png(gcf(), BASE + "filter")
close()


signal_removed_echo = convol(signal_added_echo, filt)
savewave(BASE + "signal_removed_echo", signal_removed_echo, 44100)

figure(8)
plot2d("nn", 1:length(signal), signal, color("blue"))
plot2d("nn", 1:length(signal), signal_removed_echo(1:length(signal)), color("red"))
title("Original signal and signal after adding and removing echo", 'fontsize', 2)
legend(["original"; "after adding and removing echo"])
xlabel("Time, t", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
xs2png(gcf(), BASE + "original_and_with_without_echo")
close()

/*
    EVALUATING THE RESULT
*/
my_kronecker = convol(irc_given, filt)
len = length(my_kronecker)
real_kronecker = zeros(1, len)
real_kronecker(int(len / 2)) = 1
figure(9)
plot2d("nn", 1:length(my_kronecker), my_kronecker, color("blue"))
xlabel("Time, t", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("My Kronecker delta signal", 'fontsize', 3)
xs2png(gcf(), BASE + "mine_kronecker")
close()

figure(10)
plot2d("nn", 1:length(real_kronecker), real_kronecker, color("red"))
xlabel("Time, t", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Real Kronecker delta signal", 'fontsize', 3)
xs2png(gcf(), BASE + "real_kronecker")


figure(11)
c = xcorr(my_kronecker, real_kronecker)
plot(c)
