clear all
clc
N=1000;
fs = 4e3;%������
f1 = 500;%�ź�Ƶ��
noise=(randn(1,N)+1i*randn(1,N))/sqrt(2);%����
signal1=exp(1i*2*pi*f1/fs*(0:N-1)+1i*2*pi*rand);

un=signal1+noise;
M=8;%MVDR������Ҳ�Ǿ���ά�ȣ�ά��Խ�߹���Ƶ��Խ׼��������Խ��
cnt =0;
for k=1:M/2:N-M
    xs(:,k)=un(k+M-1:-1:k).';
    cnt=cnt+1;
end
R=xs*xs'/(cnt);%MVDR�㷨����������ƽ�������ݣ��ڴ����������ˡ�

NF=2048;
for n=1:NF
    Aq=exp(-1i*2*pi*(n-1)/NF*(0:M-1)');%�����е�a����
    Pmvdr(n)=1/(Aq'*inv(R)*Aq);%mvdr ��α��
end

%��ͼ

Pmvdr1=Pmvdr;
Pmvdr2=Pmvdr / max(Pmvdr1); %�������׽��й�һ��
Pmvdr3=10*log10(Pmvdr); %���ݻ�Ϊ�ֱ�ֵ

figure();
plot((1:NF)/NF*fs,real(Pmvdr3));

[~, max] = max(Pmvdr);
