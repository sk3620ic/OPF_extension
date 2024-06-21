function [loadprofile_out,windprofile1,windprofile2,solarprofile] = make_profiles(modified)
%MAKE_PROFILES Load generation and demand profiles
%   
%   [loadprofile_out,windprofile1,windprofile2,solarprofile] = make_profiles(modified)
%
%   If original profiles needed, set input to FALSE. If modified (feasible)
%   profiles are needed, set input to TRUE.

loadprofile = importloadprofile('Residential.csv');
maximum = max(loadprofile);
loadprofile = loadprofile./maximum;
clear maximum
solarprofile = importsolar('solar202.csv');
windprofile432 = importwind('wind432');
windprofile451 = importwind('wind451');
    
if modified
    load('problem_indices.mat');
    load('problem_indices2.mat');
    load('problem_indices3.mat');
    load('problem_indices4.mat');
    load('problem_indices5.mat');
    load('problem_indices6.mat');
    augment1 = zeros(8760,1);
    augment1(problem_indices) = 0.1;
    augment1(problem_indices2) = 0.2;
    augment1(problem_indices4) = 0.325;
    augment1(problem_indices5) = augment1(problem_indices5) + 0.05;
    augment1(problem_indices6) = augment1(problem_indices6) + 0.04;
    augment1(4084) = augment1(4084) - 0.04;
    windprofile1 = windprofile432 + augment1;
    windprofile2 = windprofile451 + augment1;
    
    augment2 = zeros(8760,1);
    augment2(problem_indices3) = 0.1;
    augment2(problem_indices4) = 0.125;
    augment2([4361;5033]) = 0.16;
    loadprofile_out = loadprofile - augment2;
else
    loadprofile_out = loadprofile;
    windprofile1 = windprofile432;
    windprofile2 = windprofile451;
end

