%% script to have the numato's relay interface with the TDT
% 7.3.2018 - David.J.Caldwell

%% Open connection with TDT and begin program
DA = actxcontrol('TDevAcc.X');
DA.ConnectServer('Local'); %initiates a connection with an OpenWorkbench server. The connection adds a client to the server
pause(1)

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
% %
% % if wanting to do manual stims at the beginning
% while DA.GetTargetVal('RZ5D.condition') == 0
%     pause(0.1)
% end

ampsVec = [1000 2000 3000 4000];


%% get relays ready

% clean up workspace if necessar y
houseKeeping = 1;
if houseKeeping
    % house keeping
    newobjs = instrfind;
    if ~isempty(newobjs)
        fclose(newobjs);
    end
end
%%
% establish serial port connection
relay1 = serial('COM4');
relay2 = serial('COM3');
% open serial port
fopen(relay1);
fopen(relay2);
% change terminator to carriage return from line feed
relay1.Terminator = 'CR';
relay2.Terminator = 'CR';
% number of channels on the relay board
numBits = 8;

%% now stimulation through the relays
% all combinations of stimulation channels

numRelay = 8;
% generate all combinations
c = combnk(1:numRelay,2);
desiredChannels = zeros(1,numRelay);

% close all relays to start
relay_write_all(relay1,desiredChannels);

% disarm all the stimulation channels

for chan = 1:numRelay
    DA.SetTargetVal(['RZ5D.Ch~' num2str(chan) 'En'],0);
end

for channelCombinations = c'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the relays
    
    
    % since binary starts from the left, want to make sure that this is
    % represented appropriately.
    channelCombinations
    channelCombinationsReversed = (numRelay + 1) - channelCombinations;
    desiredChannels(channelCombinationsReversed) = 1;
    % write all
    relay_write_all(relay1,desiredChannels)
    % read all
    [statusBin,statusHex] = relay_read_all(relay1,numBits)
    pause(1)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % stimulation through TDT
    
    % first, arm all of the desired stimulation channels, and disarm any
    % others
    
    for chan = channelCombinations'
        DA.SetTargetVal(['RZ5D.Ch~' num2str(chan) 'En'],1);
    end
    
    
    % go through all of the desired amplitudes
    for amp = ampsVec
        
        % set each one of the channels within the channel combinations
        % vector to be the desired amplitude
        
        for chan = channelCombinations'
            DA.SetTargetVal(['RZ5D.Amp~' num2str(chan)],amp);
            DA.SetTargetVal(['RZ5D.Amp~' num2str(chan)],amp);
        end
        
        count = 1;
        
        DA.SetTargetVal('RZ5D.StimButton', 1);
        pause(0.01) % pausing to make sure the stim is triggered in the TDT
        DA.SetTargetVal('RZ5D.StimButton', 0);
        
        % wait for stimulation to end
        pause(6)
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % do the stimulation, now put them all back to being closed
    
    desiredChannels = zeros(1,numRelay);
    relay_write_all(relay1,desiredChannels)
    
    % disarm all the stimulation channels
    
    for chan = 1:numRelay
        DA.SetTargetVal(['RZ5D.Ch~' num2str(chan) 'En'],0);
    end
    
    
end
%%

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