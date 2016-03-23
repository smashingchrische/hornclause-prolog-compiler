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
%token COMMA OPEN_PARA CLOSE_PARA OPEN_BRA CLOSE_BRA PIPE ASTERIX COLON SLASH
%token NEW_LINE_FEED
%token <num> NUMBER
%token <str> CONST_ID VAR_ID

%left PLUS MINUS ASTERIX SLASH
%left UNEQUALS SMALLER SMALLER_EQUALS GREATER GREATER_EQUALS
%%

S: S E {printf("\nCongrats. You seem to have a clue about Horn clauses.\n");}
|E {printf("\nCongrats. You seem to have a clue about Horn clauses.\n");}

E: RULE NEW_LINE_FEED
| FACT NEW_LINE_FEED;

RULE: AR IMPLIES FACT_LIST DOT;

FACT: AR DOT;

AR: CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA
| ARITHMETIC_EXP;

ARITHMETIC_EXP: VAR_ID OPERATOR ARITHMETIC_REST;

OPERATOR: PLUS
| MINUS
| EQUALS
| SMALLER_EQUALS
| SMALLER
| GREATER_EQUALS
| GREATER
| UNEQUALS
| ASTERIX
| SLASH
| IS;

ARITHMETIC_REST: VAR_ID
| NUMBER
| CONST_ID
| ARITHMETIC_EXP;

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
int partial_problem_counter;

struct variable {
	struct variable *ptr_next;
	char *name;
};

struct partial_problem {
	struct partial_problem *ptr_next;
	int number;
	struct variable *ptr_var; 
};

int main(int argc, char **argv) {
	yyparse();
	return 0;
}
void yyerror (char *message){
	printf("\nThis is not a Horn clause. Please start the program again\n");
}

