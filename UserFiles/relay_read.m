function [status] = relay_read(serialObj,relayNum,numBits)
% This is a function to read the 'on'/'off' status of a particular numato relay 
%
% inputs:
%   serialObj - the numato relay serial object as previously established
%   through establish_relay_connection
%   
%   relayNum - which relay to send the command to e.g, relayNum = 0 would
%   be the first relay
%
% outputs:
%   status - the status of the given relay channel 
%
% use:
%   status = relay_read(serialObj,0) 
%   this would return the first relay's status
%
% David.J.Caldwell, djcald@uw.edu, University of Washington, 7/2018
% BSD-3 License
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add 1 to the relay number to be consistent with the numato numbering of
% relays 
relayNum = relayNum + 1;
% open object to flush input and output 
fopen(serialObj);
% send the command read the status from a specified relay
fprintf(serialObj,['relay read ' num2str(relayNum)]);
% command info is the command which was sent to the relay, ignore
commandInfo = fscanf(serialObj);
% read the status
status = fscanf(serialObj);
% close object to flush input and output 
fclose(serialObj);

end