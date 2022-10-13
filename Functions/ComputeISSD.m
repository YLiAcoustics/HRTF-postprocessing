function [ISSD,issd,fc]=ComputeISSD(hrir1,hrir2,fs1,fs2,varargin)
%[ISSD,issd,fc]=ComputeISSD(hrir1,hrir2,fs1,fs2,flow,fhigh,erbs)
%
% Description
% Compute Inter-Subject Spectral Difference
%
% Input:
%   hrir1,hrir2     HRIRs on which the ISSD is computed (matrix(time,channel,position)) [amp]
%   fs1,fs2         sampling frequency of the two HRIRs (scalar) [Hz]
%   varargin        flow,fhigh,erbs values for the lower and upper freq.
%                   and bandwidth (in erb) of the gammatone filter, respectively 
%                   (scalars) [Hz][Hz][ERB]
%                   default values are 0.5 kHz, 18 kHz, 1 ERB
% Output:
%   ISSD            direction averaged Inter-Subject Spectral Difference (scalar) [dB^2]
%   issd            direction specific Inter-Subject Spectral Difference (matrix(position,channel)) [dB^2]
%   fc              center frequencies of the gammatone filter (vector) [Hz] 
%
%   (c) Fabio Di Giusto 03/21

% note Auditory Modelling Toolbox should be up and running
% addpath(genpath('amtoolbox-full-0.10.0'));
% amt_start

%check input
if nargin==7
    flow=varargin{1};
    fhigh=varargin{2};
    erbs=varargin{3};
else
    flow=0.5e3;
    fhigh=18e3;
    erbs=1;
end

%filter with gammatone filter bank with center frequencies fc
[in1gtf,fc]=GammaToneFilter(hrir1,fs1,flow,fhigh,erbs);
[in2gtf,~]=GammaToneFilter(hrir2,fs2,flow,fhigh,erbs);

%compute direction specific ISSD
issd=squeeze(var(in1gtf-in2gtf));

%compute averaged ISSD
ISSD=mean(mean(issd));

end %function

function [out,fc]=GammaToneFilter(in,fs,flow,fhigh,space)
fc=audspacebw(flow,fhigh,space,'erb'); % find center frequencies of auditory space
Nfc=length(fc); %number of bands
[bgt,agt]=gammatone(fc,fs,'complex'); % find values of the complex filter
fin=2*real(ufilterbankz(bgt,agt,in(:,:)));  % (amtoolbox) fitler input signal, channel (3rd) dimension resolved
fin=reshape(fin,[size(in,1),Nfc,size(in,2),size(in,3)]); % reshape to rehave the correct number of channels
fins=20*log10(squeeze(rms(fin))); % average over time in dB
imp=zeros(256,1); imp(1)=1;%impulse signal
fir=2*real(ufilterbankz(bgt,agt,imp));  % impulse response of filter
firs=20*log10(squeeze(rms(fir))).'; % average over time in dB
out=fins-firs; %correct amplitude
end %function