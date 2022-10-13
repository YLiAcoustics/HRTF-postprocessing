%%%%%% This MATLAB script interpolates and extrapolates HRTFs using the ITA
%%%%%% toolbox. theta = elevation, phi = azimuth
clear;close all

%% Init object
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\SOFA\25cm'

HRTF_sphere = itaHRTF('sofa','HRIR25cm.sofa');  % initialize HRTF sphere as an itaHRTF  object
HRTF_sphere.dirCoord.r = 0.25;

% %% Find Functions 
% coordF          = itaCoordinates([0.25 pi/2 pi/2; 1 pi/2 pi/4],'sph');
% HRTF_find       = HRTF_sphere.findnearestHRTF(coordF); % finds the object at the given coordinates
% % HRTF_dir        = HRTF_sphere.direction([11 15 17]); % wie itaAudio.ch(x) nur für itaHRTF

%% Plot Functions 
% plot frequency domain in dependence of the angle (elevation or azimuth)
slicePhi = HRTF_sphere.sphericalSlice('theta_deg',0);   % Take the slice at elevation = 0 (horizontal plane)
slicePhi.plot_freqSlice('earSide','R')
% pause(5)
% close gcf

% plot ITD
slicePhi.plot_ITD('method','xcorr','plot_type','line')

% plot time or freq. domain
HRTF_find.pt
HRTF_find.pf
HRTF_find.getEar('R').pf
%% Play gui
pinkNoise = ita_generate('pinknoise',1,44100,12)*10;
HRTF_find.play_gui(pinkNoise); 

%% Binaural parameters
ITD = slicePhi.ITD;  % different methods are available: see method in itaHRTF
%ILD = slicePhi.ILD;
 
%% Modifications
% calculate DTF
DTF_sphere = HRTF_sphere.calcDTF;

HRTFvsDTF = ita_merge(DTF_sphere.findnearestHRTF(90,90),HRTF_sphere.findnearestHRTF(90,90));
HRTFvsDTF.pf
legend('DTF left','DTF right','HRTF left','HRTF right')

% interpolate HRTF
phiI     = deg2rad(0:5:355);
thetaI   = deg2rad(15:15:90);
[THETA_I, PHI_I] = meshgrid(thetaI,phiI);
rI       = ones(numel(PHI_I),1);
coordI   = itaCoordinates([rI THETA_I(:) PHI_I(:)],'sph'); % itaCoordinates object

HRTF_interp = HRTF_sphere.interp(coordI);

%% Write and init
nameDaff_file = 'HRTF_sphere.daff';
HRTF_sphere.writeDAFFFile(nameDaff_file);

%HRTF_daff = itaHRTF('daff',nameDaff_file);

nameDaff_file2 = 'yourHRTF.daff';
if ~strcmp(nameDaff_file2,'yourHRTF.daff')
    HRTF_daff2 = itaHRTF('daff',nameDaff_file2);
    HRTF_daff2.plot_freqSlice
else
   ita_disp('use an existing daff-file') 
end