%option noyywrap
%{
    #include "mat.tab.h"
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
{number}            {   pos += yyleng;  yylval.ival = atoi(yytext);   return NUMBER; }
[\[\],\(\)]         {   pos += 1;       return yytext[0];  }
{space}             {   pos += 1; }
"+"                 {   yylval.op.type = yytext; yylval.op.pos = pos; pos += 1; return PLUS; }
"-"                 {   yylval.op.type = yytext; yylval.op.pos = pos; pos += 1; return SUB; }
"*"                 {   yylval.op.type = yytext; yylval.op.pos = pos; pos += 1; return MUL; }
"^T"                {   yylval.op.type = yytext; yylval.op.pos = pos; pos += 2; return TRANS; }
.                   { }
{eol}               {   return(0); }

%%