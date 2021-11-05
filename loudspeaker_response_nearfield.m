%%%% This MATLAB script produces and analyzes the frequency response of the 
%%%% loudspeaker under test.
%%%% Author: Yuqing Li
%%%% Last modified: 24.02.2021

clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\210218 loudspeaker\210222\NF_loudspeaker'  

%% 0. Specify parameters and import data
data = importdata('NF_loudspeaker.mat');  
tvec = cell2mat(data.ImpulseResponse(4,1));
raw_ir = cell2mat(data.ImpulseResponse(4,2));
THD_ratio = cell2mat(data.THDRatio(4,2));
THD_level = cell2mat(data.THDLevel(4,2));
RMS_level = cell2mat(data.RMSLevel(4,2));

fs = 48000;
t_pre = 0.05;
win_dur = 0.02;

%% 1. Time windowing and FFT
% find the 1st peak in the impulse response
[M,I] = max(abs(raw_ir));             % store the peak values and indices

% specify time window lengths (in samples)
L1 = I-floor(t_pre*fs)-1;                           % pad before peak
L2 = floor(win_dur*fs);                    % pad after peak
L3 = 10;                            % length of half Hann window
L = L1+L2+L3;                      % total number of samples

w = hann(2*L3);
w = w(L3+1:end);                 % half Hann window 2 (after peak)
                        % signal length (in samples)
win_vec = zeros(L,1);      
win = zeros(L,1);
win(1:L1+L2) = 1;
win(L1+L2+1:L1+L2+L3) = w;
win = [win;zeros(length(raw_ir)-length(win),1)];

a = floor(t_pre*fs)+1;
b = I + L2;
c = I + L2 + L3;                   % end point of windowing

% apply time window
win_vec(1:L1+L2) = raw_ir(a:(b-1));
win_vec(L1+L2+1:L1+L2+L3) = raw_ir(b:(c-1)).*w;

% zeropad to make the final ir with a length of N
ir = win_vec;

FR = fft(ir);           % frequency response
N = length(FR);

%% 2. Plot results
FR_spec = 2*FR(1:ceil(N/2));   % double the DFT magnitude for 1-sided spectrum
FR_spec(1) = FR(1);            % DC magnitude remains the same

faxis = [0:ceil(N/2)-1]/N*fs;

% plot impulse response
taxis = 1000*[0:N-1]/fs;
figure(1)
set(gcf,'Unit','normalized');
set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(taxis,ir,'LineWidth',1);
xlabel('time (ms)');
ylabel('magnitude (Pa/V)');
title('Impulse Response');
xlim([0 1000*(N-1)/fs]);

ax = gca;
ax.FontName = 'Times New Roman';
ax.FontSize = 18;
grid on;

% plot frequency response
figure(2)
set(gcf,'Unit','normalized');
set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(faxis,20*log10(abs(FR_spec/(20*10^(-6)))),'LineWidth',1);
xlim([50 500]);
ylim([90 140]);
xlabel('frequency (Hz)');
ylabel('magnitude (dB)');
title('Low Frequency Spectrum');
xticks([20 30 50 100 200 300 500 1000 3000 5000 10000 20000]);
ax = gca;
ax.XScale = 'log';
ax.FontName = 'Times New Roman';
ax.FontSize = 18;
grid on;

% plot THD ratio
% orig_faxis = cell2mat(data.THDRatio(4,1));
% figure(3)
% set(gcf,'Unit','normalized');
% set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% plot(orig_faxis,THD_ratio,'LineWidth',1);
% xlabel('frequency (Hz)');
% ylabel('%');
% title('THD ratio (from APx500)');
% xlim([20 20000]);
% ylim([0 100]);
% xticks([20 30 50 100 200 300 500 1000 3000 5000 10000 20000]);
% yticks([0:10:100]);
% ax = gca;
% ax.XScale = 'log';
% ax.FontName = 'Times New Roman';
% ax.FontSize = 18;
% grid on;
