function [serialObj ] = establish_relay_connection(comPort)
% This is a function to establish a connection between MATLAB and a Numato
% relay attached to a given USB port. 
%
% inputs:
%   comPort - the port name as a string, e.g. 'COM4', that specifies to which
%   port MATLAB should open a connection. This needs to be specified during
%   the installation of the numato relay. 
%
% outputs:
%   serialObj - this is the serial port object upon which further operations
%   can be done 
%
%
% use:
%    serialObj = establish_relay_connection('COM4')
%
% David.J.Caldwell, djcald@uw.edu, University of Washington, 7/2018
% BSD-3 License
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% establish serial port connection to a given COM port, e.g. comPort =
% 'COM4'
serialObj = serial(comPort);
% open serial port
fopen(serialObj);
% change terminator to carriage return from line feed
serialObj.Terminator = 'CR';
fclose(serialObj);

end

