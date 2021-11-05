% <ITA-Toolbox>
% This file is part of the application HRTF_class for the ITA-Toolbox. All rights reserved.
% You can find the license for this m-file in the application folder.
% This script initializes the spherical coordinates and HRTF data, and plots specific
% HRTFs, with the calculation of ITD additionally.
% </ITA-Toolbox>
close all
clear all
%% Init object
coord025 = ita_sph_sampling_equiangular(1,72);   % generate SH coordinate (inputs: numbers of elevation and azimuth points)
coord025.r = 0.25;                     % SH coordinate radius

coord040 = coord025;
coord040.r = 0.40;

coord050 = coord025;
coord050.r = 0.50;

coord060 = coord025;
coord060.r = 0.60;

coord075 = coord025;
coord075.r = 0.75;

coord090 = coord025;
coord090.r = 0.90;

coord100 = coord025;
coord100.r = 1.00;

pSphere025 = itaAudio();
pSphere025.channelCoordinates = itaCoordinates(72);
pSphere025.channelCoordinates.elevation = 0; 
for a=1:72*2
    if mod(a,2) == 1
       pSphere025.channelCoordinates.azimuth(a) = floor(a/2)*5;
    else
       pSphere025.channelCoordinates.azimuth(a) = pSphere025.channelCoordinates.azimuth(a-1);
    end
end

pShpere040 = pShpere025;
pShpere050 = pShpere025;
pShpere060 = pShpere025;
pShpere075 = pShpere025;
pShpere090 = pShpere025;
pShpere100 = pShpere025;

pSphere025.channelCoordinates.r = coord025.r(1);
pSphere040.channelCoordinates.r = coord040.r(1);
pSphere050.channelCoordinates.r = coord050.r(1);
pSphere060.channelCoordinates.r = coord060.r(1);
pSphere075.channelCoordinates.r = coord075.r(1);
pSphere090.channelCoordinates.r = coord090.r(1);
pSphere100.channelCoordinates.r = coord100.r(1);

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\25cm'
for n = 1:72
    itemnum = 5*(n-1);
    filename = strcat(num2str(itemnum),'.mat');
    measured = importdata(filename);
    left_mic = importdata('left_mic.mat');
    right_mic = importdata('right_mic.mat');
    pSphere025.timeData(:,2*n-1) = cell2mat(measured.ImpulseResponse(4,2))-cell2mat(right_mic.ImpulseResponse(4,2));  % Channel 1 is right ear
    pSphere025.timeData(:,2*n) = cell2mat(measured.ImpulseResponse(4,4))-cell2mat(left_mic.ImpulseResponse(4,4));
end

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\40cm'
for n = 1:72
    itemnum = 5*(n-1);
    filename = strcat(num2str(itemnum),'.mat');
    measured = importdata(filename);
    left_mic = importdata('left_mic.mat');
    right_mic = importdata('right_mic.mat');
    pSphere040.timeData(:,2*n-1) = cell2mat(measured.ImpulseResponse(4,2))-cell2mat(right_mic.ImpulseResponse(4,2));  % Channel 1 is right ear
    pSphere040.timeData(:,2*n) = cell2mat(measured.ImpulseResponse(4,4))-cell2mat(left_mic.ImpulseResponse(4,4));
end

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\50cm'
for n = 1:72
    itemnum = 5*(n-1);
    filename = strcat(num2str(itemnum),'.mat');
    measured = importdata(filename);
    left_mic = importdata('left_mic.mat');
    right_mic = importdata('right_mic.mat');
    pSphere050.timeData(:,2*n-1) = cell2mat(measured.ImpulseResponse(4,2))-cell2mat(right_mic.ImpulseResponse(4,2));  % Channel 1 is right ear
    pSphere050.timeData(:,2*n) = cell2mat(measured.ImpulseResponse(4,4))-cell2mat(left_mic.ImpulseResponse(4,4));
end
cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\60cm'
for n = 1:72
    itemnum = 5*(n-1);
    filename = strcat(num2str(itemnum),'.mat');
    measured = importdata(filename);
    left_mic = importdata('left_mic.mat');
    right_mic = importdata('right_mic.mat');
    pSphere060.timeData(:,2*n-1) = cell2mat(measured.ImpulseResponse(4,2))-cell2mat(right_mic.ImpulseResponse(4,2));  % Channel 1 is right ear
    pSphere060.timeData(:,2*n) = cell2mat(measured.ImpulseResponse(4,4))-cell2mat(left_mic.ImpulseResponse(4,4));
end

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\75cm'
for n = 1:72
    itemnum = 5*(n-1);
    filename = strcat(num2str(itemnum),'.mat');
    measured = importdata(filename);
    left_mic = importdata('left_mic.mat');
    right_mic = importdata('right_mic.mat');
    pSphere075.timeData(:,2*n-1) = cell2mat(measured.ImpulseResponse(4,2))-cell2mat(right_mic.ImpulseResponse(4,2));  % Channel 1 is right ear
    pSphere075.timeData(:,2*n) = cell2mat(measured.ImpulseResponse(4,4))-cell2mat(left_mic.ImpulseResponse(4,4));
end

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\90cm'
for n = 1:72
    itemnum = 5*(n-1);
    filename = strcat(num2str(itemnum),'.mat');
    measured = importdata(filename);
    left_mic = importdata('left_mic.mat');
    right_mic = importdata('right_mic.mat');
    pSphere090.timeData(:,2*n-1) = cell2mat(measured.ImpulseResponse(4,2))-cell2mat(right_mic.ImpulseResponse(4,2));  % Channel 1 is right ear
    pSphere090.timeData(:,2*n) = cell2mat(measured.ImpulseResponse(4,4))-cell2mat(left_mic.ImpulseResponse(4,4));
end

cd 'C:\Users\root\Documents\00 phd\measurement\200930 KEMAR HRTF AP\1m'
for n = 1:72
    itemnum = 5*(n-1);
    filename = strcat(num2str(itemnum),'.mat');
    measured = importdata(filename);
    left_mic = importdata('left_mic.mat');
    right_mic = importdata('right_mic.mat');
    pSphere100.timeData(:,2*n-1) = cell2mat(measured.ImpulseResponse(4,2))-cell2mat(right_mic.ImpulseResponse(4,2));  % Channel 1 is right ear
    pSphere100.timeData(:,2*n) = cell2mat(measured.ImpulseResponse(4,4))-cell2mat(left_mic.ImpulseResponse(4,4));
end

HRTF_sphere025    = ita_time_shift(itaHRTF(pSphere025),pSphere025.trackLength/2,'time');  % initialize HRTF sphere
HRTF_sphere040    = ita_time_shift(itaHRTF(pSphere040),pSphere040.trackLength/2,'time');
HRTF_sphere050    = ita_time_shift(itaHRTF(pSphere050),pSphere050.trackLength/2,'time');
HRTF_sphere060    = ita_time_shift(itaHRTF(pSphere060),pSphere060.trackLength/2,'time');
HRTF_sphere075    = ita_time_shift(itaHRTF(pSphere075),pSphere075.trackLength/2,'time');
HRTF_sphere090    = ita_time_shift(itaHRTF(pSphere090),pSphere090.trackLength/2,'time');
HRTF_sphere100    = ita_time_shift(itaHRTF(pSphere100),pSphere100.trackLength/2,'time');

%% Find Functions 
coordF025          = itaCoordinates([coord025.r(1) pi/2 0],'sph');
coordF040          = itaCoordinates([coord040.r(1) pi/2 0],'sph');
coordF050          = itaCoordinates([coord050.r(1) pi/2 0],'sph');
coordF060          = itaCoordinates([coord060.r(1) pi/2 0],'sph');
coordF075          = itaCoordinates([coord075.r(1) pi/2 0],'sph');
coordF090          = itaCoordinates([coord090.r(1) pi/2 0],'sph');
coordF100          = itaCoordinates([coord100.r(1) pi/2 0],'sph');

% coordF          = itaCoordinates([coord.r(1) pi/2 pi/2; coord.r(1) pi/2 pi/4],'sph');

HRTF_find025      = HRTF_sphere025.findnearestHRTF(coordF025); % finds the object at the given coordinates
% HRTF_dir025        = HRTF_sphere025.direction([11 15 17]); % wie itaAudio.ch(x) nur für itaHRTF  (return the HRTF (L&R) for a/multiple given direction indices )

% % Slice of the TF function
% slicePhi        = HRTF_sphere.sphericalSlice('theta_deg',90);
% sliceTheta      = HRTF_sphere.sphericalSlice('phi_deg',0);
% 
% %% Plot Functions 
% % plot frequency domain in dependence of the angle (elevation or azimuth)
% figure(1)
% sliceTheta.plot_freqSlice
% % pause(5)
% % close gcf
% figure(2)
% slicePhi.plot_freqSlice('earSide','R')
% % pause(5)
% % close gcf

% % plot ITD
% slicePhi.plot_ITD('method','xcorr','plot_type','line')

% plot time or freq. domain
% HRTF_find.pt
HRTF_find.pf
HRTF_find.getEar('R').pf

% %% Play gui
% pinkNoise = ita_generate('pinknoise',1,44100,12)*10;
% HRTF_find.play_gui(pinkNoise); 

%% Binaural parameters
ITD = slicePhi.ITD;  % different methods are available: see method in itaHRTF
ILD = slicePhi.ILD;
 
%% Modifications
% calculate DTF
% DTF_sphere = HRTF_sphere.calcDTF;
% 
% HRTFvsDTF = ita_merge(DTF_sphere.findnearestHRTF(90,90),HRTF_sphere.findnearestHRTF(90,90));
% HRTFvsDTF.pf
% legend('DTF left','DTF right','HRTF left','HRTF right')


% %% Write and init
% nameDaff_file = 'HRTF_sphere.daff';
% HRTF_sphere.writeDAFFFile(nameDaff_file);
% 
% %HRTF_daff = itaHRTF('daff',nameDaff_file);
% 
% nameDaff_file2 = 'yourHRTF.daff';
% if ~strcmp(nameDaff_file2,'yourHRTF.daff')
%     HRTF_daff2 = itaHRTF('daff',nameDaff_file2);
%     HRTF_daff2.plot_freqSlice
% else
%    ita_disp('use an existing daff-file') 
% end