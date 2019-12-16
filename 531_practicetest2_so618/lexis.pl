%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Question 1 (50%)                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (a) eval(+E, +Env, -V)

eval(E, Env, V) :-
    member(E, [x, y, z]), !,
    attr_val(E, Env, V).

eval(-E, Env, V) :-
    !, eval(E, Env, Val),
    V is - Val.

eval(E1 * E2, Env, V) :-
    !, eval(E1, Env, V1),
    eval(E2, Env, V2),
    V is V1 * V2.

eval(E1 + E2, Env, V) :-
    !, eval(E1, Env, V1),
    eval(E2, Env, V2),
    V is V1 + V2.

eval(sin(E), Env, V) :-
    !, eval(E, Env, VTemp),
    V is sin(VTemp).

eval(cos(E), Env, V) :-
    !, eval(E, Env, VTemp),
    V is cos(VTemp).

eval(E, _, E).

% Attributes the value of the variable
attr_val(Var, [(Var, Val)|_ListVarval], Val).

attr_val(Var, [_H|ListVarval], Val) :-
    attr_val(Var, ListVarval, Val).


% (b) commutes(+E1, +E2)

commutes(E1 + E2, E3 + E4) :-
commutes(E1, E3),
commutes(E2, E4).

commutes(E1 + E2, E2 + E1).
commutes(E1 * E2, E2 * E1).
commutes(E, E).

commutes(sin(E1), sin(E2)) :-
commutes(E1, E2).

commutes(cos(E1), cos(E2)) :-
commutes(E1, E2).


commutes(E1 * E2, E3 * E4) :-
commutes(E1, E3),
commutes(E2, E4).


% (c) diff(+E, +V, -D)




% (d) maclaurin(+E, +X, +N, -V)






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Question 2 (50%)                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% (a) b_to_left(+Pos, -H).




% (b) move(+Pos, -NewPos)   




% (c) search_agenda(+Agenda, -Visited, -Final)




% (d) trace_moves(+Final, +Visited, -Seq)




