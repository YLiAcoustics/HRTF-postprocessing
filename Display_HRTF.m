%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% This Matlab script calculates and displays the measured HRTF.
%%%%%%%%%% Yuqing Li, 28/09/2020
clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\25cm'
 
%%%% Import data
data_measured = importdata('90.mat');

data_ref_l =  importdata('left_mic.mat');
data_ref_r =  importdata('right_mic.mat');

% measured responses
measured_response_r = cell2mat(data_measured.ImpulseResponse(4,2));         % Channel 1 is right
measured_response_l = cell2mat(data_measured.ImpulseResponse(4,4));
measured_TF_r = fft(measured_response_r);
measured_TF_l = fft(measured_response_l);

% reference responses
ref_l = cell2mat(data_ref_l.ImpulseResponse(4,2)); % reference response from the left-ear microphone
ref_r = cell2mat(data_ref_r.ImpulseResponse(4,2)); % reference response from the right-ear microphone
[ref_l_rc, ref_l_mp] = rceps(ref_l);
[ref_r_rc, ref_r_mp] = rceps(ref_r);
ref_TF_l = fft(ref_l_mp);
ref_TF_r = fft(ref_r_mp);

% ref_l = [ref_l;zeros(length(measured_response_l)-length(ref_l),2)];
% ref_r = [ref_r;zeros(length(measured_response_r)-length(ref_r),2)];

% calculate HRTF
HRTF_l = measured_TF_l./ref_TF_l;
HRTF_r = measured_TF_r./ref_TF_r;

%%%% Plot results
faxis = [20:19980/length(HRTF_l):20000-19980/length(HRTF_l)]';

figure(1);
plot(faxis, 20*log10(abs(HRTF_l)),'r','linewidth',1);
hold on;
plot(faxis, 20*log10(abs(HRTF_r)),'b','linewidth',1);
grid on;
legend ({'left','right'});

axHRTF = gca;
set(axHRTF,'xscale','log');
axHRTF.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axHRTF.XLim = [20,20000];
% axHRTF.YLim = [-60,30];
axHRTF.XLabel.String = 'frequency(Hz)';
axHRTF.YLabel.String = 'dB';
% axHRTF.Title.String = '25cm';
axHRTF.FontSize = 12;
axHRTF.Legend.FontSize = 12;
axHRTF.LineWidth = 1;