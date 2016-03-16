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
cos {return COS;}
sin {return SIN;}
sqrt {return SQRT;}
pow {return POW;}
, {return SEPARATE;}
[1-9][0-9]*|0 {sscanf(yytext,"%d",&yylval.integer); return GANZ;}
([1-9][0-9]*|0)\.[0-9]+ {sscanf(yytext,"%lf",&yylval.reell); return FLIES;}
