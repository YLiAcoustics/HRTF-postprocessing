 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% This Matlab script calculates and displays the measured HRTF.
%%%%%%%%%% Yuqing Li, 28/09/2020
clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\75cm'
 
%%%%% options
plot_HRTF = 1;
plot_HRIR = 1;

% Specify sample rate and time window
fs = 48000;
t_tru = 0.02;
t_pre = 0.05; % There is 50ms' extend acquisition at the beginning of the measured signal
%%%% Import data
data_bs = importdata('90.mat');  % binaural signal data

% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\25cm'
data_rs_l =  importdata('left_mic.mat');        % reference signal data
data_rs_r =  importdata('right_mic.mat');


%%%% measured responses
bs_ir_r = cell2mat(data_bs.ImpulseResponse(4,2));         % Channel 1 is right
bs_ir_l = cell2mat(data_bs.ImpulseResponse(4,4));

TF_r = fft(bs_ir_r);
TF_l = fft(bs_ir_l);

%%%%% reference responses
rs_ir_l = cell2mat(data_rs_l.ImpulseResponse(4,2));   % reference response from the left-ear microphone
rs_ir_r = cell2mat(data_rs_r.ImpulseResponse(4,2));   % reference response from the right-ear microphone
% minimum phase reconstruction of reference signal
[rs_ir_l_rc, rs_ir_l_mp] = rceps(rs_ir_l);
[rs_ir_r_rc, rs_ir_r_mp] = rceps(rs_ir_r);
ref_TF_l = fft(rs_ir_l_mp);
ref_TF_r = fft(rs_ir_r_mp);

HRTF_l = TF_l./ref_TF_l;
HRTF_r = TF_r./ref_TF_r;
HRIR_l = ifft(HRTF_l);
HRIR_r = ifft(HRTF_r);
HRIR_l = HRIR_l([ceil(fs*t_pre)+1:floor(fs*(t_pre+t_tru))]);
HRIR_r = HRIR_r([ceil(fs*t_pre)+1:floor(fs*(t_pre+t_tru))]);
HRTF_r = fft(HRIR_r);
HRTF_l = fft(HRIR_l);
% 
% 
% % truncate with a time window of 20ms and remove the extend acquisition
% trun_bs_ir_r = bs_ir_r([ceil(fs*t_pre)+1:floor(fs*(t_pre+t_tru))]);
% trun_bs_ir_l = bs_ir_l([ceil(fs*t_pre)+1:floor(fs*(t_pre+t_tru))]);
% 
% TF_r = fft(trun_bs_ir_r);
% TF_l = fft(trun_bs_ir_l);
% 

% % truncate with a time window of 20ms and remove the extend acquisition
% trun_rs_ir_l = rs_ir_l([ceil(fs*t_pre)+1:floor(fs*(t_pre+t_tru))]);
% trun_rs_ir_r = rs_ir_r([ceil(fs*t_pre)+1:floor(fs*(t_pre+t_tru))]);
% % minimum phase reconstruction
% [trun_rs_ir_l_rc, trun_rs_ir_l_mp] = rceps(trun_rs_ir_l);
% [trun_rs_ir_r_rc, trun_rs_ir_r_mp] = rceps(trun_rs_ir_r);
% ref_TF_l = fft(trun_rs_ir_l_mp);
% ref_TF_r = fft(trun_rs_ir_r_mp);
% 
% % calculate HRTF
% HRTF_l = TF_l./ref_TF_l;
% HRTF_r = TF_r./ref_TF_r;
% HRIR_l = ifft(HRTF_l);
% HRIR_r = ifft(HRTF_r);
% 

%%%% Plot results
faxis = [0:length(HRTF_l)-1]'/length(HRTF_l)*fs;
taxis = [0:1/length(HRTF_l):1-1/length(HRTF_l)]'*t_tru;

if plot_HRTF
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
axHRTF.Title.String = ['HRTFs at 75cm, 100' char(176)];
axHRTF.FontSize = 12;
axHRTF.Legend.FontSize = 12;
axHRTF.LineWidth = 1;
end

if plot_HRIR
    figure(2);
    subplot(2,1,1);
    plot(taxis, HRIR_l,'r','linewidth',1);
    xlabel('time (s)');
    ylabel('magnitude');
    title(['Left-ear HRIR 75cm, 100' char(176)]);
    
    subplot(2,1,2);
    plot(taxis, HRIR_r,'b','linewidth',1);
    xlabel('time (s)');
    ylabel('magnitude');
    title(['Right-ear HRIR 75cm, 100' char(176)]);
end
% figure(2);
% plot(faxis, 20*log10(abs(ref_TF_l)),'r','linewidth',1);
% hold on;
% plot(faxis, 20*log10(abs(ref_TF_r)),'b','linewidth',1);
% grid on;
% legend ({'left','right'});
% 
% axHRTF = gca;
% set(axHRTF,'xscale','log');
% axHRTF.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTF.XLim = [90,20000];
% axHRTF.YLim = [-50,0];
% axHRTF.XLabel.String = 'frequency(Hz)';
% axHRTF.YLabel.String = 'dB';
% axHRTF.Title.String = ['reference response at 40cm'];
% axHRTF.FontSize = 12;
% axHRTF.Legend.FontSize = 12;
% axHRTF.LineWidth = 1;

% figure(2);
% plot(faxis, 20*log10(abs(ILD)),'r','linewidth',1);
% axILD = gca;
% set(axILD,'xscale','log');
% axILD.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axILD.XLim = [90,20000];
% axILD.YLim = [-30,30];
% axILD.XLabel.String = 'frequency(Hz)';
% axILD.YLabel.String = 'magnitude(dB)';
% axILD.Title.String = 'ILD';
% axILD.FontSize = 12;
% axILD.LineWidth = 1;
%  
% figure(3);
% plot(faxis, 20*log10(abs(ITD)),'b','linewidth',1);
% axITD = gca;
% set(axITD,'xscale','log');
% axITD.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axITD.XLim = [90,20000];
% axITD.YLim = [-30,30];
% axITD.XLabel.String = 'frequency(Hz)';
% axITD.YLabel.String = 'magnitude(dB)';
% axITD.Title.String = 'ITD';
% axITD.FontSize = 12;
% axITD.LineWidth = 1;