%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *message);
int yylex();
%}
%union {
    int ival;
    char op;
}
%token <ival> INUMBER
%token <op>   PLUS
%type <ival>  expr
%left '+'
%%
line    : expr                  { printf("%d\n", $1); }
         ;
expr    : expr PLUS expr         { $$ = $1 + $3; }
        | INUMBER
        ;
%%

void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
