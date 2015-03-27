% Read parameters from an external file.
required = {
    'packing fraction', ...
    'minimal acceptance', 'maximal acceptance', ...
    'no. of cells in x', 'no. of cells in y', 'no. of cells in z', ...
    'maximal displacement', 'update frequency', 'cycle limit', ...
    'cut-off radius'
};
params = readparams('parameters.csv');
available = keys(params);
for i = 1:length(required)
    if strcmp(required{i}, available) == 0
        break
    end
end
if i ~= length(required)
    error('One or more required parameteres is missing: %s.', required{i});
end

% Generate fcc lattice of spheres with a given packing fraction.
geometry.nx = params('no. of cells in x');
geometry.ny = params('no. of cells in z');
geometry.nz = params('no. of cells in y');
phi = params('packing fraction');
lattice = makelatt(geometry, phi);

% Randomize positions of the sphers.
conditions.maxcycles = params('cycle limit');
conditions.nupdate = params('update frequency');
conditions.dmax = params('maximal displacement');
conditions.acceptmin = params('minimal acceptance');
conditions.acceptmax = params('maximal acceptance');
conditions.rcut = params('cut-off radius');
positions = shake(lattice, conditions);

% Dump the final configuration to an external file.
tab = positions';
save('config.dat', 'tab', '-ascii');
