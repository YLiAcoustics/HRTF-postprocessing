function [outputT,outputF]=Convolution(input1,input2,domain)
%%%% Performs frequency domain multiplication of two inputs and returns the time- and frequency-domain outputd.
%%%% Inputs:
%%%%     input1: single-channel input signal
%%%%     input2: single-channel input signal
%%%%     domain: domain of input signals, 'time' or 'freq'
%%%% Outputs:
%%%%     outputT: output signal in time domain
%%%%     outputF: output signal in frequency domain

assert(nargin==3, 'Wrong number of input arguments');    % check number of input arguments

if ~(strcmp(domain,'freq')||strcmp(domain,'time'))
    error('Wrong domain name');
elseif strcmp(domain,'freq')      % convert to time domain
    input1=ifft(input1);
    input2=ifft(input2);
end

if length(input1)~=length(input2)    % zeropad the shorter signal
    L1=length(input1);
    L2=length(input2);
    L=max(L1,L2);
    input1=padarray(input1,L-L1,0,'post');
    input2=padarray(input2,L-L2,0,'post');
end

FFT1=fft(input1);
FFT2=fft(input2);
outputF=FFT1.*FFT2;
outputT=ifft(outputF,'symmetric');
