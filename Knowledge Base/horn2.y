%{
#include <stdio.h>;
void yyerror(char *message);
int i=0;
%}


%start S
%token END
%token MINUS COLON OPEN CLOSE COM OBRA CBRA ATOM NUM VAR PIPE DOT

%%

S: S E {printf("This is a Horn Clause");}
| E {printf("This is a Horn Clause");};

E: RULE END
| FACT END;

RULE: AR COLON MINUS FL;

FACT: AR DOT;

AR: ATOM OPEN AL CLOSE;

AL: A COM AL
| A;

FL: AR COM FL
| AR;

B: VAR
| NUM;

A: VAR
| NUM
| LIST;

LIST: OBRA B SL;

SL: PIPE A CBRA
| COM A CBRA;

%%
int main(int argc, char **argv) {
	yyparse();
	return 0;
}
void yyerror (char *message){
	printf("This is not a Horn clause. Please start the program again");
}
