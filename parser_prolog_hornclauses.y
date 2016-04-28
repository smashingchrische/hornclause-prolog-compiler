%{
	#include <stdio.h>
	#define CHUNK 1024 /* read 1024 bytes at a time */

	int problem_counter;
	int line_counter = 1;

	struct variable * var_head;
	struct variable * var_tail;
	struct partial_problem * pp_head;
	struct partial_problem * pp_tail;
	struct node *node_head;
	struct node *node_tail;

	struct variable {
		char *name;
		struct variable *next;
	};
	struct partial_problem {
		struct variable *var;
		struct node *node;
		struct partial_problem *next;
	};
	struct node {
		int index;
		char type;
		char* info;
		struct output *out;
		struct node *next;
		struct node *prev;
	};
	struct output {
		int port;
		char type;
		struct node *target;
		struct output *next;
	};

	void yyerror(char *message);
	void gen_var_node(char *var_name);
	void gen_partial_problem_node(char type, char* info);
	void yyerror (char *message);
	void print_the_lot();
	void table_entry(int index, char type, struct output *out, char *info);
	void table_writer(struct node *node);
	void schwinn();
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

	SR: CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA {gen_partial_problem_node('E',$1); var_head = 0;};

	AR: CONST_ID OPEN_PARA ARG_LIST CLOSE_PARA {gen_partial_problem_node('U', $1); var_head = 0;}
	| ARITHMETIC_EXP {gen_partial_problem_node('U',""); var_head = 0;};

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
		ptr->next = 0;
		if (!var_head){
			var_head = ptr;
			var_tail = ptr;
		} else{
			var_tail->next = ptr;
			var_tail = ptr;
		}
	}
	void gen_partial_problem_node(char type, char* info){
		struct partial_problem *ptr = malloc(sizeof(struct partial_problem));
		ptr->var = var_head;
		ptr->next = 0;
		ptr->node = gen_node(type, info);
		if (!pp_head){
			pp_head = ptr;
			pp_tail = ptr;
		} else{
			pp_tail->next = ptr;
			pp_tail = ptr;
		}
	}

	struct node * gen_node(char type, struct output *output, char *info) {
		struct node* tmp = malloc(sizeof(struct node));
		tmp->type = type;
		tmp->output = output;
		tmp->info = info;
		tmp->next = 0;
		tmp->prev = 0;

		return tmp;
	}
	void insert_node_before(struct node *current, struct node *new) {
		new->prev = current->prev;
		current->prev->next = new;
		new->next = current;
		current->prev = new;
	}
	void insert_node_after(struct node *current, struct node *new) {
		new->next = current->next;
		current->next->prev = new;
		new->prev = current;
		current->next = new;
	}

	struct output * gen_output(int port, char type, struct node *target) {
		struct output* tmp = malloc(sizeof(struct output));
		tmp->port = port;
		tmp->type = type;
		tmp->target = target;
		tmp->next = 0;

		return tmp;
	}
	void insert_output(struct output *current, struct output *new) {
		new->next = current->next;
		current->next = new;
	}
	void add_output(struct node *current, int port, char type, struct node *target) {
		if(current->out != 0) {
			struct output *last = current->out;
			while(last->next != 0) {
				last = last->next;
			}
			insert_output(last,gen_output(port,type,target));
		} else {
			current->out = gen_output(port,type,target);
		}
	}

	void schwinn(){
		node_head = pp_head->node;
		struct partial_problem * pp_current = pp_head;
		pp_current = pp_current->next;
		// part 2.1.1
		add_output(node_head,1,'R',pp_current->node);
		// part 2.1.2
		pp_current = pp_current->next;
		if(pp_current->node->type == 'U'){
			struct node *c_node = gen_node('C',0,0);
			insert_node_after(pp_current->node,c_node);
			add_output(c_node,1,0,node_head->out->target);
			add_output(c_node,1,0,pp_current->node);
			node_head->out->target = c_node;
			while(pp_current->next->node->type == 'U') {
				pp_current = pp_current->next;
				add_output(c_node,1,0,pp_current->node)
			}

		} else {
		}
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
	/*void print_the_lot(){
		extern FILE* yyout;
		yyout = fopen("output_file.txt", "a+");
		struct partial_problem * tmp = pp_head;
		struct variable * var_tmp = 0;
		problem_counter = 0;

		printf("\nCongrats. You seem to have a clue about Horn clauses. Line #%d is correct: \n", line_counter);
		fprintf(yyout,"\nCongrats. You seem to have a clue about Horn clauses. Line #%d is correct: \n", line_counter);

		printf("\n\tProblem Counter\t|\tIncluded Variables");
		fprintf(yyout,"\n\tProblem Counter\t|\tIncluded Variables");

		while(tmp) {
			var_tmp = tmp->var;
			printf("\n\t%d\t\t|\t",problem_counter);
			fprintf(yyout,"\n\t%d\t\t|\t",problem_counter);
			table_entry(1,'E',0,0);
			while(var_tmp){
				printf("%s, ", var_tmp->name);
				fprintf(yyout, "%s, ", var_tmp->name);
				var_tmp = var_tmp->next;
			}
			printf("\n");
			fprintf(yyout, "\n");
			problem_counter++;
			tmp = tmp->next;
		}

		line_counter++;
		fclose(yyout);
	}

	void table_entry(int index, char type,struct output *out, char* info){
		FILE* table_out;
		table_out = fopen("output_table.txt","a+");
		fprintf(table_out,"%d \t %c",index,type);
		if(out == 0){
			fprintf(table_out,"\t -");
		}
		else{
			while(out!=0) {
				fprintf(table_out,"\t(%d,%d)", out->target->index,out->port);
				out = out->next;
			}
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
	void table_writer(struct node *node){
		table_entry(node->index,node->type,node->out,node->info);
	}*/
	void yyerror (char *message){
		extern FILE* yyout;
		yyout = fopen("output_file.txt", "a+");

		printf("\nThis is not a Horn clause. Please start the program again\n");
		fprintf(yyout,"\nThis is not a Horn clause. Please start the program again\n");

		fclose(yyout);
	}
