% author: Daniel Patek (xpatek08)
% VUT FIT 2023

main :- 
    read_lines(Lines), % get lines from stdin
    last(Lines, StartTape), % last line should be tape
    append(['S'], StartTape, Tape), % move start state to the tape
    delete(Lines, StartTape, StartRules), % delete tape from rules list
    parseRules(StartRules, Rules), % parse rules to usable form
    writeln(Rules), 
    writeln(Tape), 
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
