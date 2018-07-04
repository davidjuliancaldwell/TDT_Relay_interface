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

%%

% set target values
% set amplitudes
chansVec = [1 2 3 4];
ampsVec = [1000 2000 3000 4000];
count = 1;
for chan = chansVec
    DA.SetTargetVal(['RZ5D.Amp~' num2str(chan)],ampsVec(count));
   count = count + 1; 
end

%% stimulation

trialStructure = 

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