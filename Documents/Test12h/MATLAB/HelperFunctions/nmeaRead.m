function [ fields, week, TOW, lat, long, alt, numSats, PRN, HDOP, posECEF, magV] = nmeaRead( fullpathfilename )
%% Function to read text file in NMEA format and pull all necessary data
% Inputs:
%    - fillpathfilename = string of the full path name of the NMEA file


nmea_options  =  {  '$GPGGA',
                    '$GPGLL',
                    '$GPVTG',
                    '$GPZDA',
                    '$GPGSA',
                    '$GPGSV'};
                
fid = fopen(fullpathfilename);

tline = fgets(fid);
index = 1;
while ischar(tline)
    fields{index,:} = strsplit(tline,',');
    tline = fgets(fid);
    index = index + 1;
end
numLines = index - 1;
dataLen = floor(numLines / length(nmea_options));
week = nan(dataLen,1);
TOW = nan(dataLen,1);
lat = nan(dataLen,1);
long = nan(dataLen,1);
alt = nan(dataLen,1);
numSats = nan(dataLen,1);
PRN = nan(dataLen,12);
HDOP = nan(dataLen,1);
magV = nan(dataLen,1);
GPGGAindex = 1;
GPZDAindex = 1;
GPVTGindex = 1;
GPGLLindex = 1;
GPGSAindex = 1;
for i = 1:numLines
    nmeaType = fields{i,1}{1,1};

    case_t = find(strcmp(nmea_options,  nmeaType),1);
    if ~isempty(case_t)
    switch case_t
        case 1 %% GPGGA Read global positioning system fixed data
            if strcmp(fields{i,1}{1,4}, 'N')
                lat(GPGGAindex) = str2double(fields{i,1}{1,3}(1:2)) + str2double(fields{i,1}{1,3}(3:end))/60;
            else
                lat(GPGGAindex) = -str2double(fields{i,1}{1,3}(1:2)) - str2double(fields{i,1}{1,3}(3:end))/60;
            end
            if strcmp(fields{i,1}{1,6}, 'W')
                long(GPGGAindex) = -str2double(fields{i,1}{1,5}(1:3)) - str2double(fields{i,1}{1,5}(4:end))/60;
            else
                long(GPGGAindex) = str2double(fields{i,1}{1,5}(1:3)) + str2double(fields{i,1}{1,5}(4:end))/60;
            end
            alt(GPGGAindex) = str2double(fields{i,1}{1,10}) + str2double(fields{i,1}{1,12});
            numSats(GPGGAindex) = str2double(fields{i,1}{1,8});
            GPGGAindex = GPGGAindex + 1;
        case 2 %% GPGLL
            
            
            
        case 3 %% GPVTG
            magV(GPVTGindex) = str2double(fields{i,1}{1,8})*1000/3600; %m/s
            GPVTGindex = GPVTGindex + 1;
            
        case 4 %% $GPZDA,hhmmss.ss,dd,mm,yyyy,xx,yy*CC
            YMDS(1) = str2double(fields{i,1}{1,5});
            YMDS(2) = str2double(fields{i,1}{1,4});
            YMDS(3) = str2double(fields{i,1}{1,3});
            YMDS(4) = str2double(fields{i,1}{1,2}(1:2))*3600 + str2double(fields{i,1}{1,2}(3:4))*60 + str2double(fields{i,1}{1,2}(5:end));
            [TOW(GPZDAindex), week(GPZDAindex)]=ymds2gps(YMDS);
            GPZDAindex = GPZDAindex + 1;
            
        case 5 %% GPGSA
            for j = 1:12
                PRN(GPGSAindex,j) = str2double(fields{i,1}{1,3+j});
            end
            HDOP(GPGSAindex) = str2double(fields{i,1}{1,17});
            GPGSAindex = GPGSAindex + 1;
        case 6 %% GPGSV
    end
    end
    
end
lat = lat*pi/180;
long = long*pi/180;
[x,y,z] = lla2ecef(lat, long, alt);
posECEF = [x,y,z];


fclose(fid);


end

