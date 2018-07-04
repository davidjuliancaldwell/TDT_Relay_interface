% Clear variables we don't want to save
clearvars DA
blockName = getLatestFile_relay(tank);
save([tank, '\', blockName, '_relay.mat']);


