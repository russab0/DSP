/*
    PREPARATION
*/
clear()
BASE = "/home/sabzirov/Desktop/Spring20/DSP/assignment5/"
rand('seed', 15)


/*
    TASK1
    Implement your function for DFT in SciLab. Verify your functions
*/

DFT_MIN_SIZE = 8

function X = my_dft(x, inverse)
    N = length(x)
    if ~exists("inverse","local") then
        inverse = %F // false
    end
    /*X = zeros(N)
    for k = 1:N
        X(k)= 0
        for n = 1:N
            X(k) = X(k) + x(n) * exp(-2 * %i * %pi * n * k / N)
        end
    end*/
    n = 0:N-1 // list of integers from range [0; N)
    k = matrix(n, N, 1)  // each number is located on separate row
    if ~inverse then
        w = exp(-2 * %i * %pi * k * n / N)
    else
        w = exp(+2 * %i * %pi * k * n / N)
    end
    
    ans = zeros(N, 1)
    for i = 1:N
        ans(i) = sum(w(i, :) .* x) // multiplication on two matrices
    end 
    X = ans
endfunction


/*function X = my_fft(arr, inverse, N_init)
    if ~exists("inverse","local") then
        inverse = %F // false
    end
    if ~exists("N_init","local") then
        N_init = %nan // NaN
    end
    
    N = 2 ^ ceil(log2(length(arr)))
    arr = cat(2, zeros(1, N - length(arr)), arr)

    if N_init == %nan then // means that this is top level of recursion
        N_init = N  // fixing the size of array at the top level of recursion
    end
    
    if N <= DFT_MIN_SIZE then  // recursion base case: array size is to big to perform recursion
        X = my_dft(arr, inverse)
        return
    end
    arr_even = my_fft(arr(1:2:length(arr)), inverse, N_init)  // FFT1d on array elements with even indexes
    arr_odd  = my_fft(arr(2:2:length(arr)), inverse, N_init)  // FFT1d on array elements with odd indexes

    n = 0:N-1
    if ~inverse then
        w = exp(-2 * %i * %pi * n / N)'
    else
        w = exp(+2 * %i * %pi * n / N)' 
    end
    
    first_part = arr_even + w(1:floor(N / 2)) .* arr_odd // first half of coefficients
    second_part = arr_even + w(floor(N / 2)+1:N) .* arr_odd  // second half of coefficients
    ans = cat(1, first_part, second_part)  // concatenating two halfs
    
    if inverse & N_init == N then  // we need to normalize only if it top-level of inverse function
        ans = ans / N
    end
    X = ans
    return
endfunction*/

function X = my_fft(x)
  N = length(x)
  
  if (N <= 1) then
    X = x
  elseif (modulo(N,2)>0) then
        error('We assert signal length to be a power of 2 | N!=2^M')
  else
    X_even = my_fft(x(1:2:$)) 
    X_odd = my_fft(x(2:2:$))
    
    k = [0:1:N/2-1]
    factor = exp(k .* (-2*%i*%pi/N))
    factor = factor .* X_odd
   
    X = [X_even + factor, X_even - factor]
  end
endfunction

s=[1,2,3,4,5] 
s=rand(1, 1024, 'norm') .* 100
s_len = length(s)
frequencies = (0:s_len-1)/s_len;

figure(2)
f = gcf()
f.figure_size=[1000, 800]
clf()
subplot(221)
plot2d("nl", frequencies, abs(fft(s)), color("blue"))
xlabel("Frequency component, n", 'fontsize', 2)
ylabel("Freq Amplitude", 'fontsize', 2)
title("Signal in frequency domain (build-in FFT)", 'fontsize', 3)


subplot(222)
q = abs(my_dft(s))
plot2d("nl", frequencies, q, color("red"))
xlabel("Frequency component, n", 'fontsize', 2)
ylabel("Freq Amplitude", 'fontsize', 2)
title("Signal in frequency domain (my own )", 'fontsize', 3)



subplot(223)
plot2d("nl", frequencies, abs(fft(s)), color("blue"))
xlabel("Frequency component, n", 'fontsize', 2)
ylabel("Freq Amplitude", 'fontsize', 2)
title("Signal in frequency domain (build-in FFT)", 'fontsize', 3)



subplot(224)
q = abs(my_fft(s))
plot2d("nl", frequencies, q, color("violet"))
xlabel("Frequency component, n", 'fontsize', 2)
ylabel("Freq Amplitude", 'fontsize', 2)
title("Signal in frequency domain (my own FFT)", 'fontsize', 3)

xs2png(gcf(), BASE + "dft_evalutaion")
//close() // close immediately after saving
