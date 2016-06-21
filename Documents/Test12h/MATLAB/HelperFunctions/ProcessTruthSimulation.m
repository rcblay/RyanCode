function [Results] = ProcessTruthSimulation(filepath, filename, Results)
%% get NMEA data
fullpathfilenamenmea = [filepath filename];
[ Results.fields, Results.weektruth, Results.TOWtruth, Results.lattruth, Results.longtruth, Results.alttruth, Results.numSatstruth, Results.PRNtruth, Results.HDOPtruth,Results.posECEFtruth, Results.magVtruth] = nmeaRead( fullpathfilenamenmea );
orz = Results.posECEFtruth;
%% Find indexes where there is a valid position solution
%dataIndex = find(Results.validPos == 1); % if valid position solution

%% Convert to ENU reference frame based on truth or mean reference position

for i = 2:length(Results.TOWtruth)
   if Results.TOWtruth(i)<Results.TOWtruth(i-1)
      subtractIndex = i;
      break;
   else
      subtractIndex = 0;
   end
end
startIndex = find(Results.TOWtruth == floor(Results.rtow(1)));
alignmentIndex = startIndex+1-subtractIndex;
for i = 1:length(Results.validPos)
    if Results.validPos(i) == 1
        Results.pos_enu(i,3:5) = xyz2enu([Results.X(i),Results.Y(i),Results.Z(i)], orz(i+alignmentIndex,:));% ENU position
    end
end

end


