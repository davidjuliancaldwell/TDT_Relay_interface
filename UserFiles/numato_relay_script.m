%% script to communicate with numato relay board via MATLAB
% first, the numato relay board must be connected to a certain port. Then,
% the specified COM port needs to be opened up
% 7.3.2018 - David.J.Caldwell

%%
% house keeping
newobjs = instrfind;
fclose(newobjs);
%%
% establish serial port connection
s = serial('COM4');
% open serial port
fopen(s);

% change terminator to carriage return from line feed
s.Terminator = 'CR';

%%
% first relay
for relayNum = 4:7
    relay_write(s,relayNum,'on');
end

%%
for relayNum = 0:7
    status = relay_read(s,relayNum)
end
%%
% now, try reading the value of all the relays
[statusBin,statusHex] = relay_read_all(s)

%%
% close serial port
fclose(s);
%%
% function definitions

