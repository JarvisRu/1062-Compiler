%option noyywrap
%{
    #include "main.hpp"
    #include "add.tab.h"
%}

eol     \n
number  [0-9]+

%%
{eol}       { return(0); }
{number}    { yylval.ival = atoi(yytext); return NUMBER; }
"+"         { yylval.op = yytext[0];      return PLUS; }
.           { }
%%
