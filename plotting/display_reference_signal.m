clear all
close all

dis = 100;
% ori = 0;

% Specify sample rate and time window
fs = 48000;
t_tru = 0.02;
t_pre = 0.05; % There is 50ms' extend acquisition at the beginning of the measured signal


%%%% Import data
datapath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\',num2str(dis),'cm');
cd(datapath)
data_rs_l =  importdata('left_mic.mat');        % reference signal data
data_rs_r =  importdata('right_mic.mat');

%%%%% reference responses
rs_ir_l = cell2mat(data_rs_l.ImpulseResponse(4,2));   % reference response from the left-ear microphone
rs_ir_r = cell2mat(data_rs_r.ImpulseResponse(4,2));   % reference response from the right-ear microphone
% truncate with a time window of 20ms and remove the preringing
trun_rs_ir_l = rs_ir_l([ceil(fs*t_pre):ceil(fs*(t_pre+t_tru))]);
trun_rs_ir_r = rs_ir_r([ceil(fs*t_pre):ceil(fs*(t_pre+t_tru))]);
ref_TF_l = fft(trun_rs_ir_l);
ref_TF_r = fft(trun_rs_ir_r);

% % minimum phase reconstruction
% [trun_rs_ir_l_rc, trun_rs_ir_l_mp] = rceps(trun_rs_ir_l);
% [trun_rs_ir_r_rc, trun_rs_ir_r_mp] = rceps(trun_rs_ir_r);
% ref_TF_l = fft(trun_rs_ir_l_mp);
% ref_TF_r = fft(trun_rs_ir_r_mp);

figure(1);
set(gcf, 'Position', get(0, 'Screensize'));
faxis = [0:length(ref_TF_l)-1]'/length(ref_TF_l)*fs;
plot(faxis, 20*log10(abs(ref_TF_l)),'r', 'linestyle','--','linewidth',1.3);
hold on;
plot(faxis, 20*log10(abs(ref_TF_r)),'b', 'linestyle','--','linewidth',1.3);
grid on;

legend('left','right');
legend('boxoff');

axHRTF = gca;
set(axHRTF,'xscale','log');
axHRTF.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axHRTF.XLim = [90,20000];
axHRTF.YLim = [-60,-20];
axHRTF.XLabel.String = 'frequency(Hz)';
axHRTF.YLabel.String = 'dB';
axHRTF.Title.String = ['reference signals at ' num2str(dis) 'cm'];
axHRTF.FontSize = 12;
axHRTF.Legend.FontSize = 14;
axHRTF.Legend.Location = 'south';
axHRTF.LineWidth = 1;

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\reference response'
saveas(gcf,'reference signals 100cm.png');
saveas(gcf,'reference signals 100cm.fig');
close