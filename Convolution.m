%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% This MATLAB script convolves a dry audio signal with an HRIR in the frequency domain. The
%%%%%% outputcan be saved as a .wav file.
clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\ListeningExperiments\TestFolder\Part1\P1renderer\NF binaural renderer\media'
%%%% dry audio
[input fs] = audioread('white_Gaussian_noise_pulse_train.wav');
% input = 0.5*input;
% dis = 40;
% ori = 270;

% for n = 1:72
%     ori = 5*(n-1);

% cd('C:\Users\root\Documents\00 phd\Database');
sig_l = audioread('conti_HRTF_01_left.wav');
sig_r = audioread('conti_HRTF_01_right.wav');

% 0
filter_l_0 = sig_l([1:512]);
filter_r_0 = sig_r([1:512]);

% 90 
filter_l_90 = sig_l(512*90+[1:512]);
filter_r_90 = sig_r(512*90+[1:512]);

% 150
filter_l_150 = sig_l(512*150+[1:512]);
filter_r_150 = sig_r(512*150+[1:512]);

% 300
filter_l_300 = sig_l(512*300+[1:512]);
filter_r_300 = sig_r(512*300+[1:512]);

%%%% convolution
output_0 = zeros(length(input)+512-1,2);
output_0(:,1) = conv(input, filter_l_0);
output_0(:,2) = conv(input, filter_r_0);
output_90 = zeros(length(input)+512-1,2);
output_90(:,1) = conv(input, filter_l_90);
output_90(:,2) = conv(input, filter_r_90);
output_150 = zeros(length(input)+512-1,2);
output_150(:,1) = conv(input, filter_l_150);
output_150(:,2) = conv(input, filter_r_150);
output_300 = zeros(length(input)+512-1,2);
output_300(:,1) = conv(input, filter_l_300);
output_300(:,2) = conv(input, filter_r_300);

M = max(max(max(max(max(abs([output_0;output_90;output_150;output_300;]))))));                          % normalization (does it influence localization)
output_0 = output_0/M;
output_90 = output_90/M;
output_150 = output_150/M;
output_300 = output_300/M;

%%%% signal output
% cd 'C:\Users\root\Documents\00 phd\renderer\WP1_stage3_code_original\HRTF_database_for_SOBR'
audiowrite('output_0.wav',output_0,fs);
audiowrite('output_90.wav',output_90,fs);
audiowrite('output_150.wav',output_150,fs);
audiowrite('output_300.wav',output_300,fs);
% end