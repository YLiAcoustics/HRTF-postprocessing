clear
close all

fname = 'L:\Cloud\DataBackup\KEMARtrajectory/m24-07-17_18-02_Kitchen0.4m_HATS_S7_G8030__asdf_.mat';
fnameIR = 'L:\Cloud\DataBackup\KEMARtrajectory/IR_Kitchen0.4m_S7.mat';
data=load(fname);
audioData=data.mData;
sweep = data.v_sw;
loopB=data.loopB;

CF= [17.98 19.46];

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

Spc(:,1) = fftR(IR(:,1),4096);
Spc(:,2) = fftR(IR(:,2),4096);
fAxis = linspace(0,data.fs/2,length(Spc));

save(fnameIR,'IR');

figure
set(gcf,'Units','normalized');
set(gcf,'Position',[0.1 0.1 0.9 0.6]);
subplot(1,3,1)
plot([1:size(IR,1)]*340./data.fs,IR(:,1),'LineWidth',1);hold on
plot([1:size(IR,1)]*340./data.fs,IR(:,2),'LineWidth',1);grid on
xlim([0 10])
legend({'left','right'},'Location','northwest');
% ylim([-0.025 0.025]);
xlabel('dist [m]');ylabel('IR magnitude');
subplot(1,3,2)
plot([1:size(IR,1)]*340./data.fs,smooth(mag2db(abs(IR(:,1))),20),'LineWidth',1);hold on
plot([1:size(IR,1)]*340./data.fs,smooth(mag2db(abs(IR(:,2))),20),'LineWidth',1);grid on
xlim([0 10]);ylim([-80 0]);
xlabel('dist [m]');
ylabel('IR magnitude (dB)');
subplot(1,3,3)
plot(fAxis,smooth(mag2db(abs(Spc(:,1))),20),'LineWidth',1);hold on
plot(fAxis,smooth(mag2db(abs(Spc(:,2))),20),'LineWidth',1);grid on
xlim([20 2e4])
xlabel('Freq [Hz]');
ylabel('magnitude (dB)');
ax=gca;
ax.XScale='log';
% sgtitle(fname);