function findneigh(mols, box, rcut)
%FINDNEIGH Populates particles' neigbors lists.

nmols = length(mols);
for i = 1:nmols;
    k = 1;
    nmax = length(mols(i).neighbors);
    for j = 1:nmols
        if j ~= i && dist(mols(i).r, mols(j).r, box) < rcut
            if k > nmax
                mols(i).neighbors = [mols(i).neighbors, -ones(1, nmax)];
                k = nmax + 1;
                nmax = length(mols(i).neighbors);
            end
            mols(i).neighbors(k) = j;
            k = k + 1;
        end
    end
end

end