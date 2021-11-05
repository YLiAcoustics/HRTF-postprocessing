%%%%% This MATLAB script truncates the measured binaural responses and reference
%%%%% responses with a time window. Therefore, the HRIR is also truncated.

clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\50cm'
 
%%%% Import data
data_measured = importdata('0.mat');

% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\25cm'
data_ref_l =  importdata('left_mic.mat');
data_ref_r =  importdata('right_mic.mat');

fs = 48000;
t_tru = 0.02;

% measured responses
measured_response_r = cell2mat(data_measured.ImpulseResponse(4,2));         % Channel 1 is right
measured_response_l = cell2mat(data_measured.ImpulseResponse(4,4));

% truncate with a time window of 20ms
measured_response_r = measured_response_r(1:ceil(fs*t_tru));
measured_response_l = measured_response_l(1:ceil(fs*t_tru));

measured_TF_r = fft(measured_response_r);
measured_TF_l = fft(measured_response_l);

% reference responses
ref_l = cell2mat(data_ref_l.ImpulseResponse(4,2)); % reference response from the left-ear microphone
ref_r = cell2mat(data_ref_r.ImpulseResponse(4,2)); % reference response from the right-ear microphone

% truncate with a time window of 20ms
ref_l = ref_l(1:ceil(fs*t_tru));
ref_r = ref_r(1:ceil(fs*t_tru));

[ref_l_rc, ref_l_mp] = rceps(ref_l);
[ref_r_rc, ref_r_mp] = rceps(ref_r);
ref_TF_l = fft(ref_l_mp);
ref_TF_r = fft(ref_r_mp);

% calculate HRTF
HRTF_l = measured_TF_l./ref_TF_l;
HRTF_r = measured_TF_r./ref_TF_r;
L = length(HRTF_l);
P1_l = HRTF_l(1:L/(48000/20000)+1);
P1_r = HRTF_r(1:L/(48000/20000)+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
P1_r(2:end-1) = 2*P1_r(2:end-1);
HRTF_l = P1_l;
HRTF_r = P1_r;

% calculate ITD and ILD
ILD = abs(measured_TF_l./measured_TF_r);
P2 = ILD(1:L/(48000/20000)+1);
P2(2:end-1) = 2*P2(2:end-1);

ILD = P2;
ITD = imag(measured_TF_l./measured_TF_r);
P3 = ITD(1:L/(48000/20000)+1);
P3(2:end-1) = 2*P3(2:end-1);
ITD = P3;

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
axHRTF.XLim = [90,20000];
axHRTF.YLim = [-30,30];
axHRTF.XLabel.String = 'frequency(Hz)';
axHRTF.YLabel.String = 'dB';
% axHRTF.Title.String = '25cm';
axHRTF.FontSize = 12;
axHRTF.Legend.FontSize = 12;
axHRTF.LineWidth = 1;
