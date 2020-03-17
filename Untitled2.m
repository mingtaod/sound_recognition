n = 1:100;
fs = 4e3;
x = sin(2*pi*200/fs*n);
f= 1:1e3;

figure();
plot(n, x);