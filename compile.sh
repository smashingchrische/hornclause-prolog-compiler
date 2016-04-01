echo '\n Creating flex file...'
flex scanner_prolog_hornclauses.l
echo '\t\t Done.'

echo '\n Creating bison file...'
bison -dy parser_prolog_hornclauses.y
echo '\t\t Done.'

echo '\n Compiling...'
gcc y.tab.c lex.yy.c -lfl -lm -o myprolog.exe
echo '\t\t Done.'

echo '\n Starting the programm...'
echo '\n Reading the input_file.txt:'
echo '\t\t Done.'
echo '\n \n'
./myprolog.exe