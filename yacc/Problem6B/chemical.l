%option noyywrap
%{
    #include "chemical.tab.h"
    extern "C" 
    {   
        int yylex(void);
    }  
%}

number   ([1-9]+[0-9]+|[2-9])
element  [A-Z][a-z]?
element_num {element}{number}
eol     \n

%%
{element_num} {   printf("match EN %s\n",yytext); yylval.ele = yytext;   return ELEMENT_NUM; }
{element}   {   printf("match %s\n",yytext); yylval.ele = yytext;        return ELEMENT; }
{number}    {   yylval.ival = atoi(yytext); return NUMBER; }
"->"        {   yylval.op = yytext;         return EQUAL; }
"+"        {   yylval.op = yytext;         return PLUS; }
"("        {   printf("PAR %s\n",yytext); yylval.op = yytext;         return LEFT; }
")"        {   printf("PAR %s\n",yytext); yylval.op = yytext;         return RIGHT; }
.           { }
{eol}       { return(0); }

%%