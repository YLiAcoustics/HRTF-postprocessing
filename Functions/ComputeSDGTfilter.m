function [SD,sd,fc]=ComputeSDGTfilter(hrir1,hrir2,fs1,fs2,varargin)
%
% Description
% Compute mean spectral distorsion according to Brinkmann et al. 2015. A
% gammatone filter bank is involved.
%
% Input:
%   hrir1,hrir2     HRIRs on which the SD is computed (matrix(time,channel,position)) [amp]
%   fs1,fs2         sampling frequency of the two HRIRs (scalar) [Hz]
%   varargin        flow,fhigh values for the lower and upper freq.
%                   (scalars0 [Hz][Hz]
%                   default frequency range is 0.1 to 16 kHz 
% Output:
%   SD              direction averaged spectral distorsion (scalar) [dB]
%   sd              direction specific spectral distorsion (matrix(position,channel)) [dB]
%   f               frequency bins (vector) [Hz] 
%
%   (c) Yuqing Li 02/23

%check input
if nargin==7
    flow=varargin{1};
    fhigh=varargin{2};
    erbs=varargin{3};
else
    flow=0.3e3;
    fhigh=16e3;
    erbs=1;
end

% find minum sampling rate and eventually resample
fsm = min(fs1, fs2);
if fs1~=fsm
    hrir1=resample(hrir1,fsm,fs1,'Dimension',1);
end
if fs2~=fsm
    hrir2=resample(hrir2,fsm,fs2,'Dimension',1);
end

% find min number of samples and eventually cut impulse responses
sampm = min(size(hrir1,1),size(hrir2,1));
if size(hrir1,1)~=sampm
    hrir1 = hrir1(1:sampm,:,:);
end
if size(hrir2,1)~=sampm
    hrir2=hrir2(1:sampm,:,:);
end

%filter with gammatone filter bank with center frequencies fc
[in1gtf,fc]=GammaToneFilter(hrir1,fs1,flow,fhigh,erbs);  % dimension of in1gtf: number of filter bands x channels x directions
[in2gtf,~]=GammaToneFilter(hrir2,fs2,flow,fhigh,erbs);

%compute frequency dependent SD
sd=sqrt((in1gtf-in2gtf).^2);

%compute averaged SD across frequencies and sum the ears
SD=2*squeeze(mean(mean(abs(sd))));

end %function

function [out,fc]=GammaToneFilter(in,fs,flow,fhigh,space)
fc=audspacebw(flow,fhigh,space,'erb'); % find center frequencies of auditory space
Nfc=length(fc); %number of bands
[bgt,agt]=gammatone(fc,fs,'complex'); % find Gammatone filter coefficients of the complex filter
fin=2*real(ufilterbankz(bgt,agt,in(:,:)));  % (amtoolbox) fitler input signal, channel (3rd) dimension resolved
fin=reshape(fin,[size(in,1),Nfc,size(in,2),size(in,3)]); % reshape to rehave the correct number of channels
fins=20*log10(squeeze(rms(fin))); % average over time in dB
imp=zeros(256,1); imp(1)=1;%impulse signal
fir=2*real(ufilterbankz(bgt,agt,imp));  % impulse response of filter
firs=20*log10(squeeze(rms(fir))).'; % average over time in dB
out=fins-firs; %correct amplitude
end %function