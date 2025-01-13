
% Pull the data out of the Probability Density figure, which has all the
% traces of the swim "Distance from Upright" for all the mice. Plot the
% weighted average of each trace as a dot on the same X axis.

if ~startsWith(gca().XLabel.String, 'Distance from')
	error('Please use the mouse to click/select the original Probability figure before running this script!!');
	return;
end

F_orig = gcf;
LL = findobj(F_orig, 'Type', 'Line');  % Get all the figure lines.
vals = [];

title('Probability Density with Weighted Means');

for i = 1:length(LL)
	L = LL(i);
	line(L.XData, L.YData, 'color', L.Color);

	X = L.XData;
	Y = L.YData;

	% We want to divide by the total sum of the probabilities, since in a
	% proper probability distribution, they should sum to exactly 1.00.
	% This then gives us simply a weighted average.
	val = dot(X, Y) ./ sum(Y);

	ismutant = L.Color(1) > 0.1;
	if ismutant; mstr = 'M'; else; mstr = ' '; end
	%fprintf('%2d %s %.1f sum(Y) %5.2f\n', i, mstr, val, sum(Y));

	vals(i).val = val;
	vals(i).ismut = ismutant;
end

% Grey filled box
THRESH = 30;
v1 = gca().YLim(2) * 0.84;
v2 = gca().YLim(2) * 0.96;

try
	% Older versions of Matlab don't support FaceAlpha, and newer versions
	% apparently do not support an alpha value as the 4th color element, so
	% we try FaceAlpha first, then fall back to putting Alpha as the 4th
	% color value.
	rectangle('position', [12 v1 50 (v2-v1)], 'edgecolor', 'none', ...
		'facecolor', 0.7*[1 1 1], 'FaceAlpha', 0.3);
catch
	% Fall back to putting alpha 0.3 as the 4th facecolor element.
	rectangle('position', [12 v1 50 (v2-v1)], 'edgecolor', 'none', ...
		'facecolor', [0.7 0.7 0.7 0.3]);
end

% Add weighted mean dots to the probability distribution figure.
vert = gca().YLim(2) * 0.9; % Place dots near top of line plot.
for i=1:length(vals)
	if vals(i).ismut; color = [1 0.3 0.3]; else; color = [0 0.5 0.8]; end
	line(vals(i).val, vert, 'linestyle', 'none', 'marker', '.', 'markersize', 20, 'color', color);
end

ax = gca;
ax.YLim(1) = 0;

text('units', 'normalized', 'position', [0.35 0.9], 'string', ...
	{'Weighted Average of each trial', 'Threshold line at 30 degrees'})

% Draw a little vertical line at X=30 to show the threshold.
line([THRESH THRESH], [v1 v2], 'color', [1 1 1]*0.3, 'linewidth', 3, 'marker', 'none');
