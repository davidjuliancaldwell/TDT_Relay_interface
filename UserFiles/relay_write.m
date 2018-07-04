function [] = relay_write(serialObj,relayNum,phrase)
flushinput(serialObj)
fprintf(serialObj,['relay ' phrase ' ' num2str(relayNum)]);
fscanf(serialObj); % get rid of command 
end
