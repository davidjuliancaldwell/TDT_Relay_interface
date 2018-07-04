function [status] = relay_read(serialObj,relayNum)

flushinput(serialObj)
fprintf(serialObj,['relay read ' num2str(relayNum)]);
commandInfo = fscanf(serialObj);
status = fscanf(serialObj);

end