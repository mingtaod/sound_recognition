clear all
clc

[signal_in, fs] = audioread('Brian Crain - canon in d.mp3');
signal = signal_in(1:fs * 15, 1);

total = length(signal);
point = total / fs;
M = 8;
count = 0;
outer_cnt = 0;
NF = 2048;
win = 0.3 * fs;

mvdr_estimate = zeros(1, floor(total / win) - 1);

for n = 1:win:total-win
    
    signal_segment = signal(n:n + win - 1);
    outer_cnt = outer_cnt + 1;
    N = length(signal_segment);
    
    for k = 1:M/2:N-M
        xs(:, k) = signal_segment(k+M-1:-1:k).';
        count = count + 1;
    end
    
    R = xs * xs' / (count);
    count = 0;
    
    for i = 1:NF
        Aq=exp(-1i*2*pi*(i-1)/NF*(0:M-1)');
        Pmvdr(i)=1/(Aq'*inv(R)*Aq);
    end
    
    [~, identity] = max(Pmvdr);
    mvdr_estimate(outer_cnt) = identity;
    
end

figure();
mdf1 = 1;
mdf2 = 0;
plot((mdf1:outer_cnt-mdf2) * point / outer_cnt, mvdr_estimate(mdf1:outer_cnt-mdf2), 'Linewidth', 2);

figure();
mvdr_estimate_smooth = smooth(mvdr_estimate, 10);
plot((mdf1:outer_cnt-mdf2) * point / outer_cnt, mvdr_estimate_smooth(mdf1:outer_cnt-mdf2), 'Linewidth', 2);

for num = mdf1:5:outer_cnt-mdf2
    if mvdr_estimate(num) > 10 && mvdr_estimate(num) < 8e3
        [~, str] = freq2note(mvdr_estimate(num));
        text(num * point / outer_cnt, mvdr_estimate(num) + 20, str);
    end
end

