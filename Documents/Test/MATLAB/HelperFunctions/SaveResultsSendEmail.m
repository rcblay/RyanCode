function [  ] = SaveResultsSendEmail( Results, Outagestr, attachments, recipients, fileStr, plotFolder )
dateStr = ['_' num2str(Results.dateVector(1)) '_' num2str(Results.dateVector(2))];
newLine = sprintf('\n');
subject = ['Filename: ' fileStr ' Lat:' num2str(Results.lat*180/pi) ' Lon:' num2str(Results.lon*180/pi) ' Week:' num2str(Results.dateVector(1)) ' TOW:' num2str(Results.dateVector(2)) ' Av:' Results.percentAvailStr '% ' 'Sigma 3D = ' num2str(Results.std3D) 'm'];
bodyStr = ['Max 2D Error: ', num2str(Results.maxError2D), ' meters ', ...
        '(', num2str(Results.timeMax2D), ' hours)', newLine, newLine ...
        'Max 3D Error: ', num2str(Results.maxError3D), ' meters ',...
        '(', num2str(Results.timeMax3D), ' hours)', newLine, newLine ...
        'Max Height Error: ', num2str(Results.maxHeightError), ' meters ' ...
        '(', num2str(Results.timeMaxHeight), ' hours)', newLine, newLine ...
        'The mean and standard deviation of error in 2D:', newLine ...
        'Mean 2D = ', num2str(Results.mean2D), ' meters', newLine ...
        '1 Std 2D = ', num2str(Results.std2D), ' meters', newLine, newLine ...
        'The mean and standard deviation of error in 3D:', newLine ...
        'Mean 3D = ', num2str(Results.mean3D), ' meters', newLine ...
        '1 Std 3D = ', num2str(Results.std3D), ' meters', newLine, newLine ...
        'Total Availability of position solution was found to be:  ', Results.percentAvailStr, ' %', newLine, newLine ...
        'Outages:', newLine ...
        Outagestr];
body = bodyStr;

%% Save results in table to output text file
resultsstr = sprintf('%-20s','| Results');
max2Dstr = sprintf('%-20s','| Max 2D Error');
max3Dstr = sprintf('%-20s','| Max 3D Error');
maxHeightstr = sprintf('%-20s','| Max Height Error');
mean2Dstr = sprintf('%-20s','| Mean 2D');
std2Dstr = sprintf('%-20s','| 1 Std 2D');
mean3Dstr = sprintf('%-20s','| Mean 3D');
std3Dstr = sprintf('%-20s','| 1 Std 3D');
availstr = sprintf('%-20s','| Availability');


resultsstrdata = sprintf('%-40s',fileStr);
max2Dstrdata = sprintf('%-40s',[num2str(Results.maxError2D) ' meters ' ...
        '(' num2str(Results.timeMax2D) ' hours)']);
max3Dstrdata = sprintf('%-40s',[num2str(Results.maxError3D) ' meters '...
        '(' num2str(Results.timeMax3D) ' hours)']);
maxHeightstrdata = sprintf('%-40s',[num2str(Results.maxHeightError) ' meters ' ...
        '(' num2str(Results.timeMaxHeight) ' hours)']);
mean2Dstrdata = sprintf('%-40s',[num2str(Results.mean2D) ' meters']);
std2Dstrdata = sprintf('%-40s',[num2str(Results.std2D) ' meters']);
mean3Dstrdata = sprintf('%-40s',[num2str(Results.mean3D) ' meters']);
std3Dstrdata = sprintf('%-40s',[num2str(Results.std3D) ' meters']);
availstrdata = sprintf('%-40s',[Results.percentAvailStr, ' %']);

bodyCell = {resultsstr, resultsstrdata; ...
        max2Dstr, max2Dstrdata; ...
        max3Dstr, max3Dstrdata; ...
        maxHeightstr, maxHeightstrdata; ...
        mean2Dstr, mean2Dstrdata; ...
        std2Dstr, std2Dstrdata; ...
        mean3Dstr, mean3Dstrdata; ...
        std3Dstr, std3Dstrdata; ...
        availstr, availstrdata};
bodyTable = cell2table(bodyCell);     
writetable(bodyTable,[plotFolder 'results' dateStr '.txt'],'Delimiter','|','WriteVariableNames',0);

%% Send Rnx Email
sendLssRnxEmail(recipients,subject,body,attachments);


end

