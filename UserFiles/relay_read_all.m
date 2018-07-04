function [statusBin,statusHex] = relay_read_all(serialObj)

flushinput(serialObj)
fprintf(serialObj,['relay readall'])
commandInfo = fscanf(serialObj);
statusHex = fscanf(serialObj);
statusBin = hexToBinaryVector(statusHex);
end