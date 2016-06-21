function [ fhArray ] = PlotIntervalPos( Results )
%% Plot Settings 
subplotWindow       = 3600;	% Time window for position solution within 1 subplot (s)
subCol              = 3;   	% Number of columns within 1 figure 
subRow              = 2;    % Number of rows within 1 figure
%% Plot the position results over smaller time intervals
% Calculate number of subplots needed to cover the entire dataset over the
% required subplot window
numSubFig = ceil((Results.Time(end)-Results.Time(1))/subplotWindow);
subplotCount = 1;
figCount = 1;

disp(['Plotting ', num2str(numSubFig), ' sub-figures']);

for j = 1:numSubFig
    if rem(j,subRow*subCol) == 1
    fhArray(figCount) = figure(100+figCount);
        subplotCount = 1;
        figCount = figCount + 1;
    end
%-----Find the index indicating the end of the current hour----------------
    dataIndexEnd = find(((Results.Time-Results.Time(1))>= subplotWindow + subplotWindow*(j-1)),1);
%-----Find the index indicating the beginning of the current hour----------
    dataIndexBeg = find(((Results.Time-Results.Time(1))>= subplotWindow*(j-1)),1);
%-----Update the data index------------------------------------------------    
    dataIndex = dataIndexBeg:dataIndexEnd;
%-----If near the end of the file, and the final subplot is not a full
%hour, set the index so that it just goes to the end of the file-----------
    if isempty(dataIndexEnd) || isempty(dataIndex)
        dataIndex = dataIndexBeg:length(Results.pos_enu);
        dataIndexEnd = length(Results.pos_enu);
    end
    
    dataIndex = dataIndexBeg+find(Results.validPos(dataIndex)==1)-1; % Exclude the NaN.
%-----Calculate availability over just this time interval------------------
    timeAv = Results.Time(dataIndex); % assumes 1 second intervals
    tPA = length(timeAv);
%-----Check to make sure there is at least two position solutions in the
%time interval-------------------------------------------------------------
    if dataIndexEnd ~= dataIndexBeg
        pA = tPA/(Results.Time(dataIndexEnd)-Results.Time(dataIndexBeg));
        pA = pA*100;
    else
        pA = 0; 
    end
    pAstr = sprintf('%.1f',pA);
%-------plot-------------------
    subplot(subRow,subCol,subplotCount);
    if tPA >= 2 % Checks again for at least two position solutions
        scatter(Results.pos_enu(dataIndex,3), Results.pos_enu(dataIndex,4),24,Results.timeHours(dataIndex)-Results.timeHours(1), 'filled');
        caxis([Results.timeHours(dataIndexBeg)-Results.timeHours(1) Results.timeHours(dataIndexEnd)-Results.timeHours(1)]);
        [xunit, yunit, CEP_radius] = CEP(Results.pos_enu(dataIndex,3),Results.pos_enu(dataIndex,4));
        hold on;plot(xunit,yunit,'r.');
        title([ 't-', num2str((subplotWindow*(j-1))/3600),'-',num2str((subplotWindow + subplotWindow*(j-1))/3600) ,'hr; av:',pAstr,'%; 90%C:',num2str(CEP_radius,4),'m' ],'FontSize',10);
        xlabel('East (m)');
        ylabel('North (m)');
        axis equal;
        grid on;
    else
        title([ 't-', num2str((subplotWindow*(j-1))/3600),'-',num2str((subplotWindow + subplotWindow*(j-1))/3600) ,'hr; av:',pAstr,'%'],'FontSize',10);
        xlabel('East (m)');
        ylabel('North (m)');
        axis equal;
        grid on;
    end
%------------ update the index for the subplot-------------------------
    subplotCount = subplotCount + 1;   
end


end

