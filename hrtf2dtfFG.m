function [dtf,ctf]=hrtf2dtfFG(hrtf,FS)
%[dtf,ctf]=hrtf2dtf(hrtf,FS)
%
% Obtain Directional Transfer Functions (DTFs) and Common Transfer
% Functions CTFs (CTFs) from a set of HRTFs. The amplitude of the CTFs is
% defined as the mean of the log amplitude of the HRTFs at each position
% for the left and right channel. The CTFs are forced to be minimum phase
% transfer functions by defining the phase as the imaginary part of the
% Hiblert transform of the negative log amplitude spectrum of the CTFs.
% The DTFs are then defined by dividing the HRTFs by the complex CTFs
% spectrum, the mean of the CTFs and the division by their complex spectrum
% is taken only in an arbitrarily defined frequency range. DTFs and CTFs 
% are then transformed to time domain and attenuated to avoid clipping.
% Reference:
% Middlebrooks, J. C. and Green, D. M. (1990) 
% Directional dependence of interauralenvelope delays
% The Journal of the Acoustical Society of America 87, pages 2149–2162
%
% Input:
%   hrtf    HRTFs in time domain or HRIRs (matrix(position,channel,time)) [amp]
%   FS      sampling frequency (scalar) [Hz]
% Output:
%   dtf     DTFs in time domain (matrix(size(hrtf))) [amp]
%   ctf     CTFs in time domain (matrix(size(hrtf,1),2,size(hrtf(3)) [amp]
%
%   (c) Fabio Di Giusto 11/20

hrtf=permute(hrtf,[3,1,2]); %format time,position,channel 
nfft=2^nextpow2(size(hrtf,1)); %define length fft
HRTF=fft(hrtf,nfft); %HRTF in freq domain
f=0:FS/nfft:FS-FS/nfft; %freq axis
idx=f>=50 & f<=18000; %freq range of interest
idx(nfft/2+2:end)=fliplr(idx(2:nfft/2)); %mirror idx for negative freuq
%find log-amp mean across positions, add eps to avoid log of 0
CTFa=10.^(mean(log10(abs(HRTF)+eps),2)); %find CTFs amplitude
%force minimum phase from amplitude of spectrum
CTFp=imag(hilbert(-log(CTFa))); %find CTFs phase 
CTF=CTFa.*exp(1i*CTFp); %construct minimum phase CTFs
DTF=HRTF; %init DTFs
%find DTFs by removing CTFs from HRTFs only in the freq range of interest 
DTF(idx,:,:)=HRTF(idx,:,:)./CTF(idx,:,:);
%convert in time domain
% symmetric ifft option enforces real DC and Nyquist bin and symmetric 
% conjugate spectrum which are not obtained probably due to rounding errors
% this ensures real time domain signals
dtf=ifft(DTF,nfft,'symmetric'); %DTFs in time domain
ctf=ifft(CTF,nfft,'symmetric'); %CTFs in time domain
ctf=ctf/10^(20/20); %attenuate to avoid clipping
dtf=dtf/10^(20/20); %attenuate to avoid clipping
ctf=permute(ctf,[2,3,1]); %format as input
dtf=permute(dtf,[2,3,1]); %format as input

end %function