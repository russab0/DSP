/*
    PREPARATION
*/
clear()
BASE = "/home/sabzirov/Desktop/Spring20/DSP/assignment5/"
rand('seed', 15)
exec(BASE + 'dft_fft.sce')

x = 0:%pi/2:65
plot2d(x, cos(x))
close()



function [t,signal] = gen_signal(Func,f,A,fs,T)
    /*
        Func = function
        f - sygnal frequency (cжимает функцию), 
        A - amplitude, 
        fs - sampling frquency (частота дискретизации)
        T - time
    */
    dt = 1 / fs; 
    t = 0 : dt : T-dt;
    signal = Func(t .* (2 * %pi * f)) .* A
    t = t / dt
endfunction


/*
    ====== TASK 2 ======
*/


/*
    Single sin signals
*/

sin_fs = 128
f1 = 64; [t1,sin1] = gen_signal(cos, f1, 1, sin_fs, 1.25)
f2 = 30; [t2,sin2] = gen_signal(cos, f2, 1, sin_fs, 1.25)
f3 = 10; [t3,sin3] = gen_signal(cos, f3, 1, sin_fs, 1.25)


f = scf(); clf()
f.figure_size=[1200, 700];

subplot(211)
plot(t1, sin1, "b-o-")
plot(t2, sin2, "g-o-")
plot(t3, sin3, "r-o-")
xlabel("Time, t (s)", 'fontsize', 3)
ylabel("Amplitude", 'fontsize', 3)
title("sin signals, sampling rate: " + string(sin_fs) + " Hz", 'fontsize', 4)
legend([string(f1) + ' Hz'; string(f2) + ' Hz'; string(f3) + ' Hz']);


subplot(212)
plot(t1 / length(t1), abs(fft(sin1)),"b-o-")
plot(t2 / length(t2), abs(fft(sin2)),"g-o-")
plot(t3 / length(t3), abs(fft(sin3)),"r-o-")
xlabel("Normalized frequency", 'fontsize', 3)
ylabel("Magnitude", 'fontsize', 3)
legend([string(f1) + ' Hz'; string(f2) + ' Hz'; string(f3) + ' Hz']);
xs2png(f, BASE + "single_sin_signals")
close()


/*
    Combined sin signals
*/

sin_sum = sin1+sin2+sin3
f = scf(); clf()
f.figure_size=[1200, 700];

subplot(211)
plot(t1, sin_sum,"b-o-")
xlabel("Time, t (s)", 'fontsize', 3)
ylabel("Amplitude", 'fontsize', 3)
title("sin signals summed, sampling rate: " + string(sin_fs) + " Hz", 'fontsize', 4)
legend([string(f1) + ', ' + string(f2) + ', ' + string(f3)]);

disp(length(t1))
subplot(212)
plot(t1 / length(t1), abs(fft(sin_sum)),"b-o-")
xlabel("Normalized frequency", 'fontsize', 3)
ylabel("Magnitude", 'fontsize', 3)
legend([string(f1) + ', ' + string(f2) + ', ' + string(f3)]);
xs2png(f, BASE + "combined_sin_signals")
close()


/*
    Effect of amplitude
*/
f = scf(); clf()
f.figure_size=[1000, 1000];
to_draw = [sin1; sin1 .* 2; sin_sum; sin_sum .* 2]

for i = 0:3
    disp(i + 1)
    x = t1
    y = to_draw(i + 1, :)
    
    subplot(4, 2, i * 2 + 1)
    plot(x, y,"b-o-")
    xlabel("Time, t (s)", 'fontsize', 1)
    ylabel("Amplitude", 'fontsize', 1)
    title("sin signal time", 'fontsize', 3)
    
    subplot(4, 2, i * 2 + 2)
    plot(x / length(x), abs(fft(y)),"b-o-")
    xlabel("Normalized frequency", 'fontsize', 1)
    ylabel("Magnitude", 'fontsize', 1)
    title("sin signal frquencies", 'fontsize', 3)
end
xs2png(f, BASE + "amplitude_effect")
close()
