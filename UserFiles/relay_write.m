function [] = relay_write(serialObj,relayNum,phrase)
% This is a function to write a command to a particular Numato relay
% channel
%
% inputs:
%   serialObj - the numato relay serial object as previously established
%   through establish_relay_connection
%   
%   relayNum - which relay to send the command to e.g, relayNum = 0 would
%   be the first relay
%
% outputs:
%   none
%
% use:
%    relay_write(serialObj,0,'on')
%
% David.J.Caldwell, djcald@uw.edu, University of Washington, 7/2018
% BSD-3 License
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add 1 to the relay number to be consistent with the numato numbering of
% relays 
relayNum = relayNum + 1;
% open object to flush input and output 
fopen(serialObj);
% send the command to write to a specified channel
fprintf(serialObj,['relay ' phrase ' ' num2str(relayNum)]);
% close object to flush input and output 
fclose(serialObj);

end
