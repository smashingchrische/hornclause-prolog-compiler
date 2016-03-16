%{
#include "y.tab.h"
%}
%%
\:- {return IMPLIES;}
\. {return DOT;}
\, {return COMMA;}
\( {return OPEN_PARA;}
\) {return CLOSE_PARA;}
\[ {return OPEN_BRA;}
\] {return CLOSE_BRA;}
\| {return PIPE;}
\+ {return PLUS;}
\- {return MINUS;}
\* {return ASTERIX;}
\: {return COLON;}
\< {return SMALLER;}
\=< {return SMALLER_EQUALS;}
\> {return GREATER;}
\>= {return GREATER EQUALS;}
\= {return EQUALS;}
\== {return EQUALS;}
\not {return NOT;}
\is {return IS;}
\\== {return UNEQUALS;}
[0-9]+ {sscanf(yytext, "%d", &yylval.int1); return FULL;}
[a-z][(a-zA-Z)]* {yylval.str = strdup(yytext); return CONST_ID;}
[A-Z][(a-zA-Z)]* {yylval.str = strdup(yytext); return VAR_ID;}
\n {return NEW_LINE_FEED;}
. {printf("It seems that you have no clue about Horn Clauses."); }
