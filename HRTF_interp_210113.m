%%%%% This MATLAB script performs interpolation on HRTFs imported from .mat
%%%%% files, and saves the result in .txt for future implementation into
%%%%% Max/MSP.
%%%% Author: Yuqing Li
%%%% Last edited: October 29th, 2021
clear
close all

% import data (original HRIRs) for interpolation
dis = 100;                           % source distance (cm)
fs = 48000;                         % sampling rate (Hz)

% orig_HRIR_name = strcat('HRIR_original_',num2str(dis),'cm.mat');
HRIR_sofa = SOFAload('HRIR100cm.sofa');
HRIR = HRIR_sofa.Data.IR;
s = size(HRIR);
N = s(3);

azimuth = [0:5:355]';                % original data: 72 directions, 5 deg resolution on the horizontal plane

tic
%%%% BEGIN from Song hrtf2msp
%% 1. get the onset delay (in samples)
tau = zeros(72,2);                   % matrix for storing onset delay

for i=1:72     
    % 10 times upsampling
    H_Matrix_L_Up=resample(squeeze(HRIR(i,1,:)),fs*10,fs);
    H_Matrix_R_Up=resample(squeeze(HRIR(i,2,:)),fs*10,fs);
    
    % find the maximal value
    H_Matrix_L_Up_Max= find(abs(H_Matrix_L_Up)==max(abs(H_Matrix_L_Up)));
    H_Matrix_R_Up_Max= find(abs(H_Matrix_R_Up)==max(abs(H_Matrix_R_Up)));
    
    % left ear
        for q=1:H_Matrix_L_Up_Max    % before the peak
            if(abs(H_Matrix_L_Up(q))>=0.10*max(abs(H_Matrix_L_Up))) % set threshold: 10% of the maximal value
                Tau=q-1;
                break;
            end
        end
%         tau(i,1)=Tau/10/fs;    % downsampling
        tau(i,1)= round(Tau/10);         % store onset delay in number of samples
        
     % right ear
        for q=1:H_Matrix_R_Up_Max
            if(abs(H_Matrix_R_Up(q))>=0.10*max(abs(H_Matrix_R_Up))) 
                Tau=q-1;
                break;
            end
        end
%        tau(i,2)=Tau/10/fs; 
       tau(i,2)= round(Tau/10);       
end

%% 2. Minimum phase reconstruction of original HRIRs
min_HRIR = zeros(72,2,N); % Minimal phase system  

for j = 1:72
    [yL,yLm]= rceps(squeeze(HRIR(j,1,:)));       % H_L is the magnitude
    [yR,yRm]= rceps(squeeze(HRIR(j,2,:)));
    min_HRIR(j,1,:)=yLm;        % store the minimum phase HRIRs (time domain)
    min_HRIR(j,2,:)=yRm;
end
       
%% 3. cubic spline interpolation for each elevation
minNew=zeros(360,2,N); 
tauNew=zeros(360,2);
HRIR_interp = zeros(360,2,N);
HRTF_interp = zeros(360,2,N);
for k = 0:359         % directions to be interpolated: 0-359 deg
     minNew(k+1,1,:)=spline(azimuth,transpose(squeeze(min_HRIR(:,1,:))),k);  % interpolate the HRIRs (sample-wise)
     minNew(k+1,2,:)=spline(azimuth,transpose(squeeze(min_HRIR(:,2,:))),k); 
     tauNew(k+1,1)= round(spline(azimuth,squeeze(tau(:,1)),k));           % interpolate the onset delay
     tauNew(k+1,2)= round(spline(azimuth,squeeze(tau(:,2)),k)); 
     % store in interpolated HRIR matrix
     HRIR_interp(k+1,1,tauNew(k+1,1)+1:N) = minNew(k+1,1,1:N-tauNew(k+1,1));  
     HRIR_interp(k+1,2,tauNew(k+1,2)+1:N) = minNew(k+1,2,1:N-tauNew(k+1,2)); 
     HRIR_interp(k+1,1,1:tauNew(k+1,1)) = 0;
     HRIR_interp(k+1,2,1:tauNew(k+1,2)) = 0;
     HRTF_interp(k+1,1,:) = fft(HRIR_interp(k+1,1,:));
     HRTF_interp(k+1,2,:) = fft(HRIR_interp(k+1,2,:));
end

% calculate ITD in ms
ITD = (tauNew(:,2)-tauNew(:,1))/fs*1000;
ITD_original = (tau(:,2)-tau(:,1))/fs*1000;
% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ITD'
% save(strcat('ITD_',num2str(dis),'cm.mat'),'ITD');
% save(strcat('ITD_original_',num2str(dis),'cm.mat'),'ITD_original');

% save(strcat('HRIR_interp_',num2str(dis),'cm.mat'),'HRIR_interp');
%  save(strcat('HRTF_interp_',num2str(dis),'cm.mat'),'HRTF_interp');

% save in SOFA format
Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz

% Define positions -  we use the standard CIPIC positions here
lat1= 0:359;    % lateral angles (azimuth)
pol1= 0;                % polar angles (elevation)
pol=repmat(pol1',length(lat1),1);
lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));

% Create the HRIR matrix
M = length(lat1)*length(pol1);
Obj.Data.IR = NaN(M,2,N); % data.IR must be [M R N]

% HRIR_forsofa = permute(HRIR, [3 2 1]);
% Fill data with data
ii=1;       % IR number (including elevation and azimuth)
for aa=1:length(lat1)
	for ee=1:length(pol1)
%         HRIR_name_l = strcat(['HRIR_' num2str(dis) num2str(5*(ee-1)) '_l.wav']);
%         HRIR_name_r = strcat(['HRIR_' num2str(dis) num2str(5*(ee-1)) '_r.wav']);
		Obj.Data.IR(ii,1,:) = HRIR_interp(ii,1,:);
		Obj.Data.IR(ii,2,:) = HRIR_interp(ii,2,:);
		[azi,ele]=hor2sph(lat(ii),pol(ii));
        Obj.SourcePosition(ii,:)=[azi ele 1];
		Obj.SourcePosition(ii,:)=[azi ele 1];
		ii=ii+1;
	end
end

% Update dimensions
Obj=SOFAupdateDimensions(Obj);

% Fill with attributes
Obj.GLOBAL_ListenerShortName = 'G.R.A.S KEMAR';
Obj.GLOBAL_History = 'This database includes the angular interpolated HRIRs from measurement. Resolution is increased from 5 degrees to 1 degree.';
Obj.GLOBAL_DatabaseName = 'near-field interpolated';
% Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik, Leibniz Universität Hannover';
Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.de';

% save the SOFA file
SOFAfn=fullfile('C:\Users\root\Documents\00 phd\measurement\201020KEMAR HRTF AP\100cm','HRIR100cm_interpolated.sofa');
disp(['Saving:  ' SOFAfn]);
Obj=SOFAsave(SOFAfn, Obj);

% %% 4. store as .txt 
% matrix_HRTF = zeros(N+1,2,360);            % the first element stores tau
% 
% for i=1:360
%     ReL=real(fft(squeeze(minNew(:,1,i))));       % left ear HRTF real part
%     ReR=real(fft(squeeze(minNew(:,2,i))));       % right ear HRTF real part
%     ImL=imag(fft(squeeze(minNew(:,1,i))));       % left ear HRTF imaginary part
%     ImR=imag(fft(squeeze(minNew(:,2,i))));       % right ear HRTF imaginary part
% 
%      % store one sided HRTF
%      % especially for max/msp object "pfft~"
%      rowL=[tauNew(i,1)*fs,ReL(1:N/2)',ImL(1:N/2)'];     % row vector (N+1)x1 = tau - N/2 real - N/2 imag
%      rowR=[tauNew(i,2)*fs,ReR(1:N/2)',ImR(1:N/2)'];
% 
%      matrix(:,1,i)=rowL;
%      matrix(:,2,i)=rowR;
% end
% 
% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRTF\matrix'
% save(strcat('matrix_interp_L_',num2str(dis),'cm.mat'),'matrix(:,1,:)');
% save(strcat('matrix_interp_R_',num2str(dis),'cm.mat'),'matrix(:,2,:)');

% for i=1:360
%     writematrix('matrix_interp_1_deg_L.txt',squeeze(matrix(:,1,361-i))','-append'); % Write matrix to ASCII-delimited file (not recommended by matlab)
%     writematrix('matrix_interp_1_deg_R.txt',squeeze(matrix(:,2,361-i))','-append');
% end 
%%%% END from Song hrtf2msp
toc