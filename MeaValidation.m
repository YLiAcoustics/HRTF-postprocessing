clear
close all

fname = '/Users/yuqingli/Documents/00phd/00Measurement/room acoustics/msg_birkenweg - Kopie/measuredData/m24-07-16_12-59_test2_HATS_S7_G8030__asdf_.mat';
data=load(fname);
audioData=data.mData;
sweep = data.v_sw;
loopB=data.loopB;

fname2 = '/Volumes/lize9806/Cloud/Living Room 1.1/21-11_repo-v2/HATS/IR_pos-S7_G8030_R1_HATS_F_O.wav';
[audio, Fs]=audioread(fname2);
IR2=audio(:,1:2);
IR2=IR2/max(max(abs(IR2)));
[~,x2]=max(IR2(:,1));
Spc2(:,1)=fftR(IR2(:,1),4096);
Spc2(:,2)=fftR(IR2(:,2),4096);

% for i = 1:size(audioData,3)
%     SPL(1,i)=mag2db(CF(1)*rms(audioData(:,1,i)))+93.3;
%     SPL(2,i)=mag2db(CF(2)*rms(audioData(:,2,i)))+93.3;
% end

avr_sig=mean(audioData,3);

IRtemp(:,1) = ifft(fft(avr_sig(:,1))./fft([sweep; zeros(size(avr_sig,1)-size(sweep,1),1)]));
IRtemp(:,2) = ifft(fft(avr_sig(:,2))./fft([sweep; zeros(size(avr_sig,1)-size(sweep,1),1)]));

IRlb(:,1) = ifft(fft(avr_sig(:,1))./fft(squeeze(loopB(:,1,1))));
IRlb(:,2) = ifft(fft(avr_sig(:,2))./fft(squeeze(loopB(:,1,1))));

lag(1) = finddelay(IRlb(:,1),IRtemp(:,1));
lag(2) = finddelay(IRlb(:,2),IRtemp(:,2));
IR(:,1) = circshift(IRtemp(:,1),-lag(1));
IR(:,2) = circshift(IRtemp(:,2),-lag(2));
IR = IR(1:length(IR2),:);
IR=IR/max(max(abs(IR)));
[~,x]=max(IR(:,1));

IR2(:,1) = circshift(IR2(:,1),x-x2);
IR2(:,2) = circshift(IR2(:,2),x-x2);

Spc(:,1) = fftR(IR(:,1),4096);
Spc(:,2) = fftR(IR(:,2),4096);
fAxis = linspace(0,data.fs/2,length(Spc));

%%
figure
set(gcf,'Units','normalized');
set(gcf,'Position',[0.1 0.1 0.9 0.6]);
subplot(1,3,1)
plot([1:size(IR,1)]*340./data.fs,IR(:,1));hold on
plot([1:size(IR,1)]*340./data.fs,IR2(:,1));grid on
legend('new','old');
xlim([0 10])
% ylim([-0.025 0.025]);
xlabel('dist [m]');ylabel('IR magnitude');
subplot(1,3,2)
plot([1:size(IR,1)]*340./data.fs,smooth(mag2db(abs(IR(:,1))),50),'LineWidth',1);hold on
plot([1:size(IR,1)]*340./data.fs,smooth(mag2db(abs(IR2(:,1))),50),'LineWidth',1);grid on
legend('new','old');
xlim([0 10]);ylim([-80 0]);
xlabel('dist [m]');
ylabel('IR magnitude (dB)');
subplot(1,3,3)
plot(fAxis,smooth(mag2db(abs(Spc(:,1))),50),'LineWidth',1);hold on
plot(fAxis,smooth(mag2db(abs(Spc2(:,1))),50),'LineWidth',1);grid on
legend('new','old');
xlim([20 2e4])
xlabel('Freq [Hz]');
ylabel('magnitude (dB)');
ax=gca;
ax.XScale='log';
sgtitle('Left');

figure
set(gcf,'Units','normalized');
set(gcf,'Position',[0.1 0.1 0.9 0.6]);
subplot(1,3,1)
plot([1:size(IR,1)]*340./data.fs,IR(:,2));hold on
plot([1:size(IR,1)]*340./data.fs,IR2(:,2));grid on
legend('new','old');
xlim([0 10])
% ylim([-0.025 0.025]);
xlabel('dist [m]');ylabel('IR magnitude');
subplot(1,3,2)
plot([1:size(IR,1)]*340./data.fs,smooth(mag2db(abs(IR(:,2))),50),'LineWidth',1);hold on
plot([1:size(IR,1)]*340./data.fs,smooth(mag2db(abs(IR2(:,2))),50),'LineWidth',1);grid on
legend('new','old');
xlim([0 10]);ylim([-80 0]);
xlabel('dist [m]');
ylabel('IR magnitude (dB)');
subplot(1,3,3)
plot(fAxis,smooth(mag2db(abs(Spc(:,2))),50),'LineWidth',1);hold on
plot(fAxis,smooth(mag2db(abs(Spc2(:,2))),50),'LineWidth',1);grid on
legend('new','old');
xlim([20 2e4])
xlabel('Freq [Hz]');
ylabel('magnitude (dB)');
ax=gca;
ax.XScale='log';
sgtitle('Right');