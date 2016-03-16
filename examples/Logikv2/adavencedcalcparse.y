%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
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
%token COS
%token SIN
%token SQRT
%token POW
%token SEPARATE

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
| E DIV E {$$ = $1 / $3; if ($3 == 0) {printf("Error Divison by Zero!");}}
| OPEN E CLOSE {$$ = $2;}
| GANZ {$$ =(double)$1;}
| FLIES {$$ = $1;}
| COS OPEN E CLOSE { $$ = cos($3);}
| SIN OPEN E CLOSE {$$ = sin($3);}
| SQRT OPEN E CLOSE {$$ = sqrt($3); if($3<=0){printf("sqare root contains negative number");}}
| POW OPEN E SEPARATE E CLOSE {$$ = pow($3,$5);}
%%
int main(int argc, char ** argv){
yyparse();
return 0;
}
void yyerror(char *message){
printf("Error");
}
