%%%%%%% 
clear all
close all

%%%%%%%%%%%%%%%%%%% 25cm %%%%%%%%%%%%%%%%%%%%
%%%% Import data
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\25cm'
data_measured_025 = importdata('0.mat');
data_ref_l_025 =  importdata('left_mic.mat');
data_ref_r_025 =  importdata('right_mic.mat');

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\40cm'
data_measured_040 = importdata('0.mat');
data_ref_l_040 =  importdata('left_mic.mat');
data_ref_r_040 =  importdata('right_mic.mat');

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\50cm'
data_measured_050 = importdata('0.mat');
data_ref_l_050 =  importdata('left_mic.mat');
data_ref_r_050 =  importdata('right_mic.mat');

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\60cm'
data_measured_060 = importdata('0.mat');
data_ref_l_060 =  importdata('left_mic.mat');
data_ref_r_060 =  importdata('right_mic.mat');

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\75cm'
data_measured_075 = importdata('0.mat');
data_ref_l_075 =  importdata('left_mic.mat');
data_ref_r_075 =  importdata('right_mic.mat');

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\100cm'
data_measured_100 = importdata('0.mat');
data_ref_l_100 =  importdata('left_mic.mat');
data_ref_r_100 =  importdata('right_mic.mat');

% data_ref_l_025 =  data_ref_l_100;
% data_ref_r_025 =  data_ref_r_100;
% 
% data_ref_l_040 =  data_ref_l_100;
% data_ref_r_040 =  data_ref_r_100;
% 
% data_ref_l_050 =  data_ref_l_100;
% data_ref_r_050 =  data_ref_r_100;
% 
% data_ref_l_060 =  data_ref_l_100;
% data_ref_r_060 =  data_ref_r_100;
% 
% data_ref_l_075 =  data_ref_l_100;
% data_ref_r_075 =  data_ref_r_100;


% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\100cm'
ref_response_l_025 = cell2mat(data_ref_l_025.ImpulseResponse(4,2));
ref_response_r_025 = cell2mat(data_ref_r_025.ImpulseResponse(4,2));
[ref_response_l_025_rc, ref_response_l_025_mp] = rceps(ref_response_l_025);
[ref_response_r_025_rc, ref_response_r_025_mp] = rceps(ref_response_r_025);
ref_TF_l_025 = fft(ref_response_l_025_mp);
ref_TF_r_025 = fft(ref_response_r_025_mp);

ref_response_l_040 = cell2mat(data_ref_l_040.ImpulseResponse(4,2));
ref_response_r_040 = cell2mat(data_ref_r_040.ImpulseResponse(4,2));
[ref_response_l_040_rc, ref_response_l_040_mp] = rceps(ref_response_l_040);
[ref_response_r_040_rc, ref_response_r_040_mp] = rceps(ref_response_r_040);
ref_TF_l_040 = fft(ref_response_l_040_mp);
ref_TF_r_040 = fft(ref_response_r_040_mp);

ref_response_l_050 = cell2mat(data_ref_l_050.ImpulseResponse(4,2));
ref_response_r_050 = cell2mat(data_ref_r_050.ImpulseResponse(4,2));
[ref_response_l_050_rc, ref_response_l_050_mp] = rceps(ref_response_l_050);
[ref_response_r_050_rc, ref_response_r_050_mp] = rceps(ref_response_r_050);
ref_TF_l_050 = fft(ref_response_l_050_mp);
ref_TF_r_050 = fft(ref_response_r_050_mp);

ref_response_l_060 = cell2mat(data_ref_l_060.ImpulseResponse(4,2));
ref_response_r_060 = cell2mat(data_ref_r_060.ImpulseResponse(4,2));
[ref_response_l_060_rc, ref_response_l_060_mp] = rceps(ref_response_l_060);
[ref_response_r_060_rc, ref_response_r_060_mp] = rceps(ref_response_r_060);
ref_TF_l_060 = fft(ref_response_l_060_mp);
ref_TF_r_060 = fft(ref_response_r_060_mp);

ref_response_l_075 = cell2mat(data_ref_l_075.ImpulseResponse(4,2));
ref_response_r_075 = cell2mat(data_ref_r_075.ImpulseResponse(4,2));
[ref_response_l_075_rc, ref_response_l_075_mp] = rceps(ref_response_l_075);
[ref_response_r_075_rc, ref_response_r_075_mp] = rceps(ref_response_r_075);
ref_TF_l_075 = fft(ref_response_l_075_mp);
ref_TF_r_075 = fft(ref_response_r_075_mp);

ref_response_l_100 = cell2mat(data_ref_l_100.ImpulseResponse(4,2));
ref_response_r_100 = cell2mat(data_ref_r_100.ImpulseResponse(4,2));
[ref_response_l_100_rc, ref_response_l_100_mp] = rceps(ref_response_l_100);
[ref_response_r_100_rc, ref_response_r_100_mp] = rceps(ref_response_r_100);
ref_TF_l_100 = fft(ref_response_l_100_mp);
ref_TF_r_100 = fft(ref_response_r_100_mp);


% % measured responses
measured_response_025_r = fft(cell2mat(data_measured_025.ImpulseResponse(4,2)));
measured_response_025_l = fft(cell2mat(data_measured_025.ImpulseResponse(4,4)));
measured_response_040_r = fft(cell2mat(data_measured_040.ImpulseResponse(4,2)));
measured_response_040_l = fft(cell2mat(data_measured_040.ImpulseResponse(4,4)));
measured_response_050_r = fft(cell2mat(data_measured_050.ImpulseResponse(4,2)));
measured_response_050_l = fft(cell2mat(data_measured_050.ImpulseResponse(4,4)));
measured_response_060_r = fft(cell2mat(data_measured_060.ImpulseResponse(4,2)));
measured_response_060_l = fft(cell2mat(data_measured_060.ImpulseResponse(4,4)));
measured_response_075_r = fft(cell2mat(data_measured_075.ImpulseResponse(4,2)));
measured_response_075_l = fft(cell2mat(data_measured_075.ImpulseResponse(4,4)));
measured_response_100_r = fft(cell2mat(data_measured_100.ImpulseResponse(4,2)));
measured_response_100_l = fft(cell2mat(data_measured_100.ImpulseResponse(4,4)));

% HRTFs
HRTF_025_r = measured_response_025_r./ref_TF_r_025;
HRTF_025_l = measured_response_025_l./ref_TF_l_025;
L = length(HRTF_025_r);
P1_l = HRTF_025_l(1:L/(48000/20000)+1);
P1_r = HRTF_025_r(1:L/(48000/20000)+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
P1_r(2:end-1) = 2*P1_r(2:end-1);
HRTF_025_l = P1_l;
HRTF_025_r = P1_r;

HRTF_040_r = measured_response_040_r./ref_TF_r_040;
HRTF_040_l = measured_response_040_l./ref_TF_l_040;
L = length(HRTF_040_r);
P1_l = HRTF_040_l(1:L/(48000/20000)+1);
P1_r = HRTF_040_r(1:L/(48000/20000)+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
P1_r(2:end-1) = 2*P1_r(2:end-1);
HRTF_040_l = P1_l;
HRTF_040_r = P1_r;

HRTF_050_r = measured_response_050_r./ref_TF_r_050;
HRTF_050_l = measured_response_050_l./ref_TF_l_050;
L = length(HRTF_050_r);
P1_l = HRTF_050_l(1:L/(48000/20000)+1);
P1_r = HRTF_050_r(1:L/(48000/20000)+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
P1_r(2:end-1) = 2*P1_r(2:end-1);
HRTF_050_l = P1_l;
HRTF_050_r = P1_r;

HRTF_060_r = measured_response_060_r./ref_TF_r_060;
HRTF_060_l = measured_response_060_l./ref_TF_l_060;
L = length(HRTF_060_r);
P1_l = HRTF_060_l(1:L/(48000/20000)+1);
P1_r = HRTF_060_r(1:L/(48000/20000)+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
P1_r(2:end-1) = 2*P1_r(2:end-1);
HRTF_060_l = P1_l;
HRTF_060_r = P1_r;

HRTF_075_r = measured_response_075_r./ref_TF_r_075;
HRTF_075_l = measured_response_075_l./ref_TF_l_075;
L = length(HRTF_075_r);
P1_l = HRTF_075_l(1:L/(48000/20000)+1);
P1_r = HRTF_075_r(1:L/(48000/20000)+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
P1_r(2:end-1) = 2*P1_r(2:end-1);
HRTF_075_l = P1_l;
HRTF_075_r = P1_r;

HRTF_100_r = measured_response_100_r./ref_TF_r_100;
HRTF_100_l = measured_response_100_l./ref_TF_l_100;
L = length(HRTF_100_r);
P1_l = HRTF_100_l(1:L/(48000/20000)+1);
P1_r = HRTF_100_r(1:L/(48000/20000)+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
P1_r(2:end-1) = 2*P1_r(2:end-1);
HRTF_100_l = P1_l;
HRTF_100_r = P1_r;


%%%% Plot results
faxis = [20:19980/length(HRTF_100_l):20000-19980/length(HRTF_100_l)]';

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\right ear' 

% figure(1);
% plot(faxis, 20*log10(abs(HRTF_025_r)),'r', 'linestyle',':','linewidth',0.9);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_040_r)),'r', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_050_r)),'r', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_060_r)),'b', 'linestyle',':','linewidth',1.4);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_075_r)),'b', 'linestyle','-','linewidth',1.4);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_100_r)),'b', 'linestyle','--','linewidth',1.4);
% 
% legend('0.25m','0.40m','0.50m','0.60m','0.75m','1.00m');
% grid on;
% axHRTFr = gca;
% set(axHRTFr,'xscale','log');
% axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFr.XLim = [90,20000];
% axHRTFr.YLim = [-40,40];
% axHRTFr.XLabel.String = 'frequency(Hz)';
% axHRTFr.YLabel.String = 'dB';
% axHRTFr.Title.String = ['right ear HRTF 330' char(176)];
% axHRTFr.FontSize = 12;
% axHRTFr.Legend.FontSize = 12;
% axHRTFr.Legend.Location = 'south';
% axHRTFr.LineWidth = 1;
% set(gcf,'position',[10,10,800,600]);
% saveas(gcf,'right ear 330.png');
% saveas(gcf,'right ear 330.fig');

figure(1);
plot(faxis, smooth(20*log10(abs(HRTF_025_r)),100),'r', 'linestyle',':','linewidth',1.4);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_040_r)),100),'r', 'linestyle','-','linewidth',0.9);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_050_r)),100),'r', 'linestyle','--','linewidth',0.9);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_060_r)),100),'b', 'linestyle',':','linewidth',1.4);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_075_r)),100),'b', 'linestyle','-','linewidth',1.4);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_100_r)),100),'b', 'linestyle','--','linewidth',1.4);

legend('0.25m','0.40m','0.50m','0.60m','0.75m','1.00m');
grid on;
axHRTFr = gca;
set(axHRTFr,'xscale','log');
axHRTFr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axHRTFr.XLim = [90,20000];
axHRTFr.YLim = [-40,40];
axHRTFr.XLabel.String = 'frequency(Hz)';
axHRTFr.YLabel.String = 'dB';
axHRTFr.Title.String = ['right ear HRTF 0 (smoothed)' char(176)];
axHRTFr.FontSize = 12;
axHRTFr.Legend.FontSize = 12;
axHRTFr.Legend.Location = 'south';
axHRTFr.LineWidth = 1;
set(gcf,'position',[10,10,800,600]);
saveas(gcf,'right ear 0 smoothed.png');
saveas(gcf,'right ear 0 smoothed.fig');

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\left ear' 
% figure(2);
% plot(faxis, 20*log10(abs(HRTF_025_l)),'k', 'linestyle',':','linewidth',1.4);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_040_l)),'k', 'linestyle','-','linewidth',0.9);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_050_l)),'k', 'linestyle','--','linewidth',0.9);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_060_l)),'k', 'linestyle',':','linewidth',1.4);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_075_l)),'k', 'linestyle','-','linewidth',1.4);
% hold on;
% plot(faxis, 20*log10(abs(HRTF_100_l)),'k', 'linestyle','--','linewidth',1.4);
% 
% legend('0.25m','0.40m','0.50m','0.60m','0.75m','1.00m');
% grid on;
% axHRTFl = gca;
% set(axHRTFl,'xscale','log');
% axHRTFl.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axHRTFl.XLim = [90,20000];
% axHRTFl.YLim = [-40,40];
% axHRTFl.XLabel.String = 'frequency(Hz)';
% axHRTFl.YLabel.String = 'dB';
% axHRTFl.Title.String = ['left ear HRTF 330' char(176)];
% axHRTFl.FontSize = 12;
% axHRTFl.Legend.FontSize = 12;
% axHRTFl.Legend.Location = 'south';
% axHRTFl.LineWidth = 1;
% set(gcf,'position',[10,10,800,600]);
% saveas(gcf,'left ear 330.png');
% saveas(gcf,'left ear 330.fig');

figure(2);
plot(faxis, smooth(20*log10(abs(HRTF_025_l)),100),'r', 'linestyle',':','linewidth',1.4);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_040_l)),100),'r', 'linestyle','-','linewidth',0.9);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_050_l)),100),'r', 'linestyle','--','linewidth',0.9);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_060_l)),100),'b', 'linestyle',':','linewidth',1.4);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_075_l)),100),'b', 'linestyle','-','linewidth',1.4);
hold on;
plot(faxis, smooth(20*log10(abs(HRTF_100_l)),100),'b', 'linestyle','--','linewidth',1.4);

legend('0.25m','0.40m','0.50m','0.60m','0.75m','1.00m');
grid on;
axHRTFl = gca;
set(axHRTFl,'xscale','log');
axHRTFl.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axHRTFl.XLim = [90,20000];
axHRTFl.YLim = [-40,40];
axHRTFl.XLabel.String = 'frequency(Hz)';
axHRTFl.YLabel.String = 'dB';
axHRTFl.Title.String = ['left ear HRTF 0 (smoothed)' char(176)];
axHRTFl.FontSize = 12;
axHRTFl.Legend.FontSize = 12;
axHRTFl.Legend.Location = 'south';
axHRTFl.LineWidth = 1;
set(gcf,'position',[10,10,800,600]);
saveas(gcf,'left ear 0 smoothed.png');
saveas(gcf,'left ear 0 smoothed.fig');


% y = 1:6;
% [X,Y] = meshgrid(faxis,y);
% 
% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\right ear' 
% figure(3);
% Z1 = [20*log10(abs(HRTF_025_r)),20*log10(abs(HRTF_040_r)),20*log10(abs(HRTF_050_r)),20*log10(abs(HRTF_060_r)),20*log10(abs(HRTF_075_r)),20*log10(abs(HRTF_100_r))]';
% waterfall(X,Y,Z1);
% yticks([1:6]);
% yticklabels({'0.25m','0.40m','0.50m','0.60m','0.75m','1.00m'});
% set(gca,'xscale','log');
% xlim([90,20000]);
% xlabel('frequency(Hz)');
% ylabel('distance');
% zlabel('dB');
% title(['right ear HRTF 330' char(176)]);
% set(gcf,'position',[10,10,900,600]);
% 
% saveas(gcf,'(distance not normalized) right ear HRTF waterfall 330.png');
% saveas(gcf,'(distance not normalized) right ear HRTF waterfall 330.fig');
% 
% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\left ear' 
% figure(4);
% Z2 = [20*log10(abs(HRTF_025_l)),20*log10(abs(HRTF_040_l)),20*log10(abs(HRTF_050_l)),20*log10(abs(HRTF_060_l)),20*log10(abs(HRTF_075_l)),20*log10(abs(HRTF_100_l))]';
% waterfall(X,Y,Z2);
% yticks([1:6]);
% yticklabels({'0.25m','0.40m','0.50m','0.60m','0.75m','1.00m'});
% set(gca,'xscale','log');
% xlim([90,20000]);
% xlabel('frequency(Hz)');
% ylabel('distance');
% zlabel('dB');
% title(['left ear HRTF 330' char(176)]);
% set(gcf,'position',[10,10,900,600]);
% 
% saveas(gcf,'(distance not normalized) left ear HRTF waterfall 330.png');
% saveas(gcf,'(distance not normalized) left ear HRTF waterfall 330.fig');

