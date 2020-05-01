/*
    PREPARATION
*/
clear();
BASE = "/home/sabzirov/Desktop/Spring20/DSP/assignment5/";
rand('seed', 15);
exec(BASE + 'dft_fft.sce')


s=rand(1, 1024, 'norm') .* 100;
s_len = length(s);
frequencies = (0:s_len-1)/s_len;


f = scf();  clf(); 
f.figure_size=[1000, 800];
subplot(221);
plot2d("nl", frequencies, abs(fft(s)), color("blue"));
xlabel("Frequency component, n", 'fontsize', 2);
ylabel("Freq Amplitude", 'fontsize', 2);
title("Signal in frequency domain (build-in FFT)", 'fontsize', 3);


subplot(222);
q = abs(my_dft(s));
plot2d("nl", frequencies, q, color("red"));
xlabel("Frequency component, n", 'fontsize', 2);
ylabel("Freq Amplitude", 'fontsize', 2);
title("Signal in frequency domain (my own DFT)", 'fontsize', 3);



subplot(223);
plot2d("nl", frequencies, abs(fft(s)), color("blue"));
xlabel("Frequency component, n", 'fontsize', 2);
ylabel("Freq Amplitude", 'fontsize', 2);
title("Signal in frequency domain (build-in FFT)", 'fontsize', 3);



subplot(224);
q = abs(my_fft(s));
plot2d("nl", frequencies, q, color("violet"));
xlabel("Frequency component, n", 'fontsize', 2);
ylabel("Freq Amplitude", 'fontsize', 2);
title("Signal in frequency domain (my own FFT)", 'fontsize', 3);

xs2png(gcf(), BASE + "dft_fft");
close(); // close immediately after saving
