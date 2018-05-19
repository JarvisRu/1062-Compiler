%{
// C++ : Declaration used
#include "main.hpp"

%}
// Yacc declaration
%union {
    int ival;
    char op;
}
%token<ival> NUMBER
%token<op> PLUS
%type <ival> expr
%left '+'
/* grammar and corresponding action */
%%

line    : expr                  { cout << $1; }
        ;
expr    : expr PLUS expr        { cout << "Look " << $1 << " | " << $3 << endl; $$ = $1 + $3; }
        | NUMBER                { cout << "in N " << $1 << endl; }
        ;
%%
void yyerror (const char *message)
{
        cerr << message << endl;
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
