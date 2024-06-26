function Wind = importwind(filename, dataLines)
%IMPORTFILE Import data from a text file
%  WIND432 = IMPORTFILE(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the numeric data.
%
%  WIND432 = IMPORTFILE(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 08-Jun-2024 20:27:31

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [5, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "VarName3"];
opts.SelectedVariableNames = "VarName3";
opts.VariableTypes = ["string", "string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2"], "EmptyFieldRule", "auto");

% Import the data
Wind = readtable(filename, opts);

%% Convert to output type
Wind = table2array(Wind);
end