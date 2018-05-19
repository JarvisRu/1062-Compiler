%option noyywrap
%{
    #include "che.tab.h"
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
{element_num}   {   yylval.ele = yytext;        return ELEMENT_NUM; }
{element}       {   yylval.ele = yytext;        return ELEMENT;     }
{number}        {   yylval.ival = atoi(yytext); return NUMBER;      }
"->"            {   yylval.op = yytext;         return EQUAL;       }
"+"             {   yylval.op = yytext;         return PLUS;        }
"("             {   yylval.op = yytext;         return LEFT;        }
")"             {   yylval.op = yytext;         return RIGHT;       }
.               { }
{eol}           { return(0); }

%%