%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *message);
%}
%start S
%token EOI
%token PLUS MINUS
%token TIMES DIV
%token GANZ FLIES
%token OPEN CLOSE

%left PLUS
%left MINUS
%left TIMES
%left DIV
%%
S: E EOI {printf("= %d\n",$1);}
| S E EOI {printf("=%d\n",$2);}
E: E PLUS E {$$ = $1 + $3;}
| E MINUS E {$$ = $1 - $3;}
| E TIMES E {$$ = $1 * $3;}
| E DIV E {$$ = $1 / $3;}
| OPEN E CLOSE
| NUM {$$ = $1;}
NUM: GANZ {$$ = $1;}
%%
int main(int argc, char ** argv){
yyparse();
return 0;
}
void yyerror(char *message){
printf("Error");
}
