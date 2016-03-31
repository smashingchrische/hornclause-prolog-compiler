%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *message);
%}
%union{
double reell;
int integer;
}

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
%type <reell> E
%type <integer> GANZ
%type <reell> FLIES
%%
S: E EOI {printf("= %lf\n",$1);}
| S E EOI {printf("=%lf\n",$2);}
E: E PLUS E {$$ = $1 + $3;}
| E MINUS E {$$ = $1 - $3;}
| E TIMES E {$$ = $1 * $3;}
| E DIV E {$$ = $1 / $3;}
| OPEN E CLOSE {$$ = $2;}
| GANZ {$$ =(double)$1;}
| FLIES {$$ = $1;}
%%
int main(int argc, char ** argv){
yyparse();
return 0;
}
void yyerror(char *message){
printf("Error");
}
