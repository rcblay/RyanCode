function [ attachments ] = SavePlots(plotWholePos, plotIntervalPos, plotSigParams, plotVelocityComponents, plotVelocityHist, plotPRNElevation, plot2DSky, plot3DSky, handleArray, fileStr, plotpath )
%% Order in which plots are saved:
%   1. whole pos
%   2. sig params (dt)
%   3. vel comps
%   4. vel hist
%   5. prn/elev
%   6. 2D sky
%   7. 3D sky
%   8-... smaller interval pos solutions
 
%% Setup Naming Convention
plotFolder = plotpath;
separated = textscan(fileStr, '%s%s%s', 'delimiter','_');
dateVector = [str2double(separated{1,2}{1,1}) str2double(separated{1,3}{1,1}(1:end-4))];
dateStr = ['_' num2str(dateVector(1)) '_' num2str(dateVector(2))];
%% Save Plots to send as attachments
handleindex = 1;

%----------------check for whole position plot---------------------------
if plotWholePos ~= 0
    plotName1 = ['PosSol' dateStr '.png'];
    plotName1fig = ['PosSol' dateStr '.fig'];
    saveas(handleArray(handleindex), [plotFolder plotName1]);
    saveas(handleArray(handleindex), [plotFolder plotName1fig]);
    attachments{handleindex} = [plotFolder plotName1];
    handleindex = handleindex + 1;
end
%-----------------check for signal parameters plot-----------------------
if plotSigParams ~= 0
    plotName2 = ['DT' dateStr '.png'];
    plotName2fig = ['DT' dateStr '.fig'];
    saveas(handleArray(handleindex), [plotFolder plotName2]);
    saveas(handleArray(handleindex), [plotFolder plotName2fig]);
    attachments{handleindex} = [plotFolder plotName2];
    handleindex = handleindex + 1;
end
%-----------------check for velocity components plot-----------------------
if plotVelocityComponents ~= 0
    plotName3 = ['VelComp' dateStr '.png'];
    plotName3fig = ['VelComp' dateStr '.fig'];
    saveas(handleArray(handleindex), [plotFolder plotName3]);
    saveas(handleArray(handleindex), [plotFolder plotName3fig]);
    attachments{handleindex} = [plotFolder plotName3];
    handleindex = handleindex + 1;
end
%-----------------check for velocity histogram plot-----------------------
if plotVelocityHist ~= 0
    plotName4 = ['VelHist' dateStr '.png'];
    plotName4fig = ['VelHist' dateStr '.fig'];
    saveas(handleArray(handleindex), [plotFolder plotName4]);
    saveas(handleArray(handleindex), [plotFolder plotName4fig]);
    attachments{handleindex} = [plotFolder plotName4];
    handleindex = handleindex + 1;
end
%-----------------check for PRN/Elevation plot-----------------------------
if plotPRNElevation ~= 0
    plotName5 = ['PRN' dateStr '.png'];
    plotName5fig = ['PRN' dateStr '.fig'];
    saveas(handleArray(handleindex), [plotFolder plotName5]);
    saveas(handleArray(handleindex), [plotFolder plotName5fig]);
    attachments{handleindex} = [plotFolder plotName5];
    handleindex = handleindex + 1;
end
%-----------------check for 2D skyplot plot--------------------------------
if plot2DSky ~= 0
    plotName6 = ['Skyplot2D' dateStr '.png'];
    plotName6fig = ['Skyplot2D' dateStr '.fig'];
    saveas(handleArray(handleindex), [plotFolder plotName6]);
    saveas(handleArray(handleindex), [plotFolder plotName6fig]);
    attachments{handleindex} = [plotFolder plotName6];
    handleindex = handleindex + 1;
end
%-----------------check for 3D skyplot plot--------------------------------
if plot3DSky ~= 0
    plotName7 = ['Skyplot3D' dateStr '.png'];
    plotName7fig = ['Skyplot3D' dateStr '.fig'];
    saveas(handleArray(handleindex), [plotFolder plotName7]);
    saveas(handleArray(handleindex), [plotFolder plotName7fig]);
    attachments{handleindex} = [plotFolder plotName7];
    handleindex = handleindex + 1;
end
%-----------------check for smaller pos sol intervals plots----------------
if plotIntervalPos ~= 0
    for i = handleindex:length(handleArray)
      saveas(handleArray(i), [plotFolder 'IntervalPos' num2str(i-handleindex) dateStr  '.png']);
      saveas(handleArray(i), [plotFolder 'IntervalPos' num2str(i-handleindex) dateStr  '.fig']);
      attachments{i} = [plotFolder 'IntervalPos' num2str(i-handleindex) dateStr '.png'];
    end
end

end

