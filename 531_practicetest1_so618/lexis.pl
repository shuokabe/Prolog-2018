%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
%         MSc Prolog 531                           %
%                                                  %
%         Lexis Test                               %
%                                                  %
%         Question 1 (prison)                      %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
%         Question 1 (prison)                      %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% compile the Prison Database etc.

:- ensure_loaded(utilities).



cell(N) :-
   cells(Cells),
   in_range(1,Cells,N).


forall(C1, C2) :- \+ (C1, \+ C2).

%% ------ Add your code to this file here.

%% Uncomment the next two lines to skip Question 1 (a)
%% :- use_module(library(between)). 
%% in_range(Min,Max,N) :- between(Min,Max,N).

% in_range(+Min,+Max,?N)
in_range(Min, Max, Min) :-
    Min =< Max.

in_range(Min, Max, N) :-
    Min < Max,
    NewMin is Min + 1,
    in_range(NewMin, Max, N).


% --- empty cell
% empty_cell(?Cell)

empty_cell(Cell) :-
    cell(Cell),
    \+ prisoner(_Surname, _FirstName, Cell, _Crime, _Sentence, _ToServe).


% all_female_cell(?Cell)

all_female_cell(Cell) :-
    cell(Cell),
    \+ empty_cell(Cell),
    forall(prisoner(_Surname, FirstName, Cell, _, _, _),
    female_name(FirstName)).

% female_prisoners(?N)

female_prisoners(N) :-
    female_counter([], ListF),
    length(ListF, N).


female_counter(List, FinalL) :-
    prisoner(Surname, FirstName, _, _, _, _),
    female_name(FirstName),
    \+ member((Surname, FirstName), List), !,
    female_counter([(Surname, FirstName)|List], FinalL).

female_counter(FinalL, FinalL).

% Count the total number of prisoners.
prisoner_counter(List, FinalL) :-
    prisoner(Surname, FirstName, _, _, _, _),
    \+ member((Surname, FirstName), List), !,
    prisoner_counter([(Surname, FirstName)|List], FinalL).

prisoner_counter(FinalL, FinalL).


% cell_occupancy(?Cell, ?N)

cell_occupancy(Cell, N) :-
    cell(Cell),
    prisoner_counter_cell(Cell, [], FinalL),
    length(FinalL, N).

% Count the number of prisoners per cell.
prisoner_counter_cell(Cell, List, FinalL) :-
    prisoner(Surname, FirstName, Cell, _, _, _),
    \+ member((Surname, FirstName), List), !,
    prisoner_counter_cell(Cell, [(Surname, FirstName)|List], FinalL).

prisoner_counter_cell(_Cell, FinalL, FinalL).


% fullest_cell(?Cell)

fullest_cell(FullCell) :-
    findall((Cell, N), cell_occupancy(Cell, N), L),
    find_max(-1, L, Max),
    cell_occupancy(FullCell, Max).

% Find the maximum occupancy in the prison.
find_max(Max, [], Max).

find_max(I, [(_Cell, H)|T], Max) :-
    I < H, !,
    find_max(H, T, Max).

find_max(_I, [(_Cell, _H)|T], Max) :-
    find_max(_I, T, Max).


% worst_psychopath(?S,?F,?Crime,?T)

worst_psychopath(Surname, FirstName, Crime, T) :-
    findall(Sentence, (psychopath(Surname, FirstName), prisoner(Surname, FirstName, _, _, Sentence, _)), L),
    find_max_sentence(-1, L, T), !,
    psychopath(Surname, FirstName),
    prisoner(Surname, FirstName, _, Crime, T, _).

find_max_sentence(Max, [], Max).

find_max_sentence(I, [H|T], Max) :-
    I < H, !,
    find_max_sentence(H, T, Max).

find_max_sentence(_I, [_H|T], Max) :-
    find_max_sentence(_I, T, Max).


% criminals(?Crime,?N)

criminals(Crime, N) :-
    findall(Crime, prisoner(_, _, _, Crime, _, _), L),
    find_crimes(L, [], UniqueCrimeList),
    member(Crime, UniqueCrimeList),
    count_occ(Crime, L, 0, N).

% List of all crimes
find_crimes([], CrimeList, CrimeList).

find_crimes([Crime|ListPrison], List, CrimeList) :-
    \+ member(Crime, List), !,
    find_crimes(ListPrison, [Crime|List], CrimeList).

find_crimes([_Crime|ListPrison], List, CrimeList) :-
    find_crimes(ListPrison, List, CrimeList).

% Count all the occurences
count_occ(_, [], N, N).

count_occ(Element, [Element|List], I, N) :-
    !, NewI is I + 1,
    count_occ(Element, List, NewI, N).

count_occ(Element, [_H|List], I, N) :-
    count_occ(Element, List, I, N).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
%         Question 2 (ciphers)                     %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% character codes
%     a  97
%     z 122
%     A  65     (97 - 32)
%     Z  90     (122 -32)

%% ------ Add your code to this file here.


% upper_case_string(+String)

upper_case_string(String) :-
    length(String, 1),
    String < 91.

upper_case_string([H|T]) :-
    65 =< H,
    H =< 90,
    upper_case_string(T).

upper_case_string([32|T]) :-
    upper_case_string(T).


% subst_string(+Input, +Subst, -Output) 

subst_string(Input, Subst, Output) :-
    subst_char(Input, Subst, [], RevList),
    reverse_list(RevList, [], Output).

% Substitue the string character per character
subst_char([], _, FinOutput, FinOutput).

subst_char([H|T], In-Out, Output, FinOutput) :-
    member(H, In), !,
    match_char(In, Out, H, CorrH),
    subst_char(T, In-Out, [CorrH|Output], FinOutput).

subst_char([H|T], In-Out, Output, FinOutput) :-
    subst_char(T, In-Out, [H|Output], FinOutput).

% Find the corresponding character
match_char([Char|_In], [CorrChar|_Out], Char, CorrChar).

match_char([_H|In], [_CorrH|Out], Char, CorrChar) :-
    match_char(In, Out, Char, CorrChar).

% Reverse a list
reverse_list([], RevList, RevList).

reverse_list([H|T], List, RevList) :-
    reverse_list(T, [H|List], RevList).


% encrypt_string(+Plain, +Key, -Cipher)

% Convert upper character to lower character
upper_to_lower(Char, Out) :-
65 =< Char,
Char =< 90, !,
Out is Char + 32.

upper_to_lower(Char, Out) :-
Out is Char + 0.

encrypt_string(Plain, Key, Cipher) :-
encrypt_char(Plain, Key, [], RevCipher),
reverse_list(RevCipher, [], Cipher).

% Encrypt the string character per character
encrypt_char([], _, Cipher, Cipher).

encrypt_char([H|T], Key, Output, Cipher) :-
upper_to_lower(H, LowH),
match_char_alpha(97, Key, LowH, CorrChar),
encrypt_char(T, Key, [CorrChar|Output], Cipher).

% Find the corresponding character (alphabet)
match_char_alpha(Char, [CorrChar|_Out], Char, CorrChar) :- !.

match_char_alpha(In, [_CorrH|Out], Char, CorrChar) :-
In =< 122, !,
NewIn is In + 1,
match_char_alpha(NewIn, Out, Char, CorrChar).

match_char_alpha(_, [], Char, Char).


% decrypt_string(+Cipher, +Key, -Plain)

decrypt_string(Cipher, Key, Plain) :-
decrypt_char(Cipher, Key, [], RevPlain),
reverse_list(RevPlain, [], Plain).

% Decrypt the string character per character
decrypt_char([], _, Plain, Plain).

decrypt_char([H|T], Key, Output, Cipher) :-
match_char_alpha_rev(Key, 97, H, CorrChar),
decrypt_char(T, Key, [CorrChar|Output], Cipher).


match_char_alpha_rev([Char|_Out], CorrChar, Char, CorrChar) :- !.

match_char_alpha_rev([_CorrH|In], Out, Char, CorrChar) :-
Out =< 122, !,
NewOut is Out + 1,
match_char_alpha_rev(In, NewOut, Char, CorrChar).

match_char_alpha_rev([], _, Char, Char).


% keyphrase_cipher(+Keyphrase, -Key)

keyphrase_cipher(_, _) :- fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
%         Question 3 (graphs)                      %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ------ Add your code to this file here.


/* Uncomment this to skip Question 3 (a)

merge_ordered(Left,Right,Merged) :-
   append(Left,Right,Both),
   sort(Both,Merged).

*/

% merge_ordered(+Left,+Right,-Merged)

merge_ordered(_, _, _):- fail.
  


% hf_to_graph_term(+Hform, -Graph)

hf_to_graph_term(_, _) :- fail.



% graph_term_to_adj_list(+Graph, -AdjList)

graph_term_to_adj_list(_, _) :- fail.



