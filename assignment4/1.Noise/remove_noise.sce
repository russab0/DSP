clear()
/*
    PREPARATION
*/
BASE = "/home/sabzirov/Desktop/Spring20/DSP/assignment4/1.Noise/"
exec(BASE + "cshift.sci")
signal_with_noise = 0
Fs = 0
signal_filtered = 0
load(BASE + "signal_with_noise_and_filtered.sod",'signal_with_noise','Fs','signal_filtered')
s = signal_with_noise(1, :) // Take the first channel


/*
    SIGNAL IN TIME DOMAIN
*/
figure(1)
plot(s)
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Signal with noise in time domain", 'fontsize', 3)
xs2png(gcf(),BASE +  "signal_with_noise_time.png")
close() // close immediately after saving


/*
    SIGNAL IN FREQUENCY DOMAIN
*/
s_len = length(s)
frequencies = (0:s_len-1)/s_len * Fs;

figure(2)
plot2d("nl", frequencies, abs(fft(s)), color("blue"))
xlabel("Frequency component, n", 'fontsize', 2)
ylabel("Freq Amplitude", 'fontsize', 2)
title("Signal with noise in frequency domain", 'fontsize', 3)
xs2png(gcf(), BASE + "signal_with_noise_freq.png")
close() // close immediately after saving

function H = ideal_lowpass(N, cutoff, stop_value)
    N = (N - modulo(N,2)) / 2
    cutoff = floor(2 * N * cutoff)
    H = ones(1, N) * stop_value
    H(1,1:cutoff) = 1.
    H = [1. H flipdim(H, 2)]  
endfunction

function H = ideal_highpass(N, cutoff, stop_value)
    N = (N - modulo(N,2)) / 2
    cutoff = floor(2 * N * cutoff)
    H = ones(1, N) * stop_value
    H(1,cutoff:N) = 1.
    H = [0. H flipdim(H, 2)]
endfunction

H_l = ideal_lowpass(5120, 0.15, 0.); 
H_H = ideal_highpass(5120, 0.001, 0.);

/*
    FREQUENCY RESPONSES OF FILTERS
*/
h_len = length(H_l)
frequencies = (0:h_len-1)/h_len * Fs;
figure(3)
plot2d("nn", frequencies, H_l, color("blue"))
xlabel("Frequency, Hz", 'fontsize', 2)
ylabel("Freq amplitude", 'fontsize', 2)
title("Frequency response of ideal low-pass filter", 'fontsize', 3)
xs2png(gcf(), BASE + "ideal_lowpass_freq.png")
close()

h_len = length(H_H)
frequencies = (0:h_len-1)/h_len * Fs;
figure(3)
plot2d("nn", frequencies, H_H, color("blue"))
xlabel("Frequency, Hz", 'fontsize', 2)
ylabel("Freq amplitude", 'fontsize', 2)
title("Frequency response of ideal high-pass filter", 'fontsize', 3)
xs2png(gcf(), BASE + "ideal_highpass_freq.png")
close()


/*
    SHIFTING FILTERS 
*/
h_len = length(H_l) 
h_l = real(ifft(H_l))
h_l = cshift(h_l, [0 (h_len - modulo(h_len,2)) / 2])
h_len = length(H_H) 
h_h = real(ifft(H_H))
h_h = cshift(h_h, [0 (h_len - modulo(h_len,2)) / 2])

figure(4)
plot2d('nn', 0:length(h_l)-1, h_l, color("blue"))
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Impulse response of ideal low-pass filter", 'fontsize', 3)
xs2png(gcf(), BASE + "ideal_lowpass_time.png")
close()

figure(4)
plot2d('nn', 0:length(h_h)-1, h_h, color("blue"))
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Impulse response of ideal high-pass filter", 'fontsize', 3)
xs2png(gcf(), BASE + "ideal_highpass_time.png")
close()


/*
    WINDOWING FILTERS
*/
h_l = h_l .* window('kr', length(h_l), 8)
h_h = h_h .* window('kr', length(h_h), 8)

figure(5)
plot2d('nn', 0:length(h_l)-1, h_l, color("blue"))
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Windowed impulse response of ideal low-pass filter", 'fontsize', 3)
xs2png(gcf(), BASE + "window_lowpass.png")
close()

figure(5)
plot2d('nn', 0:length(h_h)-1, h_h, color("blue"))
xlabel("Time, n", 'fontsize', 2)
ylabel("Amplitude", 'fontsize', 2)
title("Windowed impulse response of ideal high-pass filter", 'fontsize', 3)
xs2png(gcf(), BASE + "window_highpass.png")
close()


/*
    FREQUENCY RESPONSE OF FINAL FILTERS
*/
h_len = length(H_l)
frequencies = (0:h_len-1)/h_len * Fs;
filt = abs(fft(h_l))
figure(6)
plot2d("nl", frequencies, filt, color("blue"))
xlabel("Frequency, Hz", 'fontsize', 2)
ylabel("Freq amplitude", 'fontsize', 2)
title("Frequency response of the final lowpass FIR filter", 'fontsize', 3)
xs2png(gcf(),BASE + "freq_resp_lowpass.png")
close()


h_len = length(H_H)
frequencies = (0:h_len-1)/h_len * Fs;
filt = abs(fft(h_h))
figure(6)
plot2d("nl", frequencies, filt, color("blue"))
xlabel("Frequency, Hz", 'fontsize', 2)
ylabel("Freq amplitude", 'fontsize', 2)
title("Frequency response of the final highpass FIR filter", 'fontsize', 3)
xs2png(gcf(),BASE + "freq_resp_highpass.png")
//close()


/*
    APPLYING THE FILTERS
*/
len = length(s)
frequencies = (0:len-1)/len * Fs;
signal = abs(fft(s))
convolution = convol(convol(s,h_l), h_h)
len = length(convolution)
frequencies_conv = (0:len-1)/len * Fs;

figure(8)
plot2d("nl", frequencies, signal, color("red"))
plot2d("nl", frequencies_conv, abs(fft(convolution)), color("blue"))
xlabel("Frequence, Hz", 'fontsize', 2)
ylabel("Freq amplitude", 'fontsize', 2)
title("Signals", 'fontsize', 3)
legend(['Original';'Filtered'])
xs2png(gcf(),BASE + "signal_filtered.png")
savewave(BASE + "signal_filtered.wav", convolution, 44100)
//close()
