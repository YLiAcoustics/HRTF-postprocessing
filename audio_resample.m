%%%% This MATLAB script takes an audio file and resamples it.

cd 'C:\Users\root\Documents\00 phd\code\Plate-Reverb-master'

[audio fs]= audioread('PlateReverb_default_IR_Li.wav');
fs_new = 48000;
audio_new = resample(audio,fs_new,fs);

audiowrite('PlateReverb_default_IR_Li_48000_mono.wav',audio_new(:,1),fs_new);