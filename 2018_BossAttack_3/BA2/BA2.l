%option noyywrap
%{
    #include "main.h"
    #include "BA2.tab.h"
    extern "C" 
    {   
        int yylex(void);
    }
%}

number  ([1-9]+[0-9]+|[1-9])
eol     \n
space   [\t\r ]

%%
{number}            {   yylval.ival = atoi(yytext); return NUMBER; }
"load"              {   yylval.op = yytext;  return LOAD; }
"add"               {   yylval.op = yytext;  return PLUS; }
"sub"               {   yylval.op = yytext;  return SUB; }
"mul"               {   yylval.op = yytext;  return MUL; }
"mod"               {   yylval.op = yytext;  return MOD; }
"inc"               {   yylval.op = yytext;  return INC; }
"dec"               {   yylval.op = yytext;  return DEC; }
{space}             { }
.                   { }

<<EOF>>             { return 0; }

%%