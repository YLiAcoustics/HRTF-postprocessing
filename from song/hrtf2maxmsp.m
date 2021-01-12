
% Load HRTF database from TH Köln "HRIR_FULL2DEG.mat"
load('E:\Matlab Dokumente\HRTF Database\TH-Köln\HRIR_FULL2DEG.mat');

% Convert the azimuth and elevation angles from rad to degree 
Azimuth_old=HRIR_FULL2DEG.azimuth/pi*180;
Elevation_old=round(90-HRIR_FULL2DEG.elevation/pi*180);

% reserve memeory for HRIR, magnitude, phase and ITDs
HRTF_L=zeros(181,89,128); % HRIR for left ear (azimuth, elevation, hrir taps)
HRTF_R=zeros(181,89,128); % HRIR for right ear

Magnitude_L=zeros(181,89,1024); % Magnitude for left ear 
Magnitude_R=zeros(181,89,1024); % Magnitude for right ear

Phase_L=zeros(181,89,1024); % Phase for left ear 
Phase_R=zeros(181,89,1024); % Phase for right ear
         
tauL=zeros(181,89); % Onset delay for left ear (azimuth, elevation)
tauR=zeros(181,89); % Onset delay for right ear 


for i=1:length(HRIR_FULL2DEG.azimuth)

    azi=round(HRIR_FULL2DEG.azimuth(i)/pi*180)/2+1; % get the azimuth angle in integer
    ele=round(HRIR_FULL2DEG.elevation(i)/pi*180)/2; % get the elevation angle in integer
    hrtf_L = HRIR_FULL2DEG.irChOne(:,i); % get the HRIR for left ear
    hrtf_R = HRIR_FULL2DEG.irChTwo(:,i); % get the HRIR for right ear
    
    HRTF_L(azi,ele,:)=hrtf_L; % store the HRIRs in matrix (azimuth, elevation, hrir taps)
    HRTF_R(azi,ele,:)=hrtf_R; 
    
    Magnitude_L(azi,ele,:)=abs(fft(hrtf_L,1024)); % store the magnitude of HRTFs in matrix 
    Magnitude_R(azi,ele,:)=abs(fft(hrtf_R,1024)); 
    
    Phase_L(azi,ele,:)=angle(fft(hrtf_L,1024)); % store the phase of HRTFs in matrix 
    Phase_R(azi,ele,:)=angle(fft(hrtf_R,1024));

end

 for j=1:89 % hrirs, magnitude and phase for 360° is equal to 0°
    HRTF_L(181,j,:)=HRTF_L(1,j,:);
    HRTF_R(181,j,:)=HRTF_R(1,j,:);
    
    Magnitude_L(181,j,:)=Magnitude_L(1,j,:);
    Magnitude_R(181,j,:)=Magnitude_R(1,j,:);
    
    Phase_L(181,j,:)=Phase_L(1,j,:);
    Phase_R(181,j,:)=Phase_R(1,j,:);
 end
 
 
fs=48000;
     
for i=1:181 % get the onset delay
    for j=1:89
    % 10 fach Upsampling!!!
    H_Matrix_L_Up=resample(squeeze(HRTF_L(i,j,:)),fs*10,fs);
    H_Matrix_R_Up=resample(squeeze(HRTF_R(i,j,:)),fs*10,fs);
    
    % find the maximal value !!!
    H_Matrix_L_Up_Max= find(abs(H_Matrix_L_Up)==max(abs(H_Matrix_L_Up)));
    H_Matrix_R_Up_Max= find(abs(H_Matrix_R_Up)==max(abs(H_Matrix_R_Up)));

        for q=1:H_Matrix_L_Up_Max
            if(abs(H_Matrix_L_Up(q))>=0.10*max(abs(H_Matrix_L_Up))) % set threshold: 10% of the maximal value
                tau=q-1;
                break;
            end
        end

        tauL(i,j)=tau/10/fs; % downsampling

        for q=1:H_Matrix_R_Up_Max
            if(abs(H_Matrix_R_Up(q))>=0.10*max(abs(H_Matrix_R_Up))) % set threshold: 10% of the maximal value
                tau=q-1;
                break;
            end
        end

       tauR(i,j)=tau/10/fs; % downsampling

    end
end
        
        

    minL=zeros(size(Magnitude_L)); % Minimal phase system
    minR=zeros(size(Magnitude_R)); % Minimal phase system
        
       for i=1:181
           for j=1:89
               % smooth the HRTF with simple auditory filter ot overcome the clicks caused by switch HRTFs in bianural rendering
               % this function "hssmooth" is provided by CIPIC 
                dB_L = hsmooth(squeeze(Magnitude_L(i,j,:)),30); 
                dB_R = hsmooth(squeeze(Magnitude_R(i,j,:)),30);
                
                % mirror the half spectrum
                H_L=[dB_L;flip(dB_L(2:end-1))]; 
                H_R=[dB_R;flip(dB_R(2:end-1))]; 

                % convert db to amplitude
                H_L=10.^(H_L./20);
                H_R=10.^(H_R./20);
            
                % unwrap the phase
                Phase_L_unwrap = unwrap(squeeze(Phase_L(i,j,:)));
                Phase_R_unwrap = unwrap(squeeze(Phase_R(i,j,:)));

                % minimumphase system
                [yL,yLm]= rceps(ifft(H_L.*exp(1j*Phase_L_unwrap),'symmetric'));
                [yR,yRm]= rceps(ifft(H_R.*exp(1j*Phase_R_unwrap),'symmetric'));

                minL(i,j,:)=yLm; % store the minimumphase system
                minR(i,j,:)=yRm;

            end

       end
   
       
       
       
       
       
   % store as .txt


        Re_minL=zeros(181,89,512); Re_minR=zeros(181,89,512);
        Im_minL=zeros(181,89,512); Im_minR=zeros(181,89,512);
        matrixL=zeros(181,89,1025);
        matrixR=zeros(181,89,1025);


        for i=1:181
        for j=1:89
            ReL=real(fft(squeeze(minL(i,j,:))));
            ReR=real(fft(squeeze(minR(i,j,:))));
            ImL=imag(fft(squeeze(minL(i,j,:))));
            ImR=imag(fft(squeeze(minR(i,j,:))));

            % because of the symmetric, only half size of the real and imaginary part are stored
            % especially for max/msp object "pfft~"
            rowL=[tauL(i,j)*fs,ReL(1:512)',ImL(1:512)']; 
            rowR=[tauR(i,j)*fs,ReR(1:512)',ImR(1:512)'];

            matrixL(i,j,:)=rowL;
            matrixR(i,j,:)=rowR;
        end

        end
       
   save('3dmatrix_THKOELN_L.mat','matrixL');
   save('3dmatrix_THKOELN_R.mat','matrixR');
       
       for i=1:181
           for j=5:80   %80  ->   -70  
                dlmwrite('3dmatrix_THKOELN_L.txt',squeeze(matrixL(182-i,j,:))','-append');
                dlmwrite('3dmatrix_THKOELN_R.txt',squeeze(matrixR(182-i,j,:))','-append');
           end 
           i
       end
 
       
       
       
       
       
       
       
       
       
       
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
       
       
% Load HRTF database from TH Köln "HRIR_FULL2DEG.mat"
load('C:\Users\Song Li\Documents\MATLAB\HRTF Database\TH-Köln\HRIR_FULL2DEG.mat');

% Convert the azimuth and elevation angles from rad to degree 
Azimuth_old=HRIR_FULL2DEG.azimuth/pi*180;
Elevation_old=round(90-HRIR_FULL2DEG.elevation/pi*180);

% reserve memeory for HRIR, magnitude, phase and ITDs
HRTF_L=zeros(181,89,128); % HRIR for left ear (azimuth, elevation, hrir taps)
HRTF_R=zeros(181,89,128); % HRIR for right ear

Magnitude_L=zeros(181,89,512); % Magnitude for left ear 
Magnitude_R=zeros(181,89,512); % Magnitude for right ear

Phase_L=zeros(181,89,512); % Phase for left ear 
Phase_R=zeros(181,89,512); % Phase for right ear
         
tauL=zeros(181,89); % Onset delay for left ear (azimuth, elevation)
tauR=zeros(181,89); % Onset delay for right ear 


for i=1:length(HRIR_FULL2DEG.azimuth)

    azi=round(HRIR_FULL2DEG.azimuth(i)/pi*180)/2+1; % get the azimuth angle in integer
    ele=round(HRIR_FULL2DEG.elevation(i)/pi*180)/2; % get the elevation angle in integer
    hrtf_L = HRIR_FULL2DEG.irChOne(:,i); % get the HRIR for left ear
    hrtf_R = HRIR_FULL2DEG.irChTwo(:,i); % get the HRIR for right ear
    
    HRTF_L(azi,ele,:)=hrtf_L; % store the HRIRs in matrix (azimuth, elevation, hrir taps)
    HRTF_R(azi,ele,:)=hrtf_R; 
    
    Magnitude_L(azi,ele,:)=abs(fft(hrtf_L,512)); % store the magnitude in matrix 
    Magnitude_R(azi,ele,:)=abs(fft(hrtf_R,512)); 
    
    Phase_L(azi,ele,:)=angle(fft(hrtf_L,512)); % store the phase in matrix 
    Phase_R(azi,ele,:)=angle(fft(hrtf_R,512));

end

 for j=1:89 % hrirs, magnitude and phase for 360° is equal to 0°
    HRTF_L(181,j,:)=HRTF_L(1,j,:);
    HRTF_R(181,j,:)=HRTF_R(1,j,:);
    
    Magnitude_L(181,j,:)=Magnitude_L(1,j,:);
    Magnitude_R(181,j,:)=Magnitude_R(1,j,:);
    
    Phase_L(181,j,:)=Phase_L(1,j,:);
    Phase_R(181,j,:)=Phase_R(1,j,:);
 end
 
 
fs=48000;

% get the onset delay
for i=1:181
    for j=1:89
    % 10 fach Upsampling!!!  % reason:
    H_Matrix_L_Up=resample(squeeze(HRTF_L(i,j,:)),fs*10,fs);
    H_Matrix_R_Up=resample(squeeze(HRTF_R(i,j,:)),fs*10,fs);
    
    % find the maximal value !!!
    H_Matrix_L_Up_Max= find(abs(H_Matrix_L_Up)==max(abs(H_Matrix_L_Up)));
    H_Matrix_R_Up_Max= find(abs(H_Matrix_R_Up)==max(abs(H_Matrix_R_Up)));

        for q=1:H_Matrix_L_Up_Max    % before the peak
            if(abs(H_Matrix_L_Up(q))>=0.10*max(abs(H_Matrix_L_Up))) % set threshold: 10% of the maximal value
                tau=q-1;
                break;
            end
        end

        tauL(i,j)=tau/10/fs; % downsampling

        for q=1:H_Matrix_R_Up_Max
            if(abs(H_Matrix_R_Up(q))>=0.10*max(abs(H_Matrix_R_Up))) % set threshold: 10% of the maximal value
                tau=q-1;
                break;
            end
        end

       tauR(i,j)=tau/10/fs; % downsampling

    end
end
        
        

    minL=zeros(size(Magnitude_L)); % Minimal phase system
    minR=zeros(size(Magnitude_R)); % Minimal phase system
        
       for i=1:181
           for j=1:89
               % smooth the HRTF with simple auditory filter to overcome the clicks caused by switch HRTFs in bianural rendering
               % this function "hsmooth" is provided by CIPIC 
               % avoid peaks in interpolation
                dB_L = hsmooth(squeeze(Magnitude_L(i,j,:)),30);               % hsmooth results in dB
                dB_R = hsmooth(squeeze(Magnitude_R(i,j,:)),30);
                
                % mirror the half spectrum
                H_L=[dB_L;flip(dB_L(2:end-1))]; 
                H_R=[dB_R;flip(dB_R(2:end-1))]; 

                % convert db to amplitude
                H_L=10.^(H_L./20);
                H_R=10.^(H_R./20);
            
                % unwrap the phase      % linear phase?
                Phase_L_unwrap = unwrap(squeeze(Phase_L(i,j,:)));
                Phase_R_unwrap = unwrap(squeeze(Phase_R(i,j,:)));

                % minimumphase system
                [yL,yLm]= rceps(ifft(H_L.*exp(1j*Phase_L_unwrap),'symmetric'));       % H_L is the magnitude
                [yR,yRm]= rceps(ifft(H_R.*exp(1j*Phase_R_unwrap),'symmetric'));

                minL(i,j,:)=yLm; % store the minimumphase system (time domain)
                minR(i,j,:)=yRm;

            end

       end
   
       
       
       
    %%%%%%%%%%%%%%%%%%%%% Interpolation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % reserve the memeory for HRIR, magnitude, phase and ITDs after
       % interpolation for azimuth (time domain)
       Azimuth=0:2:360;
       minLNew=zeros(361,89,512); minRNew=zeros(361,89,512);
       tauLNew=zeros(361,89); tauRNew=zeros(361,89);
       
       for j=1:89
           minLMatrix=squeeze(minL(:,j,:))';
           minRMatrix=squeeze(minR(:,j,:))';
           
           % cubic line interpolation for each elevation
           for k=0:360
            minLNew(k+1,j,:)=spline(Azimuth,minLMatrix,k); 
            minRNew(k+1,j,:)=spline(Azimuth,minRMatrix,k); 
            tauLNew(k+1,j)= spline(Azimuth,tauL(:,j),k); 
            tauRNew(k+1,j)= spline(Azimuth,tauR(:,j),k); 
           end
           j
       end
       
       % reserve the memeory for HRIR, magnitude, phase and ITDs after
       % interpolation for elevation
       minLVoll=zeros(361,177,512);  minRVoll=zeros(361,177,512);
       tauLVoll=zeros(361,177,512); tauRVoll=zeros(361,177,512);
       Elevation=88:-2:-88;
       
      % cubic line interpolation for each azimuth
      for i=1:361
           minLMatrix=squeeze(minLNew(i,:,:))';
           minRMatrix=squeeze(minRNew(i,:,:))';
           
           for k=88:-1:-88
            minLVoll(i,89-k,:)=spline(Elevation,minLMatrix,k);  
            minRVoll(i,89-k,:)=spline(Elevation,minRMatrix,k); 
            tauLVoll(i,89-k)= spline(Elevation,tauLNew(i,:),k); 
            tauRVoll(i,89-k)= spline(Elevation,tauRNew(i,:),k); 
           end
         
       end    
       
   
       
   % store as .txt


        Re_minL=zeros(361,177,512); Re_minR=zeros(361,177,512);
        Im_minL=zeros(361,177,512); Im_minR=zeros(361,177,512);
        matrixL=zeros(361,177,513);
        matrixR=zeros(361,177,513);


        for i=1:361
        for j=1:177
            ReL=real(fft(squeeze(minLVoll(i,j,:))));
            ReR=real(fft(squeeze(minRVoll(i,j,:))));
            ImL=imag(fft(squeeze(minLVoll(i,j,:))));
            ImR=imag(fft(squeeze(minRVoll(i,j,:))));

            % because of the symmetric, only half size of the real and imaginary part are stored
            % especially for max/msp object "pfft~"
            rowL=[tauLVoll(i,j)*fs,ReL(1:256)',ImL(1:256)']; 
            rowR=[tauRVoll(i,j)*fs,ReR(1:256)',ImR(1:256)'];

            matrixL(i,j,:)=rowL;
            matrixR(i,j,:)=rowR;
        end
i
        end
       
   save('3dmatrix_THKOELN_L.mat','matrixL');
   save('3dmatrix_THKOELN_R.mat','matrixR');
       
       for i=1:361
           for j=9:159   %80  ->   -70  
                dlmwrite('3dmatrix_THKOELN_1_degree_L.txt',squeeze(matrixL(362-i,j,:))','-append');
                dlmwrite('3dmatrix_THKOELN_1_degree_R.txt',squeeze(matrixR(362-i,j,:))','-append');
           end 
           i
       end
 