%back beam
close all;
lambda = 1e-3;
k0 = 2*pi/lambda;
L = 50e-3;
M = 512;
dx = L/M;
z = 20e-3;
x = dx*(-M/2:M/2-1);
y = dx*(-M/2:M/2-1);
[X, Y] = meshgrid(x, y);

r = sqrt(X.^2 + Y.^2);

angle_offset = 30;
offset = z*tand(angle_offset);


u0 = exp(1i*k0*sqrt(X.^2+(Y+offset).^2+z^2));
u0(abs(y) > 6e-3, :) = 0;
u0(:, abs(x)>6e-3) = 0;

u1 = propTF(u0, L, lambda, z);

u0 = backpropTF(u1, L, lambda, z);

reu1 = propTF(u0, L, lambda, z);


figure;
subplot(131);
imagesc(x, y, abs(u1));
colorbar;
axis square;
colormap jet;

subplot(132);
imagesc(x, y, angle(u0));
colorbar;
axis square;
colormap jet;

subplot(133);
imagesc(x, y, abs(reu1));
colorbar;
axis square;
colormap jet;