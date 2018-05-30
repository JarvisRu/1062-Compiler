#include<iostream>  
#include<string>  
#include<sstream>  
#include<stdio.h>
#include<map>
#include<vector>

using namespace std;

extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

// declare struct or function
typedef struct treeNode{
    struct treeNode *left, *right;
    string type;
    int rtype;                          // return type, 0 as NUM, 1 as LOGIC, 2 as ID
    int ival;
    string name;
    bool bval;
} Node; 

typedef struct{
    int rtype;
    int ival;
    bool bval;
} Var;

typedef struct{
    int left_value;
    int right_value;
} Matrix; 

typedef struct{
    char *type;
    int pos;
} Operator;

typedef Var* Var_ptr;
typedef Node* Node_ptr;

Node* newNode(Node*, Node*, string, int, int, string, bool);    // type, rytpe, ival, name, bval
Var* newVar(int, int, bool);
Matrix* newMatrix(int, int);
void traverseAST(Node*);

void printResult();