function map = readparams(file)
%READPARAMS Read simulation parameters from an external file.
%   m = readparams(file) creates a map m between parameters names and their
%   values read from an external file.
%
%   It assumes that file content looks similar to
%       <name>, <value>
%   where <name> is a string representing parameter's name and <value> is
%   a representation of any valid MATLAB "constant literal" (e.g. skalar,
%   vector, etc.).

if exist(file, 'file') ~= 2
    error('File %s does not exists.', file)
end
p = importdata(file, ',', 0);
map = containers.Map(p.textdata, p.data);
end

