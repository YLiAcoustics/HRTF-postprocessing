%%%% This MATLAB script saves the measured near-field HRIRs into SOFA
%%%% files.

clear
close all

%%%%%% The following section of code is taken from demo_SOFAsave.m
%% Get an empy conventions structure
Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz

%% Define positions -  we use the standard CIPIC positions here
lat1= 5*(0:71);    % lateral angles (azimuth)
pol1= 0;                % polar angles (elevation)
pol=repmat(pol1',length(lat1),1);
lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));

%% Create the HRIR matrix
M = length(lat1)*length(pol1);
N = 960;
Obj.Data.IR = NaN(M,2,N); % data.IR must be [M R N]

%% Fill data with data
cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\HRIRs\1203\25cm'
ii=1;       % IR number (including elevation and azimuth)
for aa=1:length(lat1)
	for ee=1:length(pol1)
        HRIR_name_l = strcat(['HRIR_25_' num2str(5*(ee-1)) '_l.wav']);
        HRIR_name_r = strcat(['HRIR_25_' num2str(5*(ee-1)) '_r.wav']);
		Obj.Data.IR(ii,1,:) = audioread(HRIR_name_l);
		Obj.Data.IR(ii,2,:) = audioread(HRIR_name_r);
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
Obj.GLOBAL_DatabaseName = 'near-field';
% Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik';
Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.com';
Obj.GLOBAL_Comment = 'Contains simple pulses for all directions';

%% save the SOFA file
SOFAfn=fullfile('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\SOFA','HRIR25cm.sofa');
disp(['Saving:  ' SOFAfn]);
Obj=SOFAsave(SOFAfn, Obj);