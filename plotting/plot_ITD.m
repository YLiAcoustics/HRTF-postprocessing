%%%% This MATLAB script plots saved ITD as a function of azimuth.
%%%% Author : Yuqing Li
%%%% Date: 20/01/2021
clear all
close all

plot_ori = 1;
plot_interp = 0;

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ITD'
if plot_ori
ITD_25_ori = importdata('ITD_original_25cm.mat');
ITD_40_ori = importdata('ITD_original_40cm.mat');
ITD_50_ori = importdata('ITD_original_50cm.mat');
ITD_60_ori = importdata('ITD_original_60cm.mat');
ITD_75_ori = importdata('ITD_original_75cm.mat');
ITD_100_ori = importdata('ITD_original_100cm.mat');

azimuth = [0:5:359];
figure(1)
scatter(azimuth,1000*ITD_25_ori,35,'r','filled');
hold on;
scatter(azimuth,1000*ITD_40_ori,35,'b','filled');
hold on;
scatter(azimuth,1000*ITD_50_ori,35,'g','filled');
hold on;
scatter(azimuth,1000*ITD_60_ori,35,[0.95 0.75 0.1],'filled');
hold on;
scatter(azimuth,1000*ITD_75_ori,35,'k','filled');
hold on;
scatter(azimuth,1000*ITD_100_ori,35,'m','filled');
grid on;

xlabel('Azimuth(degrees)');
ylabel('ITD (us)');
xlim([0 359]);
ylim([-1000 1000]);
legend({'25cm','40cm','50cm','60cm','75cm','100cm'},'Location','southeast');
title('original ITD');
set(gca,'FontSize', 16, 'FontName', 'Times New Roman');
end

if plot_interp
ITD_25 = importdata('ITD_25cm.mat');
ITD_40 = importdata('ITD_40cm.mat');
ITD_50 = importdata('ITD_50cm.mat');
ITD_60 = importdata('ITD_60cm.mat');
ITD_75 = importdata('ITD_75cm.mat');
ITD_100 = importdata('ITD_100cm.mat');
ITD_25 = smooth(ITD_25,20);
ITD_40 = smooth(ITD_40,20);
ITD_50 = smooth(ITD_50,20);
ITD_60 = smooth(ITD_60,20);
ITD_75 = smooth(ITD_75,20);
ITD_100 = smooth(ITD_100,20);

azimuth = [0:359];
figure(2)
plot(azimuth,1000*ITD_25,'-b','linewidth',1.5);
hold on;
plot(azimuth,1000*ITD_40,'-r','linewidth',1.5);
hold on;
plot(azimuth,1000*ITD_50,'--b','linewidth',1.5);
hold on;
plot(azimuth,1000*ITD_60,'--r','linewidth',1.5);
hold on;
plot(azimuth,1000*ITD_75,':r','linewidth',2);
hold on;
plot(azimuth,1000*ITD_100,':b','linewidth',2);
grid on;

xlabel('Azimuth(degrees)');
ylabel('ITD (us)');
xlim([0 359]);
ylim([-1000 1000]);
legend({'25cm','40cm','50cm','60cm','75cm','100cm'},'Location','southeast');
title('interpolated ITD');
end