clear
close all

cd 'L:\Cloud\DataBackup\KEMARtrajectory'

fs=44100;
c=343;
traj = 1;

if traj == 1
    disV=[0:0.1:3.5];
    for i=1:length(disV)
        dis=disV(i);
        fname_S4=['IR' num2str(dis) 'm_S4.mat'];
        fname_S5=['IR' num2str(dis) 'm_S5.mat'];
        fname_S7=['IR' num2str(dis) 'm_S7.mat'];
        fname_STV=['IR' num2str(dis) 'm_STV.mat'];

        IRmat(:,:,i,1)=importdata(fname_S4);
        IRmat(:,:,i,2)=importdata(fname_S5);
        IRmat(:,:,i,3)=importdata(fname_S7);
        IRmat(:,:,i,4)=importdata(fname_STV);
    end
elseif traj==2
    disV=[0:0.1:2];
    for i=1:length(disV)
        dis=disV(i);
        fname_S4=['IR_Kitchen' num2str(dis) 'm_S4.mat'];
        fname_S5=['IR_Kitchen' num2str(dis) 'm_S5.mat'];
        fname_S7=['IR_Kitchen' num2str(dis) 'm_S7.mat'];
        fname_STV=['IR_Kitchen' num2str(dis) 'm_STV.mat'];

        IRmat(:,:,i,1)=importdata(fname_S4);
        IRmat(:,:,i,2)=importdata(fname_S5);
        IRmat(:,:,i,3)=importdata(fname_S7);
        IRmat(:,:,i,4)=importdata(fname_STV);       
    end
end
IRmat=IRmat(1:44100,:,:,:);
IRmat_L = squeeze(IRmat(:,1,:,:));
IRmat_R = squeeze(IRmat(:,2,:,:));
HanWin = hann(100);
WinFun = ones(44100,1);
WinFun(1:50) = HanWin(1:50);
WinFun(44100-49:end) = HanWin(51:100);
IRmat_L = IRmat_L.*WinFun;
IRmat_R = IRmat_R.*WinFun;

Specmat_L=fft(IRmat_L);
Specmat_R=fft(IRmat_R);

%% spectral smoothing
for i = 1:size(Specmat_L,2)
    for j = 1:size(Specmat_R,3)
        tempsmoothedL = smoothnew3(abs(squeeze(Specmat_L(:,i,j))),1/3);
        Specmat_L_smoothed(:,i,j) = tempsmoothedL.'; 
        tempsmoothedR= smoothnew3(abs(squeeze(Specmat_R(:,i,j))),1/3);
        Specmat_R_smoothed(:,i,j) = tempsmoothedR.';
    end
end

%%
fAxis=[0:floor(length(Specmat_L)/2)-1]/length(Specmat_L)*fs;
Specmat_L_plot=2*Specmat_L_smoothed([1:floor(length(Specmat_L_smoothed)/2)],:,:);
Specmat_L_plot(1,:,:)=Specmat_L_plot(1,:,:)/2;
Specmat_R_plot=2*Specmat_R_smoothed([1:floor(length(Specmat_R_smoothed)/2)],:,:);
Specmat_R_plot(1,:,:)=Specmat_R_plot(1,:,:)/2;

% fAxis=[0:floor(length(Specmat_L)/2)-1]/length(Specmat_L)*fs;
% Specmat_L_plot=2*Specmat_L([1:floor(length(Specmat_L)/2)],:,:);
% Specmat_L_plot(1,:,:)=Specmat_L_plot(1,:,:)/2;
% Specmat_R_plot=2*Specmat_R([1:floor(length(Specmat_R)/2)],:,:);
% Specmat_R_plot(1,:,:)=Specmat_R_plot(1,:,:)/2;
% 
% %% spectral smoothing
% for i = 1:size(Specmat_L,2)
%     for j = 1:size(Specmat_R,3)
%         tempsmoothedL = smoothnew3(squeeze(Specmat_L_plot(:,i,j)),1/3);
%         Specmat_L_smoothed(:,i,j) = tempsmoothedL.'; 
%         tempsmoothedR= smoothnew3(squeeze(Specmat_R_plot(:,i,j)),1/3);
%         Specmat_R_smoothed(:,i,j) = tempsmoothedR.';
%     end
% end

%%
[X,Y]=meshgrid(fAxis/1000,disV);
[X1,Y1]=meshgrid([0:length(IRmat)-1]/fs,disV);
figname={'S4','S5','S7','STV'};
for j = 1:4
    figure
    set(gcf,'Units','normalized');
    set(gcf,'Position',[0.1 0.1 0.3 0.6]);
    t=tiledlayout(2,1,"TileSpacing","compact");
    nexttile
    pc1=pcolor(X,Y,transpose(squeeze(mag2db(abs(Specmat_L_plot(:,:,j))))));cb=colorbar;clim([-20 20]);
    cb.Label.String='Mag (dB)';
%     colormap(redblueTecplot);
    pc1.LineStyle="none";
    pc1.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',12);
    set(gca,'LineWidth',1);
    set(gca,'XScale','log');
    ylabel('Distance (m)');
    xticks([0.1 1 10]);
    xticklabels([0.1 1 10]);
    xlim([50 22050]/1000);
    title([figname(j) 'left']);
    nexttile
    pc2=pcolor(X,Y,transpose(squeeze(mag2db(abs(Specmat_R_plot(:,:,j))))));cb=colorbar;clim([-20 20]);
    cb.Label.String='Mag (dB)';
%     colormap(redblueTecplot);
    pc2.LineStyle='none';
    pc2.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',12);
    set(gca,'LineWidth',1);
    set(gca,'XScale','log');
    xlim([50 22050]/1000);
    xlabel('Freq (kHz)');
    xticks([0.1 1 10]);
    xticklabels([0.1 1 10]);
    ylabel('Distance (m)');
    title('right');

    figure
    set(gcf,'Units','normalized');
    set(gcf,'Position',[0.1 0.1 0.3 0.6]);
    t=tiledlayout(2,1,"TileSpacing","compact");
    nexttile
    pc3=pcolor(X1,Y1,transpose(squeeze(mag2db(abs(IRmat_L(:,:,j))))));colorbar;clim([-50 0]);
    oldcmap = colormap('gray');
%     colormap( flipud(oldcmap) );
    colormap('gray');
    pc3.LineStyle="none";
    pc3.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',12);
    set(gca,'LineWidth',1);
    ylabel('Distance (m)');
    xlim([0 0.05]);
    title([figname(j) 'left']);
    nexttile
    pc4=pcolor(X1,Y1,transpose(squeeze(mag2db(abs(IRmat_R(:,:,j))))));colorbar;clim([-50 0]);
%     colormap( flipud(oldcmap) );
    colormap('gray');
    pc4.LineStyle='none';
    pc4.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',12);
    set(gca,'LineWidth',1);
    xlim([0 0.05]);
    xlabel('Time (s)');
    ylabel('Distance (m)');
    title([figname(j) ' right']);
end
