%%%%% This MATLAB script calculates frequency- and distance-dependent ILD
%%%%% from measured HRTFs. (Xie, Bosun 2013, Eq.3.22, p90)
clear all
close all

% smooth_plot = 1;
% savefig = 0;
% span = 4;

fs = 48000;
dis = 100;

%%%% HRTF
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRTF'
filename = strcat('HRTF_interp_',num2str(dis),'cm.mat');
HRTF = importdata(filename);
HRTF_l = HRTF(:,1,:);
HRTF_r = HRTF(:,2,:);
ILD_mat = HRTF_r./HRTF_l;

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ILD'
save(strcat('ILD_',num2str(dis),'cm.mat'),'ILD_mat');
% 
% N = length(squeeze(HRTF_raw(:,1,1)));
% faxis = [0:round(N*16000/48000)-1]'/N*fs;

% 
% figure(1);
% set(gcf, 'Position', get(0, 'Screensize'));
% if smooth_plot
% plot(faxis, smooth(ILD_25,span),'LineStyle',':','Color','#D95319','linewidth',1);
% hold on;
% plot(faxis, smooth(ILD_40,span),'-b','linewidth',0.9);
% hold on;
% plot(faxis, smooth(ILD_50,span),'--m','linewidth',1);
% hold on;
% plot(faxis, smooth(ILD_60,span),'LineStyle',':','Color','#D95319','linewidth',1.5);
% hold on;
% plot(faxis, smooth(ILD_75,span),'-b','linewidth',1.5);
% hold on;
% plot(faxis, smooth(ILD_100,span),'--m','linewidth',1.5);
% grid on;
% else
% plot(faxis, ILD_25,'LineStyle',':','Color','#D95319','linewidth',1);
% hold on;
% plot(faxis, ILD_40,'-b','linewidth',0.9);
% hold on;
% plot(faxis, ILD_50,'--m','linewidth',1);
% hold on;
% plot(faxis, ILD_60,'LineStyle',':','Color','#D95319','linewidth',1.5);
% hold on;
% plot(faxis, ILD_75,'-b','linewidth',1.5);
% hold on;
% plot(faxis, ILD_100,'--m','linewidth',1.5);
% grid on;
% end
% 
% legend({'25cm','40cm','50cm','60cm','75cm','100cm'},'Location','southwest');
% legend('boxoff');
% axr = gca;    
% set(axr,'xscale','log');
% axr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
% axr.XLim = [90,20000];
% axr.YLim = [-70,30];
% axr.XLabel.String = 'frequency(Hz)';
% axr.YLabel.String = 'dB';
% axr.Title.String = ['ILDs at ' num2str(ori) char(176) 'smoothed (s=4)'];
% axr.FontSize = 12;
% axr.Legend.FontSize = 12;
% axr.LineWidth = 1;
% 
% if savefig
% figurename1 = strcat('ILD_',num2str(ori),'_smoothed');
% saveas(gcf,strcat(figurename1,'.png'));
% saveas(gcf,strcat(figurename1,'.fig'));
% close
% end
