function [TF,newir,newTF,gd,newgd] = lowFComp(ir,fs,LowF,HighF)
%% Performs low frequency compensation using the method in:
%% - Xie, B. (2009): On the low frequency characteristics of head-related transfer functions. Chinese J. Acoust. 28(2), pp. 1-13
%% The magnitude response of the HRTFs has been set to a constant value and the phase has been extrapolated linearly for low frequencies. 
%% Code is provided by https://github.com/spatialaudio/lf-corrected-kemar-hrtfs/Correct_low_frequencies_of_HRTFs.m
N = length(ir);          % original length of HRIRs
f = (0:N-1)/N*fs; % frequency vector

%% find indices for frequency range used to correct low frequency data
indl = find(f>=LowF,1,'first');
indh = find(f<HighF,1,'last');

%% Correct and truncate impulse responses
TF = fft(ir);
% correct magnitude
% calculate mean magnitude from lower frequency bound to higher frequency bound
mag_mean = mean(abs(TF(indl:indh)));
%replace low frequency magnitude with mean value
TF_mag_corrected = abs(TF);
TF_mag_corrected(1:indl-1) = mag_mean;
% correct phase
TF_phase = unwrap(angle(TF));
TF_phase_corrected = TF_phase;
% extrapolate phase from data between lower frequency bound and higher frequency bound
TF_phase_corrected(1:indl-1) = interp1(f(indl:indh),TF_phase(indl:indh),f(1:indl-1),'linear','extrap');
        
%% compose complex spectrum
newTF = TF_mag_corrected.*exp(1i*TF_phase_corrected);
% calculate impulse response
newir = ifft(newTF,'symmetric');      

gd = grpdelay(ir,1,N,'whole',fs);
newgd = grpdelay(newir,1,N,'whole',fs);
end