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
%token<op> PLUS
%token<op> LEFT
%token<op> RIGHT
%type <ele> expr
%type <ele> lhs
%type <ele> rhs
%type <ele> comp
%type <ele> elem
%type <op> left
%type <op> right

%%

line    : expr                      { cout << "ACCEPT!!" << endl; }
        ;
expr    : lhs EQUAL rhs             {  }
        ;
lhs     : lhs PLUS lhs                       { cout << "LHS ALL COMPLETE !!" << endl;}
        | comp                               { cout << "New lhs complete" << endl; }
        | NUMBER comp                        { cout << "New lfs with number complete | " << $1 << endl; }
        ;
rhs     : rhs PLUS rhs                      { cout << "RHS ALL COMPLETE !!" << endl;}
        | comp                              { cout << "New rhs complete" << endl; }
        | NUMBER comp                        { cout << "New rhs with number complete | " << $1 << endl; }
        ;
comp    : comp elem                       {  }
        | elem                            {  }
        | comp left comp right NUMBER     { cout << "New (comp) with number "  << $5 << endl; }
        | comp left comp right            { cout << "New (comp) " << endl; }
        ;
elem    : ELEMENT NUMBER            { cout << "New ele " << $1[0] << " | " << $2 << endl;}
        | ELEMENT                   { cout << "New ele " << $1[0] << " | " << 1 << endl;}
        ;   
left    : LEFT  { cout << "( occurs!!" << endl; }
        ;
right   : RIGHT { cout << ") occurs!!" << endl; }
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
