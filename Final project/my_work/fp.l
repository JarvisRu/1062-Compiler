%option noyywrap
%{
    #include "fp.tab.h"
%}

/* Preliminary Definitions */
separator   [\t\n\r ]
letter      [a-z]
digit       [0-9]
digits      [1-9]{digit}*

/* Token Definitions */
number      (0|{digits}|-{digits})
id          {letter}({letter}|{digit}|-)*
bool        #t|#f

%%
"+"                 {   yylval.op = yytext;      return Plus; }
"-"                 {   yylval.op = yytext;      return Minus;  }
"*"                 {   yylval.op = yytext;      return Mul;  }
"/"                 {   yylval.op = yytext;      return Div;  }
"mod"               {   yylval.op = yytext;      return Mod;  }
">"                 {   yylval.op = yytext;      return Greater; }
"<"                 {   yylval.op = yytext;      return Smaller; }
"="                 {   yylval.op = yytext;      return Equal;   }
"and"               {   yylval.op = yytext;      return And;   }
"or"                {   yylval.op = yytext;      return Or;    }
"not"               {   yylval.op = yytext;      return Not;   }
"print-num"         {   yylval.str = yytext;        return PRINT_NUM;  }
"print-bool"        {   yylval.str = yytext;        return PRINT_BOOL; }
"define"            {   yylval.str = yytext;        return DEFINE;     }
[\(\)]              {   return yytext[0]; }

{number}            {   yylval.ival = atoi(yytext); return number;  }
{id}                {   yylval.str = yytext;        return id;   }
{bool}              {   yylval.bval = (yytext[1] == 't') ? 1 : 0;  return bool_val; }

<<EOF>>             { return 0; }
{separator}         { }
.                   { }

%%