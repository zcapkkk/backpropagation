%back beam 2; cleaning
close all;

% add path to find function scripts
addpath('./Functions');


lambda = 1e-3;
k0 = 2*pi/lambda;
L = 200e-3;
M = 4096;
dx = L/M;
z = 20e-3;
x = dx*(-M/2:M/2-1);
y = dx*(-M/2:M/2-1);
[X, Y] = meshgrid(x, y);


x_angle = -35;
y_angle = -35;


xshift = fix(z*tand(x_angle)/dx);
yshift = fix(z*tand(y_angle)/dx);
ri = 1*lambda;

% perf = sin(k0*sqrt(X.^2+Y.^2))./(k0*sqrt(X.^2+Y.^2));
perf = zeros(M);
perf(M/2, M/2) = 1;
perf = circshift(perf, [yshift xshift]);
focal_center = [xshift*dx/1e-3 yshift*dx/1e-3];

u1 = perf;


u0 = backpropTF(u1, L, lambda, z);
u0(X.^2+Y.^2>(6e-3)^2) = 0;
u1 = propTF(u0, L, lambda, z);

figure;
subplot(121);
imagesc(x/1e-3, y/1e-3, abs(perf));
title("Amplitude of focal plane");
axis square;
colormap jet;

subplot(122);
imagesc(x/1e-3, y/1e-3, angle(u0));
title("Phase of antenna plane");
axis square;
colormap jet;

figure;
imagesc(x/1e-3, y/1e-3, scaleabs(u1.^2));
hold on;
viscircles([0 0], 6, 'Color', 'magenta');
viscircles(focal_center,ri/1e-3, 'Color', 'blue');
hold off;
title("Resultant Amplitude of Focal Plane");
colorbar;
axis square;
colormap jet;


%% Image processing

info = regionprops(imbinarize(scaleabs(u1.^2)), 'MajorAxisLength', 'MinorAxisLength','Orientation', 'Centroid');
majorA = info.MajorAxisLength*dx;
minorA = info.MinorAxisLength*dx;
ora = info.Orientation;

clear perf u1;
perf = zeros(M);
perf((X/minorA).^2+(Y/majorA).^2 < 1) = 1;
perf = imrotate(perf, ora, 'bilinear', 'crop'); 
perf = circshift(perf, [yshift xshift]);
u1 = perf;


u0 = backpropTF(u1, L, lambda, z);
u0(X.^2+Y.^2>(6e-3)^2) = 0;
u1 = propTF(u0, L, lambda, z);

figure;
subplot(121);
imagesc(x/1e-3, y/1e-3, abs(perf));
hold on;
viscircles(focal_center,ri/1e-3, 'Color', 'blue');
hold off;
title("Altered focal plane");
axis square;
colormap jet;

subplot(122);
imagesc(x/1e-3, y/1e-3, angle(u0));
title("Altered antenna plane");
axis square;
colormap jet;

figure;
imagesc(x/1e-3, y/1e-3, scaleabs(u1.^2));
hold on;
viscircles([0 0], 6, 'Color', 'magenta');
viscircles(focal_center,ri/1e-3, 'Color', 'blue');
hold off;
title("Resultant focal plane due to alter");
colorbar;
axis square;
colormap jet;
