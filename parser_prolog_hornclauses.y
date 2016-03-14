{
#include "stdio.h"
void yyerror(char *message);
%}

%start S
%token IMPLIES DOT
%token PLUS MINUS EQUALS NOT IS
%token UNEQUALS SMALLER SMALLER_EQUALS GREATER GREATER_EQUALS
%token COMMA OPEN_PARA CLOSE_PARA OPEN_BRA CLOSE_BRA PIPE ASTERIX COLON
%token NEW_LINE_FEED

%type <int1> FULL
%type <str> CONST_ID VAR_ID

%%

S: S E
|

E: RULE
| FACT

RULE: 

FACT: CONST_ID DOT;
| CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA DOT;

ARG_LIST: ARG COMMA ARG_LIST
| ARG;

ARG: CONST_ID
|FULL
|LIST;

LIST: OPEN_BRA LIST_BODY CLOSE_BRA;

LIST_BODY: HEAD PIPE TAIL
|ARG_LIST
|

%%
int main(int argc, char **argv) {
	yyparse();
	return 0;
}
void yyerror (char *message){
	printf("This is not a Horn clause. Please start the program again");
}

