%%%% This MATLAB script performs microphone calibration using the
%%%% .wav files recorded by the microphone to be calibrated.
clear all
close all

cd 'C:\Users\root\Documents\00 phd\measurement\210216 microphone calibration'
sig = audioread('calibration01_02_16_2021_17_44_54.wav');
dur = 10;
SR = length(sig)/dur;

sig = sig([1:815200]);
prms = rms(sig);
dBprms = 20*log10(prms)
% plot(sig);
