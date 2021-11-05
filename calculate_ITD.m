%%%% This MATLAB script computes ITDs for interpolation.

clear all
close all
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRIR'
fs = 48000;
N = 1024;

%% input HRIR matrix
HRIR_25 = importdata('HRIR_interp_25cm.mat');
HRIR_25_new = permute(HRIR_25,[3 2 1]);
toa_diff_Threshold_25 = 10^6*itdestimator(HRIR_25_new,'fs',fs,'Threshold','lp','upper_cutfreq',3000);    % unit: us
toa_diff_MaxIACCr_25 = 10^6*itdestimator(HRIR_25_new,'fs',fs,'MaxIACCr','lp','upper_cutfreq',3000);    %  interaural cross-correlation coefficient

HRIR_40 = importdata('HRIR_interp_40cm.mat');
HRIR_40_new = permute(HRIR_40,[3 2 1]);
toa_diff_Threshold_40 = 10^6*itdestimator(HRIR_40_new,'fs',fs,'Threshold','lp','upper_cutfreq',3000);    % unit: us
toa_diff_MaxIACCr_40 = 10^6*itdestimator(HRIR_40_new,'fs',fs,'MaxIACCr','lp','upper_cutfreq',3000);    %  interaural cross-correlation coefficient

HRIR_50 = importdata('HRIR_interp_50cm.mat');
HRIR_50_new = permute(HRIR_50,[3 2 1]);
toa_diff_Threshold_50 = 10^6*itdestimator(HRIR_50_new,'fs',fs,'Threshold','lp','upper_cutfreq',3000);    % unit: us
toa_diff_MaxIACCr_50 = 10^6*itdestimator(HRIR_50_new,'fs',fs,'MaxIACCr','lp','upper_cutfreq',3000);    %  interaural cross-correlation coefficient

HRIR_60 = importdata('HRIR_interp_60cm.mat');
HRIR_60_new = permute(HRIR_60,[3 2 1]);
toa_diff_Threshold_60 = 10^6*itdestimator(HRIR_60_new,'fs',fs,'Threshold','lp','upper_cutfreq',3000);    % unit: us
toa_diff_MaxIACCr_60 = 10^6*itdestimator(HRIR_60_new,'fs',fs,'MaxIACCr','lp','upper_cutfreq',3000);    %  interaural cross-correlation coefficient

HRIR_75 = importdata('HRIR_interp_75cm.mat');
HRIR_75_new = permute(HRIR_75,[3 2 1]);
toa_diff_Threshold_75 = 10^6*itdestimator(HRIR_75_new,'fs',fs,'Threshold','lp','upper_cutfreq',3000);    % unit: us
toa_diff_MaxIACCr_75 = 10^6*itdestimator(HRIR_75_new,'fs',fs,'MaxIACCr','lp','upper_cutfreq',3000);    %  interaural cross-correlation coefficient

HRIR_100 = importdata('HRIR_interp_100cm.mat');
HRIR_100_new = permute(HRIR_100,[3 2 1]);
toa_diff_Threshold_100 = 10^6*itdestimator(HRIR_100_new,'fs',fs,'Threshold','lp','upper_cutfreq',3000);    % unit: us
toa_diff_MaxIACCr_100 = 10^6*itdestimator(HRIR_100_new,'fs',fs,'MaxIACCr','lp','upper_cutfreq',3000);    %  interaural cross-correlation coefficient

angleaxis = [0:359];
figure(1)
plot(angleaxis,smooth(toa_diff_Threshold_25,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_Threshold_40,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_Threshold_50,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_Threshold_60,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_Threshold_75,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_Threshold_100,5),'linewidth',1);
xlabel('azimuth (degrees)');
ylabel('ITD (us)');
title('ITD Threshold');
legend('25cm','40cm','50cm','60cm','75cm','100cm');
xlim([0 360]);
ylim([-1000 1000]);

figure(2)
plot(angleaxis,smooth(toa_diff_MaxIACCr_25,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_MaxIACCr_40,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_MaxIACCr_50,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_MaxIACCr_60,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_MaxIACCr_75,5),'linewidth',1);
hold on;
plot(angleaxis,smooth(toa_diff_MaxIACCr_100,5),'linewidth',1);
xlabel('azimuth (degrees)');
ylabel('ITD (us)');
title('ITD MaxIACCr');
legend('25cm','40cm','50cm','60cm','75cm','100cm');
ylim([-1000 1000]);
xlim([0 360]);
