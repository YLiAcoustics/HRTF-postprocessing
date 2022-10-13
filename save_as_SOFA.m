%%%% This MATLAB script saves the measured near-field HRIRs into SOFA
%%%% files.

clear
close all

%%%%%% The following section of code is taken from demo_SOFAsave.m
%% Get an empy conventions structure
Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz

%% Define positions -  we use the standard CIPIC positions here
lat1= 10*(0:36);    % lateral angles (azimuth)
pol1= 0;                % polar angles (elevation)
pol=repmat(pol1',length(lat1),1);
lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));

%% Create the HRIR matrix
M = length(lat1)*length(pol1);
N = 512;
Obj.Data.IR = NaN(M,2,N); % data.IR must be [M R N]

%% Fill Obj with IR data
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\0620'
hrir = importdata('hrir_lowpass_16k_new.mat');
ii=1;       % IR number (including elevation and azimuth)
for aa=1:length(lat1)
	for ee=1:length(pol1)
		Obj.Data.IR(ii,1,:) = hrir(aa,1,:,ee);
		Obj.Data.IR(ii,2,:) = hrir(aa,2,:,ee);
		[azi,ele]=hor2sph(lat(ii),pol(ii));
        Obj.SourcePosition(ii,:)=[azi ele 1];
		Obj.SourcePosition(ii,:)=[azi ele 1];
		ii=ii+1;
	end
end

%% Update dimensions
Obj=SOFAupdateDimensions(Obj);

%% Fill with attributes
Obj.GLOBAL_ListenerShortName = 'KEMAR';
Obj.GLOBAL_History = 'created with a script';
Obj.GLOBAL_DatabaseName = 'near-field continuous HRIR of KU100 dummy head';
% Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik';
Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.com';
Obj.GLOBAL_Comment = 'Contains simple pulses for all directions';

%% save the SOFA file
SOFAfn=fullfile('C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\0620','hrir_lowpass_16k_new.sofa');
disp(['Saving:  ' SOFAfn]);
Obj=SOFAsave(SOFAfn, Obj);