%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% This Matlab script compares the HRIRs resulted from different
%%%%%%%%%% truncation methods:
%%%%%%%%%% 1. truncate before HRTF calculation (as has been used so far)
%%%%%%%%%% 2. truncate after HRTF calculation
%%%%%%%%%% Yuqing Li, 02/12/2020
clear all
close all

dis = 25;
ori = 0;
%%%%% options
plot_HRTF = 1;
plot_HRIR = 1;
plot_ILD = 0;
method = 2;

export_HRIR = 0;
export_HRTF = 0;

% for n = 1:72
%     ori = 5*(n-1);
filepath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\',num2str(dis),'cm');
cd(filepath)

%% Specify sample rate and time window
fs = 48000;
t_tru = 0.02;
t_pre = 0.05; % There is 50ms' extend acquisition at the beginning of the measured signal

%% Import data
dataname = strcat(num2str(ori),'.mat');
data_bs = importdata(dataname);  % binaural signal data
data_rs_l =  importdata('left_mic.mat');        % reference signal data
data_rs_r =  importdata('right_mic.mat');

%%%% measured responses
bs_ir_r = cell2mat(data_bs.ImpulseResponse(4,2));         % Channel 1 is right
bs_ir_l = cell2mat(data_bs.ImpulseResponse(4,4));

%%%% reference responses
rs_ir_l = cell2mat(data_rs_l.ImpulseResponse(4,2));   % reference response from the left-ear microphone
rs_ir_r = cell2mat(data_rs_r.ImpulseResponse(4,2));   % reference response from the right-ear microphone

%% truncate with a time window of 20ms and remove the extend acquisition
if method == 1
%%%% Method 1 
trun_bs_ir_r = bs_ir_r([ceil(fs*t_pre)+1:ceil(fs*(t_pre+t_tru))]);
trun_bs_ir_l = bs_ir_l([ceil(fs*t_pre)+1:ceil(fs*(t_pre+t_tru))]);
TF_r = fft(trun_bs_ir_r);
TF_l = fft(trun_bs_ir_l);
% truncate with a time window of 20ms and remove the extend acquisition
trun_rs_ir_l = rs_ir_l([ceil(fs*t_pre)+1:ceil(fs*(t_pre+t_tru))]);
trun_rs_ir_r = rs_ir_r([ceil(fs*t_pre)+1:ceil(fs*(t_pre+t_tru))]);
% minimum phase reconstruction
[trun_rs_ir_l_rc, trun_rs_ir_l_mp] = rceps(trun_rs_ir_l);
[trun_rs_ir_r_rc, trun_rs_ir_r_mp] = rceps(trun_rs_ir_r);
ref_TF_l = fft(trun_rs_ir_l_mp);
ref_TF_r = fft(trun_rs_ir_r_mp);
% calculate HRTF
HRTF_l = TF_l./ref_TF_l;
HRTF_r = TF_r./ref_TF_r;
HRIR_l = ifft(HRTF_l);
HRIR_r = ifft(HRTF_r);

else
    
%%%% Method 2
TF_r = fft(bs_ir_r);
TF_l = fft(bs_ir_l);
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
end

%% Plot results
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
axHRTF.Title.String = ['HRTFs at ' num2str(dis) 'cm, ' num2str(ori) char(176)];
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
    title(['Left-ear HRIR ' num2str(dis) 'cm, ' num2str(ori) char(176)]);
    
    subplot(2,1,2);
    plot(taxis, HRIR_r,'b','linewidth',1);
    xlabel('time (s)');
    ylabel('magnitude');
    title(['Right-ear HRIR ' num2str(dis) 'cm, ' num2str(ori) char(176)]);
end

if plot_ILD
figure(3);
plot(faxis, 20*log10(abs(ILD)),'r','linewidth',1);
axILD = gca;
set(axILD,'xscale','log');
axILD.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axILD.XLim = [90,20000];
axILD.YLim = [-30,30];
axILD.XLabel.String = 'frequency(Hz)';
axILD.YLabel.String = 'magnitude(dB)';
axILD.Title.String = 'ILD';
axILD.FontSize = 12;
axILD.LineWidth = 1;
end

if export_HRIR
%%%% signal output
outputname_l = strcat('HRIR_',num2str(dis),'_',num2str(ori),'_l.wav');
outputname_r = strcat('HRIR_',num2str(dis),'_',num2str(ori),'_r.wav');

HRIRpath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\HRIRs\1203\',num2str(dis),'cm');
cd(HRIRpath)
audiowrite(outputname_l,HRIR_l,fs);
audiowrite(outputname_r,HRIR_r,fs);
end

if export_HRTF
HRTFpath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\HRTFs\1203\',num2str(dis),'cm');
cd(HRTFpath)
fnamel = strcat('HRTF_',num2str(dis),'_',num2str(ori),'_l.mat');
fnamer = strcat('HRTF_',num2str(dis),'_',num2str(ori),'_r.mat');
save(fnamel,'HRTF_l');   
save(fnamer,'HRTF_r');   
end

% end