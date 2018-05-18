%{
#include<iostream>  
#include<string>  
#include<stdio.h>
#include<map>
using namespace std;

extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

%}

%union {
    int ival;
    char* ele;
    char* op;
}
%token<ele> ELEMENT
%token<ival> NUMBER
%token<op> EQUAL
%type <ele> expr
%type <ele> lhs
%type <ele> rhs
%type <ele> comp
%type <ele> elem

%%

line    : expr                      { cout << "ACCEPT!!" << endl; }
        ;
expr    : lhs EQUAL rhs             { cout << "lhs " << $1 << "| rhs " << $3 << endl; }
        ;
lhs     : lhs '+' lhs                       { cout << "LHS COMPOUND " << $1 << endl;}
        | comp                               { cout << "lfs for one " << $1 << endl; }
        ;
rhs     : rhs '+' rhs                      { cout << "RHS COMPOUND " << $1 << endl;}
        | comp                              { cout << "rhs for one " << $1 << endl; }
        ;
comp    : comp elem                  { cout << "look " << $1 << "| " << $2 << endl; }
        | elem                       { cout << "in" << $1 << endl; }
        ;
elem    : ELEMENT NUMBER            { cout << "element & number " << $1[0] << " | " << $2 << endl;}
        | ELEMENT                   { cout << "Only element " << $1[0] << endl;}
        ;   

%%

void yyerror (const char *message)
{
    cerr << "Invalid format";
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
