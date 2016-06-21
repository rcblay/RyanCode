function [ Results ] = ProcessResultsRNX( fileStr,truthStr, format, parentpath )
% Outputs:
%   Results struct with the following fields:
%         -pos_enu = n x 5 matrix with ENU pos and GPS time elements in cols
%         -Time = time in seconds of dataset
%         -timeHours = time in hours of dataset
%         -fileStrTitles = title file to be used and interpreted by 'tex' for all figures
%         -percentAvailStr = percent available in String format
%         -metadata = string cell array of metadata used in the header (i.e. compiler info)
%         -validPos = bool to see if valid pos at that time
%         -dt = clock error
%         -numSats = number of satellites
%         -HDOP = horizontal dilution of precision
%         -Vx = X-velocity [m/s]
%         -Vy = Y-velocity [m/s]
%         -Vz = Z-velocity [m/s]
%         -dtRate = Clock Error rate [m/s]
%         -X = x-pos [m]
%         -Y = y-pos [m]
%         -Z = z-pos [m]
%         -lssVector = 3D matrix with satellite information
    %% Set File Details
    separated = textscan(fileStr, '%s%s%s', 'delimiter','_');
    Results.dateVector = [str2double(separated{1,2}{1,1}) str2double(separated{1,3}{1,1}(1:end-4))];
    Results.fileStrTitles = sprintf('%s%s%s%s%s',separated{1,1}{1,1}, '\_' ,separated{1,2}{1,1}, '\_' ,separated{1,3}{1,1});

    %% File settings
    fileName    =[parentpath fileStr];    % file name 
    myfile    = dir(fileName);        % file info
    if isempty(myfile)
        error(['Wrong Directory: Current Directory -' parentpath ' does not contain the file.']);
    else
        fileSize    = myfile.bytes;         % file size
    end
    fid         = fopen(fileName, 'rb');% FID


    %% Read in Header Data
    metadata = fgets(fid);
    Results.metadata = strsplit(metadata, '\t');
    variableNames = fgets(fid);
    variableNames = strsplit(variableNames, '\t');
    variableSizes = fgets(fid);
    variableSizes = strsplit(variableSizes, '\t');
    scaIndex = 1;
    vecIndex = 1;
    variableSizes = cellstr(variableSizes);
    bytesInEpoch = 0;
    for i = 1:numel(variableSizes)
        if isempty(strfind(variableSizes{i},'*'))
            scaType{scaIndex} = variableSizes{i};
            scaNames{scaIndex} = variableNames{i};
            scaIndex = scaIndex + 1;
        else
            startIndex = strfind(variableSizes{i},'*');
            numChannels = str2double(variableSizes{i}(1:startIndex-1));
            vecType{vecIndex} = variableSizes{i}(startIndex+1:end);
            vecNames{vecIndex} = variableNames{i};
            vecIndex = vecIndex + 1;
        end
        bytesInEpoch = bytesInEpoch + calcBytesDataType(variableSizes{i});
    end
    scaType = cellstr(scaType);
    vecType = cellstr(vecType);

    %% Pre-define the variable size
    dataLen     = floor((fileSize) / (bytesInEpoch));    % data length
    Results.lssVector   = nan(32, length(vecType), dataLen);  % data for each PRN
    Results.pos_enu     = nan(dataLen, 5);      % position data in ENU frame
    displayStep = round(dataLen / 100);  % Status display step
    temppos = nan(dataLen, 3); 
    tempScalar = nan(dataLen,length(scaNames)-1);
    templssVector = nan(numChannels, length(vecType), dataLen); 
    disp('Start LSS decoding ...');


    %% Read and save the data
    % Variable names:
    %
    % SCALAR: rtow	X	Y	Z	dt	Vx	Vy	Vz	dtRate	HDOP	VDOP	
    % TDOP	smp	frc	numSat	valid1	valid2	newKal	newMea	validPos	week
    %
    % VECTOR: pr1	cp1	dp1	cno1	pr2	cp2	dp2	cno2	Xsv	Ysv	Zsv	svClk
    % validPRN	prn	

    for i = 1:dataLen 
        if(fileSize - ftell(fid) - bytesInEpoch < 0)
            break;
        end
        scaIndex = 1;
        vecIndex = 1;
        for l = 1:length(scaNames)-1
            tempScalar(i,l) = fread(fid,1, scaType{scaIndex});
            scaIndex = scaIndex + 1;
        end
        for k = 1:length(vecNames)
            for j = 1:numChannels
                templssVector(j,k,i) = fread(fid,1, vecType{vecIndex});
            end
            vecIndex = vecIndex + 1;
        end
         if rem(i, displayStep) == 0
            disp(['Processing ', num2str(i*bytesInEpoch/fileSize*100, '%2.0f'), ' %']);
        end

    end
    % eval variables
    % Scalar
    for l = 1:length(scaNames)-1
            Results.(scaNames{l}) = tempScalar(:,l);
    %     eval([scaNames{l}, '= tempScalar(:,l);']);
    end

    for k = 1:length(vecNames)
        for j = 1:numChannels
            eval([vecNames{k}, '(:,j)=templssVector(j,k,:);']);
        end
    end
    for i = 1:dataLen
        for j = 1:numChannels
            % checkt #satellites & PRN validity
            if j <= Results.numSat(i) && validPRN(i,j) == 1
                Results.lssVector(prn(i,j), 1, i) = pr1(i,j);  % PR1
                Results.lssVector(prn(i,j), 2, i) = cp1(i,j);  % Carr1
                Results.lssVector(prn(i,j), 3, i) = dp1(i,j);  % Dopp1
                Results.lssVector(prn(i,j), 4, i) = cno1(i,j);  % CNo1
                Results.lssVector(prn(i,j), 5, i) = pr2(i,j);  % PR2
                Results.lssVector(prn(i,j), 6, i) = cp2(i,j);  % Carr2
                Results.lssVector(prn(i,j), 7, i) = dp2(i,j);  % Dopp2
                Results.lssVector(prn(i,j), 8, i) = cno2(i,j);  % CNo2
                Results.lssVector(prn(i,j), 9, i) = Xsv(i,j);  % Sat X
                Results.lssVector(prn(i,j), 10, i) = Ysv(i,j);  % Sat Y
                Results.lssVector(prn(i,j), 11, i) = Zsv(i,j);  % Sat Z
                Results.lssVector(prn(i,j), 12, i) = svClk(i,j);  % Sat Clk            
            end
        end
    %    status display
        if rem(i, displayStep) == 0
            disp(['Processing ', num2str(i*bytesInEpoch/fileSize*100, '%2.0f'), ' %']);
        end
    %     ftell(fid)
    end
    lssScalar = [Results.rtow,	Results.X,	Results.Y,	Results.Z,	Results.dt,	Results.Vx,	Results.Vy,	Results.Vz,	Results.dtRate,	Results.HDOP,	Results.VDOP,	Results.TDOP ...
         ,Results.smp,	Results.frc,	Results.numSat,	Results.valid1,	Results.valid2,	Results.newKal,	Results.newMea,	Results.validPos,	Results.week];


    %% Find indexes where there is a valid position solution
    dataIndex = find(Results.validPos == 1); % if valid position solution
    Results.pos_enu(dataIndex,1:2) = [lssScalar(dataIndex,21) lssScalar(dataIndex,1)]; % time info
    temppos(dataIndex,1:3) = lssScalar(dataIndex,2:4); % set a temp matrix with RAW position data
        %% Get total length of time

    Results.Time = lssScalar(:,1); %Time vector
    Results.timeHours = Results.Time.*(1/3600); %Time in hours vector
    %-----Taking into account week rollover (Time resets at end of week)--------
    if (Results.Time(end) < 1)
        Results.Time(end) = 604800;
        Results.timeHours(end) = 168;
    end
    totTime = Results.Time(end) - Results.Time(1); %End time of file minus beg time of file


    %% Availability
    dataIndex = find(Results.validPos == 1); % Exclude the NaN. 
    timePosAvail = length(Results.Time(dataIndex)); % finds number of indexes (seconds) that a position solution is available
    Results.percentAvail = timePosAvail/totTime; % Percentage of time that a position solution is available over entire file
    Results.percentAvailStr = sprintf('%.1f',100*Results.percentAvail);



if isempty(truthStr)
    %% Set Truth or Mean for reference position
    truthOrMeanRefStr = 'm'; % 'm' for mean ref, 't' for truth ref
    %% IF using TRUTH reference position, Set orz for truth reference position
    % DLC antenna reference position: 
    % - Lat/Lon/Hght: 40.00749295305 /-105.26167642616/1630.40495370706
    % - XYZ: [-1288084.72435924,-4720848.72539722,4079671.03660523]
    % orz = [-1288084.72435924,-4720848.72539722,4079671.03660523]; % DLC

    % 1B81 antenna
    orz = [-1288160.31484243,-4720790.09567223,4079712.76313084];   % 1B81






    %% Calculate Mean reference position 
    meanorz = [mean(temppos(dataIndex,1)), mean(temppos(dataIndex,2)), mean(temppos(dataIndex,3))];


    %% Convert to ENU reference frame based on truth or mean reference position
    if strcmp(truthOrMeanRefStr, 'm')==1 %------if using mean ref position-------
        for i = 1:sum(dataLen)
            if lssScalar(i,20) == 1
                Results.pos_enu(i,3:5) = xyz2enu(lssScalar(i,2:4), meanorz);% ENU position
            end
        end
        %% Set Latitude/Longitude of Reference Position
        llh = xyz2llh(meanorz);
        Results.lat = llh(1);
        Results.lon = llh(2);
        Results.alt = llh(3);
    else %------if using truth ref position-----------------
        for i = 1:sum(dataLen)
            if lssScalar(i,20) == 1
                Results.pos_enu(i,3:5) = xyz2enu(lssScalar(i,2:4), orz);% ENU position
            end
        end
        %% Set Latitude/Longitude of Reference Position
        llh = xyz2llh(orz);
        Results.lat = llh(1);
        Results.lon = llh(2);
        Results.alt = llh(3);
    end

    
else
    options = {'drive','nmea'};
    case_t = find(strcmp(options,  format),1);
    if ~isempty(case_t)
        switch case_t
            case 1 %'drive' truth set
                [Results] = ProcessTruthDrive(parentpath, truthStr, Results);
                 llh = xyz2llh([mean(Results.X(Results.validPos==1)) mean(Results.Y(Results.validPos==1)) mean(Results.Z(Results.validPos==1))]);
                 Results.lat = llh(1);
                 Results.lon = llh(2);
                 Results.alt = llh(3);
            case 2 %'nmea' truth set
                [Results] = ProcessTruthSimulation(parentpath, truthStr, Results);
                 llh = xyz2llh([mean(Results.X(Results.validPos==1)) mean(Results.Y(Results.validPos==1)) mean(Results.Z(Results.validPos==1))]);
                 Results.lat = llh(1);
                 Results.lon = llh(2);
                 Results.alt = llh(3);
        end
    end
end

fclose all;
    disp('---  LSS Decoding finished ---');
    if strcmp(format, 'drive')
        dataIndex = find(~isnan(Results.pos_enu(:,3)));
    else
        dataIndex = find(Results.validPos == 1);
    end
    %% Max 2D and 3D Error (and epoch/time)
    % Max 2D
    Results.error2D = sqrt(Results.pos_enu(dataIndex,3).^2 + Results.pos_enu(dataIndex,4).^2);
    Results.maxError2D = max(Results.error2D); %m
    Results.timeMax2D = Results.timeHours(Results.error2D == Results.maxError2D)-Results.timeHours(1); %hr
    % Max 3D 
    Results.error3D = sqrt(Results.pos_enu(dataIndex,3).^2 + Results.pos_enu(dataIndex,4).^2 + Results.pos_enu(dataIndex,5).^2);
    Results.maxError3D = max(Results.error3D); %m
    Results.timeMax3D = Results.timeHours(Results.error3D == Results.maxError3D)-Results.timeHours(1); %hr


    %% Max Height Error (and epoch/time)
    Results.maxHeightError = max(Results.pos_enu(:,5)); %m
    Results.timeMaxHeight = Results.timeHours(Results.pos_enu(:,5) == Results.maxHeightError)-Results.timeHours(1); %hr


    %% Mean and std for 2D and 3D Error
    % Mean and std 2D
    Results.mean2D = mean(Results.error2D);
    Results.std2D = std(Results.error2D);
    % Mean and std 3D
    Results.mean3D = mean(Results.error3D);
    Results.std3D = std(Results.error3D);
end

