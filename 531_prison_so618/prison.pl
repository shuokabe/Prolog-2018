/*

    Module 531: Laboratory (Prolog)
    Exercise No.4  (prison)

*/


% May be helpful for testing

% generate_integer(+Min, +Max, -I)
%   I is an integer in the range Min <= I <= Max

generate_integer(Min,Max,Min):-
  Min =< Max.
generate_integer(Min,Max,I) :-
  Min < Max,
  NewMin is Min + 1,
  generate_integer(NewMin,Max,I).
  
  
% Uncomment this line to use the provided database for Problem 2.
% You MUST recomment or remove it from your submitted solution.
% :- include(prisonDb).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prison_game(+Cells, +Warders, -Escaped)
%   Escaped is a list of cell numbers for prisoners who will escape
%   once all warders have completed their runs.

prison_game(Cells, Warders, Escaped) :-
  integer(Cells), Cells > 0,
  integer(Warders), Warders > 0,
  make_list(Cells, unlocked, Initial),
  run_warders(2, Warders, Initial, Final),
  extract_indices(Final, unlocked, Escaped).
  

% Write your program here.

% Task 1.1 make_list(+N, +Item, -List).
%   Given a (non-negative) integer N and item Item constructs list List of N
%   elements each of which is Item
make_list(N, Item, List) :- 
	make_list_acc(N, Item, [], List).

make_list_acc(0, _Item, FinList, FinList).
make_list_acc(N, Item, TempList, FinList) :-
	N > 0, 
	NewN is N - 1, !,
	make_list_acc(NewN, Item, [Item|TempList], FinList).


% Task 1.2 extract_indices(+List, +Item, -Indices).
%   Given list List and item Item computes the list Indices of integers N such
%   that Item is the Nth item of the list List

extract_indices(List, Item, Indices) :-
	extract_indices_temp(List, Item, 1, [], RevIndices),
	reverse_list(RevIndices, [], Indices).

extract_indices_temp([], _Item, _CurrIndex, FinIndices, FinIndices).

extract_indices_temp([Item|T], Item, CurrIndex, TempIndices, FinIndices) :- 
	NextIndex is CurrIndex + 1, 
	extract_indices_temp(T, Item, NextIndex, [CurrIndex|TempIndices], FinIndices).

extract_indices_temp([H|T], Item, CurrIndex, TempIndices, FinIndices) :- 
	H \= Item, 
	NextIndex is CurrIndex + 1, !,
	extract_indices_temp(T, Item, NextIndex, TempIndices, FinIndices).

reverse_list([], RevList, RevList).
reverse_list([H|T], RevListAcc, RevList) :- 
	reverse_list(T, [H|RevListAcc], RevList).


% Task 1.3 run_warders(+N, +W, +Initial, -Final). 
%   Given next warder N and total warders W (both positive integers), and 
%   current door states Initial (a list of the constants locked and unlocked) 
%   returns Final, the list of door states after all warders have completed 
%   their runs.


run_warders(W, W, Initial, Final) :- 
	run_one_warder(W, 1, Initial, [], RevFinal),
	reverse_list(RevFinal, [], Final).

run_warders(N, W, InitialW, Final) :- 
	N < W,
	run_one_warder(N, 1, InitialW, [], RevNextW),
	reverse_list(RevNextW, [], NextW),
	NewN is N + 1, !,
	run_warders(NewN, W, NextW, Final).


run_one_warder(_N, _CurrDoor, [], Fin, Fin).

run_one_warder(N, N, [locked|Initial], Next, Fin) :-
	run_one_warder(N, 1, Initial, [unlocked|Next], Fin).

run_one_warder(N, N, [unlocked|Initial], Next, Fin) :-
	run_one_warder(N, 1, Initial, [locked|Next], Fin).

run_one_warder(N, CurrDoor,  [H|Initial], Next, Fin) :-
	N > CurrDoor,
	NextDoor is CurrDoor + 1, !,
	run_one_warder(N, NextDoor, Initial, [H|Next], Fin).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Write your program here.

% Task 2.1 cell_status(+Cell, +N, ?Status)
%   Succeeds if the status of cell Cell is Status after N warders have made 
%   their runs. If Status is a variable, then the correct value should be 
%   returned.

cell_status(Cell, _N, locked) :- 
	psycho_present(Cell).

cell_status(Cell, N, Status) :- 
	\+ psycho_present(Cell),
	StopGame is min(Cell, N),
	divisor(Cell, 1, StopGame, [], WarderUseKey),
	even_odd_status(WarderUseKey, Status).

psycho_present(Cell) :-
	prisoner(Surname, FirstName, Cell, _Crime, _Sentence, _ToServe),
	psychopath(Surname, FirstName).

divisor(_Number, Index, StopNumber, FinList, FinList) :-
	Index > StopNumber.

divisor(Number, Index, StopNumber, TempList, FinList) :- 
	Index =< StopNumber,
	Remainder is Number mod Index, Remainder = 0,
	NextIndex is Index + 1, !,
	divisor(Number, NextIndex, StopNumber, [Index|TempList], FinList).

divisor(Number, Index, StopNumber, TempList, FinList) :- 
	Index =< StopNumber,
	Remainder is Number mod Index, Remainder > 0,
	NextIndex is Index + 1, !,
	divisor(Number, NextIndex, StopNumber, TempList, FinList).

even_odd_status(List, locked) :- 
	length(List, DoorOpenClosed), 
	Even is DoorOpenClosed mod 2, Even = 0.

even_odd_status(List, unlocked) :- 
	length(List, DoorOpenClosed), 
	Odd is DoorOpenClosed mod 2, Odd = 1.


% Task 2.2 

% escaped(?Surname, ?FirstName)
%   holds when the prisoner with that name escapes (i.e., occupies a cell which 
%   is unlocked after the last warder has made his run, but bearing in mind that
%   prisoners with a year or less left to serve will not escape).

escaped(Surname, FirstName) :- 
	prisoner(Surname, FirstName, Cell, _Crime, _Sentence, ToServe),
	ToServe > 1,
	warders(NWarders),
	cell_status(Cell, NWarders, unlocked).


% escapers(-List)
%   List is the list of escaped prisoners. List is a list of terms of the form 
%   (Surname, FirstName), sorted in ascending alphabetical order according to 
%   Surname.

escapers(List) :- 
	findall((SurName, FirstName), escaped(SurName, FirstName), ListToSort),
	sort(ListToSort, List).




