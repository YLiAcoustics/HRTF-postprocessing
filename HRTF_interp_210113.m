%%%%% This MATLAB script performs interpolation on HRTFs imported from .mat
%%%%% files, and saves the result in .txt for future implementation into
%%%%% Max/MSP.
%%%% Author: Yuqing Li
%%%% Last edited: 06.03.2022
clear
close all

% import data (original HRIRs) for interpolation
dis = 100;                           % source distance (cm)
fs = 48000;                         % sampling rate (Hz)

cd 'C:\Users\root\Documents\00 phd\Database\SCUT HRTF (near-field)\HRIR data'
HRIR_mat = zeros(512,2,10,72);
data01 = importdata('SCUT_HRIR_0.2.mat');
data02 = importdata('SCUT_HRIR_0.25.mat');
data03 = importdata('SCUT_HRIR_0.3.mat');
data04 = importdata('SCUT_HRIR_0.4.mat');
data05 = importdata('SCUT_HRIR_0.5.mat');
data06 = importdata('SCUT_HRIR_0.6.mat');
data07 = importdata('SCUT_HRIR_0.7.mat');
data08 = importdata('SCUT_HRIR_0.8.mat');
data09 = importdata('SCUT_HRIR_0.9.mat');
data10 = importdata('SCUT_HRIR_1.mat');

HRIR_mat(:,:,1,:) = data01;
HRIR_mat(:,:,2,:) = data02;
HRIR_mat(:,:,3,:) = data03;
HRIR_mat(:,:,4,:) = data04;
HRIR_mat(:,:,5,:) = data05;
HRIR_mat(:,:,6,:) = data06;
HRIR_mat(:,:,7,:) = data07;
HRIR_mat(:,:,8,:) = data08;
HRIR_mat(:,:,9,:) = data09;
HRIR_mat(:,:,10,:) = data10;

% normalize
HRIR_mat = HRIR_mat/max(max(max(max(abs(HRIR_mat)))));

N = 512;
azimuth = [0:5:355]';                % original data: 72 directions, 5 deg resolution on the horizontal plane

% data_name = strcat('SCUT_KEMAR_radius_',num2str(dis/100),'.sofa');
% data_sofa = SOFAload(data_name);
% HRIR_sofa = data_sofa.Data.IR;
% 
% fs_sofa = data_sofa.Data.SamplingRate;
% 
% % extract HRIR data on the horizontal plane
% HRIR_ori = HRIR_sofa(145:216,:,:);
% % correct azimuth sequence
% for k = 2:37
%     temp = HRIR_ori(k,:,:);
%     HRIR_ori(k,:,:) = HRIR_ori(74-k,:,:);
%     HRIR_ori(74-k,:,:) = temp;
% end
% 
% 
% % resample if necessary
% if fs ~= fs_sofa
%     for i = 1:72
%         HRIR(i,1,:) = resample(squeeze(HRIR_ori(i,1,:)),fs,fs_sofa);
%         HRIR(i,2,:) = resample(squeeze(HRIR_ori(i,2,:)),fs,fs_sofa);
%     end
% else
%     HRIR = HRIR_ori;
% end
% 
% HRIR = permute(HRIR,[3 2 1]);
% HRIR = HRIR(1:512,:,:);
% 
% % concatenate HRIRs at different diretions for inspecting magnitude
% HRIR_full_vec = zeros(512*72,2);
% for j = 1:72
%         HRIR_full_vec(512*(j-1)+1:512*j,1) = HRIR(:,1,j);
%         HRIR_full_vec(512*(j-1)+1:512*j,2) = HRIR(:,2,j);
% end
% 
% %% save data 
% % audiowrite(['hrir_vec_' num2str(dis/100) '.wav'],HRIR_full_vec,fs);
% save(['hrir_vec_' num2str(dis/100) '.mat'],'HRIR_full_vec');

tic
%%%% BEGIN from Song hrtf2msp
%% 1. get the onset delay (in samples)
tau = zeros(2,10,72);                   % matrix for storing onset delay

for k = 1:10
    for i=1:72     
        % 10 times upsampling
        H_Matrix_L_Up=resample(squeeze(HRIR_mat(:,1,k,i)),fs*10,fs);
        H_Matrix_R_Up=resample(squeeze(HRIR_mat(:,2,k,i)),fs*10,fs);
    
        % find the maximal value
        H_Matrix_L_Up_Max= find(abs(H_Matrix_L_Up)==max(abs(H_Matrix_L_Up)));
        H_Matrix_R_Up_Max= find(abs(H_Matrix_R_Up)==max(abs(H_Matrix_R_Up)));
    
        % left ear
        for q=1:H_Matrix_L_Up_Max    % before the peak
            if(abs(H_Matrix_L_Up(q))>=0.30*max(abs(H_Matrix_L_Up))) % set threshold: 30% of the maximal value
                 Tau=q-1;
                break;
            end
        end
%         tau(i,1)=Tau/10/fs;    % downsampling
        tau(1,k,i)= round(Tau/10);         % store onset delay in number of samples
        
     % right ear
        for q=1:H_Matrix_R_Up_Max
            if(abs(H_Matrix_R_Up(q))>=0.30*max(abs(H_Matrix_R_Up))) 
                Tau=q-1;
                break;
            end
        end
%        tau(i,2)=Tau/10/fs; 
       tau(2,k,i)= round(Tau/10);    
    end
end

%% 2. Minimum phase reconstruction of original HRIRs
min_HRIR = zeros(N,2,10,72); % Minimal phase system  

for k = 1:10
    for j = 1:72
        [yL,yLm]= rceps(squeeze(HRIR_mat(:,1,k,j)));       % H_L is the magnitude
        [yR,yRm]= rceps(squeeze(HRIR_mat(:,2,k,j)));
        min_HRIR(:,1,k,j)=yLm;        % store the minimum phase HRIRs (time domain)
        min_HRIR(:,2,k,j)=yRm;
    end
end
       
%% 3. cubic spline interpolation for each elevation
minLNew = zeros(512,10,360);     % matrix to store intepolated minimum-phase HRIRs
minRNew = zeros(512,10,360);
tauLNew = zeros(10,360);     % matrix to store interpolated time delay
tauRNew = zeros(10,360);

for i = 1:10
    minLMatrix=squeeze(min_HRIR(:,1,i,:));
    minRMatrix=squeeze(min_HRIR(:,2,i,:));
    for k = 0:359         % directions to be interpolated: 0-359 deg
        minLNew(:,i,k+1)=spline(azimuth,minLMatrix,k);  % interpolate the HRIRs (sample-wise)
        minRNew(:,i,k+1)=spline(azimuth,minRMatrix,k); 
        tauLNew(i,k+1)= spline(azimuth,squeeze(tau(1,i,:)),k);           % interpolate the onset delay
        tauRNew(i,k+1)= spline(azimuth,squeeze(tau(2,i,:)),k); 
%      % store in interpolated HRIR matrix
%      HRIR_interp(k+1,1,tauNew(k+1,1)+1:N) = minNew(k+1,1,1:N-tauNew(k+1,1));  
%      HRIR_interp(k+1,2,tauNew(k+1,2)+1:N) = minNew(k+1,2,1:N-tauNew(k+1,2)); 
%      HRIR_interp(k+1,1,1:tauNew(k+1,1)) = 0;
%      HRIR_interp(k+1,2,1:tauNew(k+1,2)) = 0;
%      HRTF_interp(k+1,1,:) = fft(HRIR_interp(k+1,1,:));
%      HRTF_interp(k+1,2,:) = fft(HRIR_interp(k+1,2,:));
    end
    i
end

% % calculate ITD in us
% ITD = squeeze((tau(1,:) - tau(2,:))/fs*10^6);
% ITD_interpolated = squeeze((tauLNew-tauRNew)/fs*10^6);
% 
% r_tauLNew = round(tauLNew);
% r_tauRNew = round(tauRNew);

% cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\ITD'
% save(strcat('ITD_',num2str(dis),'cm.mat'),'ITD');
% save(strcat('ITD_original_',num2str(dis),'cm.mat'),'ITD_original');

% save(strcat('HRIR_interp_',num2str(dis),'cm.mat'),'HRIR_interp');
%  save(strcat('HRTF_interp_',num2str(dis),'cm.mat'),'HRTF_interp');

% % save in SOFA format
% Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz
% 
% % Define positions -  we use the standard CIPIC positions here
% lat1= 0:359;    % lateral angles (azimuth)
% pol1= 0;                % polar angles (elevation)
% pol=repmat(pol1',length(lat1),1);
% lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));
% 
% % Create the HRIR matrix
% M = length(lat1)*length(pol1);
% Obj.Data.IR = NaN(M,2,N); % data.IR must be [M R N]
% 
% % HRIR_forsofa = permute(HRIR, [3 2 1]);
% % Fill data with data
% ii=1;       % IR number (including elevation and azimuth)
% for aa=1:length(lat1)
% 	for ee=1:length(pol1)
% %         HRIR_name_l = strcat(['HRIR_' num2str(dis) num2str(5*(ee-1)) '_l.wav']);
% %         HRIR_name_r = strcat(['HRIR_' num2str(dis) num2str(5*(ee-1)) '_r.wav']);
% 		Obj.Data.IR(ii,1,:) = HRIR_interp(ii,1,:);
% 		Obj.Data.IR(ii,2,:) = HRIR_interp(ii,2,:);
% 		[azi,ele]=hor2sph(lat(ii),pol(ii));
%         Obj.SourcePosition(ii,:)=[azi ele 1];
% 		Obj.SourcePosition(ii,:)=[azi ele 1];
% 		ii=ii+1;
% 	end
% end
% 
% % Update dimensions
% Obj=SOFAupdateDimensions(Obj);
% 
% % Fill with attributes
% Obj.GLOBAL_ListenerShortName = 'G.R.A.S KEMAR';
% Obj.GLOBAL_History = 'This database includes the angular interpolated HRIRs from measurement. Resolution is increased from 5 degrees to 1 degree.';
% Obj.GLOBAL_DatabaseName = 'near-field interpolated';
% % Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
% Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
% Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik, Leibniz Universität Hannover';
% Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.de';
% 
% % save the SOFA file
% SOFAfn=fullfile('C:\Users\root\Documents\00 phd\measurement\201020KEMAR HRTF AP\100cm','HRIR100cm_interpolated.sofa');
% disp(['Saving:  ' SOFAfn]);
% Obj=SOFAsave(SOFAfn, Obj);
% 
%% 4. store as .txt 
Re_minL=zeros(512,10,360); Re_minR=zeros(512,10,360);
Im_minL=zeros(512,10,360); Im_minR=zeros(512,10,360);
matrixL=zeros(513,10,360);
matrixR=zeros(513,10,360);           % the first element stores tau

for k = 1:10
    for i=1:360
        ReL=real(fft(squeeze(minLNew(:,k,i))));       % left ear HRTF real part
        ReR=real(fft(squeeze(minRNew(:,k,i))));       % right ear HRTF real part
        ImL=imag(fft(squeeze(minLNew(:,k,i))));       % left ear HRTF imaginary part
        ImR=imag(fft(squeeze(minRNew(:,k,i))));       % right ear HRTF imaginary part

         % store one sided HRTF
         % especially for max/msp object "pfft~"
         rowL=[tauLNew(k,i),ReL(1:N/2)',ImL(1:N/2)'];     % row vector (N+1)x1 = tau - N/2 real - N/2 imag
         rowR=[tauRNew(k,i),ReR(1:N/2)',ImR(1:N/2)'];

         matrixL(:,k,i)=rowL;
         matrixR(:,k,i)=rowR;
    end
end

% cd 'C:\Users\root\Documents\00 phd\Database\SCUT HRTF (near-field)\HRIR data'
% save(strcat('matrix_interp_L_',num2str(dis),'cm.mat'),'matrix(:,1,:)');
% save(strcat('matrix_interp_R_',num2str(dis),'cm.mat'),'matrix(:,2,:)');

for k = 1:10
    for i=1:360
        dlmwrite(['matrix_SCUT_L.txt'],squeeze(matrixL(:,k,i))','-append'); % Write matrix to ASCII-delimited file (not recommended by matlab)
        dlmwrite(['matrix_SCUT_R.txt'],squeeze(matrixR(:,k,i))','-append');
    end 
    k
end
%%% END from Song hrtf2msp
toc