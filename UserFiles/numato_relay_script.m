%% example script to communicate with numato relay board via MATLAB
% this is an example script of how to interface with a numato relay board
% via MATLAB
% the relay board must first have been appropriately installed as outlined
% on the numato website, and assigned a COM port to be recognized in MATLAB
% 7.2018 - David.J.Caldwell, djcald@uw.edu, University of Washington
% BSD-3 License

%%
% first, the numato relay board must be connected to a certain port. Then,
% the specified COM port needs to be opened up

% comPort is whichever port the relay is attached to in the device manager
comPort = 'COM4';
% open up a connection
serialObj = establish_relay_connection(comPort);
% the number of relays on the given board, e.g, 8
numBits = 8;

%%
% turn a single relay channel 'on', in this case, number 0 (the first
% relay)

relayNum = 0;
relay_write(serialObj,relayNum,'on');
%
% read a single relay channel, in this case, number 1
status = relay_read(serialObj,relayNum)
%%
% turn a single relay channel 'off', in this case, number 1
relayNum = 0;
relay_write(serialObj,relayNum,'off');
%
% read a single relay channel, in this case, number 1
status = relay_read(serialObj,relayNum)
%%
% now, try reading the value of all the relays
% statusBin is the status in binary, statusHex is the status in hex
[statusBin,statusHex] = relay_read_all(serialObj,numBits)

%% now write all of the relay values, turn on 0, 2, 4, 6
% this will overwrite any of the previous relay settings
% desired channels is a vector that is the length of the number of channels
% in the relay, and at each relay location (the 1st 
desiredChannels = [1 0 0 1 0 1 0 1];
relay_write_all(serialObj,desiredChannels)

%% read again

% now, try reading the value of all the relays
% statusBin is the status in binary, statusHex is the status in hex
[statusBin,statusHex] = relay_read_all(serialObj,numBits)

%% write all of the relay settings, but preserve any that were on 
% this will keep any of the previous relay settings where ones were turned
% on 
desiredChannels = [0 1 0 0 0 0 0 0];
relay_write_all_preserve_on(serialObj,desiredChannels,numBits)

%% read again

% now, try reading the value of all the relays
% statusBin is the status in binary, statusHex is the status in hex
[statusBin,statusHex] = relay_read_all(serialObj,numBits)

