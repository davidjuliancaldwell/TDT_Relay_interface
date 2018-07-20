%% script to run the TDT stimulation through various voltage settings with no relay
% 7.16.2018 - David.J.Caldwell

%% user parameters

% define the amplitudes in uA to be tested
ampsVec = [10 50 100 500 1000 1500 2000];
stimsOn = [1 2]; % which channels to engage
% define stimulation parameters
PW = 1200; % us
IPI = 498000; % us
PTD = 10008; % ms
ITI = 1227; % ms
numTrains = 1;

% only use first stim output channel
chan = 1;

% duration to pause, add 2 seconds to pulse train duration
pauseTime = PTD/1000 + 2;
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

%% now set appropriate settings once connected

% turn on first channel stimulation
DA.SetTargetVal(['RZ5D.ITI-mat'],ITI);
DA.SetTargetVal(['RZ5D.NumTrains-Mat'],numTrains);
DA.SetTargetVal(['RZ5D.PW-Mat'],PW);
DA.SetTargetVal(['RZ5D.IPI-Mat'],IPI);
DA.SetTargetVal(['RZ5D.PTD-Mat'],PTD);
%
for chan = stimsOn
    DA.SetTargetVal(['RZ5D.ChEnMat~' num2str(chan)],1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% stimulation through TDT

% go through all of the desired amplitudes
for amp = ampsVec
    
    for chan = 1:stimsOn
        DA.SetTargetVal(['RZ5D.Amp-Mat~' num2str(chan)],amp);
        
    end
    
    disp(['the current amplitude is ' num2str(amp) ' uA'])
    count = 1;
    
    DA.SetTargetVal('RZ5D.StimButton', 1);
    pause(0.02) % pausing to make sure the stim is triggered in the TDT
    DA.SetTargetVal('RZ5D.StimButton', 0);
    
    % wait for stimulation to end, assume 2 Hz stim, 20 pulses @ each
    pause(pauseTime)
    
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
%save_numato_relay