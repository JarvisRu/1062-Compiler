%option noyywrap
%{
    #include "main.h"
    #include "mat.tab.h"
    extern "C" 
    {   
        int yylex(void);
    }
%}

number  ([1-9]+[0-9]+|[1-9])
digit   [0-9]
digits  [1-9]{digit}*
letter  [a-z]

eol     \n
space   [\t\r ]

%%
{number}            {   yylval.ival = atoi(yytext); return NUMBER; }
[\[\],\(\)]         {   return yytext[0];  }
{space}             {   }
"+"                 {   yylval.op.type = yytext; yylval.op.pos = pos; return PLUS; }
"-"                 {   yylval.op.type = yytext; yylval.op.pos = pos; return SUB; }
"*"                 {   yylval.op.type = yytext; yylval.op.pos = pos; return MUL; }
"^T"                {   yylval.op.type = yytext; yylval.op.pos = pos; return TRANS; }
.                   { }


{eol}               { return(0); }
<<EOF>>             { return 0; }

%%