function [SD,sd,f]=ComputeSD(hrir1,hrir2,fs1,fs2,varargin)
%[ISSD,issd,f]=ComputeSD(hrir1,hrir2,fs1,fs2,flow,fhigh)
%
% Description
% Compute mean spectral distorsion
%
% Input:
%   hrir1,hrir2     HRIRs on which the SD is computed (matrix(time,channel,position)) [amp]
%   fs1,fs2         sampling frequency of the two HRIRs (scalar) [Hz]
%   varargin        flow,fhigh values for the lower and upper freq.
%                   (scalars0 [Hz][Hz]
%                   default frequency range is 0.5 to 18 kHz 
% Output:
%   SD              direction averaged spectral distorsion (scalar) [dB]
%   sd              direction specific spectral distorsion (matrix(position,channel)) [dB]
%   f               frequency bins (vector) [Hz] 
%
%   (c) Fabio Di Giusto 03/21

%check input
if nargin==6
    flow=varargin{1};
    fhigh=varargin{2};
else
    flow=0.5e3;
    fhigh=18e3;
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

% transform to frequency domain
hrtf1=fft(hrir1);
hrtf2=fft(hrir2);

% compute frequency axis
f=0:fsm/sampm:fsm-fsm/sampm;

% find selected frequency range and update frequency axis
indf=f>=flow & f<=fhigh;
f=f(indf);

%compute direction specific SD
sd=squeeze(sqrt(mean((20*log10(abs(hrtf1(indf,:,:))./abs(hrtf2(indf,:,:)))).^2)));

%compute averaged SD
SD=mean(mean(sd));

end %function
