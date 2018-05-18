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

{element}   { printf("match e:%s\n",yytext);  yylval.ele = yytext;        return ELEMENT; }
{number}    { printf("match n:%s\n",yytext);  yylval.ival = atoi(yytext); return NUMBER; }
"->"        { printf("match =:%s\n",yytext);  yylval.op = yytext;         return EQUAL; }
"[+()]"         { return yytext[0]; }
.           { }
{eol}       { return(0); }

%%