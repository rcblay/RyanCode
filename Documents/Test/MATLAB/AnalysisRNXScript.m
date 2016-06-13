%% Script to analyze an rnxBinaries.bin file and produce plots to visualize the data.
% Inputs:
%   - fileStr : name of binary file to analyze set under File Details
%   - parentpath : full path to file to analyze
%   - plotpath : path where plots should be saved
%   - Analysis Settings : customize which plots should be created and/or
%   saved
%% Clear Workspace
clear all;
close all;
%% Set File Details
% Set File String
fileStr = 'timingrnxBinaries_0_0.bin';
% (OPTIONAL) set truth file or set it to empty if no truth file
truthStr = {};
format = 'drive'; %available FORMATS = {'nmea', 'drive'}
% Set Path for Plots and Files
parentpath = '/home/dma/Documents/Test/output/Dynamic1/';
plotpath = '/home/dma/Documents/Test/output/Dynamic1/Plots/';
%% Analysis Settings
plotWholePos =              1;
plotIntervalPos =           1;
plotSigParams =             1;
plotVelocityComponents =    1;
plotVelocityHist =          1;
plotPRNElevation =          1;
plot2DSky =                 0;
plot3DSky =                 0;
performOutageAnalysis =     1;
savePlots =                 1;
saveResultsandSendEmail =   1;
generateKMLfile =           0;

recipients = {'griffin.esposito@colorado.edu'};



%% Add Path to get Helper Functions
currentpathinitial = pwd();
currentpath = cd('..');
currentpath = cd('..');
addpath(genpath(currentpath));
cd(currentpathinitial);

%% Process/Parse file
Results  = ProcessResultsRNX( fileStr,truthStr, format, parentpath );
handleIndex =  1;
%% 1. Whole position solutions
if plotWholePos ~= 0
    handles(handleIndex) = PlotWholePos( Results );
    handleIndex = handleIndex + 1;
end

%% 2. dt / #SVs / HDOP
if plotSigParams ~= 0
    handles(handleIndex) = PlotSigParams( Results );
    handleIndex = handleIndex + 1;
    
end
%% 3. Velocity X,Y,Z and DT Rate
if plotVelocityComponents ~= 0
    handles(handleIndex) = PlotVelocityComponents( Results );
    handleIndex = handleIndex + 1;
end
%% 4. Histogram X,Y,Z Velocities
if plotVelocityHist ~= 0
    handles(handleIndex) = PlotVelocityHist( Results );
    handleIndex = handleIndex + 1;
end
%% 5. Plot the available PRN/Elevation angle
if plotPRNElevation ~= 0
    handles(handleIndex) = PlotPRNElevation( Results );
    handleIndex = handleIndex + 1;
    
end
%% 6. Sky 2D
if plot2DSky ~= 0
    handles(handleIndex) = Plot2DSky( Results );
    handleIndex = handleIndex + 1;
    
end
%% 7. 3D Skyplot 
if plot3DSky ~= 0
    handles(handleIndex) = Plot3DSky( Results );
    handleIndex = handleIndex + 1;
end

%% Plot the results over smaller time intervals
if plotIntervalPos ~= 0
    subhndls = PlotIntervalPos( Results );
    for i = 0:length(subhndls)-1
        handles(handleIndex+i) = subhndls(i+1);
    end
end

%% Check Where and When outages occur
if performOutageAnalysis ~= 0
    [ Outagestr ] = OutageAnalysis( Results );
end
%% Save Plots to send as attachments
if savePlots ~= 0

    [ attachments ] = SavePlots(plotWholePos, plotIntervalPos, plotSigParams, plotVelocityComponents, plotVelocityHist, plotPRNElevation, plot2DSky, plot3DSky, handles, fileStr, plotpath );
    
end
%% Setup Output Variables
if saveResultsandSendEmail ~= 0
    if savePlots == 0
        [ attachments ] = '';
    end
    if performOutageAnalysis == 0
        [ Outagestr ] = OutageAnalysis( Results );
    end
    SaveResultsSendEmail( Results, Outagestr, attachments, recipients, fileStr, plotpath );
end

%% Generate KML file
if generateKMLfile ~= 0
    [ kmlfilename ] = generateKML( Results, fileStr, parentpath );
end
