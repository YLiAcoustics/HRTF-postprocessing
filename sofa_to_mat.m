%%%% This MATLAB script converts the continuous HRIR data from .sofa format
%%%% into a matrix. Note that the coordinate convention used in the
%%%% measurements.
%%%% Last edited: Yuqing Li, 06/07/2022.

clear
close all

fs = 48000;
N = 512;
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs'
sofadata = SOFAload('hrir_ku1_las_nf_circ_hor_fn.sofa');
IR_data_raw = sofadata.Data.IR;
s = size(IR_data_raw);
sofadata.Data.SamplingRate = sofadata.Data.SamplingRate;

if sofadata.Data.SamplingRate ~= fs
    for i = 1:s(1)
        IR_data(i,1,:) = resample(squeeze(IR_data_raw(i,1,:)),fs,sofadata.Data.SamplingRate);
        IR_data(i,2,:) = resample(squeeze(IR_data_raw(i,2,:)),fs,sofadata.Data.SamplingRate);
    end
else
    IR_data = IR_data_raw;
end

s = size(IR_data);

IR_mat = zeros(N,2,101,s(1)/101);
for i = 1:(s(1)/101)
    for j = 1:101
        IR_mat(1:s(3),1,j,i) = squeeze(IR_data(s(1)/101*(j-1)+i,1,:));
        IR_mat(1:s(3),2,j,i) = squeeze(IR_data(s(1)/101*(j-1)+i,2,:));
        if s(3)~=N
            IR_mat(s(3)+1:N,:,j,i) = zeros(N-s(3),2);
        end
    end
end

IR_mat = IR_mat/max(max(max(max(abs(IR_mat)))));

HRTF = zeros(size(IR_mat));
% calculate HRTF
for i = 1:(s(1)/101)
    for j = 1:101
        HRTF(:,1,j,i) = fft(IR_mat(:,1,j,i));
        HRTF(:,2,j,i) = fft(IR_mat(:,2,j,i));
    end
end

