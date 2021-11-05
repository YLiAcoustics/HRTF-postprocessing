%%%% This MATLAB script analyzes the loudspeaker directivity from the results of loudspeaker measurements.
%%%% Author: Yuqing Li
%%%% Last modified: 08/04/2021

clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\210324 Point source directivity\0324\vertical_microphone\01'  

%% 0. Specify parameters and import data
data = importdata('measurement01.mat');  
raw_t = cell2mat(data.ImpulseResponse(4,1));
raw_ir = cell2mat(data.ImpulseResponse(4,2));
THD_ratio = cell2mat(data.THDRatio(4,2));
THD_level = cell2mat(data.THDLevel(4,2));
RMS_level = cell2mat(data.RMSLevel(4,2));
raw_f = cell2mat(data.RMSLevel(4,1));
Energy_Time_Curve = cell2mat(data.EnergyTimeCurve(4,2));

fs = 48000;                % Sampling rate
t_pre = 0.05;              % length of extended acquisition (s)
t_windur = 0.01;           % window duration (s) %% ATTENTION: determines frequency resolution for fft: f_reso = 1/t_windur

%% 1. Time windowing and FFT
% find the 1st peak in the impulse response
[M,I] = max(abs(raw_ir));             % store the peak values and indices

% specify time window lengths (in samples)
L1 = 20;                            % length of half Hann window 1 
L2 = 10;                            % pad before peak
L4 = 50;                           % length of half Hann window 2
L3 = floor(fs*t_windur)-L1-L2-L4;   % pad after peak
assert(L1+L2+fs*t_pre<I)           % Check if window length is shorter than the initial delay. assert: through error if condition false
L = L1+L2+L3+L4;                   % total number of samples in the truncated signal

w1 = hann(2*L1+1);                       
w1 = w1(1:L1);                    % half Hann window 1 (before peak)
w2 = hann(2*L4+1);
w2 = w2(L4+2:end);                 % half Hann window 2 (after peak)

win = [w1;ones(L2+L3,1);w2];
win = [zeros(I-L1-L2+1,1);win];
win = [win;zeros(length(raw_ir)-length(win),1)];

% apply time window
new_ir = raw_ir.*win;

% truncate the new ir to the length of N
N = 2^nextpow2(L);                   % FFT length (find the next power of 2 that is no less than L)
final_ir = new_ir([I-L1-L2:I-L1-L2+N-1]);

% FFT: frequency response
FR = fft(final_ir);           

%% 2. Plot results
% Generate the spectrum
P2 = abs(FR);
P1 = 2*P2(1:floor(N/2)+1);
P1(1) = P1(1)/2;
P1(end) = P1(end)/2;

faxis = [0:floor(N/2)]/N*fs;

% plot raw impulse response
figure(1)
set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(1000*raw_t,raw_ir/max(abs(raw_ir)),'LineWidth',1);hold on;
% plot time window
plot(1000*raw_t,win,'--r','LineWidth',0.8);
xlabel('time (ms)'); ylabel('magnitude (Pa/V)'); title('raw Impulse Response (normalized)');
xlim(1000*[min(raw_t) 4*L/fs]); % ylim([-0.015 0.015]);
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 18;
grid on;
% saveas(gcf,'raw IR.png');
% saveas(gcf,'raw IR.fig');
% close

% plot processed impulse response
taxis = 1000*[0:N-1]/fs;
figure(2)
set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(taxis,final_ir/max(abs(final_ir)),'LineWidth',1);
xlabel('time (ms)'); ylabel('magnitude (Pa/V)'); title('processed Impulse Response (normalized)');
xlim([0 1000*(N-1)/fs]); ylim([-1 1]);
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 18;
grid on;
% saveas(gcf,'processed IR.png');
% saveas(gcf,'processed IR.fig');
% close

% % plot impulse response in dB
% figure(3)
% set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% plot(taxis,20*log10(abs(ir)),'LineWidth',1);
% xlabel('time (ms)'); ylabel('magnitude (dB)'); title('Impulse Response in dB'); 
% xlim([0 1000*(N-1)/fs]); % ylim([-0.015 0.015]);
% ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 18;
% grid on;

% plot computed frequency response
figure(4)
set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(faxis,20*log10(abs(P1/(20*10^(-6)))),'LineWidth',1);
xlim([1/t_windur 20000]); ylim([min(20*log10(abs(P1/(20*10^(-6)))))-10 max(20*log10(abs(P1/(20*10^(-6)))))+10]);
xlabel('frequency (Hz)'); ylabel('magnitude (dB)'); title('Frequency Spectrum');
xticks([20 30 50 100 200 300 500 1000  2000 3000 5000 10000 20000]);
ax = gca; ax.XScale = 'log'; ax.FontName = 'Times New Roman'; ax.FontSize = 18;
grid on;
% saveas(gcf,'Spectrum.png');
% saveas(gcf,'Spectrum.fig');
% close

% % compare computed frequency response to AP data
figure(5)
set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot(faxis,20*log10(abs(P1/(20*10^(-6)))),'LineWidth',1);hold on;
plot(cell2mat(data.RMSLevel(4,1)),cell2mat(data.RMSLevel(4,2)),'LineWidth',1);
xlim([1/t_windur 20000]);  ylim([min(20*log10(abs(P1/(20*10^(-6)))))-10 max(20*log10(abs(P1/(20*10^(-6)))))+10]);
xlabel('frequency (Hz)'); ylabel('magnitude (dB)'); 
legend({'computed Frequency Spectrum','Frequency Spectrum (RMS) from AP'});
title('Frequency Spectrum comparison');
xticks([20 30 50 100 200 300 500 1000 2000 3000 5000 10000 20000]);
ax = gca; ax.XScale = 'log'; ax.FontName = 'Times New Roman'; ax.FontSize = 18;
grid on;
% saveas(gcf,'Spectrum comparison.png');
% saveas(gcf,'Spectrum comparison.fig');
% close
