%option noyywrap
%{
    #include "cal.tab.h"
    extern "C" 
    {   
        int yylex(void);
    }
%}

digit   [0-9]
digits  [1-9]{digit}*

eol     \n
space   [\t\r ]

%%
{digits}            {   yylval.ival = atoi(yytext); return NUMBER; }
[\(\)]              {   return yytext[0];  }
{space}             {   }
"+"                 {   yylval.op = yytext[0]; return PLUS; }
"-"                 {   yylval.op = yytext[0]; return SUB; }
"*"                 {   yylval.op = yytext[0]; return MUL; }
"/"                 {   yylval.op = yytext[0]; return DIV; }
.                   { }


{eol}               { return(0); }


%%