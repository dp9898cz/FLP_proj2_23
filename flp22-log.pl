% author: Daniel Patek (xpatek08)
% VUT FIT 2023

main :- 
    read_lines(Lines), 
    last(Lines, Tape),

    write(Lines), 
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