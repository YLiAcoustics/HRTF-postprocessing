%%%% This MATLAB script performs microphone calibration using the
%%%% data from APx500.
clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\210216 microphone calibration'
data = importdata('calibration04.mat');
taxis = cell2mat(data.RMSLevel(4,1));
rmsl = cell2mat(data.RMSLevel(4,2));
dur = max(taxis);
max(rmsl)

figure(1)
plot(taxis,1000*rmsl);
xlabel('time (s)');
ylabel('mVrms');
grid on;