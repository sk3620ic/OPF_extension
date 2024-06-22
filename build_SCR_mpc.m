function [mpc_ext,A,u] = build_SCR_mpc(mpc,WFvector,SCR,IBRcapability)
%BUILD_A Build the stability constraint matrix A
%   Detailed explanation goes here



gen_idx = mpc.gen(:,1);
n = length(gen_idx);
n_WF = length(WFvector);

if nargin<4
    IBRcapability = ones(1,n_WF);
end

[Ybus, ~, ~] = makeYbus(mpc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pload = mpc.bus(:,3);
Qload = mpc.bus(:,4);
Yloads = (Pload - 1j*Qload)./(mpc.baseMVA);
Yloads = sparse(diag(Yloads));
Ybus = Ybus+Yloads;

Xsubtran = ones(10,1)*0.18;
Xsubtran(1,1) = 0.28;
Prated = mpc.gen(:,9);
Xsubtran_pu = 1j.*(Xsubtran .* ((mpc.baseMVA*0.9)./Prated));
Ysubtran = [zeros(29,1); 1./Xsubtran_pu];

for i=1:n_WF
    Ysubtran(WFvector(i)) = 0;
end

Ysubtran = sparse(diag(Ysubtran));
Ybus = Ybus+Ysubtran;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Zbus = inv(Ybus);

Z = zeros(n_WF,n);
c = 1;
for i = 1:n
    if c <= n_WF
        if any(gen_idx(i) == WFvector)
            Z(c,i) = abs(Zbus(gen_idx(i),gen_idx(i)));
            c = c + 1;
        end
    else
        i = n;
    end
end

n_bus = length(mpc.bus(:,1));
paddingleft = sparse(n_WF, 2*n_bus);
paddingright = sparse(n_WF, n);

A = [paddingleft, sparse(Z), paddingright];

u = ones(n_WF,1) * (1/SCR);

l = zeros(n_WF,1);

mpc_ext = mpc;
mpc_ext.A = A;
mpc_ext.u = u;
mpc_ext.l = l;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mpc_ext.gen(:,5) = -mpc.gen(:,4)./2; %Allow reactive power absorption for all generators, half of reactive power production capability
mpc_ext.gen(:,10) = 50 .* ones(n,1); %Set minimum active power generation for all generators

IBRgencost = [2, 0, 0, 3, 0, 0, 0.1];
for i=1:n_WF
    if (i == n_WF)
        mpc_ext.gencost(WFvector(i) - 29, :) = [2, 0, 0, 3, 0, 0, 0.05]; %Set last IBR to have costs of a solar farm
    else
        mpc_ext.gencost(WFvector(i) - 29, :) = IBRgencost;
        mpc_ext.gencost(WFvector(i) - 29, :) = mpc_ext.gencost(WFvector(i) - 29, :) + [0, 0, 0, 0, 0, (1e-3)*i, 0];
    end
    mpc_ext.gen(WFvector(i) - 29, 10) = 0; % Allow 0 minimum active power production for IBRs
    mpc_ext.gen(WFvector(i) - 29, 9) = mpc_ext.gen(WFvector(i) - 29, 9) * IBRcapability(i); %Pmax
    mpc_ext.gen(WFvector(i) - 29, 4) = mpc_ext.gen(WFvector(i) - 29, 9) * 0.8; %Qmax
    mpc_ext.gen(WFvector(i) - 29, 5) = -mpc_ext.gen(WFvector(i) - 29, 9) * 0.8; %Qmin
end

end

