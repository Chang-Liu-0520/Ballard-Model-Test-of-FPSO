clear all;
close all;
clc;

%read the data that is free decay
roll = textread('rolldecay_2.tsv');
roll = roll(:,4);
pitch = textread('pitchdecay_2.tsv');
pitch = pitch(:,5);
surge = textread('surgedecay_2.tsv');
surge = surge(:,1);

%generate the time signal that are in the same length with each data, Frequency as 25Hz
% t_motion_zero = 0:0.04:0.04*(length(motion_zero)-1);
t_roll = 0:0.04:0.04*(length(roll)-1);
t_pitch = 0:0.04:0.04*(length(pitch)-1);
t_surge = 0:0.04:0.04*(length(surge)-1);

lamba = 64; %缩尺比
gamma = 1.025;
%plot the decay curve of the model ship
figure(1);
set(gcf,'color','white');
plot(t_roll,roll,'LineWidth',2);
ylabel('\phi /°','FontWeight','bold');
xlabel('Time t/s','FontWeight','bold');
title('Roll Decay Curve of Ship Model in Still Water','FontWeight','bold');
saveas(gcf,'Roll Decay Curve of Ship Model.jpg');

figure(2);
set(gcf,'color','white');
plot(t_pitch,pitch,'LineWidth',2);
ylabel('\phi /°','FontWeight','bold');
xlabel('Time t/s','FontWeight','bold');
title('Pitch Decay Curve of Ship Model in Still Water','FontWeight','bold');
saveas(gcf,'Pitch Decay Curve of Ship Model.jpg');

figure(3);
set(gcf,'color','white');
plot(t_surge,surge,'LineWidth',2);
ylabel('\phi /°','FontWeight','bold');
xlabel('Time t/s','FontWeight','bold');
title('Surge Decay Curve of Ship Model in Still Water','FontWeight','bold');
saveas(gcf,'Surge Decay Curve of Ship Model.jpg');

%plot the decay curve of the real ship 
figure(4);
set(gcf,'color','white');
plot(t_roll*sqrt(lamba),roll,'LineWidth',2);
ylabel('\phi /°','FontWeight','bold');
xlabel('Time t/s','FontWeight','bold');
title('Roll Decay Curve of Real Ship in Still Water','FontWeight','bold');
saveas(gcf,'Roll Decay Curve of Real Ship.jpg');

figure(5);
set(gcf,'color','white');
plot(t_pitch*sqrt(lamba),pitch,'LineWidth',2);
ylabel('\phi /°','FontWeight','bold');
xlabel('Time t/s','FontWeight','bold');
title('Pitch Decay Curve of Real Ship in Still Water','FontWeight','bold');
saveas(gcf,'Pitch Decay Curve of Real Ship.jpg');

figure(6);
set(gcf,'color','white');
plot(t_surge*sqrt(lamba),surge,'LineWidth',2);
ylabel('\phi /°','FontWeight','bold');
xlabel('Time t/s','FontWeight','bold');
title('Surge Decay Curve of Real Ship in Still Water','FontWeight','bold');
saveas(gcf,'Surge Decay Curve of Real Ship.jpg');

%Plot the Power Spectrum of the Roll, Pitch, Surge Decay
interval = 0.04;
f0 = 1/interval;
N = length(t_roll);
mag = abs(fft(roll));
f = f0*(0:N/2-1)/N;
figure(7);
set(gcf,'color','white');
plot(f(1:end),mag(1:floor(N/2)),'LineWidth',2);
ylabel('Power W','FontWeight','bold');
xlabel('Frequency f/Hz','FontWeight','bold');
title('Spectrum of Roll Decay in Still Water','FontWeight','bold');
saveas(gcf,'Spectrum of Roll Decay.jpg');

interval = 0.04;
f0 = 1/interval;
N = length(t_pitch);
mag = abs(fft(pitch));
f = f0*(0:N/2-1)/N;
figure(8);
set(gcf,'color','white');
plot(f(1:end),mag(1:floor(N/2)),'LineWidth',2);
ylabel('Power W','FontWeight','bold');
xlabel('Frequency f/Hz','FontWeight','bold');
title('Spectrum of Pitch Decay in Still Water','FontWeight','bold');
saveas(gcf,'Spectrum of Pitch Decay.jpg');

interval = 0.04;
f0 = 1/interval;
N = length(t_surge);
mag = abs(fft(surge));
f = f0*(0:N/2-1)/N;
figure(9);
set(gcf,'color','white');
plot(f(1:end),mag(1:floor(N/2)),'LineWidth',2);
ylabel('Power W','FontWeight','bold');
xlabel('Frequency f/Hz','FontWeight','bold');
title('Spectrum of Surge Decay in Still Water','FontWeight','bold');
saveas(gcf,'Spectrum of Surge Decay.jpg');

figure(10);
set(gcf,'color','white');
plot(t_roll(800:1000),roll(800:1000),'LineWidth',2);
[RollMax,LocationMax] = findpeaks(roll(800:1000));
hold on;
plot(t_roll(LocationMax+799),RollMax,'LineWidth',2);
legend('Time History','Peak');
xlabel('Time t(s)','FontWeight','bold');
ylabel('Rolling Angle \psi °','FontWeight','bold');
title('Preprocessed Data of Roll Decay in Still Water','FontWeight','bold');
saveas(gcf,'Preprocessed Data of Roll Decay.jpg');

% figure(11);
% set(gcf,'color','white');
% plot(t_pitch(470:500),pitch(470:500),'LineWidth',2);
% [PitchMax,LocationMax] = findpeaks(pitch(470:500));
% hold on;
% plot(t_pitch(LocationMax+469),PitchMax,'LineWidth',2);
% legend('Time History','Peak');
% xlabel('Time t(s)','FontWeight','bold');
% ylabel('Pitch Angle \psi °','FontWeight','bold');
% title('Preprocessed Data of Pitch Decay','FontWeight','bold');
% saveas(gcf,'Preprocessed Data of Pitch Decay.jpg');


%read the data that are in the non-regular wave 这里是处理规则波的
force = textread('force100cww-Model.dat');
motion_wcw = textread('100wcw_motion.tsv');
motion_zero = textread('zero-2.tsv');
motion_zero = mean(motion_zero(:,1:6)); %零位数据求平均
motion_wcw = motion_wcw(:,1:6);
for i = 1:6 %运动信号数据减去零位数据
	motion_wcw(:,i) = motion_wcw(:,i)-motion_zero(i);
end 

t_force = 0:0.04:0.04*(length(force)-1);
t_motion_wcw = 0:0.04:0.04*(length(motion_wcw)-1);
name = ['    X';'    Y';'    Z';' Roll';'Pitch';'Surge'];

StatisticValue = zeros(4,6); %规则波上6自由度运动的统计量，第一行最大值，第二行最小值，第三行平均值，第四行方差

for i = 1:6
	figure(11+i)
	set(gcf,'color','white');
	plot(t_motion_wcw,motion_wcw(:,i),'LineWidth',2);
	ylabel('\phi /°','FontWeight','bold');
	xlabel('Time t/s','FontWeight','bold');
	title([name(i,:),' Motion Curve in A-hundred-year Return Period Wind-Wave-Current (Full Load)'],'FontWeight','bold');
	saveas(gcf,[name(i,:),' Motion Curve in A-hundred-year Return Period Wind-Wave-Current (Full Load)','.jpg']);

	interval = 0.04;
	f0 = 1/interval;
	N = length(t_motion_wcw);
	mag = abs(fft(motion_wcw(:,i)));
	f = f0*(0:N/2-1)/N;
	figure(17+i);
	set(gcf,'color','white');
	plot(f(1:end),mag(1:floor(N/2)),'LineWidth',2);
	ylabel('Power W','FontWeight','bold');
	xlabel('Frequency f/Hz','FontWeight','bold');
	title([name(i,:),' Motion Power Spectrum in A-hundred-year Return Period Wind-Wave-Current (Full Load).jpg'],'FontWeight','bold');
	saveas(gcf,[name(i,:),' Motion Power Spectrum in A-hundred-year Return Period Wind-Wave-Current (Full Load).jpg']);
end

I = find(motion_wcw(:,1)>100);
for i = 1:length(I)
	motion_wcw(I(i),1) = 0;
end
I = find(motion_wcw(:,3)>60);
for i = 1:length(I)
	motion_wcw(I(i),3) = 0;
end
for i = 1:6
	StatisticValue(1,i) = max(motion_wcw(:,i));
	StatisticValue(2,i) = min(motion_wcw(:,i));
	StatisticValue(3,i) = mean(motion_wcw(:,i));
	StatisticValue(4,i) = var(motion_wcw(:,i));
end

StatisticValueReal(:,1:3) = StatisticValue(:,1:3)*8/1000;

waveheight = force(:,15:16);
force =force(:,2:10);
force = force+0.2013;
%Force Signal
for i = 1:9
	figure(23+i)
	set(gcf,'color','white');
	plot(t_force,force(:,i),'LineWidth',2);
	ylabel('Anchor Force (N)','FontWeight','bold');
	xlabel('Time t/s','FontWeight','bold');
	title(['Time History of Anchor Chain No.',num2str(i)],'FontWeight','bold');
	saveas(gcf,['Time History of Anchor Chain No.',num2str(i),' .jpg']);

	interval = 0.04;
	f0 = 1/interval;
	N = length(t_force);
	mag = abs(fft(force(:,i)));
	f = f0*(0:N/2-1)/N;
	figure(32+i);
	set(gcf,'color','white');
	plot(f(1:end),mag(1:floor(N/2)),'LineWidth',2);
	ylabel('Power W','FontWeight','bold');
	xlabel('Frequency f/Hz','FontWeight','bold');
	title(['Power Spectrum of Anchor Chain No.',num2str(i)],'FontWeight','bold');
	saveas(gcf,['Power Spectrum of Anchor Chain No.',num2str(i),' .jpg']);
end

I = find(motion_wcw(:,1)>100);
for i = 1:length(I)
	motion_wcw(I(i),1) = 0;
end
I = find(motion_wcw(:,3)>60);
for i = 1:length(I)
	motion_wcw(I(i),3) = 0;
end

StatisticValueForce = zeros(4,9);
for i = 1:9
	StatisticValueForce(1,i) = max(force(:,i));
	StatisticValueForce(2,i) = min(force(:,i));
	StatisticValueForce(3,i) = mean(force(:,i));
	StatisticValueForce(4,i) = var(force(:,i));
end

StatisticValueRealForce = zeros(4,9);
for i = 1:9
	StatisticValueRealForce(1,i) = StatisticValueForce(1,i)*gamma*lamba^3/1000;
	StatisticValueRealForce(2,i) = StatisticValueForce(2,i)*gamma*lamba^3/1000;
	StatisticValueRealForce(3,i) = StatisticValueForce(3,i)*gamma*lamba^3/1000;
	StatisticValueRealForce(4,i) = StatisticValueForce(4,i)*(gamma*lamba^3)^2/1000/1000;
end

t_waveheight =  0:0.04:0.04*(length(waveheight)-1);

direction = ['East','North'];

for i = 1
	figure(42+i);
	set(gcf,'color','white');
	plot(t_waveheight,waveheight(:,i),'LineWidth',2);
	ylabel('Wave Height (cm)','FontWeight','bold');
	xlabel('Time t/s','FontWeight','bold');
	title('Time History of Wave Height','FontWeight','bold');
	saveas(gcf,'Time History of Wave Height .jpg');

	interval = 0.04;
	f0 = 1/interval;
	N = length(t_waveheight);
	mag = abs(fft(waveheight(:,i)));
	f = f0*(0:N/2-1)/N;
	figure(44+i);
	set(gcf,'color','white');
	plot(f(1:end),mag(1:floor(N/2)),'LineWidth',2);
	ylabel('Power W','FontWeight','bold');
	xlabel('Frequency f/Hz','FontWeight','bold');
	title('Power Spectrum of Wave Height ','FontWeight','bold');
	saveas(gcf,'Power Spectrum of Wave Height .jpg');
end
[Max,MaxLocation] = findpeaks(waveheight(:,1));
[Min,MinLocation] = findpeaks(-waveheight(:,1));

StatisticValueWave(1,i) = max(waveheight(:,i));
StatisticValueWave(2,i) = min(waveheight(:,i));
StatisticValueWave(3,i) = mean(waveheight(:,i));
StatisticValueWave(4,i) = var(waveheight(:,i));