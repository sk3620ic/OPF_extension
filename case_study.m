%%

[loadprofile_modified,windprofile1,windprofile2,solarprofile] = make_profiles(true);

mpc = loadcase('case39');
IBRvector = [35,38,36];
ESCR = 5;

mpopt = mpoption;

% FMINCON is more reliable but a bit slower slower sometimes
% MIPS is the default option
mpopt.opf.ac.solver = 'MIPS';

% Supress output print-outs with these two lines
mpopt.verbose = 0;
mpopt.out.all = 0;

N = length(loadprofile_modified);

results_ESCR = zeros(N,3);
results_cost = zeros(N,1);
results_IBRmix = zeros(N,1);
results_Total_gen = zeros(N,1);

tic

wait = waitbar(0, 'Loading...');
for i = 1:N
    mpc_temp = mpc;
    mpc_temp.bus(:,3:4) = mpc.bus(:,3:4) .* loadprofile_modified(i);
    mpc_ext = build_stability_mpc(mpc_temp,IBRvector,ESCR,[windprofile1(i), windprofile2(i), solarprofile(i)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % These lines remove stability constraints, keeping IBR  modifications
    % mpc_ext = rmfield(mpc_ext,'l');
    % mpc_ext = rmfield(mpc_ext,'u');
    % mpc_ext = rmfield(mpc_ext,'A');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    results = runopf(mpc_ext,mpopt);
    if results.success
        results_ESCR(i,:) = (calc_ESCR(results,IBRvector))';
        results_cost(i) = results.f;
        [results_IBRmix(i), results_Total_gen(i)] = calc_fuelmix_percentage(results,IBRvector);
    else
        results_ESCR(i,:) = -1 * ones(1,length(IBRvector));
        results_cost(i) = -1;
        results_IBRmix(i) = -1;
    end

    if (mod(i,50) == 0)
        waitbar(i/N,wait)
    end

end
close(wait)

toc

%% Single iteration (For testing purposes)

[loadprofile_modified,windprofile1,windprofile2,solarprofile] = make_profiles(true);

mpc = loadcase('case39');
IBRvector = [35,38,36];
ESCR = 5;

mpopt = mpoption;

% FMINCON is more reliable but a bit slower slower sometimes
% MIPS is the default option
mpopt.opf.ac.solver = 'MIPS';

% Supress output print-outs with these two lines
%mpopt.verbose = 0;
%mpopt.out.all = 0;

i = 4084;
mpc_temp = mpc;
mpc_temp.bus(:,3:4) = mpc.bus(:,3:4) .* loadprofile_modified(i);
mpc_ext = build_stability_mpc(mpc_temp,IBRvector,ESCR,[windprofile1(i)-0.04, windprofile2(i)-0.04, solarprofile(i)]);

mpc_ext = rmfield(mpc_ext,'l');
mpc_ext = rmfield(mpc_ext,'u');
mpc_ext = rmfield(mpc_ext,'A');

results = runopf(mpc_ext,mpopt);
results_ESCR(1,:) = (calc_ESCR(results,IBRvector))';
results_cost(1) = results.f;
results_IBRmix(1) = calc_fuelmix_percentage(results,IBRvector);

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
ylim ([0 85])
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')

subplot(2,2,3)
bar(results_IBRmix(2190*2+1:(2190*3)))
title ('Percentage of IBR generation: 3^{rd} quarter ')
xlim([0 2191])
ylim ([0 85])
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')


subplot(2,2,4)
bar(results_IBRmix(2190*3+1:(2190*4)))
title ('Percentage of IBR generation: 4^{th} quarter ')
xlim([0 2191])
ylim ([0 85])
grid on
xlabel ('Hours')
ylabel ('IBR Generation [%]')

%% Plot results (ESCR)

figure
subplot(2,2,1)
plot(results_ESCR(1:2190,1),'.')
hold on
plot(results_ESCR(1:2190,2),'.')
plot(results_ESCR(1:2190,3),'.')
title ('ESCR: 1^{st} quarter ')
xlim([0 2191])
ylim ([0 10])
grid on
xlabel ('Hours')
ylabel ('ESCR')
legend ('Wind - Bus 35','Wind - Bus 38','Solar - Bus 36','Location','southeast')

subplot(2,2,2)
plot(results_ESCR(2191:(2190*2),1),'.')
hold on
plot(results_ESCR(2191:(2190*2),2),'.')
plot(results_ESCR(2191:(2190*2),3),'.')
title ('ESCR: 2^{nd} quarter ')
xlim([0 2191])
ylim ([0 10])
grid on
xlabel ('Hours')
ylabel ('ESCR')
legend ('Wind - Bus 35','Wind - Bus 38','Solar - Bus 36','Location','southeast')

subplot(2,2,3)
plot(results_ESCR(2190*2+1:(2190*3),1),'.')
hold on
plot(results_ESCR(2190*2+1:(2190*3),2),'.')
plot(results_ESCR(2190*2+1:(2190*3),3),'.')
title ('ESCR: 3^{rd} quarter ')
xlim([0 2191])
ylim ([0 10])
grid on
xlabel ('Hours')
ylabel ('ESCR')
legend ('Wind - Bus 35','Wind - Bus 38','Solar - Bus 36','Location','southeast')


subplot(2,2,4)
plot(results_ESCR(2190*3+1:(2190*4),1),'.')
hold on
plot(results_ESCR(2190*3+1:(2190*4),2),'.')
plot(results_ESCR(2190*3+1:(2190*4),3),'.')
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
