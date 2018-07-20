%% script to have the numato's relay interface with the TDT
% 7.3.2018 - David.J.Caldwell

%% user parameters

% all combinations of stimulation channels
% define the amplitudes in uA to be tested 
ampsVec = [100 500 1000 1500];

%% Open connection with TDT and begin program
DA = actxcontrol('TDevAcc.X');
DA.ConnectServer('Local'); %initiates a connection with an OpenWorkbench server. The connection adds a client to the server
pause(1)

% try until a connection is established 
while DA.CheckServerConnection ~= 1
    disp('OpenWorkbench is not connected to server. Trying again...')
    close all
    DA = actxcontrol('TDevAcc.X');
    DA.ConnectServer('Local');
    pause(1) % seconds
end
clc
disp('Connected to server')

% If OpenWorkbench is not in Record mode, then this will set it to record
if DA.GetSysMode ~= 3
    DA.SetSysMode(3);
    while DA.GetSysMode ~= 3
        pause(.1)
    end
end

% Before proceeding make sure that the system is armed:
if DA.GetTargetVal('RZ5D.IsArmed') == 0
    disp('System is not armed');
elseif DA.GetTargetVal('RZ5D.IsArmed') == 1
    disp('System armed');
end

while DA.GetTargetVal('RZ5D.IsArmed')~=1
    % waiting until the system is armed
end
pause(1)
disp('System armed');

tank = DA.GetTankName;

%% close any existing connections to the relays
houseKeeping = 1;
if houseKeeping
    % house keeping
    newobjs = instrfind;
    if ~isempty(newobjs)
        fclose(newobjs);
    end
end
%% establish serial port connection
relay1 = establish_relay_connection('COM4');
relay2 = establish_relay_connection('COM5');
% number of channels on the relay board
numBits = 8;
disp('connection to relays established')



%% now stimulation through the relays

% number of relays 
numRelay = 8;
% generate all combinations
c = combnk(1:numRelay,2);
desiredChannelsFirst = zeros(1,numRelay);
desiredChannelsSecond = desiredChannelsFirst;

active = 1;
ground = 2;

% close all relays to start
relay_write_all(relay1,desiredChannelsFirst);
relay_write_all(relay2,desiredChannelsSecond);

%% now set appropriate settings once connected

% turn on first channel stimulation
DA.SetTargetVal(['RZ5D.ITI-mat'],ITI);
DA.SetTargetVal(['RZ5D.NumTrains-Mat'],numTrains);
DA.SetTargetVal(['RZ5D.PW-Mat'],PW);
DA.SetTargetVal(['RZ5D.IPI-Mat'],IPI);
DA.SetTargetVal(['RZ5D.PTD-Mat'],PTD);

%%
%disarm all the stimulation channels

for chan = 1:numRelay
    DA.SetTargetVal(['RZ5D.ChEnMat~' num2str(chan)],0);
end

for channelCombinations = c'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the relays

    % since binary starts from the left, want to make sure that this is
    % represented appropriately.
    disp(['channels stimulated = ' num2str(channelCombinations')])
    channelCombinationsReversed = (numRelay + 1) - channelCombinations;
    desiredChannelsFirst(channelCombinationsReversed) = 1;
    desiredChannelsSecond(numRelay + 1 - channelCombinations(ground)) = 1;
    % write all
    relay_write_all(relay1,desiredChannelsFirst);
    relay_write_all(relay2,desiredChannelsSecond);

    % read all
    [statusBin,statusHex] = relay_read_all(relay1,numBits);
    disp(['status of relay 1 = [ ' num2str(statusBin) ' ]'])

    [statusBin,statusHex] = relay_read_all(relay2,numBits);
    disp(['status of relay 2 = [ ' num2str(statusBin) ' ]'])

    pause(1)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % stimulation through TDT
    
    % first, arm all of the desired stimulation channels, and disarm any
    % others
    
    for chan = channelCombinations'
    DA.SetTargetVal(['RZ5D.ChEnMat~' num2str(chan)],1);
    end

    % go through all of the desired amplitudes
    for amp = ampsVec
        
        % set each one of the channels within the channel combinations
        % vector to be the desired amplitude
        
        for chan = channelCombinations'
            DA.SetTargetVal(['RZ5D.Amp-Mat~' num2str(chan)],amp);
        end
        
        count = 1;
        
        DA.SetTargetVal('RZ5D.StimButton', 1);
        pause(0.02) % pausing to make sure the stim is triggered in the TDT
        DA.SetTargetVal('RZ5D.StimButton', 0);
        
        % wait for stimulation to end
        pause(7)
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % do the stimulation, now put them all back to being closed
    
    desiredChannelsFirst = zeros(1,numRelay);
    desiredChannelsSecond = desiredChannelsFirst;
    relay_write_all(relay1,desiredChannelsFirst)
    relay_write_all(relay2,desiredChannelsSecond)
    
    % disarm all the stimulation channels
    
    for chan = 1:numRelay
    DA.SetTargetVal(['RZ5D.ChEnMat~' num2str(chan)],0);
    end
    
    
end
%
disp('this stimulation run has been finished')


%% When run is ended, close the connection

% Disarm stim:
DA.SetTargetVal('RZ5D.ArmSystem', 0);

% Read the loaded circuit's name so that we can save this
circuitLoaded = DA.GetDeviceRCO('RZ5D');

% Close ActiveX connection:
DA.CloseConnection
if DA.CheckServerConnection == 0
    disp('Server was disconnected');
end

%% Save the values
save_numato_relay