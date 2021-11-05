%%%% This MATLAB script analyzes the loudspeaker directivity from the results of loudspeaker measurements.
%%%% Results are plotted in the form of (1) polar plot (2) color map (3) off axis plot 
%%%% Author: Yuqing Li
%%%% Last modified: 08/04/2021

clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\0729loudspeaker\Loudspeaker measurement 0804\loudspeaker response with inverse filter\data'
%% 0. Specify parameters and import data
fs = 44100;                % Sampling rate
t_pre = 0.05;              % length of extended acquisition (s)
t_windur = 0.01;           % window duration (s) %% ATTENTION: determines frequency resolution for fft: f_reso = 1/t_windur

% specify time window lengths (in samples)
L = floor(fs*t_windur);    % total number of samples in the truncated signal

L1 = 20;                            % length of half Hann window 1 
L2 = 10;                            % pad before peak
L4 = 50;                           % length of half Hann window 2
L3 = L-L1-L2-L4;                   % pad after peak

% FFT length (find the next power of 2 that is no less than L)
N = 2^nextpow2(L);  

ir_matrix = zeros(N,54+1);
Spec_matrix = zeros(floor(N/2)+1,54+1);

angle = [0:5:85,90:10:180,185:5:265,270:10:360]; 
ir_matrix = zeros(22050,37);
FR_matrix = zeros(22050,37);
for n = -18:18
    dataname = strcat('iv measurement_',num2str(5*n),'.mat'); 
    data = importdata(dataname);  
    ir_matrix(:,n+19) = data.ave_ir;
    FR_matrix(:,n+19) = data.ave_FR;

%% 1. Time windowing and FFT
% find the 1st peak in the impulse response
[M,I] = max(abs(raw_ir));             % store the peak values and indices

assert(L1+L2+fs*t_pre<I)           % Check if window length is shorter than the initial delay. assert: through error if condition false

w1 = hann(2*L1+1);                       
w1 = w1(1:L1);                    % half Hann window 1 (before peak)
w2 = hann(2*L4+1);
w2 = w2(L4+2:end);                 % half Hann window 2 (after peak)

win = [w1;ones(L2+L3,1);w2];
win = [zeros(I-L1-L2+1,1);win];
win = [win;zeros(length(raw_ir)-length(win),1)];

% apply time window and truncate the new ir to the length of N
new_ir = raw_ir.*win;
final_ir = new_ir([I-L1-L2:I-L1-L2+N-1]); 
% save into the ir matrix
ir_matrix(:,n) = final_ir;

% FFT: frequency response
FR = fft(final_ir);   

% Generate the spectrum
P2 = abs(FR);
P1 = 2*P2(1:floor(N/2)+1);
P1(1) = P1(1)/2;
P1(end) = P1(end)/2;
% save into the spectrum matrix
Spec_matrix(:,n) = P1;
end

ir_matrix(:,55) = ir_matrix(:,1);
Spec_matrix(:,55) = Spec_matrix(:,1);

%% 2. Plot results
faxis = [0:floor(N/2)]/N*fs;

% polar plot 
figure(1)
set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
plot_angle = [deg2rad([0:5:85]),deg2rad([90:10:180]),deg2rad([185:5:265]),deg2rad([270:10:360])];       % ATTENTION: theta should be in radians
 % specify frequencies to plot
freq_1 = 200;           % frequency to inspect (Hz)
[min_diff index_1] = min(abs(freq_1-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_1,:)/(20*10^(-6)))),'--b','MarkerSize',3,'LineWidth',1);hold on;
freq_2 = 1000;  
[min_diff index_2] = min(abs(freq_2-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_2,:)/(20*10^(-6)))),'--r','MarkerSize',3,'LineWidth',1);hold on;
freq_3 = 2000;  
[min_diff index_3] = min(abs(freq_3-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_3,:)/(20*10^(-6)))),'--g','MarkerSize',3,'LineWidth',1);hold on;
freq_4 = 4000;  
[min_diff index_4] = min(abs(freq_4-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_4,:)/(20*10^(-6)))),'--m','MarkerSize',3,'LineWidth',1);hold on;
freq_5 = 6000;  
[min_diff index_5] = min(abs(freq_5-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_5,:)/(20*10^(-6)))),'--k','MarkerSize',3,'LineWidth',1);hold on;
freq_6 = 10000;  
[min_diff index_6] = min(abs(freq_6-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_6,:)/(20*10^(-6)))),'-b','MarkerSize',3,'LineWidth',1);hold on;
freq_7 = 13000;  
[min_diff index_7] = min(abs(freq_7-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_7,:)/(20*10^(-6)))),'-r','MarkerSize',3,'LineWidth',1);hold on;
freq_8 = 15000;  
[min_diff index_8] = min(abs(freq_8-faxis));  
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_8,:)/(20*10^(-6)))),'-g','MarkerSize',3,'LineWidth',1);hold on;
freq_9 = 18000;  
[min_diff index_9] = min(abs(freq_9-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_9,:)/(20*10^(-6)))),'-m','MarkerSize',3,'LineWidth',1);hold on;
freq_10 = 20000;  
[min_diff index_10] = min(abs(freq_10-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
polarplot(plot_angle,20*log10(abs(Spec_matrix(index_10,:)/(20*10^(-6)))),'-k','MarkerSize',3,'LineWidth',1);hold on;

rlim([-10 90]);
legend({strcat(num2str(round(faxis(index_1))),'Hz'),strcat(num2str(round(faxis(index_2))),'Hz'),...
    strcat(num2str(round(faxis(index_3))),'Hz'),strcat(num2str(round(faxis(index_4))),'Hz'),...
    strcat(num2str(round(faxis(index_5))),'Hz'),strcat(num2str(round(faxis(index_6))),'Hz'),...
    strcat(num2str(round(faxis(index_7))),'Hz'),strcat(num2str(round(faxis(index_8))),'Hz'),...
    strcat(num2str(round(faxis(index_9))),'Hz'),strcat(num2str(round(faxis(index_10))),'Hz')});
title(strcat(['Magnitude (dB)']));
ax = gca; 
ax.Position = [0 0.1 0.8 0.8];
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
ax.RTick = [0:10:90];
ax.RTickLabel = {'0dB','10dB','20dB','30dB','40dB','50dB','60dB','70dB','80dB','90dB'};
ax.FontName = 'Times New Roman'; ax.FontSize = 14;
grid on;

% figure(2)
% set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
%  % specify frequencies to plot
% freq_5 = 2000;  
% [min_diff index_5] = min(abs(freq_5-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
% polarplot(plot_angle,20*log10(abs(Spec_matrix(index_5,:)/(20*10^(-6)))),'--m','MarkerSize',3,'LineWidth',1);hold on;
% freq_6 = 4000;  
% [min_diff index_6] = min(abs(freq_6-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
% polarplot(plot_angle,20*log10(abs(Spec_matrix(index_6,:)/(20*10^(-6)))),'-b','MarkerSize',3,'LineWidth',1);hold on;
% freq_7 = 6000;  
% [min_diff index_7] = min(abs(freq_7-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
% polarplot(plot_angle,20*log10(abs(Spec_matrix(index_7,:)/(20*10^(-6)))),'-r','MarkerSize',3,'LineWidth',1);hold on;
% freq_8 = 10000;  
% [min_diff index_8] = min(abs(freq_8-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
% polarplot(plot_angle,20*log10(abs(Spec_matrix(index_8,:)/(20*10^(-6)))),'-k','MarkerSize',3,'LineWidth',1);hold on;
% freq_9 = 15000;  
% [min_diff index_9] = min(abs(freq_9-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
% polarplot(plot_angle,20*log10(abs(Spec_matrix(index_9,:)/(20*10^(-6)))),'-g','MarkerSize',3,'LineWidth',1);hold on;
% freq_10 = 20000;  
% [min_diff index_10] = min(abs(freq_10-faxis));         % find the index in the faxis that corresponds to the frequency closest to the frequency to inspect
% polarplot(plot_angle,20*log10(abs(Spec_matrix(index_10,:)/(20*10^(-6)))),'-m','MarkerSize',3,'LineWidth',1);hold on;
% 
% rlim([-10 80]);
% legend({strcat(num2str(faxis(index_5)),'Hz'),strcat(num2str(faxis(index_6)),'Hz'),strcat(num2str(faxis(index_7)),'Hz'),strcat(num2str(faxis(index_8)),'Hz'),strcat(num2str(faxis(index_9)),'Hz'),strcat(num2str(faxis(index_10)),'Hz'),});
% title(strcat(['Magnitude (dB)']));
% ax = gca; 
% ax.Position = [0 0.1 0.8 0.8];
% ax.ThetaZeroLocation = 'top';
% ax.ThetaDir = 'clockwise';
% ax.RTick = [0:10:80];
% ax.RTickLabel = {'0dB','10dB','20dB','30dB','40dB','50dB','60dB','70dB','80dB'};
% ax.FontName = 'Times New Roman'; ax.FontSize = 14;
% grid on;

% Frequency Spectrum color map 
figure(3)
set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% swap positions of angles so that 0 degree is at the center of the colormap
plot_angle_colormap = [plot_angle(28:54)-2*pi,plot_angle(1:28)];
Spec_matrix_colormap = [Spec_matrix(:,28:54),Spec_matrix(:,1:28)];
for k = 1:27
    Spec_matrix_colormap(:,k) = Spec_matrix_colormap(:,k)./Spec_matrix_colormap(:,28);
end
for k = 29:55
    Spec_matrix_colormap(:,k) = Spec_matrix_colormap(:,k)./Spec_matrix_colormap(:,28);
end
Spec_matrix_colormap(:,28) = 1;
[X,Y] = meshgrid(faxis,rad2deg(plot_angle_colormap));
surface(X,Y,20*log10(abs(Spec_matrix_colormap')),'FaceColor','interp','LineStyle','none');
colorbar
colormap jet
xlim([1/t_windur 20000]);   ylim([-90 90]);
caxis([-20 10]);
xlabel('frequency (Hz)'); ylabel('direction (degrees)'); 
title('Directivity Color Map (Normalized to 0 degree)');
xticks([20 30 50 100 200 300 500 1000 2000 3000 5000 10000 20000]);
yticks([-90:30:90]);
ax = gca; ax.XScale = 'log'; ax.FontName = 'Times New Roman'; ax.FontSize = 18;
ax.YTickLabel={'-90','-60','-30','0','30','60','90'};

% Frequency Spectrum off axis plot 
figure(4)
set(gcf,'Unit','normalized'); set(gcf,'Position',[0.13,0.15,0.78,0.76]);
% 0
plot(faxis,20*log10(abs(Spec_matrix(:,1)/(20*10^(-6)))),'b','LineWidth',1);hold on;
% 30
plot(faxis,20*log10(abs(Spec_matrix(:,7)/(20*10^(-6)))),'r','LineWidth',1);hold on;
% 60
plot(faxis,20*log10(abs(Spec_matrix(:,13)/(20*10^(-6)))),'g','LineWidth',1);hold on;
% 90
plot(faxis,20*log10(abs(Spec_matrix(:,19)/(20*10^(-6)))),'k','LineWidth',1);hold on;
% 120
plot(faxis,20*log10(abs(Spec_matrix(:,22)/(20*10^(-6)))),'m','LineWidth',1);hold on;
% 150
plot(faxis,20*log10(abs(Spec_matrix(:,25)/(20*10^(-6)))),'Color','#EDB120','LineWidth',1);hold on;
% 180
plot(faxis,20*log10(abs(Spec_matrix(:,28)/(20*10^(-6)))),'Color','#7E2F8E','LineWidth',1);
grid on;
xlim([1/t_windur 20000]);  % ylim([min(20*log10(abs(P1/(20*10^(-6)))))-10 max(20*log10(abs(P1/(20*10^(-6)))))+10]);
xlabel('frequency (Hz)'); ylabel('magnitude (dB)'); 
legend({strcat('0',char(176)),strcat('30',char(176)),strcat('60',char(176)),strcat('90',char(176)),strcat('120',char(176)),strcat('150',char(176)),strcat('180',char(176))},'Location','southwest');
title('Frequency Spectrum - off axis plot');
xticks([20 30 50 100 200 300 500 1000 2000 3000 5000 10000 20000]);
ax = gca; ax.XScale = 'log'; ax.FontName = 'Times New Roman'; ax.FontSize = 16;