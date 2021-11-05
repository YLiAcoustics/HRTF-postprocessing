%%%% This MATLAB script takes HRIRs as input, calculates corresponding
%%%% HRTFs and displays them if required.
clear all
close all

% 0. options
plot_HRTF = 1;

% 1. import HRIRs
cd 'C:\Users\root\Documents\00 phd\Database\SCUT HRTF (near-field)\HRIR data'
HRIR_l = importdata('SCUT_HRIR_left_1m.mat');
HRIR_r = importdata('SCUT_HRIR_right_1m.mat');
HRTF_l = zeros(256,72);
HRTF_r = zeros(256,72);
FFT_HRIR_l = zeros(512,72);
FFT_HRIR_r = zeros(512,72);


for n = 1:72
    FFT_HRIR_l(:,n) = fft(HRIR_l(:,n));
    FFT_HRIR_r(:,n) = fft(HRIR_r(:,n));
    
    HRTF_l(:,n) = 2*FFT_HRIR_l(1:256,n);
    HRTF_r(:,n) = 2*FFT_HRIR_r(1:256,n);
    
    HRTF_l(1,n) = HRTF_l(1,n)/2;
    HRTF_r(1,n) = HRTF_r(1,n)/2;
end

% 2. plot HRTF
if plot_HRTF
    figure(1)
    faxis = [0:255]/512*44100;
    plot(faxis,20*log10(abs(HRTF_l(:,1))),'Color',[0.8500 0.3250 0.0980]);
    hold on;
    plot(faxis,20*log10(abs(HRTF_r(:,1))),'b');
    xlabel('frequency (Hz)');
    ax = gca;
    ax.XScale = 'log';
    legend({'left','right'});
end