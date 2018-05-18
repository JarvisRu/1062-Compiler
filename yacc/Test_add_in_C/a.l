%option noyywrap
%{
#include "a.tab.h"
%}
%%
\n	            { return(0); }
[ \t]+	        {  }
[0-9]+	        { yylval.ival = atoi(yytext);   return(INUMBER); }
"+"             { yylval.op = yytext[0];        return(PLUS); }
.	            { return(yytext[0]); }
%%

