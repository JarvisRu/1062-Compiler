%option noyywrap
%{
    #include "main.h"
    #include "BA1.tab.h"
    extern "C" 
    {   
        int yylex(void);
    }
%}

number  ([1-9]+[0-9]+|[1-9])

eol     \n
space   [\t\r ]

%%
{number}            {   yylval.fval = atoi(yytext); return NUMBER; }
[\{\}]              {   return yytext[0];  }
"+"                 {   yylval.op = yytext[0];  return PLUS; }
"-"                 {   yylval.op = yytext[0];  return SUB; }
"^"                 {   yylval.op = yytext[0];  return POWER; }
"\\frac"            {   yylval.str = yytext;    return FRAC;}
{space}             { }
.                   { }

{eol}               { return(0); }


%%