function [IRout,delay]=Windowing(IRin,Ltar,Lwin,Nsam_bfpk)
%%%% attributes:
%%%% IRin
%%%% Ltar: length of target IR
%%%% Lwin: Hann window length
%%%% Nsam_bfpk: number of samples before peak (after window)


[~,I]=max(abs(IRin));
assert(round(Lwin/2)+Nsam_bfpk<I,'Too many samples before peak! Reduce L or Nsam_bfpk.');

win=hann(Lwin);

IRout=IRin(I-round(Lwin/2)-Nsam_bfpk+1:I-round(Lwin/2)-Nsam_bfpk+Ltar).*[win(1:round(Lwin/2));ones(Ltar-Lwin,1);win(round(Lwin/2)+1:end)];
delay=I;
