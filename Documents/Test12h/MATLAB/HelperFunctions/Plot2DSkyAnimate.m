function [ fh ] = Plot2DSkyAnimate( Results )
%% Sky 2D
colors = {'.k','.b','.g','.r','.c','.m','.y'};
minThreshold = 0;
firstvalidPRN = 1;
fh = figure;

hold on;
k = 1:floor(length(Results.lssVector(1,1,:))/10):length(Results.lssVector(1,1,:));
for n = 2:length(k)
for i = 1:32
%    check the valid PRNs
    checkPRN = reshape(Results.lssVector(i,1,k(n-1):k(n)), 1, length(Results.lssVector(i,1,k(n-1):k(n))));
    data = ~isnan(checkPRN)*i;
    idx = (data==0);
    data(idx) = nan;
    
    dataIndex = find(~isnan(data));
%   Get Position data for indexes where the current PRN is available
    satPos =  [reshape(Results.lssVector(i,9,dataIndex + k(n-1)), length(Results.lssVector(dataIndex + k(n-1))),1) reshape(Results.lssVector(i,10,dataIndex + k(n-1)),length(Results.lssVector(dataIndex + k(n-1))),1) reshape(Results.lssVector(i,11,dataIndex + k(n-1)),length(Results.lssVector(dataIndex + k(n-1))),1)];  % Pos Sat
    rcvPos = [Results.X(dataIndex + k(n-1)) Results.Y(dataIndex + k(n-1)) Results.Z(dataIndex + k(n-1))];
%   Set Variables
    Elev = nan(length(satPos),1);
    Azumith = nan(length(satPos),1);
   
%   Get Elevation and Azumith
    for j = 1:length(satPos)
        [Elev(j),Azumith(j)] = Calc_Azimuth_Elevation(rcvPos(j,:),satPos(j,:));
    end
    Elev = Elev*180/pi; %convert to degrees
    Azumith = Azumith*180/pi;
%%%%%%%%%%%%%%%%%%%%%% Plot Data and Legend %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    w = mod(i,length(colors));
    if w == 0
        w = length(colors);
    end
    if ~isempty(Elev)
        indexBelowThres = find(Elev <= minThreshold);
        if ~isempty(indexBelowThres)
            Elev(indexBelowThres) = [];
            Azumith(indexBelowThres) = [];
        end
        if i == firstvalidPRN
            skyPlot(Azumith, Elev, i*ones(length(Azumith)),colors{w}, 1);
        else
            hpol = skyPlot(Azumith, Elev, i*ones(length(Azumith)),colors{w}, 1);
        end
    else
        firstvalidPRN = firstvalidPRN + 1;
    end
end
drawnow
%u.Value = n-1;
F(n-1) = getframe;
end
u = uicontrol('Style','slider','Position',[10 50 20 340],'Tag','SkyCallback',...
    'Min',1,'Max',length(k)-1,'Value',1);
u.Callback = {@SkyCallback,fh,F};
%movie(F,10);
%--------Include version number, git, compiler in plot--------------------
ylimit=get(gca,'YLim');
xlimit=get(gca,'XLim');
info = sprintf('%s\n%s\n%s',Results.metadata{2},Results.metadata{3},Results.metadata{4});
text(xlimit(2),ylimit(1),info,...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','right','Interpreter','none');
title(['Filename: ' Results.fileStrTitles ]); 




end
