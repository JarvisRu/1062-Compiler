%option noyywrap
%{
    #include "chemical.tab.h"
    extern "C" 
    {   
        int yylex(void);
    }  
%}

number   ([1-9]+[0-9]+|[2-9]?)
element  [A-Z]
eol     \n

%%

{element}   { yylval.ele = yytext;        return ELEMENT; }
{number}    { yylval.ival = atoi(yytext); return NUMBER; }
"->"        { yylval.op = yytext;         return EQUAL; }
"+"         { return yytext[0]; }
.           { }
{eol}       { return(0); }

%%