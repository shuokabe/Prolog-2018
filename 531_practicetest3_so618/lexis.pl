% lexis.pl


:-consult('support').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1 (5%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read_move(-Move) ... [or read_move(-Move, +Input, ?Remainder) as a non-DCG rule]
%   Given an Input string of the form:
%     "xy"        - where x is a valid column and y is a valid row, e.g. "e6"
%   or 
%     "xyd" - where x is a valid column 
%                   y is a valid row
%                   d is either "v" or "h", e.g. "c6h"
%   Returns the corresponding internal representation of the move as Move 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 (50%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2 (a) in_range(?N,+Min,+Max) 

% Uncomment the following to skip this part.
/*
:- use_module(library(between)).

in_range(N, Min, Max):-
  between(Min, Max, N).
*/
    

    
% 2(b) fence_space(+Fs,?Space)
%   Given the list Fs of existing fences,
%   Space is a fence space, i.e. a new fence Space = (X,Y,Dir)
%   could be added, ignoring the paths open to either pawn.

% Uncomment the following incomplete program to skip this part.
/*
fence_space(_, (1,1,h)).
fence_space(_, (1,1,v)).
*/
  


% 2(c) reachable(+From,+Fences,?To)
%   Succeeds iff To = (X1,Y1) is reachable by a pawn at From = (X,Y) 
%   with the given list of Fences, ignoring the position of the other pawn.

% Uncomment the following incomplete program to skip this part.
/*
reachable(_, _, (1,1)).
reachable(_, _, (9,9)).
*/



% 2(d) fence_move(NumFs, Fences, (OppX,OppY), OppTarget, NewF)
%   Given NumFs, the number of fences the player has left to play,
%   the list Fs = [(X,Y,Dir),...] of fences on the board, 
%   (OppX,OppY) the position of the opposing pawn, and
%   OppTarget, the row the opponent is trying to reach,
%   returns a fence = (X,Y,Dir) that can be added according to the rules.


    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3 (20%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% pawn_move(+OpSq,+Fs,+From,?To).
%   Given pairs OpSq = (OppX,OppY) and From = (X,Y) defining the current
%   locations of the two pawns, and a list Fs = [(F1X,F1Y,F1Dir),...], 
%   returns a valid square To = (X1,Y1) that the pawn at (X,Y) can move to 
%   in a single turn.

% Uncomment the following to skip this Question.
/*
pawn_move(_, _, _, (5,2)).
pawn_move(_, _, _, (6,1)).
pawn_move(_, _, _, (4,1)).
*/


    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4 (15%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4 (a) game_over(+State)
%   Given a board state State, succeeds if one of the players has won the game.



% 4 (b) next_state(+S0,+Player,+Move,?S1).
%   Returns S1, given S0, Player and Move.
%   S0 and S1 are states. 
%   Move is either (X,Y) or (X,Y,Dir)
%   Player is either p1 or p2.


    
% 4 (c) play(+Player,+Name,+OppName,+State,-Winner)
%  Given Player (either p1 or p2) identifying the next player to take a turn,
%  their name Name, their opponent's name OppName, and the current board State,
%  returns the winner's name as Winner.
    



