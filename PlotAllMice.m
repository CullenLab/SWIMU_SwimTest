
% Each MAT file has an array of ALL of the R rotation matrix data, which is
% output from imufilter(), and converted from quaternion to matrix.

% Load the Heterozygous and Homozygous MAT data files from their respective
% subdirectories.
pathhet = 'Heterozygous';
pathhom = 'Homozygous';
filehet = {dir([pathhet '/*.mat']).name};
filehom = {dir([pathhom '/*.mat']).name};

%%

% Ignore warnings while adding data to the tables.
warning('off', 'MATLAB:table:RowsAddedExistingVars');
warning('off', 'MATLAB:table:RowsAddedNewVars');

% Load the rotation matrices (computed using imufilter()) for each data
% set.

% Create a 45 degree pitch rotation operator matrix to effectively give the
% "Forehead" vector. The matmult() matrix multiplication below applies this
% 45 degree rotation operator to each data point.
MR = matrot_x(45);

hetTabR=table();
homTabR=table();
for i = 1:length(filehet)
    het{i} = matmult(load(fullfile(pathhet, filehet{i})).R,MR);
    filHe{i}=filehet{i}(1:8);
end
for i = 1:length(filehom)
    hom{i} = matmult(load(fullfile(pathhom, filehom{i})).R,MR);
    filHo{i}=filehom{i}(1:8);
end

[ud,ix,iy]=unique(string(filHe'));
for i = 1:length(ud)
    temp=(het(string(filHe')==ud(i)))';
    hetTabR(ud(i),'R')={cat(3,temp{1:end})}; % inverted
    hetTabR(ud(i),'Squeezed')={squeeze(acosd(hetTabR.R{i}(3,3,:)))};
end
for i = 1:height(hetTabR)
    hetTabR(ud(i),'SqueezedSkew')={skewness(hetTabR.Squeezed{i})};
    hetTabR(ud(i),'SqueezedKurt')={kurtosis(hetTabR.Squeezed{i})};
end

[ud,ix,iy]=unique(string(filHo'));
for i = 1:length(ud)
    temp=(hom(string(filHo')==ud(i)))';
    homTabR(ud(i),'R')={cat(3,temp{1:end})}; % inverted
    homTabR(ud(i),'Squeezed')={squeeze(acosd(homTabR.R{i}(3,3,:)))};
end
for i = 1:height(homTabR)
    homTabR(ud(i),'SqueezedSkew')={skewness(homTabR.Squeezed{i})};
    homTabR(ud(i),'SqueezedKurt')={kurtosis(homTabR.Squeezed{i})};
end


%% Plot
ALL_names = [filehet filehom];
R_het = het;
R_hom = hom;
ALL_R = [R_het R_hom];

allhet = cat(3,het{:});
allhom = cat(3,hom{:});

figure(20);
HistPath(allhet,'het')
hold on
HistPath(allhom,'hom')
title('Positional Distribution','FontSize', 20)
legend({'Gpr156 +/-' 'Gpr156 -/-'},'Location','Northeast');

%% FIT DISTRIBUTIONS
% figure(21)
IDKO=categorical();
start=1;
temphet=hetTabR{:,2};
temphom=homTabR{:,2};
for i = 1:size(homTabR.Properties.RowNames,1)
    endf=start+size(temphom{i},1)-1;
    IDKO(start:endf,1)=homTabR.Properties.RowNames(i);
    start=endf+1;
end

IDCO=categorical();
start=1;
for i = 1:size(hetTabR.Properties.RowNames,1)
    endf=start+size(temphet{i},1)-1;
    IDCO(start:endf,1)=hetTabR.Properties.RowNames(i);
    start=endf+1;
end
[KerHom,IDs]=fitdist(vertcat(temphom{1:end}),'Kernel','by',IDKO);
[KerHet,IDss]=fitdist(vertcat(temphet{1:end}),'Kernel','by',IDCO);

x=0:0.1:180;

pdfHoms=[];
pdfHets=[];
for i = 1:size(KerHom,2)
    pdfHoms=[pdfHoms,pdf(KerHom{i},x)'];
end
for i = 1:size(KerHet,2)
    pdfHets=[pdfHets,pdf(KerHet{i},x)'];
end

figure(22)

titlestr=sprintf('PDF');
xlbl=sprintf('Distance from Upright (°)');
hold on

plot(x,mean(pdfHoms,2),'Color',[237 50 55]/255);
hold on
stdshade(pdfHoms',0.3,[237 50 55]/255,x);

plot(x,mean(pdfHets,2),'Color',[0 175 239]/255);
stdshade(pdfHets',0.3,[0 175 239]/255,x);

for i = 1:size(KerHom,2)
    m=plot(x,pdf(KerHom{i},x),'Color',[237 50 55]/255,'LineWidth',0.2);
    m.Color=[237/255,50/255,55/255,0.3];
end
for i = 1:size(KerHet,2)
    m=plot(x,pdf(KerHet{i},x),'Color',[0 175 239]/255,'LineWidth',0.2);
    m.Color=[0/255,175/255,239/255,0.3];
end
title(titlestr,'FontSize',16)
xlabel(xlbl)
xlim([min(x) max(x)])
box off
ax1=gca;
ax1.YAxis.Visible = 'off';  

% Add the Weighted Mean to the PDF figure, and create new figure.
AddWeightedMean();





% Plot the "path length" from the mouse Z vector, to the space/gravity/up Z
% vector. It's just essentially the acosd(Zz), the acos of the Z component
% of the mouse Z vector.
function HistPath(R,typez)

if typez == 'het'
    H = histogram(squeeze(acosd(R(3,3,:))), 0:5:180, 'normalization', 'probability','FaceColor',[0 175 239]/255);
else
    H = histogram(squeeze(acosd(R(3,3,:))), 0:5:180, 'normalization', 'probability','FaceColor',[237 50 55]/255);
end
xlim([0 180]);
ylim([0 0.2]);
xlabel('Distance from Upright (°)');
ylabel('Probability');
box off
grid off;
end

function bxPlot(Rhet,Rhom)
    x1=squeeze(acosd(Rhet(3,3,:)));
    x2=squeeze(acosd(Rhom(3,3,:)));
    groups = [ones(size(x2)); 2*ones(size(x1))];
    %H = boxplot([x2;x1],groups,'Labels',{'Gpr156-/-','Gpr156+/-'}, 'Colors',[[237 50 55]/255;[0 175 239]/255],'Orientation', 'horizontal','PlotStyle','compact','Symbol','');
    H = boxplot([x2;x1],groups,'Labels',{'Gpr156-/-','Gpr156+/-'}, 'Colors',[[237 50 55]/255;[0 175 239]/255],'PlotStyle','Compact','Symbol','');

    box off
    xlabel('Distance from Upright (°)','FontSize',14);
    ylim([0,180]);
end

% Plot the Z component of the Nose (-Y) and LeftEar (X) vectors.
% Plot in YELLOW or RED if the Z component of the Z vector gets too low.
function NoseEarEl(R)
plot(squeeze(-R(3,2,:)), squeeze(R(3,1,:)), '.', 'markersize', 1);

hold on

% YELLOW for values of Zz (i.e., R(3,3,:)) below first threshold.
ZLOW1 = R(3,3,:) < 0.4;
plot(squeeze(-R(3,2,ZLOW1)), squeeze(R(3,1,ZLOW1)), '.', 'markersize', 1, 'color', [1 1 0]);

% RED for values of Zz below second threshold.
ZLOW2 = R(3,3,:) < 0;
plot(squeeze(-R(3,2,ZLOW2)), squeeze(R(3,1,ZLOW2)), '.', 'markersize', 1, 'color', [1 0 0]);
hold off

xlabel('Nose Elevation');
ylabel('Left Ear Elevation');
axis equal
axis([-1 1 -1 1]);
grid on;
end

% Pass a function handle that does the desired plot.
% Loop over all 6 mice, and plot all in subplots of a single figure.
function PlotAll(ALL_R, ALL_names, FUNC)

for i=1:length(ALL_R)
	subplot(4,5,i);
	FUNC(ALL_R{i});
	title(ALL_names{i}, 'interpreter', 'none');
end
end
