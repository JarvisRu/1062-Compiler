%{
#include<iostream>  
#include<string>  
#include<sstream>  
#include<stdio.h>
#include<map>
using namespace std;

extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

map<string,int> lhsMap;
map<string,int> rhsMap;
map<string,int> tmpMap;
map<string,int> innerMap;
map<string,int> resultMap;
map<string,int>::iterator it, it2;
bool inLHS = true;
bool inner = false;

void updateForElement(string, bool);
void updateForInner(int);
void updateForCompound(int);
void printResult();
%}

%union {
    int ival;
    char* ele;
    char* op;
}
%token<ele> ELEMENT
%token<ele> ELEMENT_NUM
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

line    : expr                      { cout << "ACCEPT!!" << endl; printResult(); }
        ;
expr    : lhs EQUAL rhs             
        ;
lhs     : lhs PLUS lhs                       { cout << "LHS ALL COMPLETE !!" << endl;  }
        | comp                               { cout << "New lhs complete" << endl; updateForCompound(1); }
        | NUMBER comp                        { cout << "New lfs with number complete | " << $1 << endl; updateForCompound($1); }
        ;
rhs     : rhs PLUS rhs                      { cout << "RHS ALL COMPLETE !!" << endl;}
        | comp                              { cout << "New rhs complete" << endl; inLHS = false; updateForCompound(1);}
        | NUMBER comp                        { cout << "New rhs with number complete | " << $1 << endl; inLHS = false; updateForCompound($1);}
        ;
comp    : comp elem                       
        | elem                           
        | comp left comp right NUMBER     { cout << "New (comp) with number "  << $5 << endl; updateForInner($5); }
        | comp left comp right            { cout << "New (comp) " << endl; updateForInner(1); }
        |
        ;
elem    : ELEMENT_NUM               { cout << "New eleN " << $1 << endl; updateForElement($1, true); }
        | ELEMENT                   { cout << "New ele " << $$ << " | " << 1 << endl; updateForElement($1, false);}
        ;   
left    : LEFT  { cout << "( occurs!!" << endl; inner = true;}
        ;
right   : RIGHT { cout << ") occurs!!" << endl; inner = false;}
        ;

%%

void yyerror (const char *message) {
    cout << "Invalid format";
}

void updateForElement(string ele, bool has_num) {
    int num = 1;
    if (has_num) {
        string ivalue;
        stringstream ss;
        if(ele[1] >= 'a' && ele[1] <= 'z') {
            ivalue = ele.substr(2, ele.length()-2);
            ele = ele.substr(0, 2);
        }
        else {
            ivalue = ele.substr(1, ele.length()-1);
            ele = ele[0];
        }
        ss << ivalue;
        ss >> num;
    }
    cout << "====update element=====" << endl;
    if(!inner) {
        it = tmpMap.find(ele);
        if (it != tmpMap.end()) {
            tmpMap[ele] += num;
        } else {
            tmpMap[ele] = num;
        }
    } else {
        it = innerMap.find(ele);
        if (it != innerMap.end()) {
            innerMap[ele] += num;
        } else {
            innerMap[ele] = num;
        }
    }
}

void updateForInner(int num) {
    for(it = innerMap.begin() ; it != innerMap.end() ; ++it) {
        it2 = tmpMap.find(it->first);
        if(it2 != tmpMap.end()) {
            tmpMap[it->first] += num * it->second;
        } else {
            tmpMap[it->first] = num * it->second;
        }
    }

    innerMap.clear();
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

void printResult() {
    cout << "=========LHS=========" << endl;
    for(it = lhsMap.begin() ; it != lhsMap.end() ; ++it) {
        cout << it->first << " | " << it->second << endl;
    }    
    cout << "=========RHS=========" << endl;
    for(it = rhsMap.begin() ; it != rhsMap.end() ; ++it) {
        cout << it->first << " | " << it->second << endl;
    }
    cout << "=========Result=========" << endl;
    // traverse LHS
    for(it = lhsMap.begin() ; it != lhsMap.end() ; ++it) {
        it2 = rhsMap.find(it->first);
        // find target element in RHS
        if(it2 != rhsMap.end()) {
            if(it->second != it2->second) {
                resultMap[it->first] = it->second - it2->second;
            }
            // erase this element in rhsMap
            rhsMap.erase(it->first); 
        } else {
            resultMap[it->first] = it->second;
        }
        // erase this element in lhsMap
        lhsMap.erase(it->first);
    }
    // traverse remaining RHS
    for(it = rhsMap.begin() ; it != rhsMap.end() ; ++it) {
        resultMap[it->first] = -1 * it->second;
        // erase this element
        rhsMap.erase(it->first);
    }
    // order result in lexicographic order
    for(it = resultMap.begin() ; it != resultMap.end() ; ++it) {
        cout << it->first << " " << it->second << endl;
    }
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
