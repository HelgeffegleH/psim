% psim example
if ~exist('hr','var')
	handranks_read;
end
pocket = [21 22].';		% 7c 7d (7 clubs, 7 diamonds) ("My cards")
flop = [47 49 1].';		% kh ac 2c (king hearts,  Ace clubs, 2 clubs)
turn=[];				% not dealt
river=[];				% not dealt
nOpponents = 2;			% 2 opponents
t=tic;
p=psim(pocket,flop,turn,river,nOpponents,hr);	% simulate games.
e=toc(t);
format short
clc
disp(['Simulated 10000 games in ' num2str(e) ' seconds.']);
disp(['"My" winrate: ' num2str(p(end)*100) '%']);