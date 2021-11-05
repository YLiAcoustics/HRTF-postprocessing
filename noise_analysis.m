%%%% This MATLAB script produces and analyzes the frequency response of the 
%%%% measured noise by APx500.
%%%% Author: Yuqing Li
%%%% Last modified: 24.02.2021
clear
close all

fs = 48000;

% Specify parameters and import data
cd 'C:\Users\root\Documents\00 phd\measurement\210218 loudspeaker\210219\zero_input_acoustic_response\AR01'  
data01 = importdata('noise01.mat');  
faxis01 = cell2mat(data01.RMSLevel(4,1));
RMS_level01 = cell2mat(data01.RMSLevel(4,2));

cd 'C:\Users\root\Documents\00 phd\measurement\210218 loudspeaker\210219\zero_input_acoustic_response\AR02'  
data02 = importdata('AR02.mat');  
faxis02 = cell2mat(data02.RMSLevel(4,1));
RMS_level02 = cell2mat(data02.RMSLevel(4,2));

cd 'C:\Users\root\Documents\00 phd\measurement\210218 loudspeaker\210219\zero_input_acoustic_response\AR03'  
data03 = importdata('AR03.mat');  
faxis03 = cell2mat(data03.RMSLevel(4,1));
RMS_level03 = cell2mat(data03.RMSLevel(4,2));

% figure(1)
% plot(faxis,smooth(RMS_level,10),'LineWidth',1);
% xlim([20 20000]);
% xlabel('frequency (Hz)');
% ylabel('magnitude (dB)');
% title('noise spectrum');
% ax = gca;
% ax.XScale = 'log';
% ax.FontSize = 16;
% xticks([20 30 50 100 200 300 500 1000 3000 5000 10000 20000]);
% grid on;

ave_RMS_level = (RMS_level01+RMS_level02+RMS_level03)/3;

figure(2)
plot(faxis01,smooth(ave_RMS_level,10),'LineWidth',1);
xlim([20 20000]);
xlabel('frequency (Hz)');
ylabel('magnitude (dB)');
title('noise spectrum (averaged)');
ax = gca;
ax.XScale = 'log';
ax.FontSize = 18;
ax.FontName = 'Times New Roman';
xticks([20 30 50 100 200 300 500 1000 3000 5000 10000 20000]);
grid on;