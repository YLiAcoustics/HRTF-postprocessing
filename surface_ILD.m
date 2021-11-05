%%%%% This MATLAB script calculates and plots frequency- and
%%%%% distance-dependent ILDs for different azimuths in a surface plot. (Xie, Bosun 2013, Eq.3.22, p90)
clear all
close all

surface = 0;
compare_dis_dir = 1;
compare_dis_fre = 0;
savefig = 0;

fs = 48000;
N = 1024;

%%%% import data
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ILD'

ILD_25 = importdata('ILD_25cm.mat');
ILD_40 = importdata('ILD_40cm.mat');
ILD_50 = importdata('ILD_50cm.mat');
ILD_60 = importdata('ILD_60cm.mat');
ILD_75 = importdata('ILD_75cm.mat');
ILD_100 = importdata('ILD_100cm.mat');
ILD_25_db = squeeze(20*log10(abs(ILD_25)))';   % convert to dB scale
ILD_40_db = squeeze(20*log10(abs(ILD_40)))';
ILD_50_db = squeeze(20*log10(abs(ILD_50)))';
ILD_60_db = squeeze(20*log10(abs(ILD_60)))';
ILD_75_db = squeeze(20*log10(abs(ILD_75)))';
ILD_100_db = squeeze(20*log10(abs(ILD_100)))';
for n = 1:360
    ILD_25_db_smo(n,:) = smooth(ILD_25_db(n,:),10);
    ILD_40_db_smo(n,:) = smooth(ILD_40_db(n,:),10);
    ILD_50_db_smo(n,:) = smooth(ILD_50_db(n,:),10);
    ILD_60_db_smo(n,:) = smooth(ILD_60_db(n,:),10);
    ILD_75_db_smo(n,:) = smooth(ILD_75_db(n,:),10);
    ILD_100_db_smo(n,:) = smooth(ILD_100_db(n,:),10);
end
azimuth = [0:359]';
faxis = [0:N-1]'/N*fs;
[X Y] = meshgrid(faxis,azimuth);

if surface
    figure(1);
    set(gcf,'Unit','normalized');
    set(gcf, 'Position', [0.1 0.1 0.8 0.8]);
    s = surf(X,Y,ILD_25_db);
    colormap gray
    caxis([-10 20]);
    % s.EdgeColor = 'interp';
    xlabel('frequency(Hz)');
    ylabel('azimuth');
    zlabel('magnitude (dB)');
    title(strcat('ILDs at 25cm'));
    colorbar;

    ax = gca;    
    set(ax,'xscale','log');
    ax.XTick = [100,200,300,500,1000,2000,3000,5000,10000];
    ax.XLim = [100,5000];
    ax.YLim = [0,180];
    ax.ZLim = [0,40];
    ax.FontSize = 16;
end

if compare_dis_dir
    f = figure('Unit','normalized','Position', [0 0 0.8 0.8])
    subplot(3,1,1);
    plot(faxis,ILD_25_db_smo(136,:),'-r','LineWidth',1);
    hold on;
    plot(faxis,ILD_40_db_smo(136,:),'-b','LineWidth',1);
    hold on;
    plot(faxis,ILD_50_db_smo(136,:),'--r','LineWidth',1);
    hold on;
    plot(faxis,ILD_75_db_smo(136,:),'--b','LineWidth',1);
    hold on;
    plot(faxis,ILD_100_db_smo(136,:),':r','LineWidth',1.5);
    grid on;
    lgd = legend({'25cm','40cm','50cm','75cm','100cm'},'Location','northwest');legend('boxoff');lgd.NumColumns = 2;
    ax1 = gca;    
    set(ax1,'xscale','log');
    ax1.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
    ax1.XLim = [90,20000];
    ax1.YLim = [-20,40];
    ax1.XLabel.String = 'frequency(Hz)';
    ax1.YLabel.String = 'dB';
    ax1.Title.String = ['ILDs at different distances, 135' char(176) '(smoothed)'];
    ax1.FontSize = 12;
%     ax1.Legend.FontSize = 12;
    
    subplot(3,1,2);
    plot(faxis,ILD_25_db_smo(181,:),'-r','LineWidth',1);
    hold on;
    plot(faxis,ILD_40_db_smo(181,:),'-b','LineWidth',1);
    hold on;
    plot(faxis,ILD_50_db_smo(181,:),'--r','LineWidth',1);
    hold on;
    plot(faxis,ILD_75_db_smo(181,:),'--b','LineWidth',1);
    hold on;
    plot(faxis,ILD_100_db_smo(181,:),':r','LineWidth',1.5);
    grid on;
    lgd = legend({'25cm','40cm','50cm','60cm','100cm'},'Location','northwest');legend('boxoff');lgd.NumColumns = 2;
    ax1 = gca;    
    ax2 = gca;    
    set(ax2,'xscale','log');
    ax2.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
    ax2.XLim = [90,20000];
    ax2.YLim = [-20,20];
    ax2.XLabel.String = 'frequency(Hz)';
    ax2.YLabel.String = 'dB';
    ax2.Title.String = ['ILDs at different distances, 180' char(176) '(smoothed)'];
    ax2.FontSize = 12;
%     ax2.Legend.FontSize = 12;
    
%     subplot(3,1,3);
%     plot(faxis,ILD_25_db_smo(91,:),'-r','LineWidth',1);
%     hold on;
%     plot(faxis,ILD_40_db_smo(91,:),'-b','LineWidth',1);
%     hold on;
%     plot(faxis,ILD_50_db_smo(91,:),'--r','LineWidth',1);
%     hold on;
%     plot(faxis,ILD_75_db_smo(91,:),'--b','LineWidth',1);
%     hold on;
%     plot(faxis,ILD_100_db_smo(91,:),':r','LineWidth',1.5);
%     grid on;
%     lgd = legend({'25cm','40cm','50cm','75cm','100cm'},'Location','northwest');legend('boxoff');lgd.NumColumns = 2;
%     ax1 = gca;    
%     ax3 = gca;    
%     set(ax3,'xscale','log');
%     ax3.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
%     ax3.XLim = [90,500];
%     ax3.YLim = [0,60];
%     ax3.XLabel.String = 'frequency(Hz)';
%     ax3.YLabel.String = 'dB';
%     ax3.Title.String = ['ILDs at different distances, 90' char(176) '(smoothed)'];
%     ax3.FontSize = 12;
% %     ax3.Legend.FontSize = 12;
end


if savefig
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\ILD\1208'
figurename1 = strcat('ILD_surface_contra_',num2str(dis));
saveas(gcf,strcat(figurename1,'.png'));
saveas(gcf,strcat(figurename1,'.fig'));
close
end
