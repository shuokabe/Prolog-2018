%% File: syllogisms.pl
%% Name: Shu Okabe
%% Date: 22/11/2018
%%
%% This program is a solution to Prolog 531 Assessed Exercise 5 'Syllogisms'
%% The exercise is to develop a parser and meta-interpreter for syllogistic
%% sentences, and use these to build a tool to determine the validity of a
%% syllogistic argument.

%% ---------------------------- Step 1 ---------------------------------------%%

%% opposite(+L, -Opp)

opposite([no, B, _Is, Option, C], [some, B, _Is, Option, C]).
opposite([no, B, _Is, C], [some, B, _Is, C]).

opposite([some, B, _Is, not, Option, C], [a, B, _Is, Option, C]).
opposite([some, B, _Is, not, C], [a, B, _Is, C]).

opposite([some, B, _Is, Option, C], [no, B, _Is, Option, C]) :-
	Option \= not.
opposite([some, B, _Is, C], [no, B, _Is, C]).

opposite([Article, B, _Is, Option, C], [some, B, _Is, not, Option, C]) :-
	Article \= no, Article \= some.
opposite([Article, B, _Is, C], [some, B, _Is, not, C]) :-
	Article \= no, Article \= some.


%% ---------------------------- Step 2 ---------------------------------------%%

%% Stage 2.1 - This is the suggested way to develop the solution.
%% Once Stage 2.2 is complete you can delete or comment out this code.
%% syllogism/0

%syllogism :- fail.

syllogism --> article, subject, is_verb, complement.
syllogism --> head_no, subject, is_verb, complement.
syllogism --> head_some, subject, is_verb, complement.
syllogism --> head_some, subject, is_verb, not_pres, complement.

subject --> [_].
complement --> subject.
complement --> option, subject.

article --> [a].
article --> [every].
head_no --> [no].
head_some --> [some].
not_pres --> [not].
option --> [a].
is_verb --> [is].


%% Stage 2.2 
%% syllogism(-Clauses)

syllogism([(PartC :- PartS)]) --> article(_A), subject(S), is_verb(_I), complement(C),
    {PartC =.. [C, X], PartS =.. [S, X]}.

syllogism([(false :- PartS, PartC)]) --> head_no(_HN), subject(S), is_verb(_I), complement(C), {PartC =.. [C, X], PartS =.. [S, X]}.

syllogism([(PartS :- true), (PartC :- true)]) --> head_some(_HS), subject(S), is_verb(_I), complement(C),
    {SomeSC =.. [some, S, C], PartS =.. [S, SomeSC], PartC =.. [C, SomeSC]}.

syllogism([(PartS :- true), (false :- PartC)]) --> head_some(_HS), subject(S), is_verb(_I), not_pres(_NOT), complement(C),
    {SomeSNC =.. [some, S, not(C)], PartS =.. [S, SomeSNC], PartC =.. [C, SomeSNC]}.


subject(S) --> [S], {subject(S)}.
article(A) --> [A], {article(A)}.
head_no(HN) --> [HN], {head_no(HN)}.
head_some(HS) --> [HS], {head_some(HS)}.
is_verb(I) --> [I], {is_verb(is)}.
option(O) --> [O], {option(O)}.
not_pres(NOT) --> [NOT], {not_pres(NOT)}.
complement(C) --> subject(C).
complement(C) --> option(_O), subject(S), {C = S}. %{C = [O|S]}.

subject(_).
article(a).
article(every).
head_no(no).
head_some(some).
not_pres(not).
option(a).
is_verb(is).


%% ---------------------------- Step 3 ---------------------------------------%%

%% translate(+N)

:- dynamic cl/3.

translate(N) :-
    p(N, S), phrase(syllogism(ClauseS), S),
    p(N, T), T \= S, phrase(syllogism(ClauseT), T),
    c(N, U), opposite(U, O), phrase(syllogism(ClauseO), O),
    assertall(N, ClauseS),
    assertall(N, ClauseT),
    assertall(N, ClauseO).


%% ---------------------------- Step 4 ---------------------------------------%%

%% eval(+N, +Calls)

%eval(N, Calls) :-
%cl(N, _H, _B),
%clause(Calls, _Body).

eval(N, false) :-
eval_temp(N, false, _B).

eval_temp(N, false, B) :-
clause(cl(N, B, _NextB), _Body).

eval_temp(_N, _H, true).

eval_temp(N, H, B) :-
clause(cl(N, H, _NextB), B),
eval_temp(N, _NextB, B).


%% valid(?N)

valid(N) :-
    eval(N, false).

%% invalid(?N)

invalid(N) :-
    \+ eval(N, false).

%% ---------------------------- Step 5 ---------------------------------------%%

%% test(+N)

test(N) :-
    translate(N), % if not done before
    show_syllogism(N),
    nl,
    format("Premises and opposite of conclusion converted to clauses:", []), nl,
    show_clauses(N),
    nl,
    valid_syl(N).
    %format("false can be derived, syllogism ~d is valid.", [N]).

% show_syllogism(+N) displays the (untranslated) premises and conclusion of the Nth syllogism
show_syllogism(N) :-
    format("syllogism ~d:", [N]), nl,
    forall(
        p(N, L),
        (write('   '), writeL(L), nl)
    ),
    write('   '), write(=>), nl,
    forall(
        c(N, C),
        (write('   '), writeL(C), nl)
    ).


% valid_syl(+N) displays the final sentence about the validity of the syllogism.
valid_syl(N) :-
    valid(N), !, % The syllogism is valid.
    format("false can be derived, syllogism ~d is valid.", [N]).

valid_syl(N) :-
    invalid(N), !, % The syllogism is invalid.
    format("false cannot be derived, syllogism ~d is invalid.", [N]).


