%% script to communicate with numato relay board via MATLAB
% first, the numato relay board must be connected to a certain port. Then,
% the specified COM port needs to be opened up
% 7.3.2018 - David.J.Caldwell

% establish serial port connection
s = serial('COM4');

% open serial port
fopen(s);

% change terminator to carriage return from line feed
f.Terminator = 'CR';

%%
% now, try reading the value of all the relays
relay_read_all(s)

%%
% close serial port
fclose(s);
%%
% function definitions
function [] = relay_write(serialObj,relayNum,phrase)
fprintf(serialObj,['relay ' num2str(relayNum) ' ' phrase]);
end

function [output] = relay_read_all(serialObj)
fprintf(serialObj,['relay readall'])
commandInfo = fscanf(s);
status = hexToBinaryVector(fscanf(s));
end