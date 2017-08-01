%%
%       Calculate win rate, given players hand types and rank of each hand.
%
%   INPUT:
%           handType, players hand types, nOpponents+1-by-nGames*nReuse matrix, 0 is
%           invalid hand(shouldn't occur), 1 is high card, 2 is pair,...,9 is straight flush. 
%           handRank, the rank of players hand type, 1 is worst rank of
%           hand type X, higher rank better hand.
%   Output:
%           p, winrates for each player, 1-by-nOpponents+1 vector, last
%           element "my" winrate. sum(p)=1.
%
function p=winRate(handType,handRank)
	[nPlayers,nGames]=size(handType);       % Get constants.
	scores=handType*1e8+handRank;           % Calculate score, put 1e8 factor on hand type, add rank.
	M=max(scores);                          % Get max score in each game.
	win=scores==repmat(M,[nPlayers 1]);     % Let all players with max score be a winner.(per game)
	nWins=repmat(sum(win),[nPlayers 1]);    % Credit 1/(number of winners) to each winner. (per game)
	p=sum(win./nWins,2)/nGames;             % Calculate win rates.
end
