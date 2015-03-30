function [counts, centers] = rdf(particles, box, res)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dmax = min(box) / 2;
npart = length(particles);
dists = -ones(1, npart * (npart - 1) / 2);
idx = 1;
for i = 1:npart-1
    for j = i:npart
        if i ~= j
            dij = dist(particles(i).r, particles(j).r, box);
            if dij < dmax;
                dists(idx) = dij;
                idx = idx + 1;
            end
        end
    end
end

dr = (dmax - 2) / res;
bins = 2 + (0:res-1) * dr + 0.5 * dr;
dists = dists(dists > -1);
[counts, centers] = hist([dists, dists], bins);
counts = counts / (sum(counts) * dr);
end

