function lattice = makelatt(geometry, phi)
%MKLATT Generates fcc lattice having a given packing fraction.
%   L, B = lattice(nx, ny, nz, phi) returns a matrix which columns
%   represent positions of fcc lattice with nx, ny, nz unit cells in x, y,
%   and z directions having packing fraction phi along with a column vector
%   represeting simulation box lengths.

% Generate an fcc lattice at close packing limit.
[positions, box] = fcc(geometry.nx, geometry.ny, geometry.nz);

% Adjust box size to ensure that in z direction spheres lie completely
% withing the simulation box.
box = box + [0; 0; 2 - sqrt(2)];

% Calculate packing fraction for adjusted box.
vsph = 4/3 * pi;
n = 4 * geometry.nx * geometry.ny * geometry.nz;
v0 = box(1) * box(2) * box(3);
phi0 = n * vsph / v0;

% Rescale lattice and box to achieve the target packing fraction.
c = (phi0 / phi)^(1/3);
lattice.positions = c * positions;
lattice.box = c * box;
lattice.npart = n;
end


function [lattice, box] = fcc(nx, ny, nz)
%FCC Generates fcc lattice at close packing limit.
%   L = lattice(nx, ny, nz) returns a matrix which columns represent
%   positions of closed-packed fcc lattice having nx, ny, and nz unit cells in
%   x, y, and z direction respectively.
%
%   Lattice's center of mass is put in the origin of the reference frame.

% Lattice constant when sphere radius is a unit length.
a = 2 * sqrt(2);

% Postions of atoms within a unit cell.
cell = zeros(3, 4);
cell(:, 1) = [0; 0; 0];
cell(:, 2) = 0.5 * [a; a; 0];
cell(:, 3) = 0.5 * [0; a; a];
cell(:, 4) = 0.5 * [a; 0; a];

lattice = zeros(3, 4 * nx * ny * nz);
m = 1;
for i = 0:nz-1
    for j = 0:ny-1
        for k = 0:nx-1
            for l = 1:length(cell)
                lattice(:, m) = a * [k; j; i] + cell(:, l);
                m = m + 1;
            end
        end
    end
end

% Put the center of mass in the origin of the reference frame.
rcm = sum(lattice , 2) / length(lattice);
lattice = bsxfun(@minus, lattice, rcm);

box = a * [nx; ny; nz];
end