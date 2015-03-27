function positions = shake(lattice, parameters)
%SHAKE Randomizes positons of the particles.
%   shake(lattice) uses Monte Carlo method to randomize positions of the
%   sphere which initially were arranged in some crystalline structure.

% Initial length of neighbor list. It will be automatically extended if
% necesseery, so I don't see a point to make it an adjustable parameter for
% now.
nneigh = 12;

dmax = parameters.dmax;
ratiomin = parameters.acceptmin;
ratiomax = parameters.acceptmax;

npart = lattice.npart;
part.r = [0; 0; 0];
part.neighbors = -ones(1, nneigh);
particles = repmat(part, 1, npart);
for i = 1:npart
    particles(i).r = lattice.positions(:, i);
end

box = lattice.box;

% Initialize neighbor list for each particle.
findneigh(particles, box, parameters.rcut);        

accepted = 0.0;
total = 0.0;
ratio = 0.0;
ncycles = 0;
while (ratio < ratiomin || ratio > ratiomax || ncycles == parameters.maxcycles)
    for i = 1:npart
        p = particles(i);
        
        % Generate new tentative position.
        p.r = p.r + dmax * (1 - 2 * rand(3, 1));
   
        % Apply periodic boundary conditions along x, y (but NOT z)
        % directions.
        p.r = p.r - [box(1); box(2); 0] .* fix(p.r ./ box);
        
        % Accept new position if it doesn't lead to overlaps with its
        % neighbors and walls.
        neighbors = particles(p.neighbors(p.neighbors > 0));
        assert(~isempty(neighbors));
        if ~isoverlap(p, neighbors, box)
            particles(i) = p;
            accepted = accepted + 1;
        end
        
        total = total + 1;
    end
    
    % Adujst maximal displcement if the acceptance ratio is out of bounds.
    ratio = accepted / total
    if ratio < parameters.acceptmin
        dmax = 0.99 * dmax;
    end
    if ratio > parameters.acceptmax
        dmax = 1.01 * dmax;
    end
    
    % Update neighbor list periodically.
    if mod(ncycle, parameters.nupdate) == 0
        for i = 1:n
            particles(i).neighbors = -ones(1, m);
        end
        find_neigbors(particles);
        
        % Reset counters.
        accepted = 0.0;
        total = 0.0;
        ratio = 0.0;
    end
    
    ncycles = ncycles + 1;
end

positions = zeros(3, npart);
for i = 1:npart
    positions(:, i) = particles(i).r;
end

end