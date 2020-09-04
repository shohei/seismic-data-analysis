clear; close all; clc;

dat = readtable('seis.dat');
N = 5000;
dat = dat(1:N,:);
Fs = 100;
t = (0:1/Fs:(N-1)/Fs)';
NS=table2array(dat(:,1));
EW=table2array(dat(:,2));
UD=table2array(dat(:,3));
% subplot(311);
% plot(t,NS);
% subplot(312);
% plot(t,EW);
% subplot(313);
% plot(t,UD);

digFilt1 = designfilt('lowpassiir', 'PassbandFrequency', 20, 'StopbandFrequency', 25, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate', 100);
digFilt2 = designfilt('lowpassfir', 'PassbandFrequency', 20, 'StopbandFrequency', 25, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate', 100);

% grpdelay(digFilt1,500,Fs);
% hold on;
% grpdelay(digFilt1,500,Fs);
% 
% freqz(digFilt1);
% hold on;
% freqz(digFilt2);

NS_filt = filter(digFilt1, NS);
EW_filt = filter(digFilt1, EW);
UD_filt = filter(digFilt1, UD);

NS_filtfilt = filtfilt(digFilt1, NS);
EW_filtfilt = filtfilt(digFilt1, EW);
UD_filtfilt = filtfilt(digFilt1, UD);

% subplot(221);
% plot(t,UD);
% subplot(222);
% plot(t,UD_filt);
% subplot(223);
% spectrogram(UD,[],[],[],Fs,'yaxis');
% subplot(224);
% spectrogram(UD_filt,[],[],[],Fs,'yaxis');
% sgtitle('25Hz Low pass filter (IIR Butterworth)');
%sgtitle('25Hz Low pass filter (FIR Equiripple)');

% figure(3);
% plot(t,UD);
% hold on;
% plot(t,UD_filt);
% plot(t,UD_filtfilt);
% legend('original','LPF with delay','compensated LPF');

Nr = 1;
Dr = [1 -1];

UD_v = filter(Nr, Dr, detrend(UD_filtfilt))/Fs;
NS_v = filter(Nr, Dr, detrend(NS_filtfilt))/Fs;
EW_v = filter(Nr, Dr, detrend(EW_filtfilt))/Fs;
% UD_v = filter(Nr, Dr, UD_filtfilt)/Fs;
% NS_v = filter(Nr, Dr, NS_filtfilt)/Fs;
% EW_v = filter(Nr, Dr, EW_filtfilt)/Fs;

UD_p = filter(Nr, Dr, UD_v)/Fs;
NS_p = filter(Nr, Dr, NS_v)/Fs;
EW_p = filter(Nr, Dr, EW_v)/Fs;

plot(t,UD_p);
hold on;
plot(t,NS_p);
plot(t,EW_p);
legend('Vertical','N-S','E-W');

figure();
plot3(NS_p,EW_p,UD_p);
grid;

big;










