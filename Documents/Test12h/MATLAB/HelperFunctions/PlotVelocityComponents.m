function [ fh ] = PlotVelocityComponents( Results )
%% Velocity X,Y,Z and DT Rate
%% -----Get indexes where there is a position solution----------------------
dataIndex = (Results.validPos ~= 0);
%% -----Get indexes where there is outages----------------------------------
dataIndex1 = (Results.validPos == 0);
outages = Results.timeHours(dataIndex1)-Results.timeHours(1);
x = zeros(1,length(outages));
fh = figure;
%% -------Plot X vel and outages on same subplot----------------------
subplot(4,1,1)
maxThreshold = 150;
minThreshold = -150;
hold on
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.Vx(dataIndex),'.b','MarkerSize',18);
indexAboveThres = find(Results.Vx(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    plot(Results.timeHours(indexAboveThres)-Results.timeHours(1),maxThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
indexBelowThres = find(Results.Vx(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    plot(Results.timeHours(indexBelowThres)-Results.timeHours(1),minThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
if ~isempty(outages)
outageHandle = plot(outages,x, 'or','MarkerSize',10);
legend(outageHandle, 'Outages');
end

title(['Filename: ' Results.fileStrTitles]);
%ylim([-100 100]);
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('X Vel [m/s]');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;
hold off
%% -------Plot Y vel----------------------
subplot(4,1,2)
maxThreshold = 150;
minThreshold = -150;
hold on
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.Vy(dataIndex),'.b','MarkerSize',18);
indexAboveThres = find(Results.Vy(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    plot(Results.timeHours(indexAboveThres)-Results.timeHours(1),maxThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
indexBelowThres = find(Results.Vy(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    plot(Results.timeHours(indexBelowThres)-Results.timeHours(1),minThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end

%ylim([-100 100]);
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('Y Vel [m/s]');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;
hold off
%% -------Plot Z vel----------------------
subplot(4,1,3)
maxThreshold = 150;
minThreshold = -150;
hold on
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.Vz(dataIndex),'.b','MarkerSize',18);
indexAboveThres = find(Results.Vz(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    plot(Results.timeHours(indexAboveThres)-Results.timeHours(1),maxThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
indexBelowThres = find(Results.Vz(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    plot(Results.timeHours(indexBelowThres)-Results.timeHours(1),minThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end

%ylim([-100 100]);
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('Z Vel [m/s]');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;
hold off

%% -----------plot DT Rate in next subplot -----------------------------------
subplot(4,1,4)
maxThreshold = 300;
minThreshold = -300;
hold on;
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.dtRate(dataIndex),'.r','MarkerSize',18);
% axis tight 
%ylim([-100 100]);
indexAboveThres = find(Results.dtRate(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    plot(Results.timeHours(indexAboveThres)-Results.timeHours(1),maxThreshold,'.r','MarkerSize',18)
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
indexBelowThres = find(Results.dtRate(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    plot(Results.timeHours(indexBelowThres)-Results.timeHours(1),minThreshold,'.r','MarkerSize',18)
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('dt Rate');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;

%--------Include version number, git, compiler in plot--------------------
ylimit=get(gca,'YLim');
xlimit=get(gca,'XLim');
info = sprintf('%s\n%s\n%s',Results.metadata{2},Results.metadata{3},Results.metadata{4});
text(xlimit(2),ylimit(1),info,...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','right','Interpreter','none');
%----------JOIN subplots and set the ylabels closer to the plots to see
%them better-------------------------------------------------------------
samexaxis('join','yld',0.75);
end

