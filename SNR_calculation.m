%%%% This MATLAB script takes in a measured impulse response and calculates
%%%% the frequency independent SNR.

clear all
close all

fs = 44100;
%% 0. import data
cd 'C:\Users\root\Documents\00 phd\measurement\0729loudspeaker\Loudspeaker measurement 0804\loudspeaker response 0810\data'
target_ir = importdata('measurement_0_ir.mat');
figure(1)
plot(target_ir);

%% 1. calculate SNR
% find peak
[M I] = max(abs(target_ir));
windowed_ir = target_ir(I-100+1:I+4900);
N = length(windowed_ir);
noise = target_ir(end-N+1:end);
SNR = 10*log10(mean(target_ir.^2)/mean(noise.^2));
fft_noise = fft(noise);
spec_noise = 2*fft_noise(1:ceil(length(noise)/2));
spec_noise(1) = fft_noise(1);
faxis_noise = [0:ceil(length(noise)/2)-1]/length(noise)*fs;

fft_windowed_ir = fft(windowed_ir);
FR_windowed_ir = 2*fft_windowed_ir(1:ceil(length(windowed_ir)/2));
FR_windowed_ir(1) = FR_windowed_ir(1)/2;

faxis = [0:ceil(N/2)-1]/N*fs;

%% 2. plot results
figure(2)
set(gcf,'Unit','normalized');
set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(faxis,20*log10(abs(FR_windowed_ir)),'LineWidth',1);
hold on;
plot(faxis,20*log10(abs(spec_noise)),'LineWidth',1);
grid on;
title('Frequency Response');
xlabel('frequency (Hz)');
ylabel('magnitude (dB)');
xlim([20 20000]);
xticks([20 30 50 100 200 300 500 1000  2000 3000 5000 10000 20000]);
ax = gca;
ax.XScale = 'log';
grid on;