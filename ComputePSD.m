
%% Calculate perceptual spectral difference for binaural signals.
%% Model: mckenzie2021
%% Yuqing Li, August 2022

clear;close all;

fs = 48000;

%% 0. Import HRTFs and input sigal
cd 'C:\Users\root\Documents\00phd\00Measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs'
hrir1=importdata('HRIR_mea_128.mat');
hrir2=importdata('HRIR_sim_128.mat');
cd 'C:\Users\root\Documents\00phd\00HRTFDatabases\dry audio\audio files'  
monosig=audioread('Gaussian_white_noise_3s.wav');
monosig=monosig(1:fs);

s1=size(hrir1);
s2=size(hrir2);

RMS1 = rms(hrir1);
RMS2 = rms(hrir2);
hrir1 = hrir1/mean(RMS1(:));
hrir2 = hrir2/mean(RMS2(:));
MAX = max(max(max(max(max(abs(hrir1))))),max(max(max(max(abs(hrir2))))));
hrir1 = hrir1/MAX;
hrir2 = hrir2/MAX;

%% 2. Calculate perceptual spectral difference
domFlag=0;           % time (0) / frequency (1) / frequency_dB (2)
f=struct('fs',fs,'nfft',s1(1),'minFreq',20,'maxFreq',20000);
for i=1:min(s1(4),s2(4))
    for j=1:s1(3)
        tic
        HRIR1=hrir1(:,:,j,i);
        HRIR2=hrir2(:,:,j,i);
        %% generate binaural signals
        binsig1(:,1) = conv(monosig,HRIR1(:,1));
        binsig1(:,2) = conv(monosig,HRIR1(:,2));
        binsig2(:,1) = conv(monosig,HRIR2(:,1));
        binsig2(:,2) = conv(monosig,HRIR2(:,2));
        [~,PSpecDiff]=mckenzie2021(binsig1,binsig2,domFlag,f);
        PavgSpecDiffS = mean(PSpecDiff,2);
        PSD(j,i) = PavgSpecDiffS;
        toc
    end
    i
end

figure
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.6 0.5]);
daxis = 19:119;
aaxis = 0:10:350;
[X,Y] = meshgrid(daxis,aaxis);
s = pcolor(X,Y,PSD');
set(gca, 'Layer', 'top')
s.EdgeColor = 'none';
s.FaceColor = 'interp';
h = colorbar('XTick', 0:1:5);
h.Label.String = 'PSD (sones)';
h.FontSize=10;
ax=gca;
ax.CLim=[0 5];
ax.FontSize=12;
yticks(0:30:360);
ylabel(['azimuth (' char(176) ')']);
xlabel('distance (cm)');

% plot PSD
figure
left_color = [16 87 163]/255;
right_color = [201 197 52]/255;
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.6 0.5]);
plot(19:119,mean(PSD,2),'LineWidth',1.4,'Color','k');hold on;
ylabel('PSD (sones)');
ylim([0 5]);
xlim([19 119]);
xticks([19:20:119]);
xlabel('distance (cm)');
set(gca,'FontSize',12);
set(gca,'LineWidth',1);
grid

