% If the second argument is "true" (which is the default), then the sphere
% is transparent. Else it is opaque, which can make it less visually
% confusing while manually rotating.

function Plot3D(R, TRANSPARENT_SPHERE, fig_title)

if nargin < 2
	TRANSPARENT_SPHERE = true;
end

if nargin < 3
	fig_title = '';
	% If no title is given, assume we are just creating a single sphere
	% plot, and open a new Figure window.
	figure;
end

SAMP_RATE=500;
N = size(R,3);
T = (1:N)/SAMP_RATE;

STEP = 1:5:N;  % Plot every 5th sample for Sphere Plots.

cla;
[X,Y,Z] = sphere(20);

% Plot an initial empty "sphere" framework, against which we can more
% easily visualize the vector endpoints.
if TRANSPARENT_SPHERE
	surf(X,Y,Z, 'facecolor', 'none'); % Sphere is "see-through"
else
	surf(X,Y,Z, 'facecolor', [1 1 1]); % Sphere is opaque.
end

hold on

% Now plot the Forehead vector endpoint data, in three different colors,
% depending on distance from upright.

% Blue when vector is close to upright.
plot3(squeeze(R(1,3,STEP)), squeeze(R(2,3,STEP)), squeeze(R(3,3,STEP)), '.','markersize', 2)

% YELLOW for values of Z (i.e., R(3,3,:)) below first threshold.
ZLOW1 = R(3,3,:) < 0.4;
plot3(squeeze(R(1,3,ZLOW1)), squeeze(R(2,3,ZLOW1)), squeeze(R(3,3,ZLOW1)), '.', 'markersize', 2, 'color', [1 0.6 0.3]);

% RED for negative values of Z, which are below the sphere mid-line.
ZLOW2 = R(3,3,:) < 0;
plot3(squeeze(R(1,3,ZLOW2)), squeeze(R(2,3,ZLOW2)), squeeze(R(3,3,ZLOW2)), '.', 'markersize', 2, 'color', [1 0 0]);

hold off

title(fig_title, 'interpreter', 'none', 'FontSize', 18);

xlabel('X axis');
ylabel('Y axis');
zlabel('Z axis');
axis equal
view(150, 30);  % Use azimuth, eleveation.

end
