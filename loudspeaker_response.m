 %%%% This MATLAB script produces and analyzes the frequency response of the 
%%%% loudspeaker under test.
%%%% Author: Yuqing Li
%%%% Last modified: 24.02.2021

clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\0729loudspeaker\Loudspeaker measurement 0804\loudspeaker response 0810\data'  

%% 0. Specify parameters and import data
data = importdata('measurement_0.mat');  
ir = data.ave_ir;
FR = data.ave_FR;
fs = data.fs;

% normalize
ir = ir/max(abs(ir));
FR = fft(ir);

N = length(ir);
FS = 2*FR(1:ceil(N/2));
FS(1) = FS(1)/2;

faxis = [0:ceil(N/2)-1]*fs/N;

% t_pre = 0.05;
% win_dur = 0.005;
% fft_raw_ir = fft(raw_ir);
% FS_raw_ir = 2*fft_raw_ir(1:ceil(length(fft_raw_ir)/2));
% FS_raw_ir(1) = FS_raw_ir(1)/2;
% raw_faxis = [0:ceil(length(fft_raw_ir)/2)-1]*fs/length(fft_raw_ir);
% % plot acquired waveform spectrum
% N_aw = length(Acquired_waveform);
% fft_aw = fft(Acquired_waveform);
% spec_aw = 2*fft_aw(1:ceil(N_aw/2))/N_aw;   % double the DFT magnitude for 1-sided spectrum
% spec_aw(1) = fft_aw(1)/N_aw;            % DC magnitude remains the same
% 
% faxis_aw = [0:ceil(N_aw/2)-1]/N_aw*fs;
% figure(1)
% plot(faxis_aw,20*log10(abs(spec_aw/(20*10^(-6)))));
% title('Frequency Spectrum of Acquired Waveform');
% xlabel('frequency(Hz)');
% ylabel('magnitude(dB)');
% xlim([20 20000]);
% ax = gca;
% ax.XScale = 'log';
% 
% % calculate frequency-independent SNR
% plot raw impulse response
figure(1)
set(gcf,'Unit','normalized');
set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(1000*[0:N-1]/fs,ir,'k','LineWidth',1);
xlabel('time (ms)');
ylabel('magnitude');
title('Impulse Response');
ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 18;

figure(2)
set(gcf,'Unit','normalized');
set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(faxis,smooth(20*log10(abs(FS)),50),'k','LineWidth',1);
xlabel('frequency (Hz)');
ylabel('magnitude (dB)');
title('Frequency Spectrum');
ax = gca;
ax.XScale = 'log';
ax.FontName = 'Arial';
ax.FontSize = 18;
xlim([20 20000]);
xticks([20 30 50 100 200 300 500 1000  2000 3000 5000 10000 20000]);
grid on;

% 
% figure(3)
% set(gcf,'Unit','normalized');
% set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% plot(tvec,20*log10(raw_ir/(20*10^(-6))),'LineWidth',1);
% xlabel('time (s)');
% ylabel('magnitude (dB)');
% title('Energy time curve');
% ax = gca;
% ax.FontName = 'Times New Roman';
% ax.FontSize = 18;
% xlim([0 0.05]);
% 
% noise = raw_ir([round(2*fs):end]);
% % SNR = 10*log10(mean(raw_ir.^2)/mean(noise.^2));
% fft_noise = fft(noise);
% spec_noise = 2*fft_noise(1:ceil(length(noise)/2));
% spec_noise(1) = fft_noise(1);
% faxis_noise = [0:ceil(length(noise)/2)-1]/length(noise)*fs;
% figure(4)
% plot(faxis_noise,20*log10(abs(spec_noise/(20*10^(-6)))));
% title('Frequency Spectrum of Noise');
% xlabel('frequency(Hz)');
% ylabel('magnitude(dB)');
% xlim([20 20000]);
% ax = gca;
% ax.XScale = 'log';

% %% 1. Time windowing and FFT
% % find the 1st peak in the impulse response
% [M,I] = max(abs(raw_ir));             % store the peak values and indices
% 
% % specify time window lengths (in samples)
% L1 = 10;                            % length of half Hann window 1 
% L2 = 20;                            % pad before peak
% L3 = floor(win_dur*fs);                           % pad after peak
% L4 = 10;                           % length of half Hann window 2
% assert(L1+L2+fs*t_pre<I)         % Check if window length is shorter than the initial delay. assert: through error if condition false
% L = L1+L2+L3+L4;              % total number of samples
% 
% w1 = hann(2*L1);                       
% w1 = w1(1:L1);                    % half Hann window 1 (before peak)
% w2 = hann(2*L4);
% w2 = w2(L4+1:end);                 % half Hann window 2 (after peak)
% 
% N = 1024;                          % signal length (in samples)
% win_vec = zeros(L,1);              
% win = zeros(L,1);
% win(1:L1) = w1;
% win(L1+1:L1+L2+L3) = 1;
% win(L1+L2+L3+1:L1+L2+L3+L4) = w2;
% win = [zeros(I-L1-L2+1,1);win];
% win = [win;zeros(length(raw_ir)-length(win),1)];
% 
% a = I - (L1+L2);                   % start point of windowing
% b = I - L2;
% c = I + L3;
% d = I + (L3+L4);                   % end point of windowing
% 
% % apply time window
% win_vec(1:L1) = raw_ir(a:(b-1)).*w1;
% win_vec(L1+1:L1+L2+L3) = raw_ir(b:(c-1));
% win_vec(L1+L2+L3+1:L1+L2+L3+L4) = raw_ir(c:(d-1)).*w2;
% 
% % zeropad to make the final ir with a length of N
% ir = [win_vec;zeros(N-L,1)];
% 
% FR = fft(ir);           % frequency response
% 
% %% 2. Plot results
% FR_spec = 2*FR(1:ceil(N/2));   % double the DFT magnitude for 1-sided spectrum
% FR_spec(1) = FR(1);            % DC magnitude remains the same
% 
% faxis = [0:ceil(N/2)-1]/N*fs;
% 
% % plot impulse response
% taxis = 1000*[0:N-1]/fs;
% figure(1)
% set(gcf,'Unit','normalized');
% set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% plot(taxis,ir,'LineWidth',1);
% xlabel('time (ms)');
% ylabel('magnitude (Pa/V)');
% title('Impulse Response');
% xlim([0 1000*(N-1)/fs]);
% % ylim([-0.015 0.015]);
% ax = gca;
% ax.FontName = 'Times New Roman';
% ax.FontSize = 18;
% 
% grid on;
% 
% % plot impulse response in dB
% figure(4)
% set(gcf,'Unit','normalized');
% set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% plot(taxis,20*log10(abs(ir/(20*10^(-6)))),'LineWidth',1);
% xlabel('time (ms)');
% ylabel('magnitude (dB)');
% title('Impulse Response in dB');
% xlim([0 1000*(N-1)/fs]);
% % ylim([-0.015 0.015]);
% ax = gca;
% ax.FontName = 'Times New Roman';
% ax.FontSize = 18;
% 
% grid on;
% 
% % plot frequency response
% figure(5)
% set(gcf,'Unit','normalized');
% set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% plot(faxis,20*log10(abs(FR_spec/(20*10^(-6)))),'LineWidth',1);
% xlim([1/win_dur 20000]);
% ylim([-10 90]);
% xlabel('frequency (Hz)');
% ylabel('magnitude (dB)');
% title('Frequency Spectrum');
% xticks([20 30 50 100 200 300 500 1000  2000 3000 5000 10000 20000]);
% ax = gca;
% ax.XScale = 'log';
% ax.FontName = 'Times New Roman';
% ax.FontSize = 18;
% grid on;
% 
% % plot THD ratio
% % orig_faxis = cell2mat(data.THDRatio(4,1));
% % figure(3)
% % set(gcf,'Unit','normalized');
% % set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% % plot(orig_faxis,THD_ratio,'LineWidth',1);
% % xlabel('frequency (Hz)');
% % ylabel('%');
% % title('THD ratio (from APx500)');
% % xlim([20 20000]);
% % ylim([0 100]);
% % xticks([20 30 50 100 200 300 500 1000 3000 5000 10000 20000]);
% % yticks([0:10:100]);
% % ax = gca;
% % ax.XScale = 'log';
% % ax.FontName = 'Times New Roman';
% % ax.FontSize = 18;
% % grid on;
