%%%% This MATLAB script performs full post-processing on measured
%%%% HRTF/HRIRs:
%%%% 1. Time windowing
%%%% 2. Free-field equalization
%%%% 3. Low-frequency extention (To be completed)
%%%% 4. Deconvolution
%%%% 5. Interpolation
%%%% 6. Save as MATLAB data / wav files.
%%%% Author: Yuqing Li
%%%% Date: January 7th, 2021
clear all
close all

%% Options
plot_BTF = 0;
plot_RTF = 0;
plot_HRTF = 1;
plot_HRIR = 1;

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
L = L1+L2+L3+L4;              % total number of samples

w1 = hann(2*L1);                       
w1 = w1(1:L1);                    % half Hann window 1 (before peak)
w2 = hann(2*L4);
w2 = w2(L4+1:end);                 % half Hann window 2 (after peak)

N = 1024;                          % signal length (in samples)

win_mat_bs = zeros(L,2,72);

l_zeropad = 20;                    % zero pad the binaural signals to ensure casuality

zeropad_win_mat_bs = zeros(N,2,72);
BTF = zeropad_win_mat_bs;              % binaural transfer function matrix
win_mat_rs = zeropad_win_mat_bs;           % reference signal matrix

% window the binaural responses with the defined time windows
for k = 1:72                
    % left ear
    a1 = I1(k) - (L1+L2);                   % start point of windowing
    b1 = I1(k) - L2;
    c1 = I1(k) + L3;
    d1 = I1(k) + (L3+L4);                   % end point of windowing
    % apply time window
    win_mat_bs(1:L1,1,k) = mat_bs(a1:(b1-1),1,k).*w1;
    win_mat_bs(L1+1:L1+L2+L3,1,k) = mat_bs(b1:(c1-1),1,k);
    win_mat_bs(L1+L2+L3+1:L1+L2+L3+L4,1,k) = mat_bs(c1:(d1-1),1,k).*w2;
    
    % right ear
    a2 = I2(k) - (L1+L2);                   
    b2 = I2(k) - L2;
    c2 = I2(k) + L3;
    d2 = I2(k) + (L3+L4);   
    % apply time window
    win_mat_bs(1:L1,2,k) = mat_bs(a2:(b2-1),2,k).*w1;
    win_mat_bs(L1+1:L1+L2+L3,2,k) = mat_bs(b2:(c2-1),2,k);
    win_mat_bs(L1+L2+L3+1:L1+L2+L3+L4,2,k) = mat_bs(c1:(d1-1),2,k).*w2;
    % delay the binaural signals
    zeropad_win_mat_bs(l_zeropad:l_zeropad+L-1,:,k) = win_mat_bs(:,:,k);
    
    % Fourier Transform
    BTF(:,1,k) = fft(zeropad_win_mat_bs(:,1,k));        
    BTF(:,2,k) = fft(zeropad_win_mat_bs(:,2,k));
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
win_mat_rs(L1+L2+L3+1:L1+L2+L3+L4,1) = mat_rs(c3:(d3-1),1).*w2;

% right ear
a4 = I4 - (L1+L2);                  
b4 = I4 - L2;
c4 = I4 + L3;
d4 = I4 + (L3+L4);
% apply time window
win_mat_rs(1:L1,2) = mat_rs(a4:(b4-1),2).*w1;
win_mat_rs(L1+1:L1+L2+L3,2) = mat_rs(b4:(c4-1),2);
win_mat_rs(L1+L2+L3+1:L1+L2+L3+L4,2) = mat_rs(c4:(d4-1),2).*w2;

% Fourier Transform
RTF = zeros(N,2);
RTF(:,1) = fft(win_mat_rs(:,1));
RTF(:,2) = fft(win_mat_rs(:,2));

%% 2. Free-field equalization
HRTF = zeros(N,2,72); 
raw_HRIR = HRTF; 
lowpass_HRIR = HRTF;
HRIR = HRTF;
for q = 1:72  
    HRTF(:,1,q) = BTF(:,1,q)./RTF(:,1);
    HRTF(:,2,q) = BTF(:,2,q)./RTF(:,2);
end

%% 3. Low-frequency extention (To be completed)

%% 4. Deconvolution
initial_delay = [I1-fs*t_pre I2-fs*t_pre];                   % initial delay in samples (72 x 2)
for p = 1:72  
    raw_HRIR(:,1,p) = ifft(HRTF(:,1,p));   
    raw_HRIR(:,2,p) = ifft(HRTF(:,2,p));
    % apply low-pass filter to filter out high frequency noise, passband frequency: 16kHz
    lowpass_HRIR(:,1,p) = lowpass(raw_HRIR(:,1,p),16000,fs);
    lowpass_HRIR(:,2,p) = lowpass(raw_HRIR(:,2,p),16000,fs);
    % Reinstate the removed delay    
    HRIR(initial_delay(p,1)+1:N,1,p) = lowpass_HRIR(1:N-initial_delay(p,1),1,p);  
    HRIR(1:initial_delay(p,1),1,p) = 0;
    HRIR(initial_delay(p,2)+1:N,2,p) = lowpass_HRIR(1:N-initial_delay(p,2),2,p);  
    HRIR(1:initial_delay(p,2),2,p) = 0;
end

% plotting
%%%% plot HRTFs
if plot_HRTF 
figure(1)
HRTF_spec = 2*HRTF(1:ceil(length(HRTF)/2),:,:);                               % double the DFT magnitude for 1-sided spectrum
HRTF_spec(1,:,:) = HRTF_spec(1,:,:)/2;            % DC magnitude remains the same
faxis = [0:ceil(N/2)-1]/N*fs;
HRTF_index = 71;
plot(faxis,20*log10(abs(HRTF_spec(:,1,HRTF_index))),'r','linewidth',1);
hold on;
plot(faxis,20*log10(abs(HRTF_spec(:,2,HRTF_index))),'b','linewidth',1);
grid on;
legend ({'left','right'});

set(gcf, 'units', 'normalized');
set(gcf, 'Position', [0.1, 0.1, 0.7, 0.8]);

axHRTF = gca;
set(axHRTF,'xscale','log');
axHRTF.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
axHRTF.XLim = [90,20000];
axHRTF.YLim = [-40,40];
axHRTF.XLabel.String = 'frequency(Hz)';
axHRTF.YLabel.String = 'dB';
axHRTF.Title.String = ['HRTFs at 25cm, 350' char(176)];
axHRTF.FontName = 'Times New Roman';
axHRTF.FontSize = 14;
axHRTF.Legend.FontSize = 14;
axHRTF.Legend.Location = 'southwest';
axHRTF.LineWidth = 1;
end

if plot_HRIR
figure(2)
taxis = 1000*[0:N-1]/fs;
HRIR_index = 18;
plot(taxis,HRIR(:,1,HRIR_index),'r','linewidth',1);
hold on;
plot(taxis,HRIR(:,2,HRIR_index),'b','linewidth',1);
grid on;
legend ({'left','right'});

set(gcf, 'units', 'normalized');
set(gcf, 'Position', [0.1, 0.1, 0.7, 0.8]);

axHRIR = gca;
axHRIR.XLim = 1000*[0,(N-1)/fs];
% axHRIR.YLim = [-40,20];
axHRIR.XLabel.String = 'time (ms)';
axHRIR.YLabel.String = 'magnitude';
axHRIR.Title.String = ['HRIRs at 25cm, 350' char(176)];
axHRIR.FontName = 'Times New Roman';
axHRIR.FontSize = 14;
axHRIR.Legend.FontSize = 14;
axHRIR.Legend.Location = 'southeast';
axHRIR.LineWidth = 1;
end

%% 5. Interpolation 
% 5.1 Magnitude interpolation
interpolated_HRTF = zeros(N,2,360);        % matrix for storing interpolated HRTFs
azimuth = [1:5:355];


lowpass_HRIR(:,1,p)
% 5.2 ITD interpolation


%% 6. Save as MATLAB data / wav files
% save HRIRs
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\HRIRs\0111\25cm';

