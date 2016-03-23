%{
#include <stdio.h>
void yyerror(char *message);
%}
%union{
char* str;
int num;
}
%start S
%token IMPLIES DOT
%token PLUS MINUS EQUALS NOT IS
%token UNEQUALS SMALLER SMALLER_EQUALS GREATER GREATER_EQUALS
%token COMMA OPEN_PARA CLOSE_PARA OPEN_BRA CLOSE_BRA PIPE ASTERIX COLON
%token NEW_LINE_FEED
%token <num> NUMBER
%token <str> CONST_ID VAR_ID

%%

S: S E {printf("Congrats. You seem to have a clue about Horn clauses.");}
|E {printf("Congrats. You seem to have a clue about Horn clauses.");}

E: RULE NEW_LINE_FEED
| FACT NEW_LINE_FEED;

RULE: AR IMPLIES FACT_LIST DOT;

FACT: AR DOT;

AR: CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA;

ARG_LIST: ARG COMMA ARG_LIST
| ARG;

FACT_LIST: AR COMMA FACT_LIST
|AR;

LIST: OPEN_BRA HEAD_CONTENT REST_LIST
| OPEN_BRA CLOSE_BRA; 

REST_LIST: PIPE ARG CLOSE_BRA
| COMMA ARG CLOSE_BRA;

HEAD_CONTENT: VAR_ID
|NUMBER
|CONST_ID;

ARG: CONST_ID
|NUMBER
|LIST
|VAR_ID;


%%
int main(int argc, char **argv) {
	yyparse();
	return 0;
}
void yyerror (char *message){
	printf("This is not a Horn clause. Please start the program again");
}

