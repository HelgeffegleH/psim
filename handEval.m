%%
%   2+2 7-card poker hand evaluation algorithm.
%
%   INPUT:
%           pCards, players cards, 7-by-nGames*nReuse matrix, uint8.
%           hr, handranks.dat, for 2+2 hand evaluation algorithm, 
%           1-by-32487833 vector, uint32.
%   OUTPUT:
%           handType, players hand types, nOpponents+1-by-nGames*nReuse matrix, 0 is
%           invalid hand(shouldn't occur), 1 is high card, 2 is pair,...,9 is straight flush. 
%           handRank, the rank of players hand type, 1 is worst rank of
%           hand type X, higher rank better hand.
%
function [handType, handRank]= handEval(pCards,hr)
	pCards=uint32(pCards);
	p = hr(53+pCards(1,:));
	p = hr(p+pCards(2,:));
	p = hr(p+pCards(3,:));
	p = hr(p+pCards(4,:));
	p = hr(p+pCards(5,:));
	p = hr(p+pCards(6,:));
	p = hr(p+pCards(7,:));
	handType=bitshift(p,-12);
	handRank=bitand(p,4095);
end