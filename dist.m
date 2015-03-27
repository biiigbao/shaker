function d = dist(ri, rj, box)
%DIST Calculates distance between particles.
%   d = dist(mi, mj, box) calculates distance d between two particles in with

rij = rj - ri;
rij = rij - box .* fix(rij ./ box);
d = norm(rij);
end