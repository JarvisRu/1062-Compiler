
%{
    #include "main.h"
    using namespace std;
%}

%union {
    float fval;
    char op;
    char *str;
}
%token<fval> NUMBER
%token<op> PLUS
%token<op> SUB
%token<op> POWER
%token<str> FRAC
%type <fval> num
%type <fval> expr
%type <fval> exp

%%
final   :   expr                            { printf("%.3lf", $1); }              
expr    :   expr PLUS exp                   { $$ = $1 + $3; }  
        |   expr SUB exp                    { $$ = $1 - $3; }  
        |   exp                             
        ;
exp     :   exp POWER num                   { $$ = pow($1, $3); }
        |   exp POWER '{' expr '}'          { $$ = pow($1, $4); }
        |   num                             
        ;
num     :   FRAC '{' expr '}' '{' expr '}'  {  $$ = $3/$6;  }
        |   NUMBER                          {  $$ = $1;     }
        ;
%%

void yyerror (const char *message) {
    cout << "Invalid format";
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
