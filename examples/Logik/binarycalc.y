%{
#include <stdio.h>
#include <math.h>
void yyerror(char *message);
%}
%start S
%token EOI
%token PLUS MINUS
%token TIMES DIV
%token ZERO ONE
%token OPEN CLOSE

%left PLUS
%left MINUS
%left TIMES
%left DIV
%%
S: E EOI {printf("= %d\n",$1);}
E: E PLUS E {$$ = $1 + $3;}
| E MINUS E {$$ = $1 - $3;}
| E TIMES E {$$ = $1 * $3;}
| E DIV E {$$ = $1 / $3;}
| NUM {$$ = $1;}
NUM: ZERO {$$ = $1;}
| ONE {$$ = $1;}

