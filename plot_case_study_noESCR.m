%% Plot results (IBR mix)

Average_fuel_mix = sum(results_IBRmix.*results_Total_gen)/sum(results_Total_gen);

figure
subplot(2,2,1)
bar(results_IBRmix(1:2190))
title ('Percentage of IBR generation: 1^{st} quarter ')
xlim([0 2191])
ylim ([0 85])
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')

subplot(2,2,2)
bar(results_IBRmix(2191:(2190*2)))
title ('Percentage of IBR generation: 2^{nd} quarter ')
xlim([0 2191])
ylim ([0 100])
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')

subplot(2,2,3)
bar(results_IBRmix(2190*2+1:(2190*3)))
title ('Percentage of IBR generation: 3^{rd} quarter ')
xlim([0 2191])
ylim ([0 100])
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')


subplot(2,2,4)
bar(results_IBRmix(2190*3+1:(2190*4)))
title ('Percentage of IBR generation: 4^{th} quarter ')
xlim([0 2191])
ylim ([0 100])
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')

%% Plot results (ESCR)

figure
subplot(2,2,1)
plot(results_ESCR(1:2190,1))
hold on
plot(results_ESCR(1:2190,2))
plot(results_ESCR(1:2190,3))
title ('ESCR: 1^{st} quarter ')
xlim([0 2191])
ylim ([0 10])
grid on
xlabel ('Hours')
ylabel ('ESCR')
legend ('Wind - Bus 35','Wind - Bus 38','Solar - Bus 36','Location','southeast')

subplot(2,2,2)
plot(results_ESCR(2191:(2190*2),1))
hold on
plot(results_ESCR(2191:(2190*2),2))
plot(results_ESCR(2191:(2190*2),3))
title ('ESCR: 2^{nd} quarter ')
xlim([0 2191])
ylim ([0 10])
grid on
xlabel ('Hours')
ylabel ('ESCR')
legend ('Wind - Bus 35','Wind - Bus 38','Solar - Bus 36','Location','southeast')

subplot(2,2,3)
plot(results_ESCR(2190*2+1:(2190*3),1))
hold on
plot(results_ESCR(2190*2+1:(2190*3),2))
plot(results_ESCR(2190*2+1:(2190*3),3))
title ('ESCR: 3^{rd} quarter ')
xlim([0 2191])
ylim ([0 10])
grid on
xlabel ('Hours')
ylabel ('ESCR')
legend ('Wind - Bus 35','Wind - Bus 38','Solar - Bus 36','Location','southeast')


subplot(2,2,4)
plot(results_ESCR(2190*3+1:(2190*4),1))
hold on
plot(results_ESCR(2190*3+1:(2190*4),2))
plot(results_ESCR(2190*3+1:(2190*4),3))
title ('ESCR: 4^{th} quarter ')
xlim([0 2191])
ylim ([0 10])
grid on
xlabel ('Hours')
ylabel ('ESCR')
legend ('Wind - Bus 35','Wind - Bus 38','Solar - Bus 36','Location','southeast')

%% Plot results (Cost)

figure
subplot(2,2,1)
bar(results_cost(1:2190))
title ('Cost: 1^{st} quarter ')
xlim([0 2191])
ylim([0 4e4])
grid on
xlabel ('Hours')
ylabel ('Cost [$]')

subplot(2,2,2)
bar(results_cost(2191:(2190*2)))
title ('Cost: 2^{nd} quarter ')
xlim([0 2191])
ylim([0 4e4])
grid on
xlabel ('Hours')
ylabel ('Cost [$]')

subplot(2,2,3)
bar(results_cost(2190*2+1:(2190*3)))
title ('Cost: 3^{rd} quarter ')
xlim([0 2191])
ylim([0 4e4])
grid on
xlabel ('Hours')
ylabel ('Cost [$]')


subplot(2,2,4)
bar(results_cost(2190*3+1:(2190*4)))
title ('Cost: 4^{th} quarter ')
xlim([0 2191])
ylim([0 4e4])
grid on
xlabel ('Hours')
ylabel ('Cost [$]')

%% Examples (High IBR day vs cost, Low IBR day vs cost)


figure
subplot(4,1,1)
bar([results_Total_gen(8760/4*2+22*24+1:8760/4*2+23*24),results_Total_gen(8760/4*3+87*24+1:8760/4*3+88*24)])
xlim ([0 25])
grid on
title ('Total Generation')
xlabel ('Hours')
ylabel ('Energy [MWh]')
legend('High IBR Day (Sample)', 'Low IBR Day (Sample)')

subplot(4,1,2)
bar([results_IBRmix(8760/4*2+22*24+1:8760/4*2+23*24), results_IBRmix(8760/4*3+87*24+1:8760/4*3+88*24)])
xlim ([0 25])
title ('IBR penetration')
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')
legend('High IBR Day (Sample)', 'Low IBR Day (Sample)')


%High IBR

subplot(4,1,3)
bar([results_cost(8760/4*2+22*24+1:8760/4*2+23*24), results_cost(8760/4*3+87*24+1:8760/4*3+88*24)])
xlim ([0 25])
title ('Cost')
xlabel ('Hours')
ylabel ('Cost [$]')
grid on
legend('High IBR Day (Sample)', 'Low IBR Day (Sample)')

marginal_cost(:,1) = results_cost(8760/4*2+22*24+1:8760/4*2+23*24)./results_Total_gen(8760/4*2+22*24+1:8760/4*2+23*24);
marginal_cost(:,2) = results_cost(8760/4*3+87*24+1:8760/4*3+88*24)./results_Total_gen(8760/4*3+87*24+1:8760/4*3+88*24);

subplot(4,1,4)
bar(marginal_cost)
xlim ([0 25])
title ('Marginal Cost')
xlabel ('Hours')
ylabel ('Marginal Cost [$/MWh]')
grid on
legend('High IBR Day (Sample)', 'Low IBR Day (Sample)')
