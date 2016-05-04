%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}
%%
\* {return TIMES;}
\/ {return DIV;}
\+ {return PLUS;}
- {return MINUS;}
\( {return OPEN;}
\) {return CLOSE;}
\n {return EOI;}
[1-9][0-9]*|0 {sscanf(yytext,"%d",&yylval); return GANZ;}
