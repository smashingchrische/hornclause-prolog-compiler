%{
#include <stdio.h>
#define CHUNK 1024 /* read 1024 bytes at a time */
void yyerror(char *message);
int problem_counter;
int line_counter = 1;
struct variable * var_head;
struct variable * var_tail;
struct partial_problem * pp_head;
struct partial_problem * pp_tail; 
struct table_row *tr_head;
struct table_row *tr_tail;
struct variable {
	struct variable *ptr_next;
	char *name;
};
 
struct partial_problem {
        struct partial_problem *ptr_next;
        struct variable *ptr_var;
	struct table_row *ptr_tr;
};
struct table_row {
	char type;
	int r_nr;
	int r_port;
	int l_nr;
	int l_port;
	char* info;
	struct table_row *ptr_next;
};
void gen_var_node(char* var_name);
void gen_partial_problem_node(int is_entry, char* info);
struct table_row* make(int is_entry, char* info);
void yyerror (char *message);
void print_the_lot();
void table_entry(char type, int r_nr, int r_port, int l_nr, int l_port, char* info);
void table_writer(struct table_row *row);
int table_counter = 1;
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

S: S E {print_the_lot();}
| E {print_the_lot();}
| S NEW_LINE_FEED
| NEW_LINE_FEED;

E: RULE
| FACT;

RULE: SR IMPLIES FACT_LIST DOT;

FACT: SR DOT;

SR: CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA {gen_partial_problem_node(1,$1); var_head = 0;};

AR: CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA {gen_partial_problem_node(0, $1); var_head = 0;}
| ARITHMETIC_EXP {gen_partial_problem_node(0,""); var_head = 0;};

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
void gen_partial_problem_node(int is_entry, char* info){
	struct partial_problem *ptr = malloc(sizeof(struct partial_problem));
        ptr->ptr_var = var_head;
	ptr->ptr_next = 0;
	ptr->ptr_tr = make(is_entry, info);
        if (!pp_head){
                pp_head = ptr;
                pp_tail = ptr;
        } else{
                pp_tail->ptr_next = ptr;
                pp_tail = ptr;
        }
}
struct table_row*  make(int is_entry, char* info){
	struct table_row *ptr = malloc(sizeof(struct table_row));
	ptr->info = info;
	if (is_entry){
		ptr->type= 'E';
	}
	return ptr;
}
void print_the_lot(){
	extern FILE* yyout;
	yyout = fopen("output_file.txt", "a+");
	struct partial_problem * ptr_tmp = pp_head;
	struct variable * ptr_var_tmp = 0;
	problem_counter = 0;
	
	printf("\nCongrats. You seem to have a clue about Horn clauses. Line #%d is correct: \n", line_counter); 
	fprintf(yyout,"\nCongrats. You seem to have a clue about Horn clauses. Line #%d is correct: \n", line_counter); 
	
	printf("\n\tProblem Counter\t|\tIncluded Variables");
	fprintf(yyout,"\n\tProblem Counter\t|\tIncluded Variables");
	
	while(ptr_tmp) {
		ptr_var_tmp = ptr_tmp->ptr_var;
		printf("\n\t%d\t\t|\t",problem_counter);
		fprintf(yyout,"\n\t%d\t\t|\t",problem_counter);
		table_entry('E',12,13,7,1,0);
		while(ptr_var_tmp){
			printf("%s, ", ptr_var_tmp->name);
			fprintf(yyout, "%s, ", ptr_var_tmp->name);
			ptr_var_tmp = ptr_var_tmp->ptr_next;
		}
		printf("\n");
		fprintf(yyout, "\n");
		problem_counter++;
		ptr_tmp = ptr_tmp->ptr_next;	
	}
	
	line_counter++;
	fclose(yyout);
}
void table_entry(char type, int r_nr, int r_port, int l_nr, int l_port, char* info){
	FILE* table_out;
	table_out = fopen("output_table.txt","a+");
	fprintf(table_out,"%d \t %c",table_counter,type);
	if(r_nr < 0){
		fprintf(table_out,"\t -");
	}
	else{
		fprintf(table_out,"\t(%d,%d)", r_nr,r_port);
	}
	if(l_nr < 0){
                fprintf(table_out,"\t -");
        }
        else{
                fprintf(table_out,"\t(%d,%d)", l_nr,l_port);
        }
	if ( info == 0 ){
		fprintf(table_out,"\t -");
	}
	else{
		fprintf(table_out,"\t %s",info);
	}
	fprintf(table_out,"\n");
	table_counter++;
	fclose(table_out);
}
void table_writer(struct table_row *row){
	table_entry(row->type,row->r_nr,row->r_port,row->l_nr,row->l_port,row->info);
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
	rewind(yyin);
	
	yyparse();
	
	fclose(yyin);
	return 0;
}
void yyerror (char *message){
	extern FILE* yyout;
	yyout = fopen("output_file.txt", "a+");
	
	printf("\nThis is not a Horn clause. Please start the program again\n");
	fprintf(yyout,"\nThis is not a Horn clause. Please start the program again\n");
	
	fclose(yyout);
}

