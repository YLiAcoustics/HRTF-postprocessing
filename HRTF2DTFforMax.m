%% Convert HRTF (HRIR from sofa) into DTF (time domain), store the results for auralization (Max/MSP binaural renderer).
%% Yuqing Li
%% 29/07/2022

clear; close all;

SaveAsSOFA = 1;
SaveAsWav = 1;
SaveAsMat = 1;

fs = 48000;
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs'
%% importdata
filename = 'hrir_ku1_las_near_circ_1deg_dtf';
Obj = SOFAload([filename '.sofa']);
HRIR = Obj.Data.IR;
Nds = 101;        % number of distances
Nel = 1;          % number of elevation
Naz = size(Obj.Data.IR,1)/Nds/Nel;   % number of azimuth

tic
[dtf,ctf]=hrtf2dtfFG(HRIR,fs);
toc

%% concatenate all DIR
DIR_L = squeeze(dtf(:,1,:))';
DIR_R = squeeze(dtf(:,2,:))';

for i = 1:Nds
    DIR_L_new(:,360*(i-1)+1) = DIR_L(:,360*(i-1)+1);
    DIR_R_new(:,360*(i-1)+1) = DIR_R(:,360*(i-1)+1);
    for j = 2:360
        DIR_L_new(:,360*(i-1)+j) = DIR_L(:,360*(i-1)+362-j);
        DIR_R_new(:,360*(i-1)+j) = DIR_R(:,360*(i-1)+362-j);
    end
end

DIR_full_vec(:,1) = DIR_L_new(:);
DIR_full_vec(:,2) = DIR_R_new(:);

DIR_full_vec = DIR_full_vec/max(max(abs(DIR_full_vec)));

if SaveAsWav
    audiowrite([filename,'_dtf_L.wav'],DIR_full_vec(:,1),fs);
    audiowrite([filename,'_dtf_R.wav'],DIR_full_vec(:,2),fs);
end

if SaveAsSOFA
    Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz
    % Define positions -  we use the standard CIPIC positions here
    lat1= 0:359;    % lateral angles (azimuth)
    pol1= 0;                % polar angles (elevation)
    pol=repmat(pol1',length(lat1)*Nds,1);
    lat=repmat(lat1',length(pol1)*Nds,1);

    Obj.Data.IR = dtf; % data.IR must be [M R N]
    % Update dimensions
    Obj=SOFAupdateDimensions(Obj);
    Obj.GLOBAL_DatabaseName = [filename '_dtf'];
    Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
    % save the SOFA file
    SOFAfn=[filename,'_dtf.sofa'];
    disp(['Saving:  ' SOFAfn]);
    Obj=SOFAsave(SOFAfn, Obj);
end

if SaveAsMat
    save([filename,'_dtf.mat'],'fs','dtf');
end