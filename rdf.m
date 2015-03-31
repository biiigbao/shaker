function [counts, centers] = rdf(particles, box, res)
%RDF Calculates radial distribution function.

npart = length(particles);

% Pre-allocate an  array for storing interparticle distances.
dists = zeros(1, npart * (npart - 1) / 2);

% Calculate distances between particles.
idx = 1;
for i = 1:npart-1
    for j = i+1:npart
        dists(idx) = dist(particles(i).r, particles(j).r, box);
        idx = idx + 1;
    end
end

% Discard any distances exceeding L/2, where L is the length of the
% shortest box edge.
dmax = min(box) / 2;
dists = dists(dists < dmax);

% Setup custom bin centers based on supplied resolution.
dr = (dmax - 2) / res;
bins = 2 + (0:res-1) * dr + 0.5 * dr;

[counts, centers] = hist([dists, dists], bins);
end