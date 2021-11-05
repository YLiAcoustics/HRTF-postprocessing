clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\200915 KEMAR HRTF AP\0.5m'
 
%%%% Import data
data_measured1 = importdata('5V_0_5m_left.mat');

% measured responses
measured_response_r1 = cell2mat(data_measured1.RMSLevel(4,[1:2]));         % Channel 1 is right
measured_response_l1 = cell2mat(data_measured1.RMSLevel(4,[3:4]));

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\50cm'
%%%% Import data
data_measured2 = importdata('270.mat');

% measured responses
measured_response_r2 = cell2mat(data_measured2.RMSLevel(4,[1:2]));         % Channel 1 is right
measured_response_l2 = cell2mat(data_measured2.RMSLevel(4,[3:4]));



%%%% Plot results
faxis = measured_response_l1(:,1);

figure(1);
plot(faxis, measured_response_l1(:,2),'r','linewidth',1);
hold on;
plot(faxis, measured_response_r1(:,2),'b','linewidth',1);
hold on;

plot(faxis, measured_response_l2(:,2),'r','linewidth',1.5);
hold on;
plot(faxis, measured_response_r2(:,2),'b','linewidth',1.5);
grid on;
legend ({'im left','im right', 'bm left','bm right'});

axHRTF = gca;
set(axHRTF,'xscale','log');
axHRTF.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axHRTF.XLim = [20,20000];
% axHRTF.YLim = [-60,30];
axHRTF.XLabel.String = 'frequency(Hz)';
axHRTF.YLabel.String = 'dBSPL';
axHRTF.Title.String = 'HRTF measured by different microphones';
axHRTF.FontSize = 12;
axHRTF.Legend.FontSize = 12;
axHRTF.LineWidth = 1;