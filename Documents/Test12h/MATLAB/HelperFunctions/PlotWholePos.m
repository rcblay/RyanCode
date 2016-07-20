function [fh] = PlotWholePos( Results )
%% Function to plot the whole position solution for a gevn data struct
% Input:
%    Results = struct with the navigation solution processed from the rnxBinaries.bin file
% Output:
%    fh = figure handle

fh = figure;
%% Whole position solutions
dataIndex = ~isnan(Results.pos_enu(:,3)); % Exclude the NaN.

h = scatter(Results.pos_enu(dataIndex,3), Results.pos_enu(dataIndex,4),24, Results.timeHours(dataIndex)-Results.timeHours(1),'filled');
cdata = get(h, 'CData');
caxis([Results.timeHours(1)-Results.timeHours(1) Results.timeHours(end)-Results.timeHours(1)]); %Set the colorbar axis to be over the entire time frame of the file
l = colorbar;
ylabel(l, 'Time (Hours)');
%---------Calculate the sigma radius circle for 1,2, and 3 stdeviations-----
[xunit, yunit, sigma_radius] = posError(Results.pos_enu(dataIndex,3),Results.pos_enu(dataIndex,4));
hold on;
plot(xunit(:,1), yunit(:,1),'g', 'linewidth', 2);       % 1 sigma
plot(xunit(:,2), yunit(:,2),'b', 'linewidth', 2);   % 2 sigma
plot(xunit(:,3), yunit(:,3),'r', 'linewidth', 2);   % 3 sigma
titString = sprintf('%s%s\n%s%s%s%s%s%s%s%s','Filename: ', Results.fileStrTitles, 'East-North 2D Position Solution (', num2str(length(Results.pos_enu)), ' samples); 1 \sigma Radius =',num2str(sigma_radius(1),4),'m','; av: ',Results.percentAvailStr,'%');
title(titString);
xlabel('East (m)');
ylabel('North (m)');
axis equal;
grid on;
%------Include text in the plot for what the radius of the circles are--------------
text(sigma_radius(1), 0,   num2str(sigma_radius(1),'%0.1f'), 'fontsize', 12, 'fontweight', 'bold', 'color', 'k');
text(sigma_radius(2), -5, num2str(sigma_radius(2),'%0.1f'), 'fontsize', 12, 'fontweight', 'bold', 'color', 'k');
text(sigma_radius(3), -10, num2str(sigma_radius(3),'%0.1f'), 'fontsize', 12, 'fontweight', 'bold', 'color', 'k');
%--------Include version number, git, compiler in plot--------------------
ylimit=get(gca,'YLim');
xlimit=get(gca,'XLim');
info = sprintf('%s\n%s\n%s',Results.metadata{2},Results.metadata{3},Results.metadata{4});
text(xlimit(2),ylimit(1),info,...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','right','Interpreter','none');
legend('Samples', '1 \sigma (39.3%)', '2 \sigma (86.5%)', '3 \sigma (98.9%)')




end

