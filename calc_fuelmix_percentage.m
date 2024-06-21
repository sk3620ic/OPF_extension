function [IBRmix, Total_gen] = calc_fuelmix_percentage(results,WFvector)
%CALC_FUELMIX_PERCENTAGE Summary of this function goes here
%   Detailed explanation goes here
Sbase = results.baseMVA;
P = results.var.val.Pg .* Sbase;
Total_gen = sum(P);

Total_IBR_gen = 0;
for i=1:length(WFvector)
    Total_IBR_gen = Total_IBR_gen + P(WFvector(i) - 29);
end

IBRmix = 100 * Total_IBR_gen/Total_gen;

end

