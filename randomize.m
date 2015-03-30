% Read parameters from an external file.
required = {
    'packing fraction', ...
    'minimal acceptance', 'maximal acceptance', ...
    'no. of cells in x', 'no. of cells in y', 'no. of cells in z', ...
    'maximal displacement', 'adjust frequency', 'update frequency', ...
    'dump frequency', 'cycle limit', 'cutoff radius'
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
geometry.ny = params('no. of cells in y');
geometry.nz = params('no. of cells in z');
phi = params('packing fraction');
lattice = makelatt(geometry, phi);

% Randomize positions of the sphers.
conditions.maxcycles = params('cycle limit');
conditions.nadjust = params('adjust frequency');
conditions.ndump = params('dump frequency');
conditions.nupdate = params('update frequency');
conditions.dmax = params('maximal displacement');
conditions.acceptmin = params('minimal acceptance');
conditions.acceptmax = params('maximal acceptance');
conditions.rcut = params('cutoff radius');

tic
positions = shake(lattice, conditions);
toc

% Dump the final configuration to an external file.
tab = positions';
save('config.dat', 'tab', '-ascii');
