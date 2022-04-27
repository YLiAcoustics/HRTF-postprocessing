%%%%% This MATLAB script performs interpolation on HRTFs imported from .mat
%%%%% files, and saves the result in .txt for future implementation into
%%%%% Max/MSP.
%%%% Author: Yuqing Li
%%%% Last edited: 31.03.2022
clear
close all

%% import data (original HRIRs) for interpolation
% dis = 20;                           % source distance (cm)
fs = 48000;                         % sampling rate (Hz)

cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220111ContinuousDistanceHRTF\0121\results'
HRIR_mat = importdata('HRIR_512_101_73_normalized_0311.mat');
lp_HRIR_mat = importdata('Lowpass_HRIR_3000.mat');
N = 512;
azimuth = [0:5:360]';                % original data
% data01 = importdata('dist_0.2m.mat');
% data02 = importdata('dist_0.3m.mat');
% data03 = importdata('dist_0.5m.mat');
% data04 = importdata('dist_0.75m.mat');
% data05 = importdata('dist_1.0m.mat');
% 
% HRIR_mat(:,:,1,:) = data01(:,:,1:512)*0.2;
% HRIR_mat(:,:,2,:) = data02(:,:,1:512)*0.3;
% HRIR_mat(:,:,3,:) = data03(:,:,1:512)*0.5;
% HRIR_mat(:,:,4,:) = data04(:,:,1:512)*0.75;
% HRIR_mat(:,:,5,:) = data05(:,:,1:512);

% normalize
% HRIR_mat = HRIR_mat/max(max(max(max(abs(HRIR_mat)))));
% HRIR_mat = permute(HRIR_mat,[4 2 3 1]);

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
% reserve memeory for HRIR, magnitude, phase and ITDs
HRIR_L=squeeze(HRIR_mat(:,1,:,:));
HRIR_R=squeeze(HRIR_mat(:,2,:,:)); 

Magnitude_L=zeros(512,101,73); % Magnitude for left ear 
Magnitude_R=zeros(512,101,73); % Magnitude for right ear

Phase_L=zeros(512,101,73); % Phase for left ear 
Phase_R=zeros(512,101,73); % Phase for right ear
         
tauL=zeros(101,73); % Onset delay for left ear (azimuth, elevation)
tauR=zeros(101,73); % Onset delay for right ear 

for i = 1:101
    for j = 1:72
        Magnitude_L(:,i,j)=abs(fft(HRIR_L(:,i,j),512)); % store the magnitude in matrix 
        Magnitude_R(:,i,j)=abs(fft(HRIR_R(:,i,j),512)); 

        Phase_L(:,i,j)=angle(fft(HRIR_L(:,i,j),512)); % store the phase in matrix 
        Phase_R(:,i,j)=angle(fft(HRIR_R(:,i,j),512));
    end
end
% magnitude and phase for 360° is equal to 0°
Magnitude_L(:,:,73) = Magnitude_L(:,:,1);
Magnitude_R(:,:,73) = Magnitude_R(:,:,1);

Phase_L(:,:,73) = Phase_L(:,:,1);
Phase_R(:,:,73) = Phase_R(:,:,1);

%% get the onset delay (in samples)
% %% low-pass filtering
% for i = 1:5
%     for j = 1:72
%         lp_HRIR_mat(:,1,i,j) = lowpass(HRIR_mat(:,1,i,j),3000,48000);
%         lp_HRIR_mat(:,2,i,j) = lowpass(HRIR_mat(:,2,i,j),3000,48000);
%     end
%     i
% end

for k = 1:101
    for i = 1:72    
        % 10 times upsampling
        H_Matrix_L_Up=resample(squeeze(lp_HRIR_mat(:,1,k,i)),fs*10,fs);
        H_Matrix_R_Up=resample(squeeze(lp_HRIR_mat(:,2,k,i)),fs*10,fs);
    
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
        tauL(k,i)=Tau/10;         % store onset delay in number of samples
        
     % right ear
        for q=1:H_Matrix_R_Up_Max
            if(abs(H_Matrix_R_Up(q))>=0.30*max(abs(H_Matrix_R_Up))) 
                Tau=q-1;
                break;
            end
        end
%        tau(i,2)=Tau/10/fs; 
       tauR(k,i)= Tau/10;    
    end
end

% % correct irregular values (caused by some DC offset at the contralateral ear)
% for k = 1:101
%     for i = 1:73   
%         % because ITD varies very little with distance (no more than one
%         % sample for adjacent distances), find those that have differences
%         % with the prvious one larger than 2 samples
%         if abs(tauL(k,i)-tauL(k-1,i))>2

%% 2. Minimum phase reconstruction of original HRIRs
min_HRIR = zeros(N,2,5,72); % Minimal phase system  

for k = 1:101
    for j = 1:72
        [yL,yLm]= rceps(squeeze(HRIR_mat(:,1,k,j)));       % H_L is the magnitude
        [yR,yRm]= rceps(squeeze(HRIR_mat(:,2,k,j)));
        min_HRIR(:,1,k,j)=yLm;        % store the minimum phase HRIRs (time domain)
        min_HRIR(:,2,k,j)=yRm;
    end
end

tauL(:,73) = tauL(:,1);
tauR(:,73) = tauR(:,1);
min_HRIR(:,:,:,73) = min_HRIR(:,:,:,1);

%% 3. cubic spline interpolation for each elevation
minLNew = zeros(512,101,361);     % matrix to store intepolated minimum-phase HRIRs
minRNew = zeros(512,101,361);
tauLNew = zeros(101,361);     % matrix to store interpolated time delay
tauRNew = zeros(101,361);
HRIR_full_vec = zeros(512*101*361,2);

for i = 1:101
    minLMatrix=squeeze(min_HRIR(:,1,i,:));
    minRMatrix=squeeze(min_HRIR(:,2,i,:));
    for k = 0:360        % directions to be interpolated: 0-359 deg
        minLNew(:,i,k+1)=spline(azimuth,minLMatrix,k);  % interpolate the HRIRs (sample-wise)
        minRNew(:,i,k+1)=spline(azimuth,minRMatrix,k); 
        tauLNew(i,k+1)= spline(azimuth,squeeze(tauL(i,:)),k);           % interpolate the onset delay
        tauRNew(i,k+1)= spline(azimuth,squeeze(tauR(i,:)),k); 
        % store in interpolated HRIR matrix
        HRIR_L_interp(tauLNew(i,k+1)+1:N,i,k+1) = minLNew(1:N-tauLNew(i,k+1),i,k+1);  
        HRIR_R_interp(tauRNew(i,k+1)+1:N,i,k+1) = minRNew(1:N-tauRNew(i,k+1),i,k+1); 
        HRIR_L_interp(1:tauLNew(i,k+1),i,k+1) = 0;
        HRIR_R_interp(1:tauRNew(i,k+1),i,k+1) = 0;
%      HRTF_interp(k+1,1,:) = fft(HRIR_interp(k+1,1,:));
%      HRTF_interp(k+1,2,:) = fft(HRIR_interp(k+1,2,:));

        % concatenate HRIRs at different distances and diretions 
        HRIR_full_vec(512*(361*(i-1)+k)+1:512*(361*(i-1)+k)+512,1) = HRIR_L_interp(:,i,k+1);
        HRIR_full_vec(512*(361*(i-1)+k)+1:512*(361*(i-1)+k)+512,2) = HRIR_R_interp(:,i,k+1);
    end
    i
end

% normalize
HRIR_full_vec = HRIR_full_vec/max(max(abs(HRIR_full_vec)));
% audiowrite('PKUIOA_hrirformax_0404_left.wav',HRIR_full_vec(:,1),fs);
% audiowrite('PKUIOA_hrirformax_0404_right.wav',HRIR_full_vec(:,2),fs);

% calculate ITD in us
ITD = squeeze((tauL- tauR)/fs*10^6);
ITD_interpolated = squeeze((tauLNew-tauRNew)/fs*10^6);
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
% %% 4. store as .txt 
% Re_minL=zeros(512,6,360); Re_minR=zeros(512,6,360);
% Im_minL=zeros(512,6,360); Im_minR=zeros(512,6,360);
% matrixL=zeros(513,6,360);
% matrixR=zeros(513,6,360);           % the first element stores tau
% 
% for k = 1:6
%     for i=1:360
%         ReL=real(fft(squeeze(minLNew(:,k,i))));       % left ear HRTF real part
%         ReR=real(fft(squeeze(minRNew(:,k,i))));       % right ear HRTF real part
%         ImL=imag(fft(squeeze(minLNew(:,k,i))));       % left ear HRTF imaginary part
%         ImR=imag(fft(squeeze(minRNew(:,k,i))));       % right ear HRTF imaginary part
% 
%          % store one sided HRTF
%          % especially for max/msp object "pfft~"
%          rowL=[tauLNew(k,i),ReL(1:N/2)',ImL(1:N/2)'];     % row vector (N+1)x1 = tau - N/2 real - N/2 imag
%          rowR=[tauRNew(k,i),ReR(1:N/2)',ImR(1:N/2)'];
% 
%          matrixL(:,k,i)=rowL;
%          matrixR(:,k,i)=rowR;
%     end
% end
% 
% % cd 'C:\Users\root\Documents\00 phd\Database\SCUT HRTF (near-field)\HRIR data'
% % save(strcat('matrix_interp_L_',num2str(dis),'cm.mat'),'matrix(:,1,:)');
% % save(strcat('matrix_interp_R_',num2str(dis),'cm.mat'),'matrix(:,2,:)');
% 
% for k = 1:6
%     for i=1:360
%         dlmwrite(['matrix_SCUT_L.txt'],squeeze(matrixL(:,k,i))','-append'); % Write matrix to ASCII-delimited file (not recommended by matlab)
%         dlmwrite(['matrix_SCUT_R.txt'],squeeze(matrixR(:,k,i))','-append');
%     end 
%     k
% end
% %%% END from Song hrtf2msp
% toc