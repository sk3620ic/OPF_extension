%% Single iteration test

mpc = loadcase('case39');
IBRvector = [35,38,36];
ESCR = 2.3;

mpc.bus(:,3:4) = mpc.bus(:,3:4);
mpc_ext = build_SCR_mpc(mpc,IBRvector,ESCR);

% These lines remove stability constraints, keeping IBR  modifications
% mpc_ext = rmfield(mpc_ext,'l');
% mpc_ext = rmfield(mpc_ext,'u');
% mpc_ext = rmfield(mpc_ext,'A');

mpopt = mpoption;

% FMINCON is more reliable but a bit slower slower sometimes
mpopt.opf.ac.solver = 'FMINCON';

% Supress output print-outs with these two lines
% mpopt.verbose = 0;
% mpopt.out.all = 0;
results = runopf(mpc_ext,mpopt);
results_ESCR = calc_ESCR(results,IBRvector);
results_cost = results.f;
results_IBRmix = calc_fuelmix_percentage(results,IBRvector);
%% Sensitivity analysis - High Loading (1 p.u.), High CIG (1 p.u.)

tic

mpc = loadcase('case39');
IBRvector = [35,38,36];

ESCRmin = 1;
ESCRmax = 10;
step = 0.1;

mpopt = mpoption('verbose',0);
mpopt.out.all = 0;
mpopt.opf.ac.solver = 'MIPS';

i = 0;
ESCRvector = ESCRmin:step:ESCRmax;
N = length(ESCRvector);
n_gen = length(mpc.gen(:,1));
P = zeros(n_gen,N);
cost = zeros(1,N);
IBRmix = zeros(1,N);
for ESCR=ESCRmin:step:ESCRmax
    i = i + 1;
    mpc_ext = build_stability_mpc(mpc,IBRvector,ESCR);
    results = runopf(mpc_ext,mpopt);
    if results.success
        P(:,i) = results.var.val.Pg;
        cost(1,i) = results.f;
        IBRmix(1,i) = calc_fuelmix_percentage(results,IBRvector);
    else
        P(:,i) = -1 .* ones(n_gen,1);
        cost(1,i) = -1;
        IBRmix(1,i) = -1;
    end
end

toc


figure
hold on
for j=1:n_gen
    plot(ESCRvector,P(j,:),'x','LineWidth',1.3)
end
xlabel ('Minimum ESCR guaranteed')
ylabel ('Active Power [p.u.]')
title ('Active Power generated')
legend ('Hydro - 1040MW', 'Nuclear - 646MW', 'Nuclear - 725MW', 'Fossil - 652MW', 'Fossil - 508MW', 'Wind - 687MW', 'Solar - 580MW', 'Nuclear - 564MW', 'Wind - 865MW', 'Interconnection - 1100MW')
grid on
xlim([1 3.5])

figure
plot(ESCRvector,cost,'x','LineWidth',1.3)
xlabel ('Minimum ESCR requested')
ylabel ('Cost [$]')
title ('Total Generation Cost')
grid on
xlim([1 3.5])

figure
plot(ESCRvector,IBRmix,'x','LineWidth',1.3)
xlabel ('Minimum ESCR requested')
ylabel ('[%]')
title ('Percentage of generation coming from IBRs')
grid on
xlim([1 3.5])


%% Sensitivity analysis - Low Loading (0.2 p.u.), High CIG (1 p.u.)

tic

mpc = loadcase('case39');
IBRvector = [35,38,36];

mpopt = mpoption('verbose',0);
mpopt.out.all = 0;
mpopt.opf.ac.solver = 'FMINCON';

i = 0;
ESCRvector = ESCRmin:step:ESCRmax;
N = length(ESCRvector);
n_gen = length(mpc.gen(:,1));
P = zeros(n_gen,N);
cost = zeros(1,N);
IBRmix = zeros(1,N);

mpc.bus(:,3:4) = mpc.bus(:,3:4).*0.2; %Vary Load

for ESCR=ESCRmin:step:ESCRmax
    i = i + 1;
    mpc_ext = build_stability_mpc(mpc,IBRvector,ESCR);
    results = runopf(mpc_ext,mpopt);
    if results.success
        P(:,i) = results.var.val.Pg;
        cost(1,i) = results.f;
        IBRmix(1,i) = calc_fuelmix_percentage(results,IBRvector);
    else
        P(:,i) = -1 .* ones(n_gen,1);
        cost(1,i) = -1;
        IBRmix(1,i) = -1;
    end
end

toc


figure
hold on
for j=1:n_gen
    plot(ESCRvector,P(j,:),'x','LineWidth',1.3)
end
xlabel ('Minimum ESCR guaranteed')
ylabel ('Active Power [p.u.]')
title ('Active Power generated')
legend ('Hydro - 1040MW', 'Nuclear - 646MW', 'Nuclear - 725MW', 'Fossil - 652MW', 'Fossil - 508MW', 'Wind - 687MW', 'Solar - 580MW', 'Nuclear - 564MW', 'Wind - 865MW', 'Interconnection - 1100MW')
grid on

figure
plot(ESCRvector,cost,'x','LineWidth',1.3)
xlabel ('Minimum ESCR requested')
ylabel ('Cost [$]')
title ('Total Generation Cost')
grid on


figure
plot(ESCRvector,IBRmix,'x','LineWidth',1.3)
xlabel ('Minimum ESCR requested')
ylabel ('[%]')
title ('Percentage of generation coming from IBRs')
grid on

%% Sensitivity analysis - Medium Loading (0.5 p.u.), Low CIG (0.2 p.u.)

tic

mpc = loadcase('case39');
IBRvector = [35,38,36];

mpopt = mpoption('verbose',0);
mpopt.out.all = 0;
mpopt.opf.ac.solver = 'FMINCON';

i = 0;
ESCRvector = ESCRmin:step:ESCRmax;
N = length(ESCRvector);
n_gen = length(mpc.gen(:,1));
P = zeros(n_gen,N);
cost = zeros(1,N);
IBRmix = zeros(1,N);

mpc.bus(:,3:4) = mpc.bus(:,3:4) .* 0.5; %Vary Load

for ESCR=ESCRmin:step:ESCRmax
    i = i + 1;
    mpc_ext = build_stability_mpc(mpc,IBRvector,ESCR,0.2*ones(1, length(IBRvector)));
    results = runopf(mpc_ext,mpopt);
    if results.success
        P(:,i) = results.var.val.Pg;
        cost(1,i) = results.f;
        IBRmix(1,i) = calc_fuelmix_percentage(results,IBRvector);
    else
        P(:,i) = -1 .* ones(n_gen,1);
        cost(1,i) = -1;
        IBRmix(1,i) = -1;
    end
end

toc


figure
hold on
for j=1:n_gen
    plot(ESCRvector,P(j,:),'x','LineWidth',1.3)
end
xlabel ('Minimum ESCR guaranteed')
ylabel ('Active Power [p.u.]')
title ('Active Power generated')
legend ('Hydro - 1040MW', 'Nuclear - 646MW', 'Nuclear - 725MW', 'Fossil - 652MW', 'Fossil - 508MW', 'Wind - 687MW', 'Solar - 580MW', 'Nuclear - 564MW', 'Wind - 865MW', 'Interconnection - 1100MW')
grid on

figure
plot(ESCRvector,cost,'x','LineWidth',1.3)
xlabel ('Minimum ESCR requested')
ylabel ('Cost [$]')
title ('Total Generation Cost')
grid on


figure
plot(ESCRvector,IBRmix,'x','LineWidth',1.3)
xlabel ('Minimum ESCR requested')
ylabel ('[%]')
title ('Percentage of generation coming from IBRs')
grid on