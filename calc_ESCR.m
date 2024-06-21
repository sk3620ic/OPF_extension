function ESCR = calc_ESCR(results,WFvector)
%CALC_ESCR Summary of this function goes here
%   Detailed explanation goes here

gen_idx = results.gen(:,1);
n = length(gen_idx);
n_WF = length(WFvector);

[Ybus, ~, ~] = makeYbus(results);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pload = results.bus(:,3);
Qload = results.bus(:,4);
Yloads = (Pload - 1j*Qload)./(results.baseMVA);
Yloads = sparse(diag(Yloads));
Ybus = Ybus+Yloads;

Xsubtran = ones(10,1)*0.18;
Xsubtran(1,1) = 0.28;
Prated = results.gen(:,9);
Xsubtran_pu = 1j.*(Xsubtran .* (results.baseMVA./Prated));
Ysubtran = [zeros(29,1); 1./Xsubtran_pu];

for i=1:length(WFvector)
    Ysubtran(WFvector(i)) = 0;
end

Ysubtran = sparse(diag(Ysubtran));
Ybus = Ybus+Ysubtran;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Zbus = inv(Ybus);

Z = zeros(n_WF,n);
for i = 1:n_WF
    temp_row = make_constraint(gen_idx,n,Zbus,WFvector,WFvector(i));
    Z(i,:) = temp_row;
end

Sbase = results.baseMVA;
P = results.gen(:,2)/Sbase;
ESCR = 1./(Z*P);
end

