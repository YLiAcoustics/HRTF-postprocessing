%%%% This MATLAB script performs full post-processing on measured
%%%% HRTF/HRIRs:
%%%% 1. Time windowing
%%%% 2. Free-field equalization
%%%% 3. Low-frequency extention
%%%% 4. Save as MATLAB data / .sofa files.
%%%% Author: Yuqing Li
%%%% Last edited: 03/2023
clear;close all

%% Options
plot_BTF = 0;     % binaural transfer function (unequalized)
plot_RTF = 0;     % reference transfer function
plot_HRTF = 1;
plot_HRIR = 1;

%% 0. Specify parameters and import data
fs=48000;               % sampling rate
N=256;                   % desired HRIR length

% cd ''
% import reference response
rir=audioread('ir_100cm_ref.wav');
bir(:,1)=audioread('ir_100cm_0_90_L.wav');
bir(:,2)=audioread('ir_100cm_0_90_R.wav');

%% 1. Windowing
[Iref,rirNew]=windowing(rir,N,40,10);
RTF=fft(rirNew);
[Ibin(1),birNew(:,1)]=windowing(bir(:,1),N,40,10);
[Ibin(2),birNew(:,2)]=windowing(bir(:,2),N,40,10);
ITD=Ibin(1)-Ibin(2);

%% 2. Free-field equalization
hrir=calculateHRIR(rirNew,birNew(:,1),birNew(:,2),fs,20000);
% reinstate difference in arrival time
if ITD>0   % right ear later, move left ear forward
    hrir(:,1)=[hrir(length(hrir)-ITD+1:length(hrir),1);hrir(1:length(hrir)-ITD,1)];
elseif ITD<0
    hrir(:,2)=[hrir(length(hrir)+ITD+1:length(hrir),2);hrir(1:length(hrir)+ITD,2)];
end

HRTF(:,1)=fft(hrir(:,1),N);
HRTF(:,2)=fft(hrir(:,2),N);

%% 3. Low-frequency compensation
LowF=300;
HighF=600;
[LfcorrHRIR(:,1),LfcorrHRTF(:,1),gd(:,1),Lfcorrgd(:,1)] = lowFComp(hrir(:,1),fs,LowF,HighF);
[LfcorrHRIR(:,2),LfcorrHRTF(:,2),gd(:,2),Lfcorrgd(:,2)] = lowFComp(hrir(:,2),fs,LowF,HighF);

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
    figure('Name','HRTF spectra');
    set(gcf, 'units', 'normalized');
    set(gcf, 'Position', [0.1, 0.1, 0.5, 0.8]);
    HRTF_spec = squeeze(2*HRTF(1:floor(N/2)+1,:));
    HRTF_spec(1,:) = HRTF_spec(1,:)/2;            % DC magnitude remains the same

    subplot(2,1,1)
    plot(faxis,20*log10(abs(HRTF_spec(:,1))),'linewidth',1.2);
    hold on;
    plot(faxis,20*log10(abs(HRTF_spec(:,2))),'b','linewidth',1);
    legend ({'left','right'});
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

    subplot(2,1,2)
    plot(faxis,angle(HRTF_spec(:,1)),'linewidth',1.2);
    hold on;
    plot(faxis,angle(HRTF_spec(:,2)),'b','linewidth',1);
    legend ({'left','right'});
    grid on;
    ax = gca;
    ax.ColorOrder = [1 0 0; 0 0 1;0.1 0.1 0.1];
    ax.LineStyleOrder = {'-','--'};
    ax.XScale='log';
    ax.XTick = [100 1000 10000];
    ax.XLim = [200,20000];
    ax.YLim = [-4,4];
    ax.XLabel.String = 'frequency (Hz)';
    ax.YLabel.String = 'phase (rad)';
    ax.FontSize = 12;


    figure('Name','HRTF spectra (low-frequency compensated)');
    set(gcf, 'units', 'normalized');
    set(gcf, 'Position', [0.1, 0.1, 0.5, 0.8]);
    LfcorrHRTF_spec = squeeze(2*LfcorrHRTF(1:floor(N/2)+1,:));
    LfcorrHRTF_spec(1,:) = LfcorrHRTF_spec(1,:)/2;            % DC magnitude remains the same

    subplot(2,1,1)
    plot(faxis,20*log10(abs(LfcorrHRTF_spec(:,1))),'linewidth',1.2);
    hold on;
    plot(faxis,20*log10(abs(LfcorrHRTF_spec(:,2))),'b','linewidth',1);
    legend ({'left','right'});
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

    subplot(2,1,2)
    plot(faxis,angle(LfcorrHRTF_spec(:,1)),'linewidth',1.2);
    hold on;
    plot(faxis,angle(LfcorrHRTF_spec(:,2)),'b','linewidth',1);
    legend ({'left','right'});
    grid on;
    ax = gca;
    ax.ColorOrder = [1 0 0; 0 0 1;0.1 0.1 0.1];
    ax.LineStyleOrder = {'-','--'};
    ax.XScale='log';
    ax.XTick = [100 1000 10000];
    ax.XLim = [200,20000];
    ax.YLim = [-4,4];
    ax.XLabel.String = 'frequency (Hz)';
    ax.YLabel.String = 'phase (rad)';
    ax.FontSize = 12;
end

if plot_HRIR
    figure('Name','HRIR')
    plot(hrir(:,1),'r','linewidth',1);
    hold on;
    plot(hrir(:,2),'b','linewidth',1);
    grid on;
    legend ({'left','right'});

    set(gcf, 'units', 'normalized');
    set(gcf, 'Position', [0.1, 0.1, 0.7, 0.8]);
    axHRIR = gca;
    axHRIR.FontSize = 12;
    axHRIR.Legend.FontSize = 12;
    axHRIR.Legend.Location = 'northeast';
    axHRIR.LineWidth = 1;
end


% %% 4. Save as SOFA files
% %%%%%% The following section of code is taken from demo_SOFAsave.m
% % Get an empy conventions structure
% Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz
% 
% % Define positions -  we use the standard CIPIC positions here
% lat1= 5*(0:71);    % lateral angles (azimuth)
% pol1= 0;                % polar angles (elevation)
% pol=repmat(pol1',length(lat1),1);
% lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));
% 
% % Create the HRIR matrix
% M = length(lat1)*length(pol1);
% Obj.Data.IR = NaN(M,2,N); % data.IR must be [M R N]
% 
% HRIR_forsofa = permute(HRIR, [3 2 1]);
% % Fill data with data
% ii=1;       % IR number (including elevation and azimuth)
% for aa=1:length(lat1)
% 	for ee=1:length(pol1)
% 		Obj.Data.IR(ii,1,:) = HRIR_forsofa(ii,1,:);
% 		Obj.Data.IR(ii,2,:) = HRIR_forsofa(ii,2,:);
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
% Obj.GLOBAL_History = 'created with a script';
% Obj.GLOBAL_DatabaseName = 'near-field';
% % Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
% Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
% Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik, Leibniz Universität Hannover';
% Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.de';
% 
% % save the SOFA file
% SOFAfn=fullfile('C:\Users\root\Documents\measurement\201020KEMAR HRTF AP\100cm','HRIR100cm.sofa');
% disp(['Saving:  ' SOFAfn]);
% Obj=SOFAsave(SOFAfn, Obj);



function [I,irNew]=windowing(ir,N,Lwin,Nsam_bfpk)     % input arguments: original IR, desired length after windowing, 
                                                      % size of Hann window (two-sided), number of samples before
                                                      % peak (excluding half-Hann window) 
                                                      % output arguments: original peak index, windowed IR
% define hann window
hwin=hann(Lwin);
% find peak
[~,I]=max(abs(ir)); 
assert(round(Lwin/2)+Nsam_bfpk<I,'Too many samples before peak! Reduce L or Nsam_bfpk.');
irNew=ir(I-round(Lwin/2)-Nsam_bfpk+1:I-round(Lwin/2)-Nsam_bfpk+N).*[hwin(1:round(Lwin/2));ones(N-Lwin,1);hwin(round(Lwin/2)+1:end)];   % apply window
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