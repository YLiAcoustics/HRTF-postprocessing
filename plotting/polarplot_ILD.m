%%%%% This MATLAB script creates polar plots of ILDs at different distances
%%%%% for specified frequencies.
%%%%% Author: Yuqing Li
%%%%% Date: 20/01/2021
clear all
close all

freq = 100;
fs = 48000;
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ILD'
ILD_25 = importdata('ILD_25cm.mat');           % complex numbers
ILD_40 = importdata('ILD_40cm.mat');
ILD_50 = importdata('ILD_50cm.mat');
ILD_60 = importdata('ILD_60cm.mat');
ILD_75 = importdata('ILD_75cm.mat');
ILD_100 = importdata('ILD_100cm.mat');

ILD_25_db = squeeze(20*log10(abs(ILD_25)));
ILD_40_db = squeeze(20*log10(abs(ILD_40)));
ILD_50_db = squeeze(20*log10(abs(ILD_50)));
ILD_60_db = squeeze(20*log10(abs(ILD_60)));
ILD_75_db = squeeze(20*log10(abs(ILD_75)));
ILD_100_db = squeeze(20*log10(abs(ILD_100)));

ILD_25_freq = ILD_25_db(round(freq/fs*1024)+1,:);
ILD_40_freq = ILD_40_db(round(freq/fs*1024)+1,:);
ILD_50_freq = ILD_50_db(round(freq/fs*1024)+1,:);
ILD_60_freq = ILD_60_db(round(freq/fs*1024)+1,:);
ILD_75_freq = ILD_75_db(round(freq/fs*1024)+1,:);
ILD_100_freq = ILD_100_db(round(freq/fs*1024)+1,:);

figure(1)
theta = [0:180]/360*2*pi';            % only plot for the contralateral(left) ear 
polarplot(theta,ILD_25_freq([1:181]),'color','k','linestyle','-','linewidth',1);
hold on;
polarplot(theta,ILD_40_freq([1:181]),'color','m','linestyle','-','linewidth',1);
hold on;
polarplot(theta,ILD_50_freq([1:181]),'color',[0.1 0.8 0.1],'linestyle','-','linewidth',1);
hold on;
polarplot(theta,ILD_60_freq([1:181]),'color','k','linestyle',':','linewidth',1.5);
hold on;
polarplot(theta,ILD_75_freq([1:181]),'color','m','linestyle',':','linewidth',1.5);
hold on;
polarplot(theta,ILD_100_freq([1:181]),'color',[0.1 0.8 0.1],'linestyle',':','linewidth',1.5);

legend({'25cm','40cm','50cm','60cm','75cm','100cm'});
pax = gca;
pax.RLim = [0 15];
pax.ThetaLim = [0 180];
pax.ThetaZeroLocation = 'top';
pax.Title.String = strcat(['Contralateral (left) ILD, ' num2str(freq) 'Hz']);
pax.FontSize = 12;
pax.Legend.FontSize = 14;

% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ILD\plots'
% figurename = strcat('polarplot_ILD_',num2str(freq),'Hz');
% saveas(gcf,strcat(figurename,'.png'));
% saveas(gcf,strcat(figurename,'.fig'));
% close