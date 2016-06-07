function [ numBytes ] = calcBytesDataType( dataString )
%% Function used to compute number of bytes in a given string data type
% Inputs:
%    -dataString = [char*] string containing data type
% Outputs:
%    -numBytes = [int] number of bytes of said data type
numBytes = 0;
switch dataString
    case 'double'
        numBytes = 8;
    case 'uint64'
        numBytes = 8;
    case 'float'
        numBytes = 4;
    case 'uint32'
        numBytes = 4;
    case '12*double'
        numBytes = 12*8;
    case '12*uint32'
        numBytes = 12*4;
end

