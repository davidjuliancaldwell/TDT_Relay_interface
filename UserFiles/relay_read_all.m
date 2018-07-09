function [statusBin,statusHex] = relay_read_all(serialObj,numBits)
% This is a function to read all of the relay channels from a particular
% relay board. It returns both a binary vector and hexadecimal representation of
% the status 
%
% inputs:
%   serialObj - the numato relay serial object as previously established
%   through establish_relay_connection
%
%   numBits - the number of bits to format the output in. This should be
%   the number of channels on the relay (e.g. 8)
%
% outputs:
%   statusBin - the status of relay as a binary vector
%   statusHex - the status of the relay as a hexadecimal
%
% use:
%   [statusBin,statusHex] = relay_read_all(serialObj,8) 
%   
%
% David.J.Caldwell, djcald@uw.edu, University of Washington, 7/2018
% BSD-3 License
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% open object to flush input and output 
fopen(serialObj);
% send command to relay to read all 
fprintf(serialObj,['relay readall'])
% command info is the command which was sent to the relay, ignore
commandInfo = fscanf(serialObj);
% read the status in hex
statusHex = fscanf(serialObj);
% convert the status from hex to binary
statusBin = hexToBinaryVector(statusHex,numBits);
% close object to flush input and output 
fclose(serialObj);

end