flex scanner_prolog_hornclauses.l
bison -dy parser_prolog_hornclauses.y
gcc y.tab.c lex.yy.c -lfl -lm -o myprolog.exe
./myprolog.exe