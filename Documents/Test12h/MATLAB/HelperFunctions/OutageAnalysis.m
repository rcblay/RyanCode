function [ Outagestr ] = OutageAnalysis( Results )
%% Check Where and When outages occur
dataIndex = ~isnan(Results.pos_enu(:,3)); 
currentlyOutage = 0; %bool to keep track of if in an outage or not
outageIndex = 1; %index to keep track of number of outages
numSecondsOutage = nan(length(dataIndex),1);
startOfOutage = nan(length(dataIndex),1);
startOfOutageS = nan(length(dataIndex),1);
for i = 1:length(dataIndex) %loop through entire data set
%--------------The start of a new outage----------------------------------
    if dataIndex(i) == 0 && currentlyOutage == 0 
        numSecondsOutage(outageIndex,1) = 0; %in time
        startOfOutage(outageIndex,1) = Results.Time(i)-Results.Time(1); %in time
        startOfOutageS(outageIndex,1) = Results.smp(i); %in samples
        currentlyOutage = 1;
%-------------Currently in an outage--------------------------------------
    else if dataIndex(i) == 0 && currentlyOutage == 1
            numSecondsOutage(outageIndex,1) = numSecondsOutage(outageIndex,1) + 1;
%-------------The end of an outage-----------------------------------------
        else if dataIndex(i) == 1 && currentlyOutage == 1
                currentlyOutage = 0;
                outageIndex = outageIndex + 1;
            end
        end
    end
end
%-----------Get rid of any NaN entries in the outage variables------------
numSecondsOutage = numSecondsOutage(~isnan(numSecondsOutage(:,1)));
startOfOutage = startOfOutage(~isnan(startOfOutage(:,1)));
startOfOutageS = startOfOutageS(~isnan(startOfOutageS(:,1)));
% string format for email
Outagestr = '';
for i = 1:length(numSecondsOutage)
%     Outagestr = strcat(Outagestr, 
    Outagestr = [Outagestr sprintf('%s%.1f%s%d%s%s%.1f%s\n\n','Start: ', startOfOutage(i),' (sec), ',startOfOutageS(i), ' (samples)', ' Lasts for: ', numSecondsOutage(i), ' (sec)')];
end




end

