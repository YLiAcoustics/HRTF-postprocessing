%% This MATLAB script performs cubic spline interpolation on HRTFs to obtain data at intermediate angles,
%% and saves the result as .wav and .txt files for implementation in Max/MSP.
%% Yuqing Li
%% Last edited: 12.08.2022
clear
close all

SaveAsSOFA = 1;
SaveAsTXT = 0;
SaveAsWav = 1;
SaveAsMat = 1;

fs = 48000;
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs'
%% import from SOFA file
filename = 'hrir_ku1_las_near_circ';
Obj = SOFAload([filename '.sofa']);
FS = Obj.Data.SamplingRate;         % sampling rate (Hz)
N = size(Obj.Data.IR,3);            % HRIR filter length
SP = Obj.SourcePosition;            % source positions
Nds = 101;        % number of distances
Nel = 1;          % number of elevation
Naz = size(Obj.Data.IR,1)/Nds/Nel;   % number of azimuth
% resample if necessary
if fs~=FS
    for i = 1:size(Obj.Data.IR,1)
        for j = 1:2
            HRIR(i,j,:) = resample(squeeze(Obj.Data.IR(i,j,:)),fs,FS);
        end
    end
else
    HRIR = Obj.Data.IR;
end
N = size(HRIR,3);

%% store HRIRs in a matrix
for i = 1:Nds
    HRIR_mat(:,1,i,1) = HRIR(Naz*(i-1)+1,1,:);   % left
    HRIR_mat(:,2,i,1) = HRIR(Naz*(i-1)+1,2,:);   % right
    for j = 2:Naz
        HRIR_mat(:,1,i,Naz+2-j) = HRIR(Naz*(i-1)+j,1,:);  % note that the coordinate in SOFA convention is opposite that of the original data, therefore azimuth
                                                             % of the SOFA HRIRs must be reversed.
                                                             % e.g. the 2nd HRIR (5 degree) is interchanged with the 72nd HRIR (355 degree).                                                 
        HRIR_mat(:,2,i,Naz+2-j) = HRIR(Naz*(i-1)+j,2,:);
    end
end
[az,~] = nav2sph(SP(:,1),SP(:,2));        % obtain azimuth vector
az = az([1:Naz]);

% % import from MATLAB data
% data = importdata('data_DVF.mat');
% HRIR_mat = data.f_shHRIR;
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
Magnitude_L=zeros(N,Nds,Naz); % Magnitude for left ear 
Magnitude_R=zeros(N,Nds,Naz); % Magnitude for right ear
Phase_L=zeros(N,Nds,Naz); % Phase for left ear 
Phase_R=zeros(N,Nds,Naz); % Phase for right ear      
tauL=zeros(Nds,Naz); % Onset delay for left ear (azimuth, elevation)
tauR=zeros(Nds,Naz); % Onset delay for right ear 
for i = 1:Nds
    for j = 1:Naz
        Magnitude_L(:,i,j)=abs(fft(HRIR_L(:,i,j),N)); % store the magnitude in matrix 
        Magnitude_R(:,i,j)=abs(fft(HRIR_R(:,i,j),N)); 

        Phase_L(:,i,j)=angle(fft(HRIR_L(:,i,j),N)); % store the phase in matrix 
        Phase_R(:,i,j)=angle(fft(HRIR_R(:,i,j),N));
    end
end

%% get the onset delay (in samples)
disp('Begin low-pass filtering...');
% low-pass filtering
for i = 1:Nds
    for j = 1:Naz
        lp_HRIR_mat(:,1,i,j) = lowpass(HRIR_mat(:,1,i,j),3000,fs);
        lp_HRIR_mat(:,2,i,j) = lowpass(HRIR_mat(:,2,i,j),3000,fs);
    end
    i
end
% lp_HRIR_mat_L = importdata('lp_normalized_lfcorrected_3000_L.mat');
% lp_HRIR_mat_R = importdata('lp_normalized_lfcorrected_3000_R.mat');
% lp_HRIR_mat = importdata('lp_DVF_normalized_lfcorrected_3000.mat');
lp_HRIR_mat_L = squeeze(lp_HRIR_mat(:,1,:,:));
lp_HRIR_mat_R = squeeze(lp_HRIR_mat(:,2,:,:));

disp('Low-pass filtering completed.');
disp('Begin time-of-arrival estimation...');
for i = 1:Nds
    for j = 1:Naz   
        % 10 times upsampling
        H_Matrix_L_Up=resample(squeeze(lp_HRIR_mat_L(:,i,j)),fs*10,fs);
        H_Matrix_R_Up=resample(squeeze(lp_HRIR_mat_R(:,i,j)),fs*10,fs);
    
        % find the maximal value
        H_Matrix_L_Up_Max= find(abs(H_Matrix_L_Up)==max(abs(H_Matrix_L_Up)));
        H_Matrix_R_Up_Max= find(abs(H_Matrix_R_Up)==max(abs(H_Matrix_R_Up)));
    
        % left ear
        for q=1:H_Matrix_L_Up_Max    % before the peak
            if(abs(H_Matrix_L_Up(q))>=0.3*max(abs(H_Matrix_L_Up))) % set threshold: 30% of the maximal value
                 Tau=q-1;
                break;
            end
        end  
        tauL(i,j)=Tau/10;         % store onset delay in number of samples
        
     % right ear
        for q=1:H_Matrix_R_Up_Max
            if(abs(H_Matrix_R_Up(q))>=0.3*max(abs(H_Matrix_R_Up))) 
                Tau=q-1;
                break;
            end
        end 
       tauR(i,j)= Tau/10;    
    end
    i
end
% calculate ITD in us
ITD = squeeze((tauL- tauR)/fs*10^6);
disp('Time-of-arrival estimation completed.');
%% Minimum phase reconstruction of original HRIRs
min_HRIR = zeros(N,2,Nds,Naz); % Minimum-phase system  
HRTF_smoothed = zeros(N,2,Nds,Naz);
disp('Begin minimum-phase reconstruction...');
for i = 1:Nds
    for j = 1:Naz
        % smooth the HRTF with simple auditory filter ot overcome the clicks caused by switch HRTFs in bianural rendering
        % this function "hsmooth" is provided by CIPIC 
        dB_L = hsmooth(squeeze(Magnitude_L(:,i,j)),30); 
        dB_R = hsmooth(squeeze(Magnitude_R(:,i,j)),30);        
        % mirror the half spectrum
        H_L=[dB_L;flip(dB_L(2:end+mod(N,2)-1))]; 
        H_R=[dB_R;flip(dB_R(2:end+mod(N,2)-1))]; 
        % convert db to amplitude
        H_L=10.^(H_L./20);
        H_R=10.^(H_R./20);
        % unwrap the phase
        Phase_L_unwrap = unwrap(squeeze(Phase_L(:,i,j)));
        Phase_R_unwrap = unwrap(squeeze(Phase_R(:,i,j)));
        % smoothed HRTF
        HRTF_smoothed(:,1,i,j) = H_L.*exp(1j*Phase_L_unwrap);
        HRTF_smoothed(:,2,i,j) = H_R.*exp(1j*Phase_R_unwrap);

        % minimum-phase system 
        [yL,yLm]= rceps(ifft(H_L.*exp(1j*Phase_L_unwrap),'symmetric'));       % H_L is the magnitude
        [yR,yRm]= rceps(ifft(H_R.*exp(1j*Phase_R_unwrap),'symmetric'));
        min_HRIR(:,1,i,j)=yLm;        % store the minimum phase HRIRs (time domain)
        min_HRIR(:,2,i,j)=yRm;
    end
    i
end
disp('Minimum-phase reconstruction completed.');

% add azimuth = 360 for interpolation
if Obj.SourcePosition(Naz) ~= 360
    NazNew = Naz+1;
    % 360° is equal to 0°
    Magnitude_L(:,:,NazNew) = Magnitude_L(:,:,1);
    Magnitude_R(:,:,NazNew) = Magnitude_R(:,:,1);
    Phase_L(:,:,NazNew) = Phase_L(:,:,1);
    Phase_R(:,:,NazNew) = Phase_R(:,:,1);
    tauL(:,NazNew) = tauL(:,1);
    tauR(:,NazNew) = tauR(:,1);
    min_HRIR(:,:,:,NazNew) = min_HRIR(:,:,:,1);
    az(NazNew) = 360;
end

%% cubic spline interpolation
minLNew = zeros(N,Nds,360);     % matrix to store intepolated minimum-phase HRIRs. Azimuthal resolution: 1 degree.
minRNew = zeros(N,Nds,360);
tauLNew = zeros(Nds,360);     % matrix to store interpolated time delay
tauRNew = zeros(Nds,360);
HRIR_full_vec = zeros(N*Nds*360,2);
disp('Begin interpolation...');
for i = 1:Nds
    minLMatrix=squeeze(min_HRIR(:,1,i,:));
    minRMatrix=squeeze(min_HRIR(:,2,i,:));
    for k = 0:359        % directions to be interpolated: 1:359
        minLNew(:,i,k+1)=spline(az,minLMatrix,k);  % interpolate the HRIRs (sample-wise)
        minRNew(:,i,k+1)=spline(az,minRMatrix,k); 
        tauLNew(i,k+1)= spline(az,squeeze(tauL(i,:)),k);           % interpolate the onset delay
        tauRNew(i,k+1)= spline(az,squeeze(tauR(i,:)),k); 
        % store in interpolated HRIR matrix
        HRIR_L_interp(round(tauLNew(i,k+1))+1:N,i,k+1) = minLNew(1:N-round(tauLNew(i,k+1)),i,k+1);  
        HRIR_R_interp(round(tauRNew(i,k+1))+1:N,i,k+1) = minRNew(1:N-round(tauRNew(i,k+1)),i,k+1); 
        if N<512    % zeropad at the end because Max buffers are 512 samples long
            HRIR_L_interp(N+1:512,i,k+1) = zeros(512-N,1);  
            HRIR_R_interp(N+1:512,i,k+1) = zeros(512-N,1); 
        end
        HRIR_L_interp(1:round(tauLNew(i,k+1)),i,k+1) = 0;
        HRIR_R_interp(1:round(tauRNew(i,k+1)),i,k+1) = 0;
        HRIR_interp(:,1,i,k+1) = HRIR_L_interp(:,i,k+1);
        HRIR_interp(:,2,i,k+1) = HRIR_R_interp(:,i,k+1);
        HRTF_interp(:,1,i,k+1) = fft(HRIR_interp(:,1,i,k+1));
        HRTF_interp(:,2,i,k+1) = fft(HRIR_interp(:,2,i,k+1));

        % concatenate HRIRs at different distances and diretions 
        HRIR_full_vec(512*(360*(i-1)+k)+1:512*(360*(i-1)+k)+512,1) = HRIR_L_interp(:,i,k+1);
        HRIR_full_vec(512*(360*(i-1)+k)+1:512*(360*(i-1)+k)+512,2) = HRIR_R_interp(:,i,k+1);
    end
    i
end
disp('Interpolation completed.');

% normalize
MaxL = max(max(max(abs(minLNew))));
MaxR = max(max(max(abs(minRNew))));
Max = max(MaxL,MaxR);
minLNew = minLNew/Max;
minRNew = minRNew/Max;
HRIR_full_vec = HRIR_full_vec/Max;

% calculate ITD in us
ITD_interpolated = squeeze((tauLNew-tauRNew)/fs*10^6);

%% save results
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs'
if SaveAsWav
    HRIR_full_vec = HRIR_full_vec/max(max(abs(HRIR_full_vec)));
    audiowrite([filename,'_1deg_L.wav'],HRIR_full_vec(:,1),fs);
    audiowrite([filename,'_1deg_R.wav'],HRIR_full_vec(:,2),fs);
end

if SaveAsSOFA
    Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz
    % Define positions -  we use the standard CIPIC positions here
    lat1= 0:359;    % lateral angles (azimuth)
    pol1= 0;                % polar angles (elevation)
    pol=repmat(pol1',length(lat1)*Nds,1);
    lat=repmat(lat1',length(pol1)*Nds,1);
    % Create the HRIR matrix
    M = length(lat1)*length(pol1)*Nds;
    Obj.Data.IR = zeros(M,2,512); % data.IR must be [M R N]
    % Fill with data
    for i = 1:Nds
        Obj.Data.IR(360*(i-1)+1,1,:) = HRIR_interp(:,1,i,1);   % left
        Obj.Data.IR(360*(i-1)+1,2,:) = HRIR_interp(:,2,i,1);   % right
        Obj.SourcePosition(360*(i-1)+1,:,:)=[0 pol1 (i+18)/100];
        for j = 2:360
            Obj.Data.IR(360*(i-1)+j,1,:) = HRIR_interp(:,1,i,362-j);  % note that the coordinate in SOFA convention is opposite that of the original data, therefore azimuth
                                                             % of the SOFA HRIRs must be reversed.
                                                             % e.g. the 2nd HRIR (5 degree) is interchanged with the 72nd HRIR (355 degree).                                                 
            Obj.Data.IR(360*(i-1)+j,2,:) = HRIR_interp(:,2,i,362-j);
            Obj.SourcePosition(360*(i-1)+j,:,:)=[j-1 pol1 (i+18)/100];
        end
    end
    % Update dimensions
    Obj=SOFAupdateDimensions(Obj);
    Obj.GLOBAL_DatabaseName = 'hrir_ku1_las_near_circ_1degree';
    Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
    % save the SOFA file
    SOFAfn=[filename,'_1deg.sofa'];
    disp(['Saving:  ' SOFAfn]);
    Obj=SOFAsave(SOFAfn, Obj);
end

if SaveAsTXT
    Re_minL=zeros(N,Nds,360); Re_minR=zeros(N,Nds,360);
    Im_minL=zeros(N,Nds,360); Im_minR=zeros(N,Nds,360);
    matrixL=zeros(N+1,Nds,360);
    matrixR=zeros(N+1,Nds,360);           % the first element stores tau
    for i = 1:Nds
        for j = 1:360
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

             dlmwrite([filename,'_1deg_L.txt'],squeeze(matrixL(:,i,j))','-append'); % Write matrix to ASCII-delimited file (not recommended by matlab)
             dlmwrite([filename,'_1deg_R.txt'],squeeze(matrixR(:,i,j))','-append');
        end
        i
    end
end

if SaveAsMat
    save([filename,'_1deg.mat'],'fs','HRIR_interp','HRTF_interp','HRIR_full_vec','lp_HRIR_mat','ITD');
end
%%% END from Song hrtf2msp
toc