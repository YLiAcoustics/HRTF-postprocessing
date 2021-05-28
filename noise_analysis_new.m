clear all
close all

fs = 48000;

% Specify parameters and import data
cd 'C:\Users\root\Documents\00 phd\measurement\210324 Point source directivity\0324\vertical_microphone\01'  
data01 = importdata('measurement01.mat');  
taxis01 = cell2mat(data01.AcquiredWaveform(4,1));
aw01 = cell2mat(data01.AcquiredWaveform(4,2));
L01 = length(aw01);
fft_aw01 = fft(aw01);
spec_aw01 = 2*fft_aw01([1:ceil(L01/2)])/L01;
spec_aw01(1) = fft_aw01(1)/L01;

cd 'C:\Users\root\Documents\00 phd\measurement\210324 Point source directivity\0324\0_input'
noise02 = importdata('noise02.mat');  
taxis02 = cell2mat(noise02.AcquiredWaveform(4,1));
aw02 = cell2mat(noise02.AcquiredWaveform(4,2));
aw02 = aw02(1:24000);
L02 = length(aw02);
fft_aw02 = fft(aw02);
spec_aw02 = 2*fft_aw02([1:ceil(L02/2)])/240;
spec_aw02(1) = fft_aw02(1)/2400;

faxis = [0:ceil(L02/2)-1]/L02*fs;
% figure(1)
% plot(taxis,aw);
% xlim([0 5]);
% xlabel('time(s)');
% ylabel('magnitude(Pa)');
figure(2)
plot(faxis,20*log10(abs(spec_aw01/(20*10^(-6)))),'b');
hold on
plot(faxis,20*log10(abs(spec_aw02/(20*10^(-6)))),'r');
xlim([100 20000]);
ax = gca;
ax.XScale = 'log';
figure(3)
plot(faxis,20*log10(abs(spec_aw01./spec_aw02)),'r');
xlim([100 20000]);
ax = gca;
ax.XScale = 'log';