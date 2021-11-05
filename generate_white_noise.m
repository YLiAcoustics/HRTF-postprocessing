%%% This script generates an audio file of sampling rate 192000Hz.
fs = 192000;
t1 = 0.8;
t2 = 0.2;
noise = rand(fs*t1,1);
pause = zeros(fs*t2,1);
output = [noise;pause;noise;pause;noise];
cd 'C:\Users\root\Documents\00 phd\Database\dry audio\audio files'
audiowrite('High SR white noise.wav',output,fs);