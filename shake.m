function positions = shake(lattice, parameters)
%SHAKE Randomizes positons of the particles.
%   shake(lattice) uses Monte Carlo method to randomize positions of the
%   sphere which initially were arranged in some crystalline structure.

% Initial length of neighbor list. It will be automatically extended if
% necesseery, so I don't see a point to make it an adjustable parameter for
% now.
nneighs = 12;

dmax = parameters.dmax;

ratiomin = parameters.acceptmin;
ratiomax = parameters.acceptmax;

npart = lattice.npart;
part.r = [0; 0; 0];
part.neighbors = -ones(1, nneighs);
particles = repmat(part, 1, npart);
for i = 1:npart
    particles(i).r = lattice.positions(:, i);
end

box = lattice.box;

% Initialize neighbor list for each particle.
particles = findneigh(particles, box, parameters.rcut);        

acceptacc = 0.0;
totalacc = 0.0;
ratio = 0.0;
ncycles = 1;
while (ratio < ratiomin || ratio > ratiomax || ncycles == parameters.maxcycles)
    [particles, accepted] = makecycle(particles, box, dmax);
    acceptacc = acceptacc + accepted;
    totalacc = totalacc + npart;
    
    % Adujst maximal displcement if the acceptance ratio is out of bounds.
    if mod(ncycles, parameters.nadjust) == 0
        ratio = acceptacc / totalacc;
        if ratio < parameters.acceptmin
            dmax = 0.99 * dmax;
        end
        if ratio > parameters.acceptmax
            dmax = 1.01 * dmax;
        end
        
        % Reset counters.
        acceptacc = 0.0;
        totalacc = 0.0;
    end
    
    % Refresh neihbor lists from time to time.
    if mod(ncycles, parameters.nupdate) == 0    
        for i = 1:npart
            particles(i).neighbors = -ones(1, nneighs);
        end
        particles = findneigh(particles, box, parameters.rcut);
    end
    
    ncycles = ncycles + 1;
end

[ratio, dmax]

res = 100;
rdfvalues = zeros(1, res);
ndump = 0;

acceptacc = 0.0;
totalacc = 0.0;
for i = 1:parameters.maxcycles
    [particles, accepted] = makecycle(particles, box, dmax);
    acceptacc = acceptacc + accepted;
    totalacc = totalacc + npart;

    % Refresh neighbor lists from time to time.
    if mod(i, parameters.nupdate) == 0    
        for j = 1:npart
            particles(j).neighbors = -ones(1, nneighs);
        end
        particles = findneigh(particles, box, parameters.rcut);
    end
    
    % Collect data for RDF.
    if mod(i, parameters.ndump) == 0
        [values, centers] = rdf(particles, box, res);
        rdfvalues = rdfvalues + values;
        ndump = ndump + 1;
    end   
end

rdfcenters = centers;
rdfvalues = rdfvalues / ndump;
tab = [rdfcenters', rdfvalues'];
save('rdf.dat', 'tab', '-ascii');

positions = zeros(3, npart);
for i = 1:npart
    positions(:, i) = particles(i).r;
end

end


function [particles, accepted] = makecycle(particles, box, maxdisp)
%MAKECYCLE Attempts to randomly move each particle from its position.
%   [particles, accepted] = makecycle(particles, maxdisp) attempts to
%   randomly generate a new position for each particle within a cube with
%   edge length maxdisp centered on its current position.
%
%   It returns particles with updated positions and number of successful
%   attempts.

accepted = 0.0;
for i = 1:length(particles)
    p = particles(i);
        
    % Generate new tentative position.
    p.r = p.r + maxdisp * (1.0 - 2.0 * rand(3, 1));
        
    % Apply periodic boundary conditions along x, y (but NOT z) directions.
    %p.r = p.r - [box(1); box(2); 0.0] .* fix(2.0 * p.r ./ box);
    p.r = p.r - box .* fix(2.0 * p.r ./ box);
        
    % Accept new position if it doesn't lead to overlaps with its
    % neighbors and walls.
    neighbors = particles(p.neighbors(p.neighbors > 0));
    if isempty(neighbors)
        warning('Particle %d has no neighbors.', i);
    end
    if ~isoverlap(p, neighbors, box)
        particles(i) = p;
        accepted = accepted + 1;
    end
end

end