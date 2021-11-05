%%%%%%%%%%% This MATLAB script produces contour plots out HRTFs as a
%%%%%%%%%%% function of azimuth and frequency
%%%%%%%%%%% Author: Yuqing Li
%%%%%%%%%%% Date: 19/01/2021

clear all
close all

savefigure = 1;

%% Import data
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRTF'
dis = 25;
fs = 48000;
filename = strcat('HRTF_interp_',num2str(dis),'cm.mat');
HRTF_raw = importdata(filename);
N = length(squeeze(HRTF_raw(:,1,1)));

HRTF = HRTF_raw(1:round(N*16000/48000),:,:);
HRTF_l = squeeze(HRTF(:,1,:));
HRTF_l = HRTF_l';
HRTF_r = squeeze(HRTF(:,2,:));
HRTF_r = HRTF_r';
for n = 1:360
    HRTF_l_smooth(n,:) = smooth(HRTF_l(n,:),5);
    HRTF_r_smooth(n,:) = smooth(HRTF_r(n,:),5);
end
azimuth = [0:359];                                     % y axis
faxis = [0:round(N*16000/48000)-1]'/N*fs;              % x axis  
[X,Y] = meshgrid(faxis,azimuth);

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRTF\plots\original'
figure(1);
s = surface(X,Y,20*log10(abs(HRTF_l)));           % left ear contour plot
% s = surface(X,Y,20*log10(abs(HRTF_l_smooth)));  
xlim([90 16000]);
ylim([0 359]);
caxis([-40 30]);
xlabel('Frequency (Hz)');
ylabel('Azimuth (degrees)');
yticks([0:45:315]);
title(strcat('left ear HRTFs:', num2str(dis),'cm (dB)'));
s.EdgeColor = 'none';
colormap(jet);
colorbar;
if savefigure
    figurename = strcat('surface_l_',num2str(dis));
    saveas(gcf,strcat(figurename,'.png'));
    saveas(gcf,strcat(figurename,'.fig'));
    close
end

figure(2);
s = surface(X,Y,20*log10(abs(HRTF_r)));           % right ear contour plot
% s = surface(X,Y,20*log10(abs(HRTF_r_smooth)));     
xlim([90 16000]);
ylim([0 359]);
caxis([-40 30]);
xlabel('Frequency (Hz)');
ylabel('Azimuth (degrees)');
yticks([0:45:315]);
title(strcat('right ear HRTFs:', num2str(dis),'cm (dB)'));
s.EdgeColor = 'none';
colormap(jet);
colorbar;
if savefigure
    figurename = strcat('surface_r_',num2str(dis));
    saveas(gcf,strcat(figurename,'.png'));
    saveas(gcf,strcat(figurename,'.fig'));
    close
end

figure(3);
s = surface(X,Y,20*log10(abs(HRTF_l)));           % left ear contour plot
% s = surface(X,Y,20*log10(abs(HRTF_l_smooth)));
xlim([700 16000]);
ylim([0 359]);
caxis([-40 30]);
xticks([1000,2000,3000,5000,10000]);
xlabel('Frequency (Hz)');
ylabel('Azimuth (degrees)');
yticks([0:45:315]);
set(gca,'XScale','log');
title(strcat('left ear HRTFs:', num2str(dis),'cm (dB)'));
s.EdgeColor = 'none';
colormap(jet);
colorbar;
if savefigure
    figurename = strcat('surface_l_',num2str(dis),'_bandlim');
    saveas(gcf,strcat(figurename,'.png'));
    saveas(gcf,strcat(figurename,'.fig'));
    close
end

figure(4);
s = surface(X,Y,20*log10(abs(HRTF_r)));           % left ear contour plot
% s = surface(X,Y,20*log10(abs(HRTF_r_smooth)));
xlim([700 16000]);
ylim([0 359]);
caxis([-40 30]);
xticks([1000,2000,3000,5000,10000]);
xlabel('Frequency (Hz)');
ylabel('Azimuth (degrees)');
yticks([0:45:315]);
set(gca,'XScale','log');
title(strcat('right ear HRTFs:', num2str(dis),'cm (dB)'));
s.EdgeColor = 'none';
colormap(jet);
colorbar;
if savefigure
    figurename = strcat('surface_r_',num2str(dis),'_bandlim');
    saveas(gcf,strcat(figurename,'.png'));
    saveas(gcf,strcat(figurename,'.fig'));
    close
end
