%%%% This MATLAB script imports and inspects the delays in original
%%%% measured data.
clear all
close all

fs = 48000;               % sampling rate
dis = 100;                 % source distance: select among {25, 40, 50, 60, 75 ,100}; unit: cm
datapath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\',num2str(dis),'cm');
cd(datapath)

% create matrices for storing signals
mat_delay = zeros(2,72);
mat_rs = zeros(2);
for n = 1:72
    ori = 5*(n-1);        % azimuth (in degrees), resolution: 5
    % binaural responses
    data_bs = importdata(strcat(num2str(ori),'.mat'));         % binaural signal data
    mat_delay(1,n) = cell2mat(data_bs.Delay(3,2));    % Channel 2: left ear
    mat_delay(2,n) = cell2mat(data_bs.Delay(2,2));    % Channel 1: right ear
end
delay_difference = mat_delay(2,:)-mat_delay(1,:);

% reference responses
data_rs_l =  importdata('left_mic.mat');                       % reference signal data
data_rs_r =  importdata('right_mic.mat');
mat_rs(1) = cell2mat(data_rs_l.Delay(2,2));
mat_rs(2) = cell2mat(data_rs_r.Delay(2,2));
delay_difference_reference = 10^6*mat_rs(1)-mat_rs(2)

azimuth = [0:5:359];
figure(1)
set(gcf,'Unit','Normalized');
set(gcf,'Position',[0.1 0.1 0.8 0.8])
scatter(azimuth,10^6*delay_difference,45,'r','filled');
xlim([0 360]);
ylim([-1200 1200]);
xlabel('Azimuth (degrees)');
ylabel('Difference (us)');
title(strcat('Difference in delay time ', num2str(dis),'cm'));
grid on;
set(gca,'FontSize', 18, 'FontName', 'Times New Roman');

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ITD\plots'
figurename1 = strcat('ori_delay_',num2str(dis),'.fig');
figurename2 = strcat('ori_delay_',num2str(dis),'.png');
saveas(gcf,figurename1);
saveas(gcf,figurename2);
close