function flag = isoverlap(particle, neighbors, box)
%ISOVERLAP Returns true value if there is an overlap.
%   isoverlap(particle, neighbors, box) returns true if the particle
%   overlaps with any of its neihbors or crosses any of electrodes.

% Set minimal allowed distance between two neighboring spheres. Parameter
% 'delta' 
delta = 0.0;
dmin = 2.0 + delta;

rmol = particle.r;

% For now assume there is no overlaps.
flag = 0;

% Check the distance between the particle and the closer electrode using
% image approach, i.e. by calulating the distance between the particle and 
% its "reflection" on the other side of an electrode.
rimg = rmol;
if rmol(3) > 0
    rimg(3) = box(3) - rmol(3);
else
    rimg(3) = -box(3) - rmol(3);
end
if norm(rimg - rmol) < dmin
    flag = 1;
    return
end

% Check if there are any overalaps with neighbors.
for i = 1:length(neighbors)
    if dist(rmol, neighbors(i).r, box) < dmin;
        flag = 1;
        break
    end
end

