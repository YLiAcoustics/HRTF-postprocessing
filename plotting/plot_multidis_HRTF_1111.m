%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% This MATLAB script plots and compares HRTF magnitudes at different source distances.
clear all
close all

smooth_HRTF = 1;
span = 4;
savefig = 0;
fs = 48000;
ori = 330;

%%%% HRTF
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRTF'
HRTF_25 = importdata('HRTF_interp_25cm.mat');
HRTF_25_l = HRTF_25(:,1,ori+1);
HRTF_25_r = HRTF_25(:,2,ori+1);

HRTF_50 = importdata('HRTF_interp_50cm.mat');
HRTF_50_l = HRTF_50(:,1,ori+1);
HRTF_50_r = HRTF_50(:,2,ori+1);

HRTF_75 = importdata('HRTF_interp_75cm.mat');
HRTF_75_l = HRTF_75(:,1,ori+1);
HRTF_75_r = HRTF_75(:,2,ori+1);

HRTF_100 = importdata('HRTF_interp_100cm.mat');
HRTF_100_l = HRTF_100(:,1,ori+1);
HRTF_100_r = HRTF_100(:,2,ori+1);

faxis = [0:length(HRTF_25_l)-1]'/length(HRTF_25_l)*fs;

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRTF\plots\multi distance'
figure(1);
if smooth_HRTF
    plot(faxis, smooth(20*log10(abs(HRTF_25_r)),span),'-b','linewidth',1.5);
    hold on;
    plot(faxis, smooth(20*log10(abs(HRTF_50_r)),span),'-m','linewidth',1.5);
    hold on;
    plot(faxis, smooth(20*log10(abs(HRTF_75_r)),span),'--b','linewidth',2);
    hold on;
    plot(faxis, smooth(20*log10(abs(HRTF_100_r)),span),'--m','linewidth',2);
    grid on;
else
    plot(faxis, 20*log10(abs(HRTF_25_r)),'-b', 'linewidth',1.5);
    hold on;
    plot(faxis, 20*log10(abs(HRTF_50_r)),'-m','linewidth',1.5);
    hold on;
    plot(faxis, 20*log10(abs(HRTF_75_r)),'--b','linewidth',2);
    hold on;
    plot(faxis, 20*log10(abs(HRTF_100_r)),'--m','linewidth',2);
    grid on;
end
legend({'25cm','50cm','75cm','100cm'},'Location','southwest');
legend('boxoff');
axr = gca;    
set(axr,'xscale','log');
axr.XTick = [100,200,300,500,1000,2000,3000,5000,10000];
axr.XLim = [90,16000];
axr.YLim = [-40,20];
axr.XLabel.String = 'frequency(Hz)';
axr.YLabel.String = 'dB';
axr.Title.String = ['Right-ear HRTFs at ' num2str(ori) char(176) 'smoothed'];
axr.FontSize = 12;
axr.Legend.FontSize = 12;
axr.LineWidth = 1;

if savefig
figurename1 = strcat('Right-ear HRTFs_',num2str(ori));
saveas(gcf,strcat(figurename1,'.png'));
saveas(gcf,strcat(figurename1,'.fig'));
close
end

figure(2);
if smooth_HRTF
    plot(faxis, smooth(20*log10(abs(HRTF_25_l)),span),'-b','linewidth',1.5);
    hold on;
    plot(faxis, smooth(20*log10(abs(HRTF_50_l)),span),'-m','linewidth',1.5);
    hold on;
    plot(faxis, smooth(20*log10(abs(HRTF_75_l)),span),'--b','linewidth',2);
    hold on;
    plot(faxis, smooth(20*log10(abs(HRTF_100_l)),span),'--m','linewidth',2);
    grid on;
else
    plot(faxis, 20*log10(abs(HRTF_25_l)),'-b','linewidth',1.5);
    hold on;
    plot(faxis, 20*log10(abs(HRTF_50_l)),'-m','linewidth',1.5);
    hold on;
    plot(faxis, 20*log10(abs(HRTF_75_l)),'--b','linewidth',2);
    hold on;
    plot(faxis, 20*log10(abs(HRTF_100_l)),'--m','linewidth',2);
    grid on;
end
legend({'25cm','50cm','75cm','100cm'},'Location','southwest');
legend('boxoff');
axl = gca;
set(axl,'xscale','log');
axl.XTick = [100,200,300,500,1000,2000,3000,5000,10000,20000];
axl.XLim = [90,16000];
axl.YLim = [-40,20];
axl.XLabel.String = 'frequency(Hz)';
axl.YLabel.String = 'dB';
axl.Title.String = ['Left-ear HRTFs at ' num2str(ori) char(176) ' smoothed'];
axl.FontSize = 12;
axl.Legend.FontSize = 12;
axl.LineWidth = 1;

if savefig
figurename2 = strcat('Left-ear HRTFs_',num2str(ori));
saveas(gcf,strcat(figurename2,'.png'));
saveas(gcf,strcat(figurename2,'.fig'));
close
end