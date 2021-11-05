%%%%% This MATLAB script calculates and plots frequency- and
%%%%% distance-dependent ILDs for different azimuths in a surface plot. (Xie, Bosun 2013, Eq.3.22, p90)
clear all
close all

surface = 0;
compare = 1;
savefig = 0;

fs = 48000;
N = 1024;

%%%% importHRTF
cd('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRIR')

dis = 25;
HRIR_25 = importdata(strcat('HRIR_interp_',num2str(dis),'cm.mat'));
ILD_25 = zeros(360,N);
for n = 1:360
    HRTF_l = fft(HRIR_25(:,1,n));
    HRTF_r = fft(HRIR_25(:,2,n));
    ILD_25(n,:) = 20*log10(abs(HRTF_l./HRTF_r));
end

dis = 40;
HRIR_40 = importdata(strcat('HRIR_interp_',num2str(dis),'cm.mat'));
ILD_40 = zeros(360,N);
for n = 1:360
    HRTF_l = fft(HRIR_40(:,1,n));
    HRTF_r = fft(HRIR_40(:,2,n));
    ILD_40(n,:) = 20*log10(abs(HRTF_l./HRTF_r));
end

dis = 50;
HRIR_50 = importdata(strcat('HRIR_interp_',num2str(dis),'cm.mat'));
ILD_50 = zeros(360,N);
for n = 1:360
    HRTF_l = fft(HRIR_50(:,1,n));
    HRTF_r = fft(HRIR_50(:,2,n));
    ILD_50(n,:) = 20*log10(abs(HRTF_l./HRTF_r));
end

dis = 60;
HRIR_60 = importdata(strcat('HRIR_interp_',num2str(dis),'cm.mat'));
ILD_60 = zeros(360,N);
for n = 1:360
    HRTF_l = fft(HRIR_60(:,1,n));
    HRTF_r = fft(HRIR_60(:,2,n));
    ILD_60(n,:) = 20*log10(abs(HRTF_l./HRTF_r));
end

dis = 75;
HRIR_75 = importdata(strcat('HRIR_interp_',num2str(dis),'cm.mat'));
ILD_75 = zeros(360,N);
for n = 1:360
    HRTF_l = fft(HRIR_75(:,1,n));
    HRTF_r = fft(HRIR_75(:,2,n));
    ILD_75(n,:) = 20*log10(abs(HRTF_l./HRTF_r));
end

dis = 100;
HRIR_100 = importdata(strcat('HRIR_interp_',num2str(dis),'cm.mat'));
ILD_100 = zeros(360,N);
for n = 1:360
    HRTF_l = fft(HRIR_100(:,1,n));
    HRTF_r = fft(HRIR_100(:,2,n));
    ILD_100(n,:) = 20*log10(abs(HRTF_l./HRTF_r));
end

azimuth = [0:359]';
faxis = [0:length(HRTF_l)-1]'/length(HRTF_l)*fs;

if surface
figure(1);
set(gcf,'Unit','normalized');
set(gcf, 'Position', [0.1 0.1 0.8 0.8]);
surface(faxis,azimuth,ILD);
colormap gray
caxis([0 70]);
shading interp
xlabel('frequency(Hz)');
ylabel('azimuth');
title(strcat('r = ',num2str(dis),'cm'));
colorbar;

ax = gca;    
set(ax,'xscale','log');
ax.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
ax.XLim = [90,20000];
ax.YLim = [180,355];
ax.FontSize = 16;
end

if compare
figure(2);
[X,Y] = meshgrid(azimuth,faxis);
set(gcf,'Unit','normalized');
set(gcf, 'Position', [0.1 0.1 0.8 0.8]);
surf(azimuth,faxis,ILD_25);
hold on;
surf(azimuth,faxis,ILD_40);
hold on;
surf(azimuth,faxis,ILD_50);
hold on;
surf(azimuth,faxis,ILD_60);
hold on;
surf(azimuth,faxis,ILD_75);
hold on;
surf(azimuth,faxis,ILD_100);
grid on;

legend({'25cm','40cm','50cm','60cm','75cm','100cm'},'Location','southwest');
legend('boxoff');
axr = gca;    
set(axr,'xscale','log');
axr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axr.XLim = [90,20000];
axr.YLim = [-70,30];
axr.XLabel.String = 'frequency(Hz)';
axr.YLabel.String = 'dB';
axr.Title.String = ['ILDs at ' num2str(ori) char(176) 'smoothed (s=4)'];
axr.FontSize = 12;
axr.Legend.FontSize = 12;
axr.LineWidth = 1;
end

if savefig
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\ILD\1208'
figurename1 = strcat('ILD_surface_contra_',num2str(dis));
saveas(gcf,strcat(figurename1,'.png'));
saveas(gcf,strcat(figurename1,'.fig'));
close
end
