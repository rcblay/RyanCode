function [  ] = SaveResultsDHT( Results, Outagestr, attachments, recipients, fileStr, plotFolder )
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

ResY = importWeek('/home/dma/Documents/Test12h/output/Dynamic/Refaptrnx/ResY.txt');
ResW = importWeek('/home/dma/Documents/Test12h/output/Dynamic/Refaptrnx/ResW.txt');

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

%% Comparison with older runs

max2DstrdataY = sprintf('%-40s',[num2str(Results.maxError2D - ResY(1)) ' meters']);
max3DstrdataY = sprintf('%-40s',[num2str(Results.maxError3D - ResY(2)) ' meters']);
maxHeightstrdataY = sprintf('%-40s',[num2str(Results.maxHeightError - ResY(3)) ' meters']);
mean2DstrdataY = sprintf('%-40s',[num2str(Results.mean2D - ResY(4)) ' meters']);
std2DstrdataY = sprintf('%-40s',[num2str(Results.std2D - ResY(5)) ' meters']);
mean3DstrdataY = sprintf('%-40s',[num2str(Results.mean3D - ResY(6)) ' meters']);
std3DstrdataY = sprintf('%-40s',[num2str(Results.std3D - ResY(7)) ' meters']);
availstrdataY = sprintf('%-40s',[num2str(str2double(Results.percentAvailStr) - ResY(8)), ' %']);

max2DstrdataW = sprintf('%-40s',[num2str(Results.maxError2D - ResW(1)) ' meters']);
max3DstrdataW = sprintf('%-40s',[num2str(Results.maxError3D - ResW(2)) ' meters']);
maxHeightstrdataW = sprintf('%-40s',[num2str(Results.maxHeightError - ResW(3)) ' meters']);
mean2DstrdataW = sprintf('%-40s',[num2str(Results.mean2D - ResW(4)) ' meters']);
std2DstrdataW = sprintf('%-40s',[num2str(Results.std2D - ResW(5)) ' meters']);
mean3DstrdataW = sprintf('%-40s',[num2str(Results.mean3D - ResW(6)) ' meters']);
std3DstrdataW = sprintf('%-40s',[num2str(Results.std3D - ResW(7)) ' meters']);
availstrdataW = sprintf('%-40s',[num2str(str2double(Results.percentAvailStr) - ResW(8)), ' %']);

bodyCell = {max3Dstr, max3Dstrdata, max3DstrdataY, max3DstrdataW; ...
        mean3Dstr, mean3Dstrdata, mean3DstrdataY, mean3DstrdataW; ...
        availstr, availstrdata, availstrdataY, availstrdataW; ...
        resultsstr, resultsstr, resultsstr, resultsstrdata; ...
        max2Dstr, max2Dstrdata, max2DstrdataY, max2DstrdataW; ...
        max3Dstr, max3Dstrdata, max3DstrdataY, max3DstrdataW; ...
        maxHeightstr, maxHeightstrdata, maxHeightstrdataY, maxHeightstrdataW; ...
        mean2Dstr, mean2Dstrdata, mean2DstrdataY, mean2DstrdataW; ...
        std2Dstr, std2Dstrdata, std2DstrdataY, std2DstrdataW; ...
        mean3Dstr, mean3Dstrdata, mean3DstrdataY, mean3DstrdataW; ...
        std3Dstr, std3Dstrdata, std3DstrdataY, std3DstrdataW; ...
        availstr, availstrdata, availstrdataY, availstrdataW; ...
        Results.metadata(2) , '   ' , Results.metadata(3) , '   '};
bodyTable = cell2table(bodyCell);     
writetable(bodyTable,[plotFolder 'resultOverV' dateStr '.txt'],'Delimiter','|','WriteVariableNames',0);
%% Send Rnx Email
%sendLssRnxEmail(recipients,subject,body,attachments);


end

