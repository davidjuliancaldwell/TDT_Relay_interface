function [] = relay_write_all_preserve_on(serialObj,phrase,numBits)
% This is a function to write a binary vector of channels on and off to the
% Numato relay board. This overwrites any existing configuration on the
% boards. 
%
% inputs:
%   serialObj - the numato relay serial object as previously established
%   through establish_relay_connection
%
%   phrase - the binary vector of channels to turn on and off
%   e.g, [1 1 1 1 0 0 0 0]. this preserves any that are already on
%
%   numBits - the number of bits to format the output in. This should be
%   the number of channels on the relay (e.g. 8)
%
% outputs:
%   none
%
% use:
%   relay_write_all_preserve(serialObj,[1 0 1 0 1 0 1 0],8)
%   this would turn on the 1,3,5,7 relay channels, while leaving on 0,2,4,6
%   if they were were already on
%
% David.J.Caldwell, djcald@uw.edu, University of Washington, 7/2018
% BSD-3 License
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% first read all to make sure you dont overwrite any existing relays

[statusBin,statusHex] = relay_read_all(serialObj,numBits);

% open object to flush input and output 
fopen(serialObj)

% bitwise OR to avoid any overwrite of already on
newPhrase = bitor(statusBin,phrase);
% convert to Hex
newPhraseHex = binaryVectorToHex(newPhrase);
% write to the relay in Hex
fprintf(serialObj,['relay writeall ' newPhraseHex])
% close object to flush input and output 
fclose(serialObj);

end