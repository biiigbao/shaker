function flag = isoverlap(particle, neighbors, box)
%ISOVERLAP Returns true value if there is an overlap.
%   Detailed explanation goes here

rmol = particle.r;
rmin = 2 + delta;

% For now assume there is no overlaps.
flag = 0;

% Positions of image spheres.
rbottom = [rmol(1); rmol(2); -rmol(3)];
rtop = [rmol(1); rmol(2); 2 * H - rmol(3)];
if norm(rbottom - rmol) < rmin || norm(rtop - rmol) < rmin
    flag = 1;
    return
end
    
for i = 1:length(neighbors)
    neighbor = neigbors(i);
    if dist(particle, neighbor, box) < rmin;
        flag = 1;
        break
    end
end

