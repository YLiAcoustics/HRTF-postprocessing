%%%%%%% 
clear all
close all

%%%% Import data
% cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\25cm'
% data_measured_025_0 = importdata('0.mat');
% data_measured_025_30 = importdata('30.mat');
% data_measured_025_60 = importdata('60.mat');
% data_measured_025_90 = importdata('90.mat');
% data_measured_025_120 = importdata('120.mat');
% data_measured_025_150 = importdata('150.mat');
% data_measured_025_180 = importdata('180.mat');
% data_measured_025_210 = importdata('210.mat');
% data_measured_025_240 = importdata('240.mat');
% data_measured_025_270 = importdata('270.mat');
% data_measured_025_300 = importdata('300.mat');
% data_measured_025_330 = importdata('330.mat');
% 
% data_ref_l_025 =  importdata('left_mic.mat');
% data_ref_r_025 =  importdata('right_mic.mat');

ref_response_l_025 = cell2mat(data_ref_l_025.ImpulseResponse(4,:));
ref_response_r_025 = cell2mat(data_ref_r_025.ImpulseResponse(4,:));
% 
% % measured responses
taxis = cell2mat(data_measured_025_0.ImpulseResponse(4,1));

measured_response_025_0_r = fft(cell2mat(data_measured_025_0.ImpulseResponse(4,2)));
measured_response_025_30_r = fft(cell2mat(data_measured_025_30.ImpulseResponse(4,2)));
measured_response_025_60_r = fft(cell2mat(data_measured_025_60.ImpulseResponse(4,2)));
measured_response_025_90_r = fft(cell2mat(data_measured_025_90.ImpulseResponse(4,2)));
measured_response_025_120_r = fft(cell2mat(data_measured_025_120.ImpulseResponse(4,2)));
measured_response_025_150_r = fft(cell2mat(data_measured_025_150.ImpulseResponse(4,2)));
measured_response_025_180_r = fft(cell2mat(data_measured_025_180.ImpulseResponse(4,2)));
measured_response_025_210_r = fft(cell2mat(data_measured_025_210.ImpulseResponse(4,2)));
measured_response_025_240_r = fft(cell2mat(data_measured_025_240.ImpulseResponse(4,2)));
measured_response_025_270_r = fft(cell2mat(data_measured_025_270.ImpulseResponse(4,2)));
measured_response_025_300_r = fft(cell2mat(data_measured_025_300.ImpulseResponse(4,2)));
measured_response_025_330_r = fft(cell2mat(data_measured_025_330.ImpulseResponse(4,2)));

measured_response_025_0_l = fft(cell2mat(data_measured_025_0.ImpulseResponse(4,4)));
measured_response_025_30_l = fft(cell2mat(data_measured_025_30.ImpulseResponse(4,4)));
measured_response_025_60_l = fft(cell2mat(data_measured_025_60.ImpulseResponse(4,4)));
measured_response_025_90_l = fft(cell2mat(data_measured_025_90.ImpulseResponse(4,4)));
measured_response_025_120_l = fft(cell2mat(data_measured_025_120.ImpulseResponse(4,4)));
measured_response_025_150_l = fft(cell2mat(data_measured_025_150.ImpulseResponse(4,4)));
measured_response_025_180_l = fft(cell2mat(data_measured_025_180.ImpulseResponse(4,4)));
measured_response_025_210_l = fft(cell2mat(data_measured_025_210.ImpulseResponse(4,4)));
measured_response_025_240_l = fft(cell2mat(data_measured_025_240.ImpulseResponse(4,4)));
measured_response_025_270_l = fft(cell2mat(data_measured_025_270.ImpulseResponse(4,4)));
measured_response_025_300_l = fft(cell2mat(data_measured_025_300.ImpulseResponse(4,4)));
measured_response_025_330_l = fft(cell2mat(data_measured_025_330.ImpulseResponse(4,4)));


cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\40cm'
data_measured_040_0 = importdata('0.mat');
data_measured_040_30 = importdata('30.mat');
data_measured_040_60 = importdata('60.mat');
data_measured_040_90 = importdata('90.mat');
data_measured_040_120 = importdata('120.mat');
data_measured_040_150 = importdata('150.mat');
data_measured_040_180 = importdata('180.mat');
data_measured_040_210 = importdata('210.mat');
data_measured_040_240 = importdata('240.mat');
data_measured_040_270 = importdata('270.mat');
data_measured_040_300 = importdata('300.mat');
data_measured_040_330 = importdata('330.mat');

data_ref_l_040 =  importdata('left_mic.mat');
data_ref_r_040 =  importdata('right_mic.mat');

% measured responses
HRTF_040_0_r = cell2mat(data_measured_040_0.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_0_l = cell2mat(data_measured_040_0.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_30_r = cell2mat(data_measured_040_30.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_30_l = cell2mat(data_measured_040_30.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_60_r = cell2mat(data_measured_040_60.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_60_l = cell2mat(data_measured_040_60.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_90_r = cell2mat(data_measured_040_90.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_90_l = cell2mat(data_measured_040_90.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_120_r = cell2mat(data_measured_040_120.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_120_l = cell2mat(data_measured_040_120.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_150_r = cell2mat(data_measured_040_150.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_150_l = cell2mat(data_measured_040_150.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_180_r = cell2mat(data_measured_040_180.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_180_l = cell2mat(data_measured_040_180.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_210_r = cell2mat(data_measured_040_210.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_210_l = cell2mat(data_measured_040_210.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_240_r = cell2mat(data_measured_040_240.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_240_l = cell2mat(data_measured_040_240.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_270_r = cell2mat(data_measured_040_270.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_270_l = cell2mat(data_measured_040_270.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_300_r = cell2mat(data_measured_040_300.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_300_l = cell2mat(data_measured_040_300.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));
HRTF_040_330_r = cell2mat(data_measured_040_330.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_040.RMSLevel(4,:));
HRTF_040_330_l = cell2mat(data_measured_040_330.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_040.RMSLevel(4,:));

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\50cm'
data_measured_050_0 = importdata('0.mat');
data_measured_050_30 = importdata('30.mat');
data_measured_050_60 = importdata('60.mat');
data_measured_050_90 = importdata('90.mat');
data_measured_050_120 = importdata('120.mat');
data_measured_050_150 = importdata('150.mat');
data_measured_050_180 = importdata('180.mat');
data_measured_050_210 = importdata('210.mat');
data_measured_050_240 = importdata('240.mat');
data_measured_050_270 = importdata('270.mat');
data_measured_050_300 = importdata('300.mat');
data_measured_050_330 = importdata('330.mat');

data_ref_l_050 =  importdata('left_mic.mat');
data_ref_r_050 =  importdata('right_mic.mat');

% measured responses
HRTF_050_0_r = cell2mat(data_measured_050_0.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_0_l = cell2mat(data_measured_050_0.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_30_r = cell2mat(data_measured_050_30.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_30_l = cell2mat(data_measured_050_30.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_60_r = cell2mat(data_measured_050_60.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_60_l = cell2mat(data_measured_050_60.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_90_r = cell2mat(data_measured_050_90.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_90_l = cell2mat(data_measured_050_90.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_120_r = cell2mat(data_measured_050_120.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_120_l = cell2mat(data_measured_050_120.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_150_r = cell2mat(data_measured_050_150.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_150_l = cell2mat(data_measured_050_150.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_180_r = cell2mat(data_measured_050_180.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_180_l = cell2mat(data_measured_050_180.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_210_r = cell2mat(data_measured_050_210.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_210_l = cell2mat(data_measured_050_210.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_240_r = cell2mat(data_measured_050_240.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_240_l = cell2mat(data_measured_050_240.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_270_r = cell2mat(data_measured_050_270.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_270_l = cell2mat(data_measured_050_270.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_300_r = cell2mat(data_measured_050_300.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_300_l = cell2mat(data_measured_050_300.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));
HRTF_050_330_r = cell2mat(data_measured_050_330.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_050.RMSLevel(4,:));
HRTF_050_330_l = cell2mat(data_measured_050_330.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_050.RMSLevel(4,:));

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\60cm'
data_measured_060_0 = importdata('0.mat');
data_measured_060_30 = importdata('30.mat');
data_measured_060_60 = importdata('60.mat');
data_measured_060_90 = importdata('90.mat');
data_measured_060_120 = importdata('120.mat');
data_measured_060_150 = importdata('150.mat');
data_measured_060_180 = importdata('180.mat');
data_measured_060_210 = importdata('210.mat');
data_measured_060_240 = importdata('240.mat');
data_measured_060_270 = importdata('270.mat');
data_measured_060_300 = importdata('300.mat');
data_measured_060_330 = importdata('330.mat');

data_ref_l_060 =  importdata('left_mic.mat');
data_ref_r_060 =  importdata('right_mic.mat');

% measured responses
HRTF_060_0_r = cell2mat(data_measured_060_0.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_0_l = cell2mat(data_measured_060_0.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_30_r = cell2mat(data_measured_060_30.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_30_l = cell2mat(data_measured_060_30.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_60_r = cell2mat(data_measured_060_60.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_60_l = cell2mat(data_measured_060_60.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_90_r = cell2mat(data_measured_060_90.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_90_l = cell2mat(data_measured_060_90.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_120_r = cell2mat(data_measured_060_120.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_120_l = cell2mat(data_measured_060_120.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_150_r = cell2mat(data_measured_060_150.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_150_l = cell2mat(data_measured_060_150.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_180_r = cell2mat(data_measured_060_180.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_180_l = cell2mat(data_measured_060_180.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_210_r = cell2mat(data_measured_060_210.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_210_l = cell2mat(data_measured_060_210.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_240_r = cell2mat(data_measured_060_240.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_240_l = cell2mat(data_measured_060_240.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_270_r = cell2mat(data_measured_060_270.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_270_l = cell2mat(data_measured_060_270.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_300_r = cell2mat(data_measured_060_300.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_300_l = cell2mat(data_measured_060_300.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));
HRTF_060_330_r = cell2mat(data_measured_060_330.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_060.RMSLevel(4,:));
HRTF_060_330_l = cell2mat(data_measured_060_330.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_060.RMSLevel(4,:));

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\75cm'
data_measured_075_0 = importdata('0.mat');
data_measured_075_30 = importdata('30.mat');
data_measured_075_60 = importdata('60.mat');
data_measured_075_90 = importdata('90.mat');
data_measured_075_120 = importdata('120.mat');
data_measured_075_150 = importdata('150.mat');
data_measured_075_180 = importdata('180.mat');
data_measured_075_210 = importdata('210.mat');
data_measured_075_240 = importdata('240.mat');
data_measured_075_270 = importdata('270.mat');
data_measured_075_300 = importdata('300.mat');
data_measured_075_330 = importdata('330.mat');

data_ref_l_075 =  importdata('left_mic.mat');
data_ref_r_075 =  importdata('right_mic.mat');

% measured responses
HRTF_075_0_r = cell2mat(data_measured_075_0.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_0_l = cell2mat(data_measured_075_0.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_30_r = cell2mat(data_measured_075_30.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_30_l = cell2mat(data_measured_075_30.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_60_r = cell2mat(data_measured_075_60.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_60_l = cell2mat(data_measured_075_60.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_90_r = cell2mat(data_measured_075_90.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_90_l = cell2mat(data_measured_075_90.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_120_r = cell2mat(data_measured_075_120.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_120_l = cell2mat(data_measured_075_120.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_150_r = cell2mat(data_measured_075_150.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_150_l = cell2mat(data_measured_075_150.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_180_r = cell2mat(data_measured_075_180.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_180_l = cell2mat(data_measured_075_180.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_210_r = cell2mat(data_measured_075_210.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_210_l = cell2mat(data_measured_075_210.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_240_r = cell2mat(data_measured_075_240.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_240_l = cell2mat(data_measured_075_240.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_270_r = cell2mat(data_measured_075_270.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_270_l = cell2mat(data_measured_075_270.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_300_r = cell2mat(data_measured_075_300.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_300_l = cell2mat(data_measured_075_300.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));
HRTF_075_330_r = cell2mat(data_measured_075_330.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_075.RMSLevel(4,:));
HRTF_075_330_l = cell2mat(data_measured_075_330.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_075.RMSLevel(4,:));

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\90cm'
data_measured_090_0 = importdata('0.mat');
data_measured_090_30 = importdata('30.mat');
data_measured_090_60 = importdata('60.mat');
data_measured_090_90 = importdata('90.mat');
data_measured_090_120 = importdata('120.mat');
data_measured_090_150 = importdata('150.mat');
data_measured_090_180 = importdata('180.mat');
data_measured_090_210 = importdata('210.mat');
data_measured_090_240 = importdata('240.mat');
data_measured_090_270 = importdata('270.mat');
data_measured_090_300 = importdata('300.mat');
data_measured_090_330 = importdata('330.mat');

data_ref_l_090 =  importdata('left_mic.mat');
data_ref_r_090 =  importdata('right_mic.mat');

% measured responses
HRTF_090_0_r = cell2mat(data_measured_090_0.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_0_l = cell2mat(data_measured_090_0.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_30_r = cell2mat(data_measured_090_30.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_30_l = cell2mat(data_measured_090_30.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_60_r = cell2mat(data_measured_090_60.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_60_l = cell2mat(data_measured_090_60.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_90_r = cell2mat(data_measured_090_90.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_90_l = cell2mat(data_measured_090_90.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_120_r = cell2mat(data_measured_090_120.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_120_l = cell2mat(data_measured_090_120.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_150_r = cell2mat(data_measured_090_150.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_150_l = cell2mat(data_measured_090_150.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_180_r = cell2mat(data_measured_090_180.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_180_l = cell2mat(data_measured_090_180.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_210_r = cell2mat(data_measured_090_210.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_210_l = cell2mat(data_measured_090_210.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_240_r = cell2mat(data_measured_090_240.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_240_l = cell2mat(data_measured_090_240.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_270_r = cell2mat(data_measured_090_270.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_270_l = cell2mat(data_measured_090_270.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_300_r = cell2mat(data_measured_090_300.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_300_l = cell2mat(data_measured_090_300.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));
HRTF_090_330_r = cell2mat(data_measured_090_330.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_090.RMSLevel(4,:));
HRTF_090_330_l = cell2mat(data_measured_090_330.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_090.RMSLevel(4,:));

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\1m'
data_measured_100_0 = importdata('0.mat');
data_measured_100_30 = importdata('30.mat');
data_measured_100_60 = importdata('60.mat');
data_measured_100_90 = importdata('90.mat');
data_measured_100_120 = importdata('120.mat');
data_measured_100_150 = importdata('150.mat');
data_measured_100_180 = importdata('180.mat');
data_measured_100_210 = importdata('210.mat');
data_measured_100_240 = importdata('240.mat');
data_measured_100_270 = importdata('270.mat');
data_measured_100_300 = importdata('300.mat');
data_measured_100_330 = importdata('330.mat');

data_ref_l_100 =  importdata('left_mic.mat');
data_ref_r_100 =  importdata('right_mic.mat');

% measured responses
HRTF_100_0_r = cell2mat(data_measured_100_0.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_0_l = cell2mat(data_measured_100_0.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_30_r = cell2mat(data_measured_100_30.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_30_l = cell2mat(data_measured_100_30.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_60_r = cell2mat(data_measured_100_60.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_60_l = cell2mat(data_measured_100_60.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_90_r = cell2mat(data_measured_100_90.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_90_l = cell2mat(data_measured_100_90.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_120_r = cell2mat(data_measured_100_120.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_120_l = cell2mat(data_measured_100_120.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_150_r = cell2mat(data_measured_100_150.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_150_l = cell2mat(data_measured_100_150.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_180_r = cell2mat(data_measured_100_180.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_180_l = cell2mat(data_measured_100_180.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_210_r = cell2mat(data_measured_100_210.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_210_l = cell2mat(data_measured_100_210.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_240_r = cell2mat(data_measured_100_240.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_240_l = cell2mat(data_measured_100_240.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_270_r = cell2mat(data_measured_100_270.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_270_l = cell2mat(data_measured_100_270.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_300_r = cell2mat(data_measured_100_300.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_300_l = cell2mat(data_measured_100_300.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));
HRTF_100_330_r = cell2mat(data_measured_100_330.RMSLevel(4,[1:2])) - cell2mat(data_ref_r_100.RMSLevel(4,:));
HRTF_100_330_l = cell2mat(data_measured_100_330.RMSLevel(4,[3:4])) - cell2mat(data_ref_l_100.RMSLevel(4,:));


%%%% Plot results
cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\plots\right ear HRTF various distances' 

 faxis = cell2mat(data_measured_040_0.RMSLevel(4,1));

figure(1);
plot(faxis, HRTF_040_0_r(:,2),'k', 'linestyle','-','linewidth',0.9);
hold on;
plot(faxis, HRTF_050_0_r(:,2),'k', 'linestyle','--','linewidth',0.9);
hold on;
plot(faxis, HRTF_060_0_r(:,2),'k', 'linestyle',':','linewidth',0.9);
hold on;
plot(faxis, HRTF_075_0_r(:,2),'k', 'linestyle',':','linewidth',1.3);
hold on;
plot(faxis, HRTF_090_0_r(:,2),'k', 'linestyle','--','linewidth',1.3);
hold on;
plot(faxis, HRTF_100_0_r(:,2),'k', 'linestyle','-','linewidth',1.3);

legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
grid on;
axHRTFr = gca;
set(axHRTFr,'xscale','log');
axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axHRTFr.XLim = [20,20000];
axHRTFr.YLim = [-30,20];
axHRTFr.XLabel.String = 'frequency(Hz)';
axHRTFr.YLabel.String = 'dBSPL';
axHRTFr.Title.String = ['0' char(176)];
axHRTFr.FontSize = 12;
axHRTFr.Legend.FontSize = 12;
axHRTFr.Legend.Location = 'south';
axHRTFr.LineWidth = 1;
set(gcf,'position',[10,10,800,600]);

saveas(gcf,'0.png');
saveas(gcf,'0.fig');

% figure(2);
% plot(faxis, HRTF_040_30_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_30_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_30_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_30_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_30_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_30_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-30,20];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['30' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'30.png');
% % saveas(gcf,'30.fig');
% 
% figure(3);
% plot(faxis, HRTF_040_60_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_60_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_60_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_60_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_60_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_60_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-30,20];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['60' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'60.png');
% % saveas(gcf,'60.fig');
% 
% figure(4);
% plot(faxis, HRTF_040_90_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_90_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_90_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_90_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_90_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_90_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-30,20];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['90' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'90.png');
% % saveas(gcf,'90.fig');
% 
% figure(5);
% plot(faxis, HRTF_040_120_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_120_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_120_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_120_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_120_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_120_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-30,20];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['120' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'120.png');
% % saveas(gcf,'120.fig');
% 
% figure(6);
% plot(faxis, HRTF_040_150_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_150_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_150_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_150_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_150_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_150_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-30,20];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['150' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'150.png');
% % saveas(gcf,'150.fig');
% 
% figure(7);
% plot(faxis, HRTF_040_180_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_180_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_180_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_180_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_180_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_180_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-30,20];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['180' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% %
% % saveas(gcf,'180.png');
% % saveas(gcf,'180.fig');
% 
% figure(8);
% plot(faxis, HRTF_040_210_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_210_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_210_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_210_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_210_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_210_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-40,10];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['210' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'210.png');
% % saveas(gcf,'210.fig');
% 
% figure(9);
% plot(faxis, HRTF_040_240_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_240_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_240_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_240_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_240_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_240_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-40,10];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['240' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'240.png');
% % saveas(gcf,'240.fig');
% 
% figure(10);
% plot(faxis, HRTF_040_270_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_270_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_270_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_270_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_270_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_270_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-40,10];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['270' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'270.png');
% % saveas(gcf,'270.fig');
% 
% figure(11);
% plot(faxis, HRTF_040_300_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_300_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_300_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_300_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_300_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_300_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-40,10];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['300' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'300.png');
% % saveas(gcf,'300.fig');
% 
% figure(12);
% plot(faxis, HRTF_040_330_r(:,2),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_050_330_r(:,2),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_060_330_r(:,2),'k', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, HRTF_075_330_r(:,2),'k', 'linestyle',':','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_090_330_r(:,2),'k', 'linestyle','--','linewidth',1.3);
% hold on;
% plot(faxis, HRTF_100_330_r(:,2),'k', 'linestyle','-','linewidth',1.3);
% 
% legend('0.40m','0.50m','0.60m','0.75m','0.90m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [20,20000];
% axHRTFr.YLim = [-40,10];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dBSPL';
% axHRTFr.Title.String = ['330' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% 
% set(gcf,'position',[10,10,800,600]);
% 
% % saveas(gcf,'330.png');
% % saveas(gcf,'330.fig');

y = 1:6;
[X,Y] = meshgrid(faxis,y);

figure(13);
Z = [HRTF_040_0_r(:,2),HRTF_050_0_r(:,2),HRTF_060_0_r(:,2),HRTF_075_0_r(:,2),HRTF_090_0_r(:,2),HRTF_100_0_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['0' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_0.png');
saveas(gcf,'waterfall_0.fig');

figure(14);
Z = [HRTF_040_30_r(:,2),HRTF_050_30_r(:,2),HRTF_060_30_r(:,2),HRTF_075_30_r(:,2),HRTF_090_30_r(:,2),HRTF_100_30_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['30' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_30.png');
saveas(gcf,'waterfall_30.fig');

figure(15);
Z = [HRTF_040_60_r(:,2),HRTF_050_60_r(:,2),HRTF_060_60_r(:,2),HRTF_075_60_r(:,2),HRTF_090_60_r(:,2),HRTF_100_60_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['60' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_60.png');
saveas(gcf,'waterfall_60.fig');

figure(16);
Z = [HRTF_040_90_r(:,2),HRTF_050_90_r(:,2),HRTF_060_90_r(:,2),HRTF_075_90_r(:,2),HRTF_090_90_r(:,2),HRTF_100_90_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['90' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_90.png');
saveas(gcf,'waterfall_90.fig');

figure(17);
Z = [HRTF_040_120_r(:,2),HRTF_050_120_r(:,2),HRTF_060_120_r(:,2),HRTF_075_120_r(:,2),HRTF_090_120_r(:,2),HRTF_100_120_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['120' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_120.png');
saveas(gcf,'waterfall_120.fig');

figure(18);
Z = [HRTF_040_150_r(:,2),HRTF_050_150_r(:,2),HRTF_060_150_r(:,2),HRTF_075_150_r(:,2),HRTF_090_150_r(:,2),HRTF_100_150_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['150' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_150.png');
saveas(gcf,'waterfall_150.fig');

figure(19);
Z = [HRTF_040_180_r(:,2),HRTF_050_180_r(:,2),HRTF_060_180_r(:,2),HRTF_075_180_r(:,2),HRTF_090_180_r(:,2),HRTF_100_180_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['180' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_180.png');
saveas(gcf,'waterfall_180.fig');

figure(20);
Z = [HRTF_040_210_r(:,2),HRTF_050_210_r(:,2),HRTF_060_210_r(:,2),HRTF_075_210_r(:,2),HRTF_090_210_r(:,2),HRTF_100_210_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['210' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_210.png');
saveas(gcf,'waterfall_210.fig');

figure(21);
Z = [HRTF_040_240_r(:,2),HRTF_050_240_r(:,2),HRTF_060_240_r(:,2),HRTF_075_240_r(:,2),HRTF_090_240_r(:,2),HRTF_100_240_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['240' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_240.png');
saveas(gcf,'waterfall_240.fig');

figure(22);
Z = [HRTF_040_270_r(:,2),HRTF_050_270_r(:,2),HRTF_060_270_r(:,2),HRTF_075_270_r(:,2),HRTF_090_270_r(:,2),HRTF_100_270_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['270' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_270.png');
saveas(gcf,'waterfall_270.fig');

figure(23);
Z = [HRTF_040_300_r(:,2),HRTF_050_300_r(:,2),HRTF_060_300_r(:,2),HRTF_075_300_r(:,2),HRTF_090_300_r(:,2),HRTF_100_300_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['300' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_300.png');
saveas(gcf,'waterfall_300.fig');

figure(24);
Z = [HRTF_040_330_r(:,2),HRTF_050_330_r(:,2),HRTF_060_330_r(:,2),HRTF_075_330_r(:,2),HRTF_090_330_r(:,2),HRTF_100_330_r(:,2)]';
waterfall(X,Y,Z);
yticks([1:6]);
yticklabels({'0.40m','0.50m','0.60m','0.75m','0.90m','1.00m'});
set(gca,'xscale','log');
xlabel('frequency(Hz)');
ylabel('distance');
zlabel('dBSPL');
title(['330' char(176)]);
set(gcf,'position',[10,10,900,600]);

saveas(gcf,'waterfall_330.png');
saveas(gcf,'waterfall_330.fig');
