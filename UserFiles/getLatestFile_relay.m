function [filename] = getLatestFile_relay(fileDir)

a = dir(fileDir);
[~, index] = max([a.datenum]);
filename = a(index).name;

end

