function [status] = CheckPyxisRunning( Results )
%% Checks top 30 lines of TOP linux command for processes matching "pyxis", "real_Converter", and "sdrnav_app"
% Outputs:
%   status(1): pyxis (0-inactive, 1-active)
%   status(2): real_Conv (0-inactive, 1-active)
%   status(3): sdrnav (0-inactive, 1-active)
%   status(4): Results.Time(end) isnan (meaning pyxis froze writing IF) (0-inactive, 1-active)
command = 'ps -C pyxis';
[cmd_status, cmd_out] = system(command);
if cmd_status == 0
   status(1) = 1;
else 
   status(1) = 0;
end
command = 'ps -C real_Converter';
[cmd_status, cmd_out] = system(command);
if cmd_status == 0
   status(2) = 1;
else 
   status(2) = 0;
end
command = 'ps -C sdrnav_app';
[cmd_status, cmd_out] = system(command);
if cmd_status == 0
   status(3) = 1;
else 
   status(3) = 0;
end
if ~isnan(Results.Time(end)) 
   status(4) = 1;
else 
   status(4) = 0;
end

end

