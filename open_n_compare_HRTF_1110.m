%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% This MATLAB script plots and compares different HRTFs.
clear all
close all

%%%% Options
plot_HRTF = 1;
convolution = 0;
plot_mode = 'multi_distance';                      % select from 'multi_distance' and 'sing_distance'

dis = 25;
disvec = [25 40 50 60 75 100];
ori = 0;
fs = 48000;

%%%% HRTF
if plot_mode == 'multi_distance'
    left_ear = figure(1);
    axl = axes(left_ear);
    set(gcf, 'Position', get(0, 'Screensize'));
    right_ear = figure(2);
    axr = axes(right_ear);
    set(gcf, 'Position', get(0, 'Screensize'));
    for m = 1:6
        dis = disvec(m);
        HRTFpath = strcat('C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\HRTFs\',num2str(dis),'cm');
        cd(HRTFpath)
        % Import data
        filename = strcat('HRTF_',num2str(dis),'_',num2str(ori));
        HRTF_l = importdata(strcat(filename,'_l.mat'));
        HRTF_r = importdata(strcat(filename,'_r.mat'));
        % plot HRTF
        if plot_HRTF   
            faxis = [0:length(HRTF_l)-1]'/length(HRTF_l)*fs;
            plot(axr,faxis, 20*log10(abs(HRTF_r)),'b','linewidth',1);
            legend(num2str(dis));
            hold on;
            plot(axl,faxis, 20*log10(abs(HRTF_l)),'r','linewidth',1);
            hold on;
        end
    end
    grid on;
%     legend ({'25cm','40cm'});
   
    set(axl,'xscale','log');
    axl.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
    axl.XLim = [90,20000];
    axl.YLim = [-40,20];
    axl.XLabel.String = 'frequency(Hz)';
    axl.YLabel.String = 'dB';
    axl.Title.String = ['Left-ear HRTFs at ' num2str(ori) char(176)];
    axl.FontSize = 12;
%     axl.Legend.FontSize = 12;
    axl.LineWidth = 1;
    
    set(axr,'xscale','log');
    axr.XTick = [20,30,50,100,200,300,500,1000,2000,3000,5000,10000,20000];
    axr.XLim = [90,20000];
    axr.YLim = [-40,20];
    axr.XLabel.String = 'frequency(Hz)';
    axr.YLabel.String = 'dB';
    axr.Title.String = ['Left-ear HRTFs at ' num2str(ori) char(176)];
    axr.FontSize = 12;
%     axr.Legend.String = ['25cm','40cm','50cm', '60cm', '75cm', '100cm'];
    axr.Legend.FontSize = 12;
    axr.LineWidth = 1;

%     
%     cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\plots\binaural HRTF plots'
%     figurename = strcat('HRTFs_',num2str(dis),'_',num2str(ori));
%     saveas(gcf,strcat(figurename,'.png'));
%     saveas(gcf,strcat(figurename,'.fig'));
%     close
end


%%%% convolution
if convolution 
% dry audio
    cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\dry audio\audio files'
    [input fs] = audioread('castanetcut_48.wav');
% HRIR
    HRIR_l = ifft(HRTF_l);
    HRIR_r = ifft(HRTF_r);
    output = zeros(length(input)+length(HRIR_l)-1,2);
    output(:,1) = conv(input, HRIR_l);
    output(:,2) = conv(input, HRIR_r);
    output = output/max(max(abs(output)));
% signal output
    cd 'C:\Users\root\Documents\00 phd\measurement\201020 KEMAR HRTF AP\convolved audio\1110'
    audioname = strcat('convolved_',num2str(dis),'_',num2str(ori),'.wav');
    audiowrite(audioname,output,fs);
end
