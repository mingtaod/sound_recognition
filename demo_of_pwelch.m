n = 1:1e5;
fs = 4e3;
x = sin(2*pi*200/fs*n);
f= 1:1e3;
[p,f] = pwelch(x,[],[],fs);
figure();
plot(f/2/pi*fs,10*log10(abs(p)));

s_f = fft(x, fs);
figure();
plot(1:length(s_f), s_f);