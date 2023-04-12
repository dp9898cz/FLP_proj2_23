% author: Daniel Patek (xpatek08)
% VUT FIT 2023

main :- 
    read_lines(Lines), % get lines from stdin
    last(Lines, StartTape), % last line should be tape
    append(['S'], StartTape, Tape), % move start state to the tape
    delete(Lines, StartTape, StartRules), % delete tape from rules list
    parseRules(StartRules, Rules), % parse rules to usable form
    run_tm(Rules, Tape, Sequence),
    writeSequence(Sequence),
    halt.

isEOF(Char) :- Char == end_of_file. % checks if character Char is EOF
isEOL(Char) :- (char_code(Char, Code), Code==10). % checks if character Char is '\n'

/* Reads multiple lines from stdin.
    Lines = result (list of lists of char)
*/
read_lines(Lines) :- 
    read_line(Line), % get one line (we dont care about character)
    (
        Line == [] -> Lines = [] ; % once we have empty line from stdin (\n or EOF) , we end recursion 
        read_lines(RestLines), Lines = [Line | RestLines]
    ).

/* Reads one line from stdin.
    Line = result (list of characters, without newline character)
*/
read_line(Line) :- 
    get_char(CurrentChar), % get one character from stdin
    (
        (isEOF(CurrentChar) ; isEOL(CurrentChar)) -> Line = [] ; % if EOF or /n is encountered, end recursion
        read_line(RestLine), Line = [CurrentChar | RestLine]
    ).

writeSequence([]).
writeSequence([Sequence|RestSequence]) :- 
    writef("%s\n", [Sequence]),
    writeSequence(RestSequence).

% parse rules to usable form (remove spaces)
parseRules(Lines, Rules) :-
    Lines == [] -> Rules = [] ;
    [Line | RestLines] = Lines,
    parseRule(Line, Rule),
    parseRules(RestLines, RestRules),
    Rules = [Rule | RestRules].

% parse one rule (remove spaces from input basically)
parseRule([CurrentState, ' ', CurrentChar, ' ', NewState, ' ', Action], Rule) :-
    Rule = [CurrentState, CurrentChar, NewState, Action].

% Start the simulation with the specified rules and tape
run_tm(Rules, Tape, CSequence) :-
    tm_step(Rules, Tape, [], 'S', Sequence), % start the simulation
    append([Tape], Sequence, CSequence). % append the starting Tape to the list

% Simulate one step of the TM
tm_step(_, Tape, Visited, State, _) :-
    % If we've already visited this state and tape, abort
    member((State, Tape), Visited), !, fail.

tm_step(_, _, _, 'F', Sequence) :-
    Sequence = [], ! .

tm_step(Rules, Tape, Visited, State, Sequence) :-
    append(Visited, [(State, Tape)], NewVisited), % Mark this state and tape as visited
    find_poss_rule(State, Tape, Rules, CurrentRule), % find rule that can be used
    
    %writeln(CurrentRule), % todo what if this returns 0 -> reject
    
    nth0(2, CurrentRule, NewState),
    nth0(3, CurrentRule, Action),

    perform_action(Action, Tape, State, TempTape), % perform specific action

    nth0(StateIndex, Tape, State), % get index of State
    replace(TempTape, StateIndex, NewState, NewTape), % change current state

    %writeln(NewTape),
    
    tm_step(Rules, NewTape, NewVisited, NewState, SequenceNext), % Simulate the next step with the new tape and state */
    Sequence = [NewTape|SequenceNext].

tm_step(Rules, _, _, State, _) :-
    % If there are no applicable rules, reject
    \+ member((State, _, _, _), Rules), State = reject.

% Replace an element in a list at a specified index
% OldList, Index, NewElem, NewList
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

% swap two elements in a list, given their indices
swap(List, Index1, Index2, Result) :-
    nth0(Index1, List, Temp1),
    nth0(Index2, List, Temp2),
    replace(List, Index1, Temp2, TempList),
    replace(TempList, Index2, Temp1, Result).


% find possible rule with current state and character in tape
find_poss_rule(State, Tape, Rules, Result) :-
    Rules == [] -> Result = [] ; % end of recursion
    
    [CurrentRule | RestRules] = Rules, % get current rule
    nth0(StateIndex, Tape, State), % get index of State
    CharIndex is StateIndex + 1, 
    nth0(CharIndex, Tape, CurrentChar), % get current character
    (
        (nth0(0, CurrentRule, RuleState),
        nth0(1, CurrentRule, RuleCharacter),
        RuleState == State,
        RuleCharacter == CurrentChar) -> Result = CurrentRule ;
        find_poss_rule(State, Tape, RestRules, Result)
    ).

/* Perform the specified tape action (L, R, or character change) 
*/
perform_action('L', Tape, State, NewTape) :- 
    nth0(StateIndex, Tape, State),
    CharacterIndex is StateIndex - 1,
    swap(Tape, StateIndex, CharacterIndex, NewTape).
perform_action('R', Tape, State, NewTape) :- 
    nth0(StateIndex, Tape, State),
    CharacterIndex is StateIndex + 1,
    swap(Tape, StateIndex, CharacterIndex, NewTape).
perform_action(Character, Tape, State, NewTape) :- 
    nth0(StateIndex, Tape, State),
    CharacterIndex is StateIndex + 1, 
    replace(Tape, CharacterIndex, Character, NewTape).