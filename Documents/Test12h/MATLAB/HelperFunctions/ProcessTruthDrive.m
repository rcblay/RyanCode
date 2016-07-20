function [Results] = ProcessTruthDrive(filepath, filename, Results)
%% Processes the truth file for a drive test.

dataIndex = find(Results.validPos == 1);
%% Read In Truth Position
truthdata = importdata([filepath filename]);
Week = truthdata.data(:,1);
Results.timetruth = truthdata.data(:,2);
Results.lattruth = truthdata.data(:,3);
Results.lontruth = truthdata.data(:,4);
Results.htruth = truthdata.data(:,5);
Results.xtruth = truthdata.data(:,6);
Results.ytruth = truthdata.data(:,7);
Results.ztruth = truthdata.data(:,8);
Results.vxtruth = truthdata.data(:,9);
Results.vytruth = truthdata.data(:,10);
Results.vztruth = truthdata.data(:,11);
Results.numSattruth = truthdata.data(:,12);
Results.HDOPtruth = truthdata.data(:,14);
% Convert to ENU reference frame based on truth or mean reference position

inttimetruth = int64(Results.timetruth);
intTime = int64(Results.Time);
if intTime(1) > inttimetruth(1) && intTime(end) > inttimetruth(end)
    indexBeg = find(inttimetruth ==intTime(1),1);
    indexEnd = find(intTime == inttimetruth(end),1);
    experimental = [Results.X(1:indexEnd), Results.Y(1:indexEnd), Results.Z(1:indexEnd)];
    timeexperimental = intTime(1:indexEnd);
    truth = [Results.xtruth(indexBeg:end),Results.ytruth(indexBeg:end),Results.ztruth(indexBeg:end)];
    timetruth = inttimetruth(indexBeg:end);
    validPos = Results.validPos(1:indexEnd);
    Results.flag = 1;
else if intTime(1) < inttimetruth(1) && intTime(end) > inttimetruth(end)
        indexBeg = find(intTime ==inttimetruth(1),1);
        indexEnd = find(intTime == inttimetruth(end),1);
        experimental = [Results.X(indexBeg:indexEnd), Results.Y(indexBeg:indexEnd), Results.Z(indexBeg:indexEnd)];
        timeexperimental = intTime(indexBeg:indexEnd);
        truth = [Results.xtruth(1:end),Results.ytruth(1:end),Results.ztruth(1:end)];
        timetruth = inttimetruth(1:end);
        validPos = Results.validPos(indexBeg:indexEnd);
        Results.flag = 2;
    else if intTime(1) < inttimetruth(1) && intTime(end) < inttimetruth(end)
            indexBeg = find(intTime ==inttimetruth(1),1);
            indexEnd = find(inttimetruth == intTime(end),1);
            experimental = [Results.X(indexBeg:end), Results.Y(indexBeg:end), Results.Z(indexBeg:end)];
            timeexperimental = intTime(indexBeg:end);
            truth = [Results.xtruth(1:indexEnd),Results.ytruth(1:indexEnd),Results.ztruth(1:indexEnd)];
            timetruth = inttimetruth(1:indexEnd);
            validPos = Results.validPos(indexBeg:end);
            Results.flag = 3;
            Results.timeDiffTruth = diff(timetruth);
            Results.timeDiffExp = diff(timeexperimental);
        else
                indexBeg = find(inttimetruth ==intTime(1),1);
                indexEnd = find(inttimetruth == intTime(end),1);
                experimental = [Results.X(1:end), Results.Y(1:end), Results.Z(1:end)];
                timeexperimental = intTime(1:end);
                truth = [xtruth(indexBeg:indexEnd),ytruth(indexBeg:indexEnd),ztruth(indexBeg:indexEnd)];
                timetruth = inttimetruth(indexBeg:indexEnd);
                validPos = Results.validPos(1:end);
                Results.flag = 4;
        end
    end
end
alignmentIndex = 1;
Results.timeexperimental = timeexperimental;
Results.timetruth = timetruth;
Results.validPosAligned = validPos;
for i = 1:length(timeexperimental)
    while (timetruth(alignmentIndex) < timeexperimental(i))
        alignmentIndex = alignmentIndex + 1; 
    end
    if (timeexperimental(i) == timetruth(alignmentIndex))
        if validPos(i)
            Results.pos_enu(i+indexBeg-1,3:5) = xyz2enu(experimental(i,:), truth(alignmentIndex,:));% ENU position
        end
        alignmentIndex = alignmentIndex + 1;       
    end
end

end

