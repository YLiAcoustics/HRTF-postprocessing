%%%% This MATLAB script modifies an HRTF dataset saved as a matrix (.mat)
%%%% and save it as a .sofa file.
%%%% Last edited: Yuqing Li, 19/04/2022.
clear
close all

%% import data (HRTF/HRIR matrix)
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220111ContinuousDistanceHRTF\0121\results'
% 1. unintepolated
HRIR_mat = importdata('HRIR_512_101_72_normalized_0310.mat');
s = size(HRIR_mat);
N = length(HRIR_mat); % HRIR length
L = s(3); % number of distances
Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz

% Define positions 
lat1= 0:5:355;    % lateral angles (azimuth)
pol1= 0;                % polar angles (elevation)
pol=repmat(pol1',length(lat1),1);
lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));

% Create the HRIR matrix
M = length(lat1)*length(pol1);  % directions
Obj.Data.IR = zeros(M*L,2,N); % data.IR must be [M R N]

sofa_ir = zeros(M*L,2,N); % data.IR must be [M R N]
% HRIR_forsofa = permute(HRIR, [3 2 1]);
% Fill data with data
for ll = 1:L % distance
    for aa=2:length(lat1)  % azimuth
		Obj.Data.IR(M*(ll-1)+aa,1,:) = squeeze(HRIR_mat(:,1,ll,length(lat1)+1-aa)); % in the sofa convention, 90 degrees = left = channel 1
		Obj.Data.IR(M*(ll-1)+aa,2,:) = squeeze(HRIR_mat(:,2,ll,length(lat1)+1-aa));
		[azi,ele]=hor2sph(lat(aa),pol(aa));
        Obj.SourcePosition((ll-1)*M+aa,:)=[azi ele (ll-1)/100+0.2];
    end
    Obj.Data.IR(M*(ll-1)+1,1,:) = squeeze(HRIR_mat(:,1,ll,1)); % in the sofa convention, 90 degrees = left = channel 1
    Obj.Data.IR(M*(ll-1)+1,2,:) = squeeze(HRIR_mat(:,2,ll,1));
    Obj.SourcePosition((ll-1)*M+1,:) = [0 0 (ll-1)/100+0.2];
 end

% Update dimensions
Obj=SOFAupdateDimensions(Obj);

% Fill with attributes
Obj.GLOBAL_ListenerShortName = 'G.R.A.S KEMAR';
Obj.GLOBAL_History = 'This is a database of continuous-distance near-field HRIRs measured using the Normalized Least Mean Square adative filtering method. Distance resolution = 1 cm. Distance range = 20cm - 120cm.';
Obj.GLOBAL_DatabaseName = 'continuous-distance near-field HRIR';
% Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik, Leibniz Universität Hannover';
Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.de';

% save the SOFA file
SOFAfn=fullfile('C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220111ContinuousDistanceHRTF\database','continuous_HRIR_1cm.sofa');
disp(['Saving:  ' SOFAfn]);
Obj=SOFAsave(SOFAfn, Obj);

