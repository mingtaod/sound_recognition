clear all
clc
N=1000;
fs = 4e3;%采样率
f1 = 500;%信号频率
noise=(randn(1,N)+1i*randn(1,N))/sqrt(2);%噪声
signal1=exp(1i*2*pi*f1/fs*(0:N-1)+1i*2*pi*rand);

un=signal1+noise;
M=8;%MVDR阶数，也是矩阵维度，维度越高估计频率越准，计算量越大
cnt =0;
for k=1:M/2:N-M
    xs(:,k)=un(k+M-1:-1:k).';
    cnt=cnt+1;
end
R=xs*xs'/(cnt);%MVDR算法中隐含了求平均的内容，在代码中体现了。

NF=2048;
for n=1:NF
    Aq=exp(-1i*2*pi*(n-1)/NF*(0:M-1)');%讲解中的a向量
    Pmvdr(n)=1/(Aq'*inv(R)*Aq);%mvdr 的伪谱
end

%绘图

Pmvdr1=Pmvdr;
Pmvdr2=Pmvdr / max(Pmvdr1); %将功率谱进行归一化
Pmvdr3=10*log10(Pmvdr); %数据化为分贝值

figure();
plot((1:NF)/NF*fs,real(Pmvdr3));

[~, max] = max(Pmvdr);
