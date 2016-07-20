function [ ] = SendErrorNotification( Results, status, recipients, fileStr )
% Sends notification of error in pyxis running
dateStr = ['_' num2str(Results.dateVector(1)) '_' num2str(Results.dateVector(2))];
newLine = sprintf('\n');
errorCode = sprintf('%d%d%d%d', status(1),status(2),status(3),status(4));
subject = ['ERROR CODE: ' errorCode 'Filename: ' fileStr ' Lat:' num2str(Results.lat*180/pi) ' Lon:' num2str(Results.lon*180/pi) ' Week:' num2str(Results.dateVector(1)) ' TOW:' num2str(Results.dateVector(2))];
body = ['Error Occurred running pyxis at TOW = ' num2str(Results.rtow(end-1)) ', Week = ' num2str(Results.week(end-1)) newLine newLine ...
        'Error in pyxis (yes = 0, no = 1): ' num2str(status(1)) newLine ...
        'Error in real_Converter (yes = 0, no = 1): ' num2str(status(2)) newLine ...
        'Error in sdrnav_app (yes = 0, no = 1): ' num2str(status(3)) newLine ...
        'Error in time logging of rnx (yes = 0, no = 1): ' num2str(status(4)) newLine];
attachments = [];
sendLssRnxEmail(recipients,subject,body,attachments);
end

