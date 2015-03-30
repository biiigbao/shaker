function parts = findneigh(parts, box, rcut)
%FINDNEIGH Populates particles' neigbors lists.

nparts = length(parts);
for i = 1:nparts;
    k = 1;
    nmax = length(parts(i).neighbors);
    for j = 1:nparts
        if j ~= i && dist(parts(i).r, parts(j).r, box) < rcut
            if k > nmax
                parts(i).neighbors = [parts(i).neighbors, -ones(1, nmax)];
                k = nmax + 1;
                nmax = length(parts(i).neighbors);
            end
            parts(i).neighbors(k) = j;
            k = k + 1;
        end
    end
end

end