clear all
clc
N=1000;
fs = 4e3; % sampling rate
f1 = 500; % signal frequency
noise=(randn(1,N)+1i*randn(1,N))/sqrt(2); % noise
signal1=exp(1i*2*pi*f1/fs*(0:N-1)+1i*2*pi*rand);

un=signal1+noise;
M=8; % the order of MVDR (the dimension of matrix); the higher the order is, the more accurate the result will be, and a larger amount of computation is required
cnt =0;
for k=1:M/2:N-M
    xs(:,k)=un(k+M-1:-1:k).';
    cnt=cnt+1;
end
R=xs*xs'/(cnt); % computation of a average value required in the MVDR algorithm

NF=2048;
for n=1:NF
    Aq=exp(-1i*2*pi*(n-1)/NF*(0:M-1)'); % vector A 
    
    Pmvdr(n)=1/(Aq'*inv(R)*Aq); % MVDR Pseudo spectral
end

%绘图

Pmvdr1=Pmvdr;
Pmvdr2=Pmvdr / max(Pmvdr1); % normalize the power spectrum
Pmvdr3=10*log10(Pmvdr); % transform data into Db values

figure();
plot((1:NF)/NF*fs,real(Pmvdr3));

[~, max] = max(Pmvdr);
