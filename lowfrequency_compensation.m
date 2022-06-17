%%%% This MATLAB script performs low frequency compensation using the
%%%% method in:
%%%%  - Xie, B. (2009): On the low frequency characteristics of head-related
%    transfer functions. Chinese J. Acoust. 28(2), pp. 1-13
%%%% the magnitude response of the HRTFs has been set to a constant value and the phase has been extrapolated linearly for low frequencies. 
%%%% Code is provided by http://github.com/spatialaudio/hptf-compensation-filters/blob/master/Correct_low_frequencies_of_HRTFs.m

close all; clear; clc

SOFAstart
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220111ContinuousDistanceHRTF\database'
% frequency range used to correct low frequency data
lowerfrequency = 300;
higherfrequency = 500;
%% Load original data
filename = 'continuous_HRIR_1cm.sofa';
% %download data if necessary
% if ~exist(filename,'file')
%     url = ['https://github.com/sfstoolbox/data/blob/master/HRTFs/', ...
%            'QU_KEMAR_anechoic_3m.sofa?raw=true'];
%     warning('Downloading file %s',url);
%     websave(filename,url);
% end
%load HRTFs
original = SOFAload(filename);

%% Prerequisites
fs = original.Data.SamplingRate; %sampling frequency
N = original.API.N; %original length of HRTFs
f = (0:N-1)/N*fs; %frequency vector
%find indices for frequency range used to correct low frequency data
indl = find(f>=lowerfrequency,1,'first');
indh = find(f<higherfrequency,1,'last');

new_length = 512; %new length of HRTFs

%% Correct and truncate impulse responses
new_irs = zeros(original.API.M,original.API.R,new_length); %preallocation
for n = 1:original.API.M %all azimuths and distances
%     for nn = 1:original.API.R %left and right channel
nn = 1;
        ir = squeeze(original.Data.IR(n,nn,:));
        HRTF = fft(ir);
        
        %correct magnitude
        %calculate mean magnitude from lower frequency bound to higher
        %frequency bound
        mag_mean = mean(abs(HRTF(indl:indh)));
        %replace low frequency magnitude with mean value
        HRTF_mag_corrected = abs(HRTF);
        HRTF_mag_corrected(1:indl-1) = mag_mean;
        
        %correct phase
        HRTF_phase = unwrap(angle(HRTF));
        HRTF_phase_corrected = HRTF_phase;
        %extrapolate phase from data between lower frequency bound and
        %higher frequency bound
        HRTF_phase_corrected(1:indl-1) = interp1(f(indl:indh),...
        HRTF_phase(indl:indh),f(1:indl-1),'linear','extrap');
        
        %compose complex spectrum
        HRTF_corrected = HRTF_mag_corrected.*exp(1i*HRTF_phase_corrected);
        %calculate impulse response
        ir_corrected = ifft(HRTF_corrected,'symmetric');
        
        %truncate corrected impulse response
        ir_corrected_trunc = ir_corrected(1:new_length);
%         %apply window at end of impulse response
%         Nwin = 32; %window length
%         win = blackmanharris(Nwin);
%         win = win(Nwin/2+1:end); %use only second half
%         ir_corrected_trunc(new_length-Nwin/2+1:end) = ...
%             ir_corrected_trunc(new_length-Nwin/2+1:end).*win;
%         %apply window at start of impulse response
%         Nwin = 64; %window length
%         win = blackmanharris(Nwin);
%         win = win(1:Nwin/2); %use only first half
%         ir_corrected_trunc(1:Nwin/2) = ir_corrected_trunc(1:Nwin/2).*win;
% 
        %save new impulse response for SOFA data array
        new_irs(n,nn,:) = ir_corrected_trunc;
        
        %plot HRTFs only for one example azimuth
        azimuth_example = 90; %in degree
        distance_example = 0.2;
        if (original.SourcePosition(n,1) == azimuth_example) && (original.SourcePosition(n,3) == distance_example)
            HRTF_corrected_trunc = fft(ir_corrected_trunc,N);
            gd = grpdelay(ir,1,N,'whole',fs);
            gd_corrected_trunc = grpdelay(ir_corrected_trunc,1,N,'whole',fs);
            if nn == 1
                side = 'left';
            elseif nn == 2
                side = 'right';
            end
%             figure('name',[num2str(original.SourcePosition(n,1)) '° azimuth, '...
%                 side])
%             set(gcf,'Units','Normalized');
%             set(gcf,'Position',[0.1 0.1 0.5 0.5]);
            figure(1)
            set(gcf,'Units','Normalized');
            set(gcf,'Position',[0.1 0.1 0.25 0.3]);
%             subplot(2,2,1)
%                 plot(db(abs(ir)),'LineWidth',0.8,'Color','#B22222'), hold on
%                 plot(db(abs(ir_corrected_trunc)),'LineWidth',0.8,'Color','#008000')
%                 grid
%                 axis([0 N -140 0])
%                 xlabel('time (samples)'),
%                 ylabel('impulse response magnitude (dB)')
% %                 legend('original','corr. + trunc.')
%                 legend('original','corrected')
%                 ax = gca;
%                 ax.LineWidth = 0.8;
%             subplot(2,2,3)
                plot_HRTF = 2*abs(HRTF);
                plot_HRTF(1) = plot_HRTF(1)/2;
                plot_HRTF_corrected_trunc = 2*abs(HRTF_corrected_trunc);
                plot_HRTF_corrected_trunc(1) = plot_HRTF_corrected_trunc(1)/2;
                semilogx(f,db(plot_HRTF),'LineWidth',0.8,'Color','#B22222'), hold on
                semilogx(f,db(plot_HRTF_corrected_trunc),'LineWidth',0.8,'Color','#008000')
                grid
                axis([100 fs/2 -20 20])
                xlabel('frequency (Hz)'), ylabel('magnitude response (dB)')
                ax = gca;
                ax.LineWidth = 0.8;
%             subplot(2,2,2)
                figure(2)
                set(gcf,'Units','Normalized');
                set(gcf,'Position',[0.1 0.1 0.25 0.3]);
                semilogx(f,angle(HRTF),'LineWidth',0.8,'Color','#B22222'), hold on
                semilogx(f,angle(HRTF_corrected_trunc),'LineWidth',0.8,'Color','#008000')
                grid
                axis([80 fs/2 -pi pi])
                xlabel('frequency (Hz)'), ylabel('phase (rad)')
                ax = gca;
                ax.LineWidth = 0.8;
%             subplot(2,2,4)
%                 semilogx(f,gd,'LineWidth',0.8,'Color','#B22222'), hold on
%                 semilogx(f,gd_corrected_trunc,'LineWidth',0.8,'Color','#008000')
%                 grid
%                 axis([80 fs/2 -500 3500])
%                 xlabel('frequency (Hz)'), ylabel('group delay (samples)')
%                 ax = gca;
%                 ax.LineWidth = 0.8;
%         end
    end
end

%% Update SOFA fields2new = original; %copy SOFA struct

%replace data array
new.Data.IR = new_irs;

%update history information
new.GLOBAL_History = ['Converted from continuous HRTFs'...
    'Low frequency correction'];

%new license
new.GLOBAL_License = 'Creative Commons Attribution 4.0';

%update title
new.GLOBAL_Title = 'continuous near-field HRTF low frequency corrected';

%replace name of database
new.GLOBAL_DatabaseName = 'continuous near-field HRTF low frequency corrected';

%% Save new SOFA file
SOFAsave('continuous_HRIR_normalized_lfcorr.sofa',new,1)