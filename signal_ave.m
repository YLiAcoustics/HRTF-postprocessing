%%%% This MATLAB script performs signal averaging.
%%%% Last edited: Yuqing Li, 07/11/2021
clear
close all

%% My method (Simplying adding up all measurements)
% 0. Specify general parameters
num_ave = 9;
fs = 44100;

% 1. Import signals
temp = audioread('mic_sig_1105_01.wav');
for i = 2:num_ave
    filename = strcat('mic_sig_1105_0',num2str(i),'.wav');
    temp = temp + audioread(filename);
end

ave = temp/num_ave;

% ADDITIONAL: IMPORT MEASURED NOISE
n_temp = audioread('noise_sig_1105_01.wav');
for i = 2:num_ave
    filename = strcat('noise_sig_1105_0',num2str(i),'.wav');
    n_temp = n_temp + audioread(filename);
end

n_ave = n_temp/num_ave;

% 2. Plot results
figure(1)
subplot(2,1,1);
plot([1:length(temp(:,1))]/fs,ave(:,1));grid on;
title('average signal (L)');
ylim([-0.03 0.03]);
subplot(2,1,2);
plot([1:length(temp(:,1))]/fs,ave(:,2));grid on;
title('average signal (R)');
ylim([-0.03 0.03]);
xlabel('time (s)');
ylabel('magnitude');
pause(1)

%% Wiki method (take averages of even and odd measurements separately, and get an estimation of the noise)
temp_odd = audioread('mic_sig_1105_01.wav');
temp_even = audioread('mic_sig_1105_02.wav');
for i = 3:num_ave
    if mod(i,2)==1
        filename = strcat('mic_sig_1105_0',num2str(i),'.wav');
        temp_odd = temp_odd + audioread(filename);
    else
        filename = strcat('mic_sig_1105_0',num2str(i),'.wav');
        temp_even = temp_even + audioread(filename);
    end
end
ave_even = temp_even/floor(num_ave/2);
ave_odd = temp_odd/ceil(num_ave/2);

ave_final = (ave_even+ave_odd)/2;
noise_est = (ave_even-ave_odd)/2;

SNR = 10*log10(mean(ave_final.^2)/mean(noise_est.^2));

figure(2)
subplot(2,1,1);
plot([1:length(temp_even(:,1))]/fs,ave_even(:,1));hold on;pause(1);
plot([1:length(temp_even(:,1))]/fs,ave_odd(:,1));hold on;pause(1);
plot([1:length(temp_even(:,1))]/fs,ave_final(:,1));grid on;
legend('even','odd','final');
ylim([-0.03 0.03]);
title('average signal (L)');
subplot(2,1,2);
plot([1:length(temp_even(:,1))]/fs,ave_even(:,2));hold on;pause(1)
plot([1:length(temp_even(:,1))]/fs,ave_odd(:,2));hold on;pause(1)
plot([1:length(temp_even(:,1))]/fs,ave_final(:,2));grid on;
legend('even','odd','final');
ylim([-0.03 0.03]);
title('average signal (R)');
xlabel('time (s)');
ylabel('magnitude');
figure(3)
subplot(2,1,1);
plot([1:length(temp_even(:,1))]/fs,noise_est(:,1));grid on;
title('estimated noise (L)');
ylim([-0.01 0.01]);
subplot(2,1,2);
plot([1:length(temp_even(:,1))]/fs,noise_est(:,2));grid on;
title('estimated noise (R)');
ylim([-0.01 0.01]);
xlabel('time (s)');
ylabel('magnitude');


%% Compute cross-correlation, evaluate signal similarity
% 1. Compare 2 methods
[r1,lags1] = xcorr(ave(:,1),ave_final(:,1),'unbiased');
[M1 I1] = max(abs(r1));
M1
lags1(I1)
% 2. Compare results from Method 2
[r2,lags2] = xcorr(ave_even(:,1),ave_odd(:,1),'unbiased');
[M2 I2] = max(abs(r2));
M2
lags2(I2)
[r3,lags3] = xcorr(ave_even(:,1),ave_final(:,1),'unbiased');
[M3 I3] = max(abs(r3));
M3
lags3(I3)

[n_r n_lags] = xcorr(n_ave(:,1),noise_est(:,1));
[M I] = max(abs(n_r));
M
n_lags(I)

% Correlation coefficient
R1 = corrcoef(ave(:,1),ave_final(:,1));
R2 = corrcoef(ave_even(:,1),ave_odd(:,1));
R3 = corrcoef(ave_even(:,1),ave_final(:,1));
R = corrcoef(n_ave(:,1),noise_est(:,1));
