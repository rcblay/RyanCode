function [ fh ] = PlotVelocityHist( Results )
%% Histogram X,Y,Z Velocities
nbins = 100;
%-----Get indexes where there is a position solution----------------------
dataIndex = (Results.validPos ~= 0);
%% -----Get indexes where there is outages----------------------------------
dataIndex1 = (Results.validPos == 0);
outages = Results.timeHours(dataIndex1)-Results.timeHours(1);
x = zeros(1,length(outages));
fh = figure;
%% -------Plot X vel and outages on same subplot----------------------
subplot(3,1,1)
maxThreshold = 15;
minThreshold = -15;
edges = [minThreshold:((abs(maxThreshold)+abs(minThreshold))/nbins):maxThreshold];
hold on
histogram(Results.Vx(dataIndex),edges,'FaceColor','b');
indexAboveThres = find(Results.Vx(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    histogram(maxThreshold,edges,'FaceColor','r');
end
indexBelowThres = find(Results.Vx(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    histogram(minThreshold,edges,'FaceColor','r');
end

%ylim([-100 100]);
y=ylabel('X Vel Samples');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;
hold off
titString = sprintf('%s%s\n%s','Filename: ', Results.fileStrTitles, 'Histogram of X,Y,Z Velocities for Dynamic Data');
title(titString);
%% ------------plot Y Vel in next subplot--------------------------------------
subplot(3,1,2)
maxThreshold = 15;
minThreshold = -15;
edges = [minThreshold:((abs(maxThreshold)+abs(minThreshold))/nbins):maxThreshold];
hold on
histogram(Results.Vy(dataIndex),edges,'FaceColor','b');
indexAboveThres = find(Results.Vy(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    histogram(maxThreshold,edges,'FaceColor','r');
end
indexBelowThres = find(Results.Vy(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    histogram(minThreshold,edges,'FaceColor','r');
end

y=ylabel('Y Vel Samples');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;
hold off
%% -----------plot Z Vel in next subplot--------------------------
subplot(3,1,3)
maxThreshold = 15;
minThreshold = -15;
edges = [minThreshold:((abs(maxThreshold)+abs(minThreshold))/nbins):maxThreshold];
hold on
histogram(Results.Vz(dataIndex),edges,'FaceColor','b');
indexAboveThres = find(Results.Vz(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    histogram(maxThreshold,edges,'FaceColor','r');
end
indexBelowThres = find(Results.Vz(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    histogram(minThreshold,edges,'FaceColor','r');
end

y=ylabel('Z Vel Samples');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
xlabel('Velocity [m/s]');
grid on;
hold off

%--------Include version number, git, compiler in plot--------------------
ylimit=get(gca,'YLim');
xlimit=get(gca,'XLim');
info = sprintf('%s\n%s\n%s',Results.metadata{2},Results.metadata{3},Results.metadata{4});
text(xlimit(2),ylimit(1),info,...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','right','Interpreter','none');

samexaxis('join','yld',0.75);
%----------JOIN subplots and set the ylabels closer to the plots to see
%them better-------------------------------------------------------------





end

