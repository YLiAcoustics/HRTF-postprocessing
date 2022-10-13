%%%% This MATLAB script performs full post-processing on measured
%%%% HRTF/HRIRs:
%%%% 1. Time windowing
%%%% 2. Free-field equalization
%%%% 3. Low-frequency extention
%%%% 4. Save as MATLAB data / .sofa files.
%%%% Author: Yuqing Li
%%%% Last edited: 26/08/2021
clear;close all

%% Options
plot_BTF = 0;
plot_RTF = 0;
plot_HRTF = 1;
plot_HRIR = 0;

%% 0. Specify parameters and import data
fs = 48000;               % sampling rate
dis = 100;                 % source distance: select among {25, 40, 50, 60, 75 ,100}; unit: cm

N=512;
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\measurementdata'
% reference response
rir_data=importdata(['static_40cm_ref.mat']);
rir=rir_data.ImpulseResponse{4,2};
rirnew=resample(rir,fs,192000);
[I,rirNew]=windowing(rirnew,N,40,N-50);
RTF=fft(rirNew);

bir_data=importdata(['static_40cm_0.mat']);
bir(:,1)=bir_data.ImpulseResponse{4,2};
bir(:,2)=bir_data.ImpulseResponse{4,4};
birnew(:,1)=resample(bir(:,1),fs,192000);
birnew(:,2)=resample(bir(:,2),fs,192000);
[I(1),birNew(:,1)]=windowing(birnew(:,1),N,40,N-50);
[I(2),birNew(:,2)]=windowing(birnew(:,2),N,40,N-50);
ITD=I(1)-I(2);

hrir=calculateHRIR(rirNew,birNew(:,1),birNew(:,2),fs,20000);
if ITD>0   % right ear later, move left ear forward
    hrir(:,1)=[hrir(length(hrir)-ITD+1:length(hrir),1);hrir(1:length(hrir)-ITD,1)];
elseif ITD<0
    hrir(:,2)=[hrir(length(hrir)+ITD+1:length(hrir),2);hrir(1:length(hrir)+ITD,2)];
end

HRTF(:,1)=fft(hrir(:,1),N);
HRTF(:,2)=fft(hrir(:,2),N);

% HRIRmat=NaN(256,2,19,3);
% HRTFmat=NaN(256,2,19,3);
% for i=1:3      
%     ele=40*(i-2);          % elevation (in degrees)
%     for j = 1:19
%         azi = 10*(j-1);        % azimuth (in degrees)
%         % binaural responses
%         if ele == -40
%             filenameL=['ir_' num2str(dis) 'cm__40_' num2str(azi) '_L.wav'];
%             filenameR=['ir_' num2str(dis) 'cm__40_' num2str(azi) '_R.wav'];
%         else
%             filenameL = ['ir_' num2str(dis) 'cm_' num2str(ele) '_' num2str(azi) '_L.wav' ];
%             filenameR = ['ir_' num2str(dis) 'cm_' num2str(ele) '_' num2str(azi) '_R.wav' ];
%         end
%         if isfile(filenameL)&&isfile(filenameR)
%             birL=audioread(filenameL);
%             birR=audioread(filenameR);
%             % perform windowing
%             [IL,birLNew]=windowing(birL,256,40,200);
%             [IR,birRNew]=windowing(birR,256,40,200);
%             % ITD in samples
%             ITD=IL-IR;
%             % compute HRIRs
%             hrir=calculateHRIR(rirNew,birLNew,birRNew,fs,20000);
%          
%             % Reinstate the removed ITD
%             if ITD>0   % right ear later, move left ear forward
%                 hrir(:,1)=[hrir(length(hrir)-ITD+1:length(hrir),1);hrir(1:length(hrir)-ITD,1)];
%             else
%                 hrir(:,2)=[hrir(length(hrir)+ITD+1:length(hrir),2);hrir(1:length(hrir)+ITD,2)];
%             end
%             HRTF(:,1)=fft(hrir(:,1),256);
%             HRTF(:,2)=fft(hrir(:,2),256);
%    
%             HRIRmat(:,1,j,i)=hrir(:,1);
%             HRIRmat(:,2,j,i)=hrir(:,2);
%             HRTFmat(:,1,j,i)=HRTF(:,1);
%             HRTFmat(:,2,j,i)=HRTF(:,2);
%         end
%     end
% end
% 
% cd 'C:\Users\root\Documents\00 phd\measurement\near-field HATO\measurement\Results'
% save(['HRTF_' num2str(dis)],'HRTFmat');
% save(['HRIR_' num2str(dis)],'HRIRmat');

%% plotting
plotele=0;
plotazi=90;
faxis = (0:floor(N/2))/N*fs;

% plot RTF
if plot_RTF
    figure('Name',['RTF magnitude, dis=' num2str(dis) ' cm']);
    set(gcf, 'units', 'normalized');
    set(gcf, 'Position', [0.1, 0.1, 0.7, 0.8]);
    RTF_spec = 2*RTF(1:floor(N/2)+1);   % double the DFT magnitude for 1-sided spectrum
    RTF_spec(1) = RTF_spec(1)/2;            % DC magnitude remains the same
    plot((0:floor(N/2))/256*fs,20*log10(abs(RTF_spec)),'r','linewidth',1);
    grid on;
    ax = gca;
    set(ax,'xscale','log');
    ax.XTick = [100 1000 10000];
    ax.XLim = [200,20000];
    ax.YLim = [-30,30];
    ax.XLabel.String = 'frequency(Hz)';
    ax.YLabel.String = 'dB';
    ax.FontSize = 12;
    ax.LineWidth = 1;
end

%% plot HRTFs
if plot_HRTF 
    figure('Name',['HRTF magnitude, dis=20 cm, azi=0' char(176)]);
%     subplot(2,1,1)
    set(gcf, 'units', 'normalized');
    set(gcf, 'Position', [0.1, 0.1, 0.5, 0.5]);
    HRTF_spec = squeeze(2*HRTF(1:floor(N/2)+1,:));   
    HRTF_spec(1,:) = HRTF_spec(1,:)/2;            % DC magnitude remains the same
%     for i = 1:3
        plot(faxis,20*log10(abs(HRTF_spec(:,1))),'linewidth',1.2);
        hold on;
        plot(faxis,20*log10(abs(HRTF_spec(:,2))),'b','linewidth',1);
%     end
%     legend ({'left','right'});
%     lgd=legend({['-40' char(176)],['0' char(176)],['40' char(176)]});
%     title(lgd,'elevation');
    grid on;
    ax = gca;
    ax.ColorOrder = [1 0 0; 0 0 1;0.1 0.1 0.1];
    ax.LineStyleOrder = {'-','--'};
    ax.XScale='log';
    ax.XTick = [100 1000 10000];
    ax.XLim = [200,20000];
    ax.YLim = [-30,30];
    ax.XLabel.String = 'frequency (Hz)';
    ax.YLabel.String = 'magnitude (dB)';
    ax.FontSize = 12;
%     ax.Legend.FontSize = 10;
%     ax.Legend.Location = 'northwest';
    ax.LineWidth = 1;
%     subplot(2,1,2)
%     for i = 1:3
%         plot(faxis,angle(HRTF_spec(:,2,i)),'linewidth',1.2);
%         hold on;
% %         plot(faxis,smooth(20*log10(abs(HRTF_spec(:,2)))),'b','linewidth',1);
%     end
% %     legend ({'left','right'});
%     lgd=legend({['-40' char(176)],['0' char(176)],['40' char(176)]});
%     title(lgd,'elevation');
%     grid on;
%     ax = gca;
%     ax.ColorOrder = [1 0 0; 0 0 1;0.1 0.1 0.1];
%     ax.LineStyleOrder = {'-','--'};
%     ax.XScale='log';
%     ax.XTick = [100 1000 10000];
%     ax.XLim = [200,20000];
%     ax.XLabel.String = 'frequency (Hz)';
%     ax.YLabel.String = 'magnitude (dB)';
%     ax.FontSize = 12;
%     ax.Legend.FontSize = 10;
%     ax.Legend.Location = 'northwest';
%     ax.LineWidth = 1;
end

%%
if plot_HRIR
figure(2)
taxis = 1000*(0:256-1)/fs;
% HRIR_index = plotdir/5+1;
plot(taxis,HRIRmat(:,1,1,1),'r','linewidth',1);
hold on;
plot(taxis,HRIRmat(:,2,1,1),'b','linewidth',1);
grid on;
legend ({'left','right'});

set(gcf, 'units', 'normalized');
set(gcf, 'Position', [0.1, 0.1, 0.7, 0.8]);

axHRIR = gca;
axHRIR.XLim = 1000*[0,(N-1)/fs];
% axHRIR.YLim = [-40,20];
axHRIR.XLabel.String = 'time (ms)';
axHRIR.YLabel.String = 'magnitude';
axHRIR.Title.String = ['HRIRs at ' num2str(dis) 'cm - ' num2str(plotdir) char(176)];
axHRIR.FontName = 'Times New Roman';
axHRIR.FontSize = 14;
axHRIR.Legend.FontSize = 14;
axHRIR.Legend.Location = 'northeast';
axHRIR.LineWidth = 1;
end

%% 5. Save as MATLAB data / wav files
% % save HRIRs
% save_path_HRIR = 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRIR';
% cd(save_path_HRIR)
% save_name_HRIR = strcat('HRIR_original_',num2str(dis),'cm.mat');
% save(save_name_HRIR,'HRIR');
% % save HRTFs
% save_path_HRTF = 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\saved data\0111\HRTF';
% cd(save_path_HRTF)
% save_name_HRTF = strcat('HRTF_original_',num2str(dis),'cm.mat');
% save(save_name_HRTF,'HRTF');

%% 6. Save as SOFA files
%%%%%% The following section of code is taken from demo_SOFAsave.m
% Get an empy conventions structure
Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz

% Define positions -  we use the standard CIPIC positions here
lat1= 5*(0:71);    % lateral angles (azimuth)
pol1= 0;                % polar angles (elevation)
pol=repmat(pol1',length(lat1),1);
lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));

% Create the HRIR matrix
M = length(lat1)*length(pol1);
Obj.Data.IR = NaN(M,2,N); % data.IR must be [M R N]

HRIR_forsofa = permute(HRIR, [3 2 1]);
% Fill data with data
ii=1;       % IR number (including elevation and azimuth)
for aa=1:length(lat1)
	for ee=1:length(pol1)
%         HRIR_name_l = strcat(['HRIR_' num2str(dis) num2str(5*(ee-1)) '_l.wav']);
%         HRIR_name_r = strcat(['HRIR_' num2str(dis) num2str(5*(ee-1)) '_r.wav']);
		Obj.Data.IR(ii,1,:) = HRIR_forsofa(ii,1,:);
		Obj.Data.IR(ii,2,:) = HRIR_forsofa(ii,2,:);
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
Obj.GLOBAL_History = 'created with a script';
Obj.GLOBAL_DatabaseName = 'near-field';
% Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik, Leibniz Universität Hannover';
Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.de';

% save the SOFA file
SOFAfn=fullfile('C:\Users\root\Documents\00 phd\measurement\201020KEMAR HRTF AP\100cm','HRIR100cm.sofa');
disp(['Saving:  ' SOFAfn]);
Obj=SOFAsave(SOFAfn, Obj);

function [I,irNew]=windowing(ir,N,Lwin,NumaftP)       % input arguments: original IR, desired length after windowing, 
                                                      % length of hann window (both-sided), number of samples after peak
                                                      % output arguments: original peak index, windowed ir
% define hann window
hwin=hann(Lwin);
% find peak
[~,I]=max(abs(ir));      
irNew=ir(I-(N-NumaftP-1):I+NumaftP).*[hwin(1:Lwin/2);ones(N-Lwin,1);hwin(Lwin/2+1:Lwin)];   % apply window
end

function hrir=calculateHRIR(RIR,BIRL,BIRR,fs,fhigh)   % fhigh: cut-off frequency for low-pass filtering the hrirs
% minimum-phase reconstruction of binaural irs
[~,RIRm]=rceps(RIR);

BTFL=fft(BIRL);
BTFR=fft(BIRR);

RTF=fft(RIRm);

HRTFL = BTFL./RTF;
HRTFR = BTFR./RTF;


hrir(:,1)=ifft(HRTFL,length(RIR),'symmetric');
hrir(:,2)=ifft(HRTFR,length(RIR),'symmetric');
hrir(:,1)=lowpass(hrir(:,1),fhigh,fs);
hrir(:,2)=lowpass(hrir(:,2),fhigh,fs);
end