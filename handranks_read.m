%%
% Script for reading Handranks.dat.
% For two plus two hand evaluation algorithm.

fileID=fopen('HandRanks.dat','r');
hr = fread(fileID,inf,'uint32=>uint32',0,'l');
hr(1)=[];   % Needed because matlab indices starts at 1, algorithm developed
            % for (probably) c.
hr=hr.';    % To fit structure in pa. Not needed for algorithm.
fclose(fileID);