function [] = relay_write_all(serialObj,phrase)
% This is a function to write a binary vector of channels on and off to the
% Numato relay board. This overwrites any existing configuration on the
% boards. 
%
% inputs:
%   serialObj - the numato relay serial object as previously established
%   through establish_relay_connection
%
% outputs:
%   none
%
% use:
%   relay_write_all(serialObj,[1 0 1 0 1 0 1 0])
%   this would turn on the 1,3,5,7 relay channels
%
% David.J.Caldwell, djcald@uw.edu, University of Washington, 7/2018
% BSD-3 License
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% open object to flush input and output 
fopen(serialObj)
% convert to Hex
newPhraseHex = binaryVectorToHex(phrase);
% write to the relay in Hex
fprintf(serialObj,['relay writeall ' newPhraseHex])
% close object to flush input and output 
fclose(serialObj);

end