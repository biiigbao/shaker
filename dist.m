function d = dist(ri, rj, box)
%DIST Calculates distance between particles.
%   d = dist(ri, rj, box) calculates distance d between two points which
%   conforms minimum image convention.

rij = rj - ri;
rij = rij - [box(1); box(2); 0.0] .* fix(2.0 * rij ./ box);
d = norm(rij);
end