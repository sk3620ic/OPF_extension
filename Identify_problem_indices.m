%% Used only in identifying problematic indices in load and generation profiles
problem_indices = 0;
for i=1:8760
    if results_IBRmix(i) == -1
        if problem_indices == 0
            problem_indices = i;
        else
            problem_indices(end+1,1) = i;
        end
    end
end

if problem_indices==0
    disp('No problems')
else
    loadgen_check = [loadprofile_modified(problem_indices), solarprofile(problem_indices), windprofile1(problem_indices), windprofile1(problem_indices)];
end