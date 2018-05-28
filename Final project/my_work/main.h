#include <iostream>  
#include <string>  
#include <cstdlib>
using namespace std;
#define NOT_EQUAL -12321

extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

typedef struct treeNode{
    struct treeNode *left, *right;
    string type;
    int rtype;     // return type, 0 as NUM, 1 as LOGIC, 2 as ID, 3 as FUN, 4 as Pars or Args
    int ival;
    string name;
    bool bval;
} Node; 

typedef struct{
    int rtype;
    int ival;
    bool bval;
} Var;

typedef Var* Var_ptr;
typedef Node* Node_ptr;


Node* newNode(Node*, Node*, string, int = 2, int = 0, string = " ", bool = false);
Var* newVar(int, int, bool);

void traverseAST(Node*);
int num_op_action(string);          // return result in EXPS for operator : Plus Mul Equal
bool bool_op_action(string);        // return result in EXPS for operator : And Or Not
bool allow2Define(string,int);      // to check if this variable is defined already, mode 1 for variable name, 2 for function name
void bindArgs2Pars(string);         // bind arguments to parameters for function 

// for debug
void printNodeInfo(Node*);      
void printAllVariable();
void printAllFunPars();
void printAllFunArgs();