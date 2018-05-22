%option noyywrap
%{
    #include "matrix.tab.h"
    extern "C" 
    {   
        int yylex(void);
    }  
    int pos = 1;
%}

number  ([1-9]+[0-9]+|[1-9])
eol     \n
space   [\t\r ]

%%
{number}            {   printf("matchN %s at Pos: %d\n",yytext,pos); pos += yyleng;  yylval.ival = atoi(yytext);   return NUMBER; }
[\[\],]              {  pos += 1;  return yytext[0];  }
{space}              {   pos += 1; }
"+"                  {    printf("match %s\n",yytext); yylval.op.type = yytext; yylval.op.pos = pos; pos += 1; return PLUS; }
"-"                  {    printf("match %s\n",yytext); yylval.op.type = yytext; yylval.op.pos = pos; pos += 1; return SUB; }
.                   { }
{eol}               { return(0); }

%%