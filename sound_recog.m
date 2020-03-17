clear all
clc

[x_in, fs] = audioread('Brian Crain - canon in d.mp3');

x = x_in(1:25 * fs, 1);
total = length(x);
point = total / fs;

window = 0.3 * fs;
win_move = window * 5 / 6;
count = 1;
freq = zeros(1, floor(total / win_move) - 1);

for n = 1:win_move:total - window
    s = x(n:n + window - 1);
    s_f = fft(s, fs);
    s_f_log = 10*log10(abs(s_f));
    
    for i = 1:20
        s_f_log(i) = -99;
    end
    
    for i = fs / 2.5:length(s_f_log)
        s_f_log(i) = -99;
    end
    
    [~, pst] = max(s_f_log);
    freq(count) = pst-1;
    count = count + 1;
end

count = count -1;

figure();
mdf1 = 1;
mdf2 = 0;
plot((mdf1:count-mdf2) * point / count, freq(mdf1:count-mdf2), 'Linewidth', 2);

figure();
freq_smooth = smooth(freq, 10);
plot((mdf1:count-mdf2) * point / count, freq_smooth(mdf1:count-mdf2), 'Linewidth', 2);

for n = mdf1:5:count-mdf2
    if freq(n) > 10 && freq(n) < 8e3
        [~, str] = freq2note(freq(n));
        text(n * point / count, freq(n) + 20, str);
    end
end