%%%%% This MATLAB script performs interpolation on HRTFs imported from .mat
%%%%% files, and saves the result in .txt for future implementation into
%%%%% Max/MSP.
%%%% Author: Yuqing Li
%%%% Last edited: 31.03.2022
clear
close all

%% import data (original HRIRs) for interpolation
fs = 48000;                         % sampling rate (Hz)

cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220111ContinuousDistanceHRTF\database'
Obj = SOFAload('continuous_HRIR_normalized_lfcorr.sofa');
for i = 1:101
    HRIR_mat(:,1,i,1) = Obj.Data.IR(72*(i-1)+1,1,:);   % left
    HRIR_mat(:,2,i,1) = Obj.Data.IR(72*(i-1)+1,2,:);   % right
    for j = 2:72
        HRIR_mat(:,1,i,74-j) = Obj.Data.IR(72*(i-1)+j,1,:);  % note that the coordinate in SOFA convention is opposite that of the original data, therefore azimuth
                                                             % of the SOFA HRIRs must be reversed.
                                                             % e.g. the 2nd HRIR (5 degree) is interchanged with the 72nd HRIR (355 degree).                                                 
        HRIR_mat(:,2,i,74-j) = Obj.Data.IR(72*(i-1)+j,2,:);
    end
end
N = 512;
azimuth = [0:5:360]';                % original grid

% % resample if necessary
% if fs ~= fs_sofa
%     for i = 1:72
%         HRIR(i,1,:) = resample(squeeze(HRIR_ori(i,1,:)),fs,fs_sofa);
%         HRIR(i,2,:) = resample(squeeze(HRIR_ori(i,2,:)),fs,fs_sofa);
%     end
% else
%     HRIR = HRIR_ori;
% end

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

%% get the onset delay (in samples)
% %% low-pass filtering
% for i = 1:101
%     for j = 1:72
%         lp_HRIR_mat(:,1,i,j) = lowpass(HRIR_mat(:,1,i,j),3000,48000);
%         lp_HRIR_mat(:,2,i,j) = lowpass(HRIR_mat(:,2,i,j),3000,48000);
%     end
%     i
% end

lp_HRIR_mat_L = importdata('lp_normalized_lfcorrected_3000_L.mat');
lp_HRIR_mat_R = importdata('lp_normalized_lfcorrected_3000_R.mat');

for i = 1:101
    for j = 1:72    
        % 10 times upsampling
        H_Matrix_L_Up=resample(squeeze(lp_HRIR_mat_L(:,i,j)),fs*10,fs);
        H_Matrix_R_Up=resample(squeeze(lp_HRIR_mat_R(:,i,j)),fs*10,fs);
    
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
%         tau(i,1)=Tau/10/fs;   
        tauL(i,j)=Tau/10;         % store onset delay in number of samples
        
     % right ear
        for q=1:H_Matrix_R_Up_Max
            if(abs(H_Matrix_R_Up(q))>=0.30*max(abs(H_Matrix_R_Up))) 
                Tau=q-1;
                break;
            end
        end
%        tau(i,2)=Tau/10/fs; 
       tauR(i,j)= Tau/10;    
    end
end

%% 2. Minimum phase reconstruction of original HRIRs
min_HRIR = zeros(N,2,101,73); % Minimum-phase system  

for i = 1:101
    for j = 1:72
        % smooth the HRTF with simple auditory filter ot overcome the clicks caused by switch HRTFs in bianural rendering
        % this function "hsmooth" is provided by CIPIC 
        dB_L = hsmooth(squeeze(Magnitude_L(:,i,j)),30); 
        dB_R = hsmooth(squeeze(Magnitude_R(:,i,j)),30);
                
        % mirror the half spectrum
        H_L=[dB_L;flip(dB_L(2:end-1))]; 
        H_R=[dB_R;flip(dB_R(2:end-1))]; 

        % convert db to amplitude
        H_L=10.^(H_L./20);
        H_R=10.^(H_R./20);
            
        % unwrap the phase
        Phase_L_unwrap = unwrap(squeeze(Phase_L(:,i,j)));
        Phase_R_unwrap = unwrap(squeeze(Phase_R(:,i,j)));

        % minimumphase system 
        [yL,yLm]= rceps(ifft(H_L.*exp(1j*Phase_L_unwrap),'symmetric'));       % H_L is the magnitude
        [yR,yRm]= rceps(ifft(H_R.*exp(1j*Phase_R_unwrap),'symmetric'));
        min_HRIR(:,1,i,j)=yLm;        % store the minimum phase HRIRs (time domain)
        min_HRIR(:,2,i,j)=yRm;
    end
    i
end

% magnitude and phase for 360° is equal to 0°
Magnitude_L(:,:,73) = Magnitude_L(:,:,1);
Magnitude_R(:,:,73) = Magnitude_R(:,:,1);

Phase_L(:,:,73) = Phase_L(:,:,1);
Phase_R(:,:,73) = Phase_R(:,:,1);

tauL(:,73) = tauL(:,1);
tauR(:,73) = tauR(:,1);
min_HRIR(:,:,:,73) = min_HRIR(:,:,:,1);

%% 3. cubic spline interpolation for each elevation
minLNew = zeros(512,101,361);     % matrix to store intepolated minimum-phase HRIRs
minRNew = zeros(512,101,361);
tauLNew = zeros(101,361);     % matrix to store interpolated time delay
tauRNew = zeros(101,361);
% HRIR_full_vec = zeros(512*101*361,2);

for i = 1:101
    minLMatrix=squeeze(min_HRIR(:,1,i,:));
    minRMatrix=squeeze(min_HRIR(:,2,i,:));
    for k = 0:360        % directions to be interpolated: 1:359
        minLNew(:,i,k+1)=spline(azimuth,minLMatrix,k);  % interpolate the HRIRs (sample-wise)
        minRNew(:,i,k+1)=spline(azimuth,minRMatrix,k); 
        tauLNew(i,k+1)= spline(azimuth,squeeze(tauL(i,:)),k);           % interpolate the onset delay
        tauRNew(i,k+1)= spline(azimuth,squeeze(tauR(i,:)),k); 
%         % store in interpolated HRIR matrix
%         HRIR_L_interp(tauLNew(i,k+1)+1:N,i,k+1) = minLNew(1:N-tauLNew(i,k+1),i,k+1);  
%         HRIR_R_interp(tauRNew(i,k+1)+1:N,i,k+1) = minRNew(1:N-tauRNew(i,k+1),i,k+1); 
%         HRIR_L_interp(1:tauLNew(i,k+1),i,k+1) = 0;
%         HRIR_R_interp(1:tauRNew(i,k+1),i,k+1) = 0;
%      HRTF_interp(k+1,1,:) = fft(HRIR_interp(k+1,1,:));
%      HRTF_interp(k+1,2,:) = fft(HRIR_interp(k+1,2,:));
% 
%         % concatenate HRIRs at different distances and diretions 
%         HRIR_full_vec(512*(361*(i-1)+k)+1:512*(361*(i-1)+k)+512,1) = HRIR_L_interp(:,i,k+1);
%         HRIR_full_vec(512*(361*(i-1)+k)+1:512*(361*(i-1)+k)+512,2) = HRIR_R_interp(:,i,k+1);
    end
    i
end

% check if the 361th IR equals the 1st IR

% normalize
MaxL = max(max(max(abs(minLNew))));
MaxR = max(max(max(abs(minRNew))));
Max = max(MaxL,MaxR);
minLNew = minLNew/Max;
minRNew = minRNew/Max;
% HRIR_full_vec = HRIR_full_vec/max(max(abs(HRIR_full_vec)));
% audiowrite('PKUIOA_hrirformax_0404_left.wav',HRIR_full_vec(:,1),fs);
% audiowrite('PKUIOA_hrirformax_0404_right.wav',HRIR_full_vec(:,2),fs);

% calculate ITD in us
ITD = squeeze((tauL- tauR)/fs*10^6);
ITD_interpolated = squeeze((tauLNew-tauRNew)/fs*10^6);
% 
% r_tauLNew = round(tauLNew);
% r_tauRNew = round(tauRNew);

cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220111ContinuousDistanceHRTF\database'
save('data_continuous_HRIR_interpolated_normalized_lpcorrected_smoothed.mat','minLNew','minRNew','tauLNew','tauRNew','ITD','ITD_interpolated');


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
Re_minL=zeros(512,101,361); Re_minR=zeros(512,101,361);
Im_minL=zeros(512,101,361); Im_minR=zeros(512,101,361);
matrixL=zeros(513,101,361);
matrixR=zeros(513,101,361);           % the first element stores tau

for i = 1:101
    for j=1:361
        ReL=real(fft(squeeze(minLNew(:,i,j))));       % left ear HRTF real part
        ReR=real(fft(squeeze(minRNew(:,i,j))));       % right ear HRTF real part
        ImL=imag(fft(squeeze(minLNew(:,i,j))));       % left ear HRTF imaginary part
        ImR=imag(fft(squeeze(minRNew(:,i,j))));       % right ear HRTF imaginary part

         % store one sided HRTF
         % especially for max/msp object "pfft~"
         rowL=[tauLNew(i,j),ReL(1:N/2)',ImL(1:N/2)'];     % row vector (N+1)x1 = tau - N/2 real - N/2 imag
         rowR=[tauRNew(i,j),ReR(1:N/2)',ImR(1:N/2)'];

         matrixL(:,i,j)=rowL;
         matrixR(:,i,j)=rowR;
    end
end

% % cd 'C:\Users\root\Documents\00 phd\Database\SCUT HRTF (near-field)\HRIR
% data'g
% % save(strcat('matrix_interp_L_',num2str(dis),'cm.mat'),'matrix(:,1,:)');
% % save(strcat('matrix_interp_R_',num2str(dis),'cm.mat'),'matrix(:,2,:)');

for i = 1:101
    for j=1:361
        dlmwrite(['matrix_continuous_L_0502(smoothed).txt'],squeeze(matrixL(:,i,j))','-append'); % Write matrix to ASCII-delimited file (not recommended by matlab)
        dlmwrite(['matrix_continuous_R_0502(smoothed).txt'],squeeze(matrixR(:,i,j))','-append');
    end 
    i
end
% %%% END from Song hrtf2msp
% toc