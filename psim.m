%%
%   Monte Carlo simulation of poker game outcomes.
%
%   p=psim(pocket,flop,turn,river,nOpponents,hr)
%
%   INPUT:
%           pocket, "my" cards, 2-by-1 vector. Requiered.
%           flop, flop cards, 3-by-1 vector, can be empty [].
%           turn, turn card, scalar, can be empty [].
%           river, river card, scalar, can be empty [].
%           nOpponents, number of opponents with cards in game, scalar,
%           range 1-5.
%           hr, handranks.dat, for 2+2 hand evaluation algorithm, 
%           1-by-32487833 vector, uint8.
%
%   OUTPUT:
%           p, winrates for each player, 1-by-nOpponents+1 vector, last
%           element "my" winrate. sum(p)=1.
%
function p=psim(pocket,flop,turn,river,nOpponents,hr)
	nGames=10000;						% Number of games simulations
	nReuse=1;                           % Pick a game from each shuffeled deck nReuse times, 
										% seems to be ok, otherwise set to 1.
										% Range, 1-3. (Experimental, default 1)

	% Information about dealt cards.
	pocket=uint8(pocket);                           % My dealt hand, always given. 2-by-1 vector.
	flop=uint8(flop);                               % 3-by-1 vector. Optional.
	turn=uint8(turn);                               % Scalar. Optional.
	river=uint8(river);                             % Scalar. Optional.
	knownCards=uint8([pocket; flop; turn; river]);  % Collect known cards

	% Make and shuffle decks
	aDeck=uint8((1:52).');                          % Deck of cards.
	aDeck(ismember(aDeck,knownCards))=[];           % Remove cards that are already dealt.
	[~,randInd]=sort(rand(length(aDeck),nGames));   % Make random index to shuffle nGames decks.
	allDecks=aDeck(randInd);                        % Shuffle according to random index, randInd.

	% Deal cards that have not been dealt.
	pockets=zeros([2 nGames*nReuse nOpponents],'uint8');   % Allocate pocket matrix
	board=zeros([5 nGames*nReuse],'uint8');                % Allocate board matrix
	% Some index for deal algorithm. [4 lines]
	startInd=[1 nGames+1 2*nGames+1];
	stopInd=[nGames nGames*2 nGames*3];
	bottom=length(aDeck);
	flopInd=bottom-(6:14);

	for j=1:nReuse
		% Deal pocket cards for opponents. Pick from top of deck
		ctr=1;                                              % Counter
		for i=1:2:nOpponents*2
			pockets(:,startInd(j):stopInd(j),ctr)=allDecks((i:i+1)+(nOpponents*j)*(j>1),:); 
			ctr=ctr+1;
		end
		% Board cards are drawn from bottom and up. 
		% If no river - deal it.
		if isempty(river)
			board(5,startInd(j):stopInd(j))=allDecks(end-j-1,:);
		else
			board(5,:)=river;
		end
		% If no turn - deal it.
		if isempty(turn)
			board(4,startInd(j):stopInd(j))=allDecks(end-4-j,:);
		else
			board(4,:)=turn;
		end
		% If no flop - deal it.
		if isempty(flop)
			board(1:3,startInd(j):stopInd(j))=allDecks(flopInd(1:3)*(j==1)+flopInd(4:6)*(j==2)+flopInd(7:9)*(j==3),:);
		else
			board(1,:)=flop(1);
			board(2,:)=flop(2);
			board(3,:)=flop(3);
		end
	end

	% Hand evaluation
	handType=zeros([nOpponents+1 nGames*nReuse]);    % Pre-allocate hand type matrix
	handRank=zeros([nOpponents+1 nGames*nReuse]);    % Pre-allocate hand rank matrix
	% Calculate opponents hand type and ranks.
	for i=1:nOpponents
		[handType(i,:),handRank(i,:)]=handEval([pockets(:,:,i);board],hr);
	end
	% Get My hand type and ranks.
	[handType(end,:),handRank(end,:)]=handEval([repmat(pocket,1,nGames*nReuse);board],hr); 
	p=winRate(handType,handRank).';
end