%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% This MATLAB script convolves a dry audio signal with an HRIR in the frequency domain. The
%%%%%% outputcan be saved as a .wav file.
clear all
close all

cd 'C:\Users\root\Documents\00 phd\Database\dry audio\audio files'
%%%% dry audio
[input fs] = audioread('Cello melody2_v2_ch1_48k.wav');
% input = 0.5*input;
% dis = 40;
% ori = 270;

% for n = 1:72
%     ori = 5*(n-1);

cd('C:\Users\root\Documents\00 phd\Database');
filter_l = audioread('headphone_HD800_comp_KEMAR_Left.wav');
filter_r = audioread('headphone_HD800_comp_KEMAR_Right.wav');

%%%% convolution
output = zeros(length(input)+length(filter_l)-1,2);
output(:,1) = conv(input, filter_l);
output(:,2) = conv(input, filter_r);
output = output/max(max(abs(output)));                           % normalization (does it influence localization)

%%%% signal output
cd 'C:\Users\root\Documents\00 phd\renderer\WP1_stage3_code_original\HRTF_database_for_SOBR'
audiowrite('compensated_input_cello.wav',output,fs);
% end