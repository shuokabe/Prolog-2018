%% File: crossings.pl
%% Name: Shu Okabe
%% Date: 31/10/2018
%%
%% This program is a solution to Prolog 531 Assessed Exercise 2 'Crossings'
%% The exercise is a version of the classic Farmer-Wolf-Goat-Cabbage Puzzle

%% Step 1 safe(+Bank)
safe(Bank) :- 
	member(f, Bank).

safe(Bank) :- 
	nonmember(w, Bank), 
	nonmember(g, Bank).

safe(Bank) :-
	member(w, Bank), !,
	nonmember(g, Bank).

safe(Bank) :- 
	member(g, Bank), !, 
	nonmember(c, Bank).


%% Step 2 goal(+State)
goal([]-South):- 
	length(South, 5),
	member(f, South),
	member(w, South),
	member(g, South),
	member(c, South),
	member(b, South).


%% Step 3 equiv(+State1, +State2)
% 
contains_list([], _).
contains_list([H|T], List2) :-
	member(H, List2),
	contains_list(T, List2).

equiv(North1-South1, North2-South2) :- 
	length(North1, _LengthN),
	length(North2, _LengthN), !,
	length(South1, _LengthS),
	length(South2, _LengthS), !,
	contains_list(North1, North2), 
	contains_list(South1, South2),
	contains_list(North2, North1), 
	contains_list(South2, South1).


%% Step 4 visited(+State, +Sequence)
visited(State, Sequence):- 
	member(Stateseq, Sequence),
	equiv(State, Stateseq).


%% Step 5 choose(-Items, +Bank)
%
remove_element(_, [], Listfin, Listfin).
remove_element(H, [H|T], List, Listfin) :- !,
	remove_element(H, T, List, Listfin).
remove_element(Element, [H|T], List, Listfin) :- 
	remove_element(Element, T, [H|List], Listfin).

choose([f], Bank) :- 
	member(f, Bank),
	remove_element(f, Bank, [], _Bankafter),
	safe(_Bankafter).

choose([f, Item], Bank) :- 
	member(f, Bank),
	member(Item, Bank),
	Item \= f,
	remove_element(f, Bank, [], _Bankafterf),
	remove_element(Item, _Bankafterf, [], _Bankafter),
	safe(_Bankafter).


%% Step 6 journey(+State1, -State2)
% North Bank to South Bank
journey(North1-South1, North2-South2) :- 
	choose([f], North1),
	remove_element(f, North1, [], North2),
	append([f], South1, South2).

journey(North1-South1, North2-South2) :- 
	choose([f, Item], North1),
	remove_element(f, North1, [], NewNorth2f),
	remove_element(Item, NewNorth2f, [], North2),
	append([f, Item], South1, South2).

% South Bank to North Bank
journey(North1-South1, North2-South2) :- 
	choose([f], South1),
	remove_element(f, South1, [], South2),
	append([f], North1, North2).

journey(North1-South1, North2-South2) :- 
	choose([f, Item], South1),
	remove_element(f, South1, [], NewSouth2f),
	remove_element(Item, NewSouth2f, [], South2),
	append([f, Item], North1, North2).


%% Step 7 succeeds(-Sequence)
reverse_list([], Reversed, Reversed).
reverse_list([H|T], Reversed, List) :-
    	reverse_list(T, [H|Reversed], List).

succeeds(Sequence) :-
	extend([[f,w,g,c,b]-[]], [f,w,g,c,b]-[], RevSequence),
    	reverse_list(RevSequence, [], Sequence).

extend(Sequence, LastState, Sequence) :-
	goal(LastState).

extend(VisitedSeq, LastStateSoFar, Sequence) :- 
	journey(LastStateSoFar, NextState),
    	\+ visited(NextState, VisitedSeq),
	extend([NextState|VisitedSeq], NextState, Sequence).


%% Step 8 fee(+State1, +State2, -Fee)
fees(2, 4).

fee(North1-South1, North2-South2, Fee):-
    	choose([f], North1),
	remove_element(f, North1, [], NewNorth2),
    	append([f], South1, NewSouth2),
    	equiv(NewNorth2-NewSouth2, North2-South2), !,
    	fees(Fee, _).

fee(North1-South1, North2-South2, Fee):-
    	choose([f, Item], North1),
    	remove_element(f, North1, [], NewNorth2f),
    	remove_element(Item, NewNorth2f, [], NewNorth2),
    	append([f, Item], South1, NewSouth2),
	equiv(NewNorth2-NewSouth2, North2-South2),
    	fees(_, Fee).

fee(North1-South1, North2-South2, Fee):-
    	choose([f], South1),
    	remove_element(f, South1, [], NewSouth2),
    	append([f], North1, NewNorth2),
    	equiv(NewNorth2-NewSouth2, North2-South2), !,
    	fees(Fee, _).

fee(North1-South1, North2-South2, Fee):-
    	choose([f, Item], South1),
    	remove_element(f, South1, [], NewSouth2f),
    	remove_element(Item, NewSouth2f, [], NewSouth2),
    	append([f, Item], North1, NewNorth2),
    	equiv(NewNorth2-NewSouth2, North2-South2),
    	fees(_, Fee).


%% Step 9 cost(-Sequence, -Cost)
cost(Sequence, Cost):-
	succeeds(Sequence),
	cost_journey(Sequence, 0, Cost).
	
cost_journey([_State], Cost, Cost).

cost_journey([State1, State2 | Sequence], CostSoFar, FinCost) :-
	fee(State1, State2, Fee),
	NewCost is CostSoFar + Fee,
	cost_journey([State2 | Sequence], NewCost, FinCost).

