function [ fh ] = PlotSigParams( Results )
%% dt / #SVs / HDOP
%-----Get indexes where there is a position solution----------------------
dataIndex = (Results.validPos ~= 0);
%-----Get indexes where there is outages----------------------------------
dataIndex1 = (Results.validPos == 0);
outages = Results.timeHours(dataIndex1)-Results.timeHours(1);
x = zeros(1,length(outages));
fh = figure;
%-------Plot height error and outages on same subplot----------------------
subplot(4,1,1)
maxThreshold = 150;
minThreshold = -150;
hold on
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.pos_enu(dataIndex,5),'.b','MarkerSize',18);
indexAboveThres = find(Results.pos_enu(dataIndex,5) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    plot(Results.timeHours(indexAboveThres)-Results.timeHours(1),maxThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
indexBelowThres = find(Results.pos_enu(dataIndex,5) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    plot(Results.timeHours(indexBelowThres)-Results.timeHours(1),minThreshold,'.r','MarkerSize',18);
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
if ~isempty(outages)
outageHandle = plot(outages,x, 'or','MarkerSize',10);
legend(outageHandle, 'Outages');
end

%ylim([-100 100]);
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('Height Error (m)');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;
hold off
title(['Filename: ' Results.fileStrTitles]);
%------------plot dt in next subplot--------------------------------------
subplot(4,1,2)
maxThreshold = 400;
minThreshold = -400;
hold on;
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.dt(dataIndex),'.g','MarkerSize',18);
% axis tight 
%ylim([-100 100]);
indexAboveThres = find(Results.dt(dataIndex) >= maxThreshold);
if ~isempty(indexAboveThres)
    maxThreshold = maxThreshold*ones(length(indexAboveThres),1);
    plot(Results.timeHours(indexAboveThres)-Results.timeHours(1),maxThreshold,'.r','MarkerSize',18)
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
indexBelowThres = find(Results.dt(dataIndex) <= minThreshold);
if ~isempty(indexBelowThres)
    minThreshold = minThreshold*ones(length(indexBelowThres),1);
    plot(Results.timeHours(indexBelowThres)-Results.timeHours(1),minThreshold,'.r','MarkerSize',18)
    ylim([minThreshold(1)-1 maxThreshold(1)+1]);
end
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('dt (m)');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
grid on;
hold off;
%-----------plot # of satellites in next subplot--------------------------
subplot(4,1,3)
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.numSat(dataIndex),'k*');
axis tight; %ylim([0 14]);
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
ylabel('#SVs');
grid on;
%-----------plot HDOP in next subplot -----------------------------------
subplot(4,1,4)
plot(Results.timeHours(dataIndex)-Results.timeHours(1), Results.HDOP(dataIndex), '.r','MarkerSize',18);
% axis tight;%ylim([0 10]);
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('HDOP');
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

