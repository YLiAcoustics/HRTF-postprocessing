%% Left/Right Spectral Symmetry
% Compute correlation distance as the metric of symmetric properties, as a
% function of frequency and source position.
% Reference: Andreopoulou et al. 2015
% Yuqing Li, 07/22

clear;close all

el = 0;          % elevation
ds = 0.2;          % distance
flow = 100;       % lower frequency limit
fhigh = 20e3;    % higher frequency limit

cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs'
Obj = SOFAload('hrir_ku1_las_nf_circ_hor_fn.sofa');
hrir = Obj.Data.IR;
fs = Obj.Data.SamplingRate;
% hrir = SOFAload('KU100_hrir_measurement.sofa');
ASV = SOFAcalculateAPV(Obj);

%% compute ERB center frequencies
% fc=erb2hz(0:40); % find center frequencies of auditory space
N=size(hrir,3);
faxis=(0:floor(N/2))/N*fs;

fc=audspacebw(flow,fhigh,1,'erb'); % find center frequencies of auditory space
Nfc=length(fc); %number of bands

for k = 1:36
    az = 10*(k-1)-360*(10*(k-1)>180);
    for j=1:101
        ds=0.19+0.01*(j-1);
        [~,n(1)] = min(abs(ASV(:,1)-az)+abs(ASV(:,2)-el)+abs(ASV(:,3)-ds)); % position index (left)
        [~,n(2)] = min(abs(ASV(:,1)-(-az))+abs(ASV(:,2)-el)+abs(ASV(:,3)-ds)); % position index (right)

        [in1gtf,~]=GammaToneFilter(squeeze(hrir(n(1),1,:)),fs,flow,fhigh,1);
        [in2gtf,~]=GammaToneFilter(squeeze(hrir(n(2),2,:)),fs,flow,fhigh,1);
    
        GTF1=fft(in1gtf);
        GTF2=fft(in2gtf);

        for i = 1:length(fc)
            dcorr(i,j,k) = 1-sum(abs(GTF1(:,i)/2).*abs(GTF2(:,i)/2))/sqrt(sum(abs(GTF1(:,i)/2).^2)*sum(abs(GTF2(:,i)/2).^2));
        end
    end
    k
end
dcorr_dismean=squeeze(mean(dcorr,2));

% plot
figure
set(gcf,'Units','Normalized');
set(gcf,'Position',[0.1 0.1 0.4 0.5]);
[X,Y] = meshgrid(0:10:350,fc);
s=pcolor(X,Y,dcorr_dismean);
s.EdgeColor='none';
set(gca, 'Layer', 'top','FontSize',12);
colormap(flipud(gray));
cb = colorbar;
cb.XLim = [0 0.4];
cb.Ticks = 0:0.1:0.4;
cb.Label.String = 'correlation distance';
cb.Label.FontSize = 10;
xticks(0:30:350);
yticks([0 5e3 10e3 15e3]);
ylim([20 fc(end)]);
xlabel(['azimuth (' char(176) ')']);
ylabel('frequency (Hz)');
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs\plots'
saveas(gca,['symmetry_sim.fig']);
saveas(gca,['symmetry_sim.png']);
saveas(gca,['symmetry_sim.eps']);

function [out,fc]=GammaToneFilter(in,fs,flow,fhigh,space)
fc=audspacebw(flow,fhigh,space,'erb'); % find center frequencies of auditory space
Nfc=length(fc); %number of bands
[bgt,agt]=gammatone(fc,fs,'complex'); % find values of the complex filter
fin=2*real(ufilterbankz(bgt,agt,in(:,:)));  % fitler input signal, channel (3rd) dimension resolved
fin=reshape(fin,[size(in,1),Nfc,size(in,2),size(in,3)]); % reshape to rehave the correct number of channels
% fins=20*log10(squeeze(rms(fin))); % average over time in dB
% imp=zeros(256,1); imp(1)=1;%impulse signal
% fir=2*real(ufilterbankz(bgt,agt,imp));  % impulse response of filter
% firs=20*log10(squeeze(rms(fir))).'; % average over time in dB
% out=fins-firs; %correct amplitude
out=fin;
end %function