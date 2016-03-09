%{
#include "y.tab.h"
%}
%%

\- return MINUS;
\: return COLON;
\( return OPEN;
\) return CLOSE;
\, return COM;
\[ return OBRA;
\] return CBRA;
\| return PIPE;
\. return DOT;
\n return END;
[a-z][a-zA-Z0-9]* return ATOM;
([0-9]+\.[0-9]+)|([0-9]+) return NUM;
[A-Z_][a-zA-Z0-9_]* return VAR;
. {printf("what?"); }
