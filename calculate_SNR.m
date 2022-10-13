%%%% This MATLAB script calculates the signal to noise ratio from raw
%%%% recordings.
%%%% Last edited: Yuqing Li, 14/01/2022

clear
close all

fs = 48000;

ori = 90;
%% import noise and calculate spectrum
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220111ContinuousDistanceHRTF\0121'
noise_01 = audioread(['bin_noise_' num2str(ori) '_01.wav']);
noise_02 = audioread(['bin_noise_' num2str(ori) '_02.wav']);
noise_03 = audioread(['bin_noise_' num2str(ori) '_03.wav']);

% split the recording
L = (30.034+3)*fs;        % length of each round, in samples

R_01_1 = noise_01(0.5*fs+[1:L],:);
R_01_2 = noise_01(0.5*fs+[L+1:2*L],:);
R_01_3 = noise_01(0.5*fs+[2*L+1:3*L],:);
R_01_4 = noise_01(0.5*fs+[3*L+1:4*L],:);

R_02_1 = noise_02(0.5*fs+[1:L],:);
R_02_2 = noise_02(0.5*fs+[L+1:2*L],:);
R_02_3 = noise_02(0.5*fs+[2*L+1:3*L],:);
R_02_4 = noise_02(0.5*fs+[3*L+1:4*L],:);

R_03_1 = noise_03(0.5*fs+[1:L],:);
R_03_2 = noise_03(0.5*fs+[L+1:2*L],:);
R_03_3 = noise_03(0.5*fs+[2*L+1:3*L],:);
R_03_4 = noise_03(0.5*fs+[3*L+1:4*L],:);

% take fft, calculate power and average 
ave_pow_noise = (abs(fft(R_01_1)).^2+abs(fft(R_01_2)).^2+abs(fft(R_01_3)).^2+abs(fft(R_01_4)).^2+...
                abs(fft(R_02_1)).^2+abs(fft(R_02_2)).^2+abs(fft(R_02_3)).^2+abs(fft(R_02_4)).^2+...
                abs(fft(R_03_1)).^2+abs(fft(R_03_2)).^2+abs(fft(R_03_3)).^2+abs(fft(R_03_4)).^2)/12;
ave_pow_noise = ave_pow_noise/length(ave_pow_noise);
one_sided_p_noise = 2*ave_pow_noise(1:ceil(length(ave_pow_noise)/2),:);
one_sided_p_noise(1,:) = one_sided_p_noise(1,:)/2;


%% import recorded signal(s)
sig_01 = audioread(['bin_f_ave_' num2str(ori) '.wav']);
sig_02 = audioread(['bin_b_ave_' num2str(ori) '.wav']);

SNR_01(1) = snr(sig_01(:,1),R_01_1(:,1));
SNR_01(2) = snr(sig_01(:,2),R_01_2(:,2));
% % take fft, calculate power and average
% ave_pow_sig = (abs(fft(sig_01)).^2+abs(fft(sig_02)).^2)/2;
% ave_pow_sig = ave_pow_sig/length(ave_pow_sig);
% one_sided_p_sig = 2*ave_pow_sig(1:ceil(length(ave_pow_sig)/2),:);
% one_sided_p_sig(1,:) = one_sided_p_sig(1,:)/2;
% 
% faxis = [0:ceil(length(ave_pow_sig)/2)-1]/length(ave_pow_sig)*fs;

% figure(1)
% set(gcf,'Units','Normalized');
% set(gcf,'Position',[0.1 0.1 0.7 0.8]);
% plot(faxis,smooth(20*log10(abs(one_sided_p_noise(:,1))),100));hold on;
% plot(faxis,smooth(20*log10(abs(one_sided_p_noise(:,2))),100));
% grid on
% xlabel('frequency(Hz)');
% ylabel('magnitude(dB)');
% legend('left ear','right ear');
% title(['Noise Spectrum']);
% xlim([100 20000]);
% xticks([100 200 300 500 1000 2000 3000 5000 10000 16000 20000]);
% xtickangle(45);
% ax = gca;
% ax.XScale = 'log';

% figure(1)
% set(gcf,'Units','Normalized');
% set(gcf,'Position',[0.1 0.1 0.7 0.8]);
% plot(faxis,smooth(10*log10(abs(one_sided_p_sig(:,1))) - 10*log10(abs(one_sided_p_noise(:,1))),100));hold on;
% plot(faxis,smooth(10*log10(abs(one_sided_p_sig(:,2))) - 10*log10(abs(one_sided_p_noise(:,2))),100));
% grid on
% xlabel('frequency(Hz)');
% ylabel('magnitude(dB)');
% legend('left ear','right ear');
% title(['SNR at ' num2str(ori) char(176)]);
% xlim([50 20000]);
% xticks([20 30 50 100 200 300 500 1000 2000 3000 5000 10000 16000 20000]);
% xtickangle(45);
% ax = gca;
% ax.XScale = 'log';

