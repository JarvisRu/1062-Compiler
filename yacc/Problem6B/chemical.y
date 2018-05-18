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
%type <ele> com
%type <ele> ele

%%

line    : expr                      { cout << "ALL " << $1; }
        ;
expr    : lhs EQUAL rhs             { cout << "First " << $1 << " Second " << $3 << endl; }
        ;
lhs     : com                  { cout << "LHS COMPOUND " << $1 << endl;}
        ;
rhs     : com                  { cout << "RHS COMPOUND " << $1 << endl;}
        ;
com     : ele com
        | 
        ;
ele     : ELEMENT NUMBER            { cout << "element and number " << $1 << $2 << endl;}
        | ELEMENT                   { cout << "Only element " << $1 << endl;}
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
