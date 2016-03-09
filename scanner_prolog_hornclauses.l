%{
#include "y.tab.h"
%}
%%
:\- {return IMPLIES;}
\. {return DOT;}
, {return COMMA;}
( {return OPEN_PARA;}
) {return CLOSE_PARA;}
\[ {return OPEN_BRA;}
\] {return CLOSE_BRA;}
\| {return PIPE;}
< {return SMALLER;}
> {return GREATER;}
== {return EQUALS;}
not {return NOT;}
is {return IS;}
\\== {return UNEQUALS;}
[(0-9)+] {sscanf(yytext, "%d", &yylval.int1); return FULL;}
[a-z(a-zA-Z)*]{strcpy(yylval.strval, YYText()); return FUNC_ID;}
[A-Z(a-zA-Z)*]{strcpy(yylval.strval, YYText()); return VAR_ID;}
