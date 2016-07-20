function YMDS = gps2ymds( gpsTimeOfWeek, gpsWeekNum)
% gps2ymds Computes the GPS time (sec) and GPS week.
%          Normally the intermediate step to computing the calendar date
% Input : gpsTimeOfWeek (GPS Sec)
%         gpsWeekNum (GPS Week)
% Output : GMT 협정시 (Greenwich Mean Time, 그리니치 표준시)
%          YMDS (1) : Year
%          YMDS (2) : Month (1~12)
%          YMDS (3) : Day
%          YMDS (4) : Sec (0~86400)
% 대한민국은 GMT + 9시간

   gpsWeekNum=gpsWeekNum-1024;
   
    % Constants
    SEC_PER_DAY     = 86400;
    NUM_GPS_WEEKS   = 1024;  % Number of GPS weeks before a week rollover
    gpsCycle=floor((gpsWeekNum+1024)/NUM_GPS_WEEKS);
    
   % Julian day number of the birthday of GPS (Midnight of January 5, 1980)
   % Can compute using January 6, 1980, HMS = 00:00:00
   JD_GPS = 2444244.5;   
   
   % Compute the (decimal) number of elapsed days since the start of GPS
   gpsDays = ((gpsCycle * NUM_GPS_WEEKS) + gpsWeekNum) * 7 ...
            + gpsTimeOfWeek / SEC_PER_DAY...
            + 0.5;
        
    % Compute the current (decimal) Julian Day
    JD = JD_GPS + gpsDays - 0.5;

% JULIANDAY2CALENDARDATE    Compute the (Gregorian) calendar date from the
%                           (decimal) Julian day.

    % Constants
    SEC_PER_DAY     = 86400;    
    
    % Most of the calculations do not need the decimal portion
    JDN = floor(JD);
    
    % Compute Seconds After Midnight (SAM) - note that days in the Julian
    % date system start at 12:00pm, so must adjust the SAM accordingly
    partialDay = JD - JDN;
    
    if ( (partialDay >= 0) && (partialDay < 0.5) )
        sam = (partialDay + 0.5) * SEC_PER_DAY;
        
    elseif( (partialDay >= 0.5) && (partialDay < 1.0) )
        sam = (partialDay - 0.5) * SEC_PER_DAY;
        
    else
        error('SAM requires partial days, i.e. less than 86400 seconds!');
    end
        
    % Compute YMD
    Z = JD + 0.5 ;
    W = floor( (Z - 1867216.25) / 36524.25 );
    X = floor( W / 4 );
    A = Z + 1 + W - X;
    B = A + 1524;
    C = floor( (B - 122.1) / 365.25 );
    D = floor( 365.25 * C );
    E = floor( (B - D) / 30.6001 );
    F = floor( 30.6001 * E );
    
    % Compute day of the month
    day = floor(B - D - F);
    
    % Compute month of the year
    if( (E - 1) <= 12 ) 
        month = E - 1;
    elseif( (E-13) <= 12 )
        month = E - 13;
    else
        error('Can''t get number less than 12 in JulianDay2CalendarDate');
    end
    
    % Compute year
    if ( month < 3 )
        year = C - 4715;
    else
        year = C - 4716;
    end
    
    YMDS(1) = year;
    YMDS(2) = month;
    YMDS(3) = day;
    YMDS(4) = sam;