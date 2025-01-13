
% Create 3D Sphere plots for all data sets, on two tabbed figures.

% Use a Tab Group to show several Sphere Plots on a single, tabbed figure
% window.

% Plot all Heterozogous data in one tabbed figure.
FIG = figure(30);
clf;
FIG.Name = 'Heterozygous (Unaffected) - Forehead Vector';
TG = uitabgroup(FIG);

%-------------------------------------------------
% Plot all Heterozygous data in one tabbed figure.
for fnum = 1:length(filehet)
	FNAME = filehet{fnum};
	R = R_het{fnum};

	TAB = uitab(TG, 'title', FNAME);
	AX = axes(TAB);

	Plot3D(R, false, FNAME);
end

% Set mouse scroll wheel callback, to switch between tabs easily.
set(FIG, 'WindowScrollWheelFcn', {@MouseScroll, TG})

%-------------------------------------------------
% Plot all Homozygous data in one tabbed figure.
FIG = figure(31);
clf;
FIG.Name = 'Homozygous (Affected) - Forehead Vector';
TG = uitabgroup(FIG);

for fnum = 1:length(filehom)
	FNAME = filehom{fnum};
	R = R_hom{fnum};

	TAB = uitab(TG, 'title', FNAME);
	AX = axes(TAB);

	Plot3D(R, false, FNAME);
end

% Set mouse scroll wheel callback, to switch between tabs easily.
set(FIG, 'WindowScrollWheelFcn', {@MouseScroll, TG})


%%
% Helper function to allow using mouse scroll wheel to move back and forth
% between tabs in the figure window.
function MouseScroll(obj, event, TG)

% Use mouse wheel to scroll between tabs.
wheel = event.VerticalScrollCount;          % wheel +1 or -1
Tnum = find(TG.SelectedTab == TG.Children); % current tab #
Ntab = length(TG.Children);

% Select new tab number, bounded by 1 and Ntabs.
Tnum = max(1, min(Ntab, Tnum - wheel));
TG.SelectedTab = TG.Children(Tnum);
end
