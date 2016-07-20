function [ fh ] = PlotPRNElevation( Results )
%% Plot the available PRN
fh = figure;
colors = {'.k','.b','.g','.r','.c','.m','.y'};
s =subplot(2,1,1);
hold on;grid on;

for i = 1:32
    % check the valid PRNs
    checkPRN = reshape(Results.lssVector(i,1,:), 1, length(Results.lssVector));
    data = ~isnan(checkPRN)*i;
    idx = (data==0);
    data(idx) = nan;
    
    %plot PRNs with time
    j = mod(i,length(colors));
    if j == 0
        j = length(colors);
    end
    plot(Results.timeHours-Results.timeHours(1), data, colors{j});
end
ax = gca;
ax.YTick = 0:1:32;
ylim([0 32]);
xlabel('Time (h)');
xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
y=ylabel('PRN');
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
title(['Filename: ' Results.fileStrTitles ', Available PRNs: ', num2str(Results.Time(1),'%0.0f'), ' - ' , num2str(Results.Time(end),'%0.0f'), ' sec']);


%% Plot the Elevation Angle as a function of time over all PRN's
subplot(2,1,2);
hold on;grid on;
minThreshold = 0;
for i = 1:32
%    check the valid PRNs
    checkPRN = reshape(Results.lssVector(i,1,:), 1, length(Results.lssVector));
    data = ~isnan(checkPRN)*i;
    idx = (data==0);
    data(idx) = nan;
    
    dataIndex = ~isnan(data);
%   Get Position data for indexes where the current PRN is available
    satPos =  [reshape(Results.lssVector(i,9,dataIndex), length(Results.lssVector(dataIndex)),1) reshape(Results.lssVector(i,10,dataIndex),length(Results.lssVector(dataIndex)),1) reshape(Results.lssVector(i,11,dataIndex),length(Results.lssVector(dataIndex)),1)];  % Pos Sat
    rcvPos = [Results.X(dataIndex) Results.Y(dataIndex) Results.Z(dataIndex)];
%   Set Variables
    Elev = nan(length(satPos),1);
    Azumith = nan(length(satPos),1);
%   Get Elevation and Azumith
    for j = 1:length(satPos)
        [Elev(j),Azumith(j)] = Calc_Azimuth_Elevation(rcvPos(j,:),satPos(j,:));
    end
    Elev = Elev*180/pi; %convert to degrees
%%%%%%%%%%%%%%%%%%%%%% Plot Data and Legend %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    j = mod(i,length(colors));
    if j == 0
        j = length(colors);
    end
    plot(Results.timeHours(dataIndex)-Results.timeHours(1), Elev, colors{j});
    if ~isempty(Elev)
        indexBelowThres = find(Elev <= minThreshold);
        if ~isempty(indexBelowThres)
            minThresholdvector = i*ones(length(indexBelowThres),1);
            outageHandle = plot(s,Results.timeHours(indexBelowThres)-Results.timeHours(1),minThresholdvector,'or','MarkerSize',10);
%             legend(outageHandle, 'Below 0 degrees');
        end
    end
%     Legend{i}=strcat('PRN Number', num2str(i));
end
 xlabel('Time (h)');
 xlim([0 (Results.timeHours(end) - Results.timeHours(1))]);
 ylim([0 90]);
 y=ylabel('Elevation Angle [degrees]');
 set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
 
 %--------Include version number, git, compiler in plot--------------------
ylimit=get(gca,'YLim');
xlimit=get(gca,'XLim');
info = sprintf('%s\n%s\n%s',Results.metadata{2},Results.metadata{3},Results.metadata{4});
text(xlimit(2),ylimit(1),info,...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','right','Interpreter','none');
samexaxis('join','yld',0.75);
 
 


end

