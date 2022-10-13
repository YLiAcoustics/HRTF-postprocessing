%% windowing of HRIRs

clear;close all

fs = 48000;
data = importdata('HRIR_sim.mat');

hanwin = hann(200);
hanwin = hanwin(floor(length(hanwin)/2)+1:end);

HRIR = data;
for i = 1:101
    for j = 1:36
        % find peak of each HRIR
        hrir_temp_L = HRIR(:,1,i,j);
        hrir_temp_R =  HRIR(:,2,i,j);
        [~,I_L] = max(abs(hrir_temp_L));
        [~,I_R] = max(abs(hrir_temp_R));
        win_L = [ones(I_L+100,1);hanwin;zeros(512-I_L-100-length(hanwin),1)];
        win_R = [ones(I_R+100,1);hanwin;zeros(512-I_R-100-length(hanwin),1)];
        HRIRwin(:,1,i,j) = hrir_temp_L.*win_L;
        HRIRwin(:,2,i,j) = hrir_temp_R.*win_R;

        HRTFwin(:,1,i,j) = fft(HRIRwin(:,1,i,j));
        HRTFwin(:,2,i,j) = fft(HRIRwin(:,2,i,j));
    end
end

plot_ori = 90;
plot_ori_index = plot_ori/10+1;
daxis = [19:119];
figure
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.5 0.55]);
[X Y] = meshgrid([1:512],daxis);
s = pcolor(X,Y,transpose(squeeze(HRIR(:,1,:,plot_ori_index)))); 
set(gca, 'Layer', 'top')
s.EdgeColor = 'none';
s.FaceColor = 'interp';
s.LineWidth = 1;
h = colorbar;
h.Label.String = 'Magnitude';
h.Label.FontSize = 16;
colormap gray;
ax = gca;
ax.FontSize = 16;
xlim([0 512]);
ax.CLim = [-0.2 0.2];
h.XTick = [-0.2:0.1:0.2];
xticks([0:100:500]);
xlabel('sample number');
ylabel('distance (cm)');
title(['HRIR ' num2str(plot_ori) char(176)]);

figure
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.5 0.55]);
[X Y] = meshgrid([1:512],daxis);
s = pcolor(X,Y,transpose(squeeze(HRIRwin(:,1,:,plot_ori_index)))); 
set(gca, 'Layer', 'top')
s.EdgeColor = 'none';
s.FaceColor = 'interp';
s.LineWidth = 1;
h = colorbar;
h.Label.String = 'Magnitude';
h.Label.FontSize = 16;
colormap gray;
ax = gca;
ax.FontSize = 16;
xlim([0 512]);
ax.CLim = [-0.2 0.2];
h.XTick = [-0.2:0.1:0.2];
xticks([0:100:500]);
xlabel('sample number');
ylabel('distance (cm)');
title(['HRIR windowed ' num2str(plot_ori) char(176)]);