%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% This MATLAB script convolves a dry audio signal with an HRIR in the frequency domain. The
%%%%%% outputcan be saved as a .wav file.
clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\dry audio\audio files'
%%%% dry audio
[input fs] = audioread('castanetcut_48.wav');
input = 0.5*input;
dis = 40;
ori = 270;

% for n = 1:72
%     ori = 5*(n-1);
%%% HRIR
filepath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\HRIRs\1203\',num2str(dis),'cm');
cd(filepath);
filename_l = strcat('HRIR_',num2str(dis),'_',num2str(ori),'_l.wav');
filename_r = strcat('HRIR_',num2str(dis),'_',num2str(ori),'_r.wav');
HRIR_l = audioread(filename_l);
HRIR_r = audioread(filename_r);

%%%% convolution
output = zeros(length(input)+length(HRIR_l)-1,2);
output(:,1) = conv(input, HRIR_l);
output(:,2) = conv(input, HRIR_r);
% output = output/max(max(abs(output)));                           % normalization (does it influence localization)

%%%% signal output
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\convolved audio\1207'
outputname = strcat('1207_',num2str(dis),'_',num2str(ori),'.wav');
audiowrite(outputname,output,fs);
% end