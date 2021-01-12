%%%% This MATLAB script performs full post-processing on measured
%%%% HRTF/HRIRs:
%%%% 1. Time windowing
%%%% 2. Free-field equalization
%%%% 3. Low-frequency extention (To be completed)
%%%% 4. Deconvolution
%%%% 5. Save in SOFA format
%%%% Author: Yuqing Li
%%%% Date: December 15th, 2020
clear all
close all

%% 0. Specify parameters and import data
fs = 48000;               % sampling rate
dis = 25;                 % source distance: select among {25, 40, 50, 60, 75 ,100}; unit: cm
t_pre = 0.05;             % pre-excitation time (s) 
datapath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\',num2str(dis),'cm');
cd(datapath)
% create matrices for storing signals
mat_bs = zeros(88416,2,72);
mat_rs = zeros(88416,2);
for n = 1:72
    ori = 5*(n-1);        % azimuth (in degrees), resolution: 5
    % binaural responses
    data_bs = importdata(strcat(num2str(ori),'.mat'));         % binaural signal data
    mat_bs(:,1,n) = cell2mat(data_bs.ImpulseResponse(4,4));    % Channel 2: left ear
    mat_bs(:,2,n) = cell2mat(data_bs.ImpulseResponse(4,2));    % Channel 1: right ear
end
% reference responses
data_rs_l =  importdata('left_mic.mat');                       % reference signal data
data_rs_r =  importdata('right_mic.mat');
mat_rs(:,1) = cell2mat(data_rs_l.ImpulseResponse(4,2));
mat_rs(:,2) = cell2mat(data_rs_r.ImpulseResponse(4,2));

%% 1. Time windowing
% find the 1st peaks in binaural responses
[M1,I1] = max(mat_bs(:,1,:));             % store the peak values and indices
[M2,I2] = max(mat_bs(:,2,:));
M1 = M1(:);                               % peak value
I1 = I1(:);                               % peak index
M2 = M2(:);
I2 = I2(:);
% find the minimum delay time (in samples)
minI1 = min(I1);
minI2 = min(I2);
% specify time window lengths (in samples)
L1 = 10;                            % length of half Hann window 1 
L2 = 20;                            % pad before peak
L3 = 250;                           % pad after peak
L4 = 200;                           % length of half Hann window 2
assert(L1+L2+fs*t_pre<minI1)         % Check if window length is shorter than the initial delay. assert: through error if condition false
assert(L1+L2+fs*t_pre<minI1)

w1 = hann(2*L1);                       
w1 = w1(1:L1);                    % half Hann window 1 (before peak)
w2 = hann(2*L4);
w2 = w2(L4+1:end);                 % half Hann window 2 (after peak)

N = 1024;                          % N-point DFT

win_mat_bs = zeros(N,2,72);
BTF_mat = win_mat_bs;              % binaural transfer function matrix
win_mat_rs = win_mat_bs;           % reference signal matrix

l_zeropad = 40;                    % zero pad the binaural signals to ensure casuality

% window the binaural responses with the defined time windows
for k = 1:72                
    % left ear
    a1 = I1(k) - (L1+L2);                   % start point of windowing
    b1 = I1(k) - L2;
    c1 = I1(k) + L3;
    d1 = I1(k) + (L3+L4);                   % end point of windowing
    % front zero pad
    win_mat_bs(1:l_zeropad,:,k) = 0;
    % apply time window
    win_mat_bs(l_zeropad+1:l_zeropad+L1,1,k) = mat_bs(a1:(b1-1),1,k).*w1;
    win_mat_bs(l_zeropad+L1+1:l_zeropad+L1+L2+L3,1,k) = mat_bs(b1:(c1-1),1,k);
    win_mat_bs(l_zeropad+L1+L2+L3+1:l_zeropad+L1+L2+L3+L4,1,k) = mat_bs(c1:(d1-1),1,k).*w2;
    win_mat_bs((N-(l_zeropad+L1+L2+L3+L4)+1):end,1,k) = 0;
    % right ear
    a2 = I2(k) - (L1+L2);                   
    b2 = I2(k) - L2;
    c2 = I2(k) + L3;
    d2 = I2(k) + (L3+L4);   
    % apply time window
    win_mat_bs(l_zeropad+1:l_zeropad+L1,2,k) = mat_bs(a2:(b2-1),2,k).*w1;
    win_mat_bs(l_zeropad+L1+1:l_zeropad+L1+L2+L3,2,k) = mat_bs(b2:(c2-1),2,k);
    win_mat_bs(l_zeropad+L1+L2+L3+1:l_zeropad+L1+L2+L3+L4,2,k) = mat_bs(c1:(d1-1),2,k).*w2;
    win_mat_bs((N-(l_zeropad+L1+L2+L3+L4)+1):end,2,k) = 0;
    
    % Fourier Transform
    BTF(:,1,k) = fft(win_mat_bs(:,1,k));        
    BTF(:,2,k) = fft(win_mat_bs(:,2,k));
end

% window the reference signals
% find the 1st peaks in reference responses
[M3,I3] = max(mat_rs(:,1));             % store the peak values and indices
[M4,I4] = max(mat_rs(:,2));

assert(L1+L2+fs*t_pre<I3)   
assert(L1+L2+fs*t_pre<I4)

% left ear
a3 = I3 - (L1+L2);                   % start point of windowing
b3 = I3 - L2;
c3 = I3 + L3;
d3 = I3 + (L3+L4);                   % end point of windowing
% apply time window
win_mat_rs(1:L1,1) = mat_rs(a3:(b3-1),1).*w1;
win_mat_rs(L1+1:L1+L2+L3,1) = mat_rs(b3:(c3-1),1);
% win_mat_rs(L1+L2+L3+1:end,1) = mat_rs(c3:(d3-1),1).*w2;
win_mat_rs(L1+L2+L3+1:L1+L2+L3+L4,1) = mat_rs(c1:(d1-1),1).*w2;
win_mat_rs((N-(L1+L2+L3+L4)+1):end,1) = 0;

% right ear
a4 = I4 - (L1+L2);                 
b4 = I4 - L2;
c4 = I4 + L3;
d4 = I4 + (L3+L4);
% apply time window
win_mat_rs(1:L1,2) = mat_rs(a4:(b4-1),2).*w1;
win_mat_rs(L1+1:L1+L2+L3,2) = mat_rs(b4:(c4-1),2);
% win_mat_rs(L1+L2+L3+1:end,2) = mat_rs(c4:(d4-1),2).*w2;
win_mat_rs(L1+L2+L3+1:L1+L2+L3+L4,2) = mat_rs(c1:(d1-1),2).*w2;
win_mat_rs((N-(L1+L2+L3+L4)+1):end,2) = 0;
% Fourier Transform
RTF(:,1) = fft(win_mat_rs(:,1));
RTF(:,2) = fft(win_mat_rs(:,2));

%% 2. Free-field equalization
HRTF = zeros(N,2,72); 
HRIR = HRTF; 
for q = 1:72  
    HRTF(:,1,q) = BTF(:,1,q)./RTF(:,1);
    HRTF(:,2,q) = BTF(:,2,q)./RTF(:,2);
end

%% 3. Low-frequency extention (To be completed)

%% 4. Deconvolution
for p = 1:72  
    HRIR(:,1,p) = ifft(HRTF(:,1,p));
    HRIR(:,2,p) = ifft(HRTF(:,2,p));
end

%% 5. Reinstate the removed delay


%% 6. Save in SOFA format
