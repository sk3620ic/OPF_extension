%% Import load profile, convert to per unit and plot

[loadprofile,~,~,~] = make_profiles(true);

figure
subplot(2,2,1)
bar(loadprofile(1:8760/4))
xlabel ('Hours')
ylabel ('Demand [p.u.]')
title ('Residential Hourly Load Profile: 1^{st} quarter')
xlim ([0 8760/4+1])
ylim ([0 1])
grid on

subplot(2,2,2)
bar(loadprofile(8760/4+1:8760/4*2))
xlabel ('Hours')
ylabel ('Demand [p.u.]')
title ('Residential Hourly Load Profile: 2^{nd} quarter')
xlim ([0 8760/4+1])
ylim ([0 1])
grid on

subplot(2,2,3)
bar(loadprofile(8760/4*2+1:8760/4*3))
xlabel ('Hours')
ylabel ('Demand [p.u.]')
title ('Residential Hourly Load Profile: 3^{rd} quarter')
xlim ([0 8760/4+1])
ylim ([0 1])
grid on

subplot(2,2,4)
bar(loadprofile(8760/4*3+1:8760))
xlabel ('Hours')
ylabel ('Demand [p.u.]')
title ('Residential Hourly Load Profile: 4^{th} quarter')
xlim ([0 8760/4+1])
ylim ([0 1])
grid on

figure
subplot(1,2,1)
bar(loadprofile(1:24))
xlabel ('Hours')
ylabel ('Demand [p.u.]')
title ('Typical Residential Hourly Load Profile for one day')
xlim ([0 25])
ylim ([0 1])
grid on

subplot(1,2,2)
bar(loadprofile(1:24*7))
xlabel ('Hours')
ylabel ('Demand [p.u.]')
title ('Typical Residential Hourly Load Profile for one week')
xlim ([0 24*7+1])
ylim ([0 1])
grid on

%% Import solar data already in per unit and plot



[~,~,~,solarprofile] = make_profiles(true);

figure
subplot(2,2,1)
bar(solarprofile(1:8760/4))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Solar Hourly Power Availability Profile: 1^{st} quarter')
xlim ([0 8760/4+1])
ylim ([0 0.9])
grid on

subplot(2,2,2)
bar(solarprofile(8760/4+1:8760/4*2))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Solar Hourly Power Availability: 2^{nd} quarter')
xlim ([0 8760/4+1])
ylim ([0 0.9])
grid on

subplot(2,2,3)
bar(solarprofile(8760/4*2+1:8760/4*3))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Solar Hourly Power Availability: 3^{rd} quarter')
xlim ([0 8760/4+1])
ylim ([0 0.9])
grid on

subplot(2,2,4)
bar(solarprofile(8760/4*3+1:8760))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Solar Hourly Power Availability: 4^{th} quarter')
xlim ([0 8760/4+1])
ylim ([0 0.9])
grid on

figure
subplot(1,2,1)
bar(solarprofile((3361):(3385)))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Typical Solar Hourly Power Availability Profile for one day')
xlim ([0 25])
ylim ([0 0.9])
grid on

subplot(1,2,2)
bar(solarprofile((3361):(3360+24*7)))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Typical Solar Hourly Power Availability Profile for one week')
xlim ([0 24*7+1])
ylim ([0 0.9])
grid on

disp(['Solar profile 1 capacity factor: ', num2str(sum(solarprofile)/8760)])

%% Import wind already in per unit and plot

[~,windprofile1,windprofile2,~] = make_profiles(true);

figure
subplot (2,2,1)
bar(windprofile1(8760/4*0+1:8760/4*1))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 1^{st} Profile: 1^{st} quarter')
xlim ([0 8760/4+1])
grid on


subplot (2,2,2)
bar(windprofile1(8760/4*1+1:8760/4*2))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 1^{st} Profile: 2^{nd} quarter')
xlim ([0 8760/4+1])
grid on


subplot (2,2,3)
bar(windprofile1(8760/4*2+1:8760/4*3))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 1^{st} Profile: 3^{rd} quarter')
xlim ([0 8760/4+1])
grid on


subplot (2,2,4)
bar(windprofile1(8760/4*3+1:8760/4*4))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 1^{st} Profile: 4^{th} quarter')
xlim ([0 8760/4+1])
grid on

disp(['Wind profile 1 capacity factor: ', num2str(sum(windprofile1)/8760)])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot (2,2,1)
bar(windprofile2(8760/4*0+1:8760/4*1))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 2^{nd} Profile: 1^{st} quarter')
xlim ([0 8760/4+1])
ylim([0 1])
grid on


subplot (2,2,2)
bar(windprofile2(8760/4*1+1:8760/4*2))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 2^{nd} Profile: 2^{nd} quarter')
xlim ([0 8760/4+1])
ylim([0 1])
grid on


subplot (2,2,3)
bar(windprofile2(8760/4*2+1:8760/4*3))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 2^{nd} Profile: 3^{rd} quarter')
xlim ([0 8760/4+1])
ylim([0 1])
grid on


subplot (2,2,4)
bar(windprofile2(8760/4*3+1:8760/4*4))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Wind Hourly Power Availability 2^{nd} Profile: 4^{th} quarter')
xlim ([0 8760/4+1])
ylim([0 1])
grid on

disp(['Wind profile 2 capacity factor: ', num2str(sum(windprofile2)/8760)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
subplot(1,2,1)
bar(windprofile1((3361):(3385)))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Typical Wind Hourly Power Availability Profile for one day')
xlim ([0 25])
ylim([0 1])
grid on

subplot(1,2,2)
bar(windprofile1((3361):3360+24*7))
xlabel ('Hours')
ylabel ('Power [p.u.]')
title ('Typical Wind Hourly Power Availability Profile for one week')
xlim ([0 24*7+1])
ylim([0 1])
grid on