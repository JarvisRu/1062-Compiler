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

map<char,int> lhsMap;
map<char,int> rhsMap;
map<char,int> tmpMap;
map<char,int>::iterator it, it2;
bool inLHS = true;
bool inner = false;

void updateForElement(char, int);
void updateForInner(char, int);
void updateForCompound(int);
void print();
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

line    : expr                      { cout << "ACCEPT!!" << endl; print(); }
        ;
expr    : lhs EQUAL rhs             {  }
        ;
lhs     : lhs PLUS lhs                       { cout << "LHS ALL COMPLETE !!" << endl; inLHS = false; }
        | comp                               { cout << "New lhs complete" << endl; updateForCompound(1); }
        | NUMBER comp                        { cout << "New lfs with number complete | " << $1 << endl; updateForCompound($1); }
        ;
rhs     : rhs PLUS rhs                      { cout << "RHS ALL COMPLETE !!" << endl;}
        | comp                              { cout << "New rhs complete" << endl; updateForCompound(1);}
        | NUMBER comp                        { cout << "New rhs with number complete | " << $1 << endl; updateForCompound($1);}
        ;
comp    : comp elem                       {  }
        | elem                            {  }
        | comp left comp right NUMBER     { cout << "New (comp) with number "  << $5 << endl; }
        | comp left comp right            { cout << "New (comp) " << endl; }
        ;
elem    : ELEMENT NUMBER            { cout << "New ele " << $1[0] << " | " << $2 << endl; updateForElement($1[0], $2); }
        | ELEMENT                   { cout << "New ele " << $1[0] << " | " << 1 << endl; updateForElement($1[0], 1);}
        ;   
left    : LEFT  { cout << "( occurs!!" << endl; }
        ;
right   : RIGHT { cout << ") occurs!!" << endl; }
        ;

%%

void yyerror (const char *message) {
    cerr << "Invalid format";
}

void updateForElement(char ele, int num) {
    cout << "====update element=====" << endl;
    it = tmpMap.find(ele);
    if (it != tmpMap.end()) {
        tmpMap[ele] += num;
    } else {
        tmpMap[ele] = num;
    }
}

void updateForCompound(int num) {
    if(inLHS) {
        for(it = tmpMap.begin() ; it != tmpMap.end() ; ++it) {
            it2 = lhsMap.find(it->first);
            if(it2 != lhsMap.end()) {
                lhsMap[it->first] += num * it->second;
            } else {
                lhsMap[it->first] = num * it->second;
            }
        }
    } else {
        for(it = tmpMap.begin() ; it != tmpMap.end() ; ++it) {
            it2 = rhsMap.find(it->first);
            if(it2 != rhsMap.end()) {
                rhsMap[it->first] += num * it->second;
            } else {
                rhsMap[it->first] = num * it->second;
            }
        }
    }  
    tmpMap.clear();
}

void print() {
    cout << "=========LHS=========" << endl;
    for(it = lhsMap.begin() ; it != lhsMap.end() ; ++it) {
        cout << it->first << " | " << it->second << endl;
    }    
    cout << "=========RHS=========" << endl;
    for(it = rhsMap.begin() ; it != rhsMap.end() ; ++it) {
        cout << it->first << " | " << it->second << endl;
    }    
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
