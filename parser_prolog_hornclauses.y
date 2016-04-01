%{
#include <stdio.h>
#define CHUNK 1024 /* read 1024 bytes at a time */
void yyerror(char *message);
 int problem_counter;
 struct variable * var_head;
 struct variable * var_tail;
 struct partial_problem * pp_head;
 struct partial_problem * pp_tail; 
 struct variable {
          struct variable *ptr_next;
          char *name;
};
 
struct partial_problem {
          struct partial_problem *ptr_next;
          struct variable *ptr_var;
};
void gen_var_node(char* var_name);
struct partial_problem * gen_struct_pp();
void gen_partial_problem_node();
void yyerror (char *message);
void print_the_lot();
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

S: S E {printf("\nCongrats. You seem to have a clue about Horn clauses.\n"); print_the_lot();}
| E {printf("\nCongrats. You seem to have a clue about Horn clauses.\n"); print_the_lot();}
| S NEW_LINE_FEED
| NEW_LINE_FEED;

E: RULE
| FACT;

RULE: AR IMPLIES FACT_LIST DOT;

FACT: AR DOT;

AR: CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA {gen_partial_problem_node(); var_head = 0;}
| ARITHMETIC_EXP {gen_partial_problem_node(); var_head = 0;};

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
| COMMA ARG REST_LIST
| CLOSE_BRA;

HEAD_CONTENT: VAR_ID {gen_var_node($1);}
|NUMBER
|CONST_ID;

ARG: CONST_ID
|NUMBER
|LIST
|VAR_ID{gen_var_node($1);}; 


%%
void gen_var_node(char* var_name){
	struct variable *ptr = malloc(sizeof(struct variable));
	ptr->name = var_name;
	ptr->ptr_next = 0;
	if (!var_head){
		var_head = ptr;
		var_tail = ptr;
	} else{
		var_tail->ptr_next = ptr;
		var_tail = ptr;
	}
}
struct partial_problem * gen_struct_pp(){
	struct partial_problem *ptr = malloc(sizeof(struct partial_problem));
	return ptr;
}
void gen_partial_problem_node(){
	struct partial_problem *ptr = malloc(sizeof(struct partial_problem));
        ptr->ptr_var = var_head;
	ptr->ptr_next = 0;
        if (!pp_head){
                pp_head = ptr;
                pp_tail = ptr;
        } else{
                pp_tail->ptr_next = ptr;
                pp_tail = ptr;
        }
}
void print_the_lot(){
	struct partial_problem * ptr_tmp = pp_head;
	struct variable * ptr_var_tmp = 0;
	problem_counter = 0;
	printf("\n\tProblem Counter\t|\tIncluded Variables");
	while(ptr_tmp) {
		ptr_var_tmp = ptr_tmp->ptr_var;
		printf("\n\t%d\t\t|\t",problem_counter);
		while(ptr_var_tmp){
			printf("%s, ", ptr_var_tmp->name);
			ptr_var_tmp = ptr_var_tmp->ptr_next;
		}
		printf("\n");
		problem_counter++;
		ptr_tmp = ptr_tmp->ptr_next;	
	}
	pp_head = 0;
	pp_tail = 0;
}
int main(int argc, char **argv) {
	extern FILE* yyin;
	size_t nread;
	char buf[CHUNK];
	
	var_head = 0;
	var_tail = 0;
	pp_head = 0;
    pp_tail = 0;
	
	yyin = fopen("input_file.txt","r");
	 while ((nread = fread(buf, 1, sizeof buf, yyin)) > 0){
        fwrite(buf, 1, nread, stdout);
	 }
	yyparse();
	
	fclose(yyin);
	return 0;
}
void yyerror (char *message){
	printf("\nThis is not a Horn clause. Please start the program again\n");
}

