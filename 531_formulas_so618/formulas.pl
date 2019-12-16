% 531 Prolog
% Assessed Exercise 1
% formulas.pl
% Shu Okabe

% Write your answers to the exercise here

% Task 1: wff(+F)
% wff(F) holds when F is a (well-formed) formula.

wff(F) :- 
    ground(F), 
    logical_atom(F).

wff(neg(F)) :- 
    ground(F), 
    wff(F).

wff(and(X, Y)) :- 
    ground(X), 
    ground(Y), 
    wff(X),
    wff(Y).

wff(or(X, Y)) :- 
    ground(X), 
    ground(Y), 
    wff(X),
    wff(Y).

wff(imp(X, Y)) :- 
    ground(X), 
    ground(Y),  
    wff(X),
    wff(Y).


% Task 2: cls(+F)
% cls(F) holds when the formula F is a clause; a clause is either a literal or
% a disjunction of literals, and a literal is either an atom or a negated atom.

cls(F) :- % literal (atom)
    ground(F), 
    logical_atom(F).

cls(neg(F)) :- % literal (negated atom)
    ground(F),
    logical_atom(F).

cls(or(X, Y)) :- % disjunction of literals
    wff(or(X, Y)),
    cls(X),
    cls(Y).


% Task 3: ats(+F, -As)
% given the formula F, returns As as a duplicate-free list (in any order) of 
% the atoms in F.

ats(F, As) :- 
    ground(F), 
    logical_atom(F),
    As = [F].

ats(neg(F), As) :- 
    wff(F),
    ats(F, As).

ats(and(X, Y), As) :- 
    wff(and(X, Y)), % Verification
    ats(X, Asx), % Atoms in formula X 
    ats(Y, Asy), 
    append(Asx, Asy, Asxy), % Atoms in formula X and Y (potential duplicates).
    sort(Asxy, As). % Remove duplicates from the list of atoms.

ats(or(X, Y), As) :- 
    wff(or(X, Y)),
    ats(X, Asx), 
    ats(Y, Asy), 
    append(Asx, Asy, Asxy),
    sort(Asxy, As).

ats(imp(X, Y), As) :- 
    wff(imp(X, Y)),
    ats(X, Asx),
    ats(Y, Asy),
    append(Asx, Asy, Asxy),
    sort(Asxy, As).


% Task 4: t_value(+F, +Val, -V)
% Calculates the truth value V of the formula F, given the valuation Val.

%% Usual truth-tables
% neg
neg_cw(t, f).
neg_cw(f, t).

% and
and_cw(t, t, t).
and_cw(t, f, f).
and_cw(f, t, f).
and_cw(f, f, f).

% or
or_cw(f, f, f).
or_cw(t, t, t).
or_cw(t, f, t).
or_cw(f, t, t).

%% Auxiliary functions
% Verifies specifications for Val = [H|T] and formula F.
val_test([], F) :- 
	wff(F).
val_test([H|T], F) :- 
	ground([H|T]), % Val is ground
	wff(F), % F is a well-formed formula
	% Val only contains logical atoms of F
	ats(F, As),
	logical_atom(H),
	member(H, As),
	val_test(T, F).

% List of common elements.
common([], _, []).
common([H|T], Lcomp, [H|L]) :- % If there is a common element
    member(H, Lcomp), !,
    common(T, Lcomp, L).
common([_|T], Lcomp, L) :- 
    common(T, Lcomp, L).

%% t_value

t_value(F, Val, V) :- % True logical atom
	val_test(Val, F), % Verification of the specifications of the task.
	logical_atom(F),
	ats(F, As),
	Val == As, !,
	V = t.

t_value(F, Val, V) :- % False logical atom
	val_test(Val, F), 
	logical_atom(F),
	V = f.

t_value(neg(F), Val, V) :- % Negation
	val_test(Val, F), 
	t_value(F, Val, Vneg),
	neg_cw(Vneg, V).

t_value(and(X, Y), Val, V) :- % and
	val_test(Val, and(X, Y)), 
	ats(X, Asx),
	ats(Y, Asy),
	common(Asx, Val, Valx), % Atoms in formula X which are true
	common(Asy, Val, Valy), 
	t_value(X, Valx, Vx), % Truth value for formula X
	t_value(Y, Valy, Vy), 
	and_cw(Vx, Vy, V).

t_value(or(X, Y), Val, V) :- % or
	val_test(Val, or(X, Y)), 
	ats(X, Asx),
	ats(Y, Asy),
	common(Asx, Val, Valx), 
	common(Asy, Val, Valy), 
	t_value(X, Valx, Vx),
	t_value(Y, Valy, Vy),
	or_cw(Vx, Vy, V).

t_value(imp(X, Y), Val, V) :- % Implication
	val_test(Val, imp(X, Y)), 
	t_value(or(neg(X), Y), Val, V).


