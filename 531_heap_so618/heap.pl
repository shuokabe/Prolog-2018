% 531 Prolog
% Assessed Exercise 3
% heap.pl


% Write your answers to the exercise here


% Task 1. is_heap(+H). Succeeds if H is a binary heap.
is_heap(empty).

is_heap(heap(K, _I, LH, RH)) :- 
	integer(K),
	is_heap(LH),
	is_heap(RH).
  

% Task 2. add_to_heap(+K, +I, +H, -NewH)
add_to_heap(K, I, empty, heap(K, I, empty, empty)).

add_to_heap(K, I, heap(KH, IH, LHH, RHH), NewH) :- 
	K < KH, !,
	add_to_heap(K, I, RHH, NewRHH),
	NewH = heap(KH, IH, NewRHH, LHH).

add_to_heap(K, I, heap(KH, IH, LHH, RHH), NewH) :- 
	add_node_to_top(K, I, heap(KH, IH, LHH, RHH), NewH).

add_node_to_top(K, I, empty, heap(K, I, empty, empty)).

add_node_to_top(K, I, heap(KH, IH, LHH, RHH), NewH) :- 
	add_node_to_top(KH, IH, RHH, NewRHH),
	NewH = heap(K, I, NewRHH, LHH).


% Task 3. remove_max(+H, -K, -I, -NewH)
remove_max(heap(K, I, empty, empty), K, I, empty).

remove_max(heap(K, I, LHH, RHH), Kmax, Imax, NewH) :-    
    Kmax = K,
    Imax = I,
    remove_left_most(LHH, Kleft, Ileft, RemoveLHH),
    NewTempH = heap(Kleft, Ileft, RHH, RemoveLHH),
    push_down_node(NewTempH, NewH).

%heap(9, neuf, heap(8, huit, heap(5, cinq, heap(1, one, empty, empty), empty), heap(4, quatre, empty, empty)), heap(7, sept, heap(6, six, empty, empty), heap(3, trois, empty, empty)))

remove_left_most(heap(K, I, empty, empty), K, I, empty).
remove_left_most(heap(_K, _I, LH, _RH), Kleft, Ileft, heap(_K, _I, _RH, RemovedLH)) :-
	remove_left_most(LH, Kleft, Ileft, RemovedLH).

push_down_node(heap(Knode, Inode, empty, empty), heap(Knode, Inode, empty, empty)).
push_down_node(heap(Knode, Inode, heap(KL, _IL, _LHL, _RHL), empty), heap(Knode, Inode, heap(KL, _IL, _LHL, _RHL), empty)) :-
    KL < Knode, !.

push_down_node(heap(Knode, Inode, heap(KL, IL, _LHL, _RHL), empty), heap(KL, IL, PushedLHH, empty)) :-
    push_down_node(heap(Knode, Inode, _LHL, _RHL), PushedLHH).

push_down_node(heap(Knode, Inode, heap(KL, _IL, _LHL, _RHL), heap(KR, IR, LHR, RHR)), heap(KR, IR, heap(KL, _IL, _LHL, _RHL), PushedRHH)) :-
    KL < KR,
    Knode < KR, !,
    push_down_node(heap(Knode, Inode, LHR, RHR), PushedRHH).

push_down_node(heap(Knode, Inode, heap(KL, IL, LHL, RHL), heap(KR, _IR, _LHR, _RHR)), heap(KL, IL, PushedLHH, heap(KR, _IR, _LHR, _RHR))) :-
    Knode < KL, !,
    push_down_node(heap(Knode, Inode, LHL, RHL), PushedLHH).

push_down_node(heap(Knode, Inode, LHH, RHH), heap(Knode, Inode, LHH, RHH)) :-
    RHH \= empty.


% Task 4. heap_sort_asc(+L, -S)
heap_sort_asc(InList, SortedList) :-
    list_to_heap(InList, empty, Heap),
    heap_to_list(Heap, [], SortedList).

list_to_heap([], FinHeap, FinHeap).
list_to_heap([(Key, Item)|T], TempHeap, FinHeap) :-
    add_to_heap(Key, Item, TempHeap, NewHeap),
    list_to_heap(T, NewHeap, FinHeap).

heap_to_list(empty, FinList, FinList).
heap_to_list(Heap, TempList, FinList) :-
    remove_max(Heap, K, I, NewHeap),
    heap_to_list(NewHeap, [(K, I)|TempList], FinList).


% Task 5. delete_from_heap(+I, +H, -NewH)
delete_from_heap(Idel, heap(_K, Idel, empty, empty), empty).

delete_from_heap(Idel, heap(_K, Idel, LHH, RHH), NewH) :-
    remove_left_most(LHH, Kleft, Ileft, TempLHH),
    NewTempHeap = heap(Kleft, Ileft, RHH, TempLHH),
    push_down_node(NewTempHeap, NewH).

delete_from_heap(Idel, heap(K, I, LHH, RHH), heap(K, I, RHH, DelLHH)) :-
    delete_from_heap(Idel, LHH, DelLHH).

delete_from_heap(Idel, heap(K, I, LHH, RHH), heap(K, I, NewDelRHH, RemLHH)) :-
    delete_from_heap(Idel, RHH, DelRHH),
    remove_left_most(LHH, Kleft, Ileft, RemLHH),
    add_to_heap(Kleft, Ileft, DelRHH, NewDelRHH).

