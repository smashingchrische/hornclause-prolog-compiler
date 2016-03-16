%{
int x = 0;
%}
%%
.*\n {printf("%d %s",++x,yytext);}
