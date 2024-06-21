function Zrow = make_constraint(gen_idx,n,Zbus,WFvector,WFbus)
%MAKE_CONSTRAINT Build one row of the stability constraint matrix A
%   To build one row of the stability constraint matrix A, need to take as
%   inputs the mpc object, the bus impedance matrix Zbus, the WFvector that
%   contains all the bus indexes that contain a wind farm and WFbus, which
%   is the wind generator bus for which this constraint is calculated.

Zrow = zeros(1,n);
for i = 1:n
    if any(gen_idx(i) == WFvector)
        Zrow(1,i) = abs(Zbus(WFbus,gen_idx(i)));
    end
end

end

