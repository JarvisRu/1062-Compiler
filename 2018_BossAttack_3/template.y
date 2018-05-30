/* 
    Template for BossAttack3_2018 
    
    @struct : Node Var Matrix Operator
    @grammar : matrix calculator 
    @author JarvisRu
*/


%{
    #include "main.h"
    using namespace std;

    // declare global variable
    bool error = false;
    // ....

%}


%union {
    int ival;
    // Matrix *mat;
    // char* ele;
    // Operator op;
}
%token<ival> NUMBER
%token<op> PLUS
%token<op> SUB
%token<op> MUL
%type <mat> mat
%type <mat> expr
%type <mat> exp

%%
final   :   expr                            { printResult();}              
expr    :   expr PLUS exp                   { $$ = calculate($1, $3, $2); }  
        |   expr SUB exp                    { $$ = calculate($1, $3, $2); }  
        |   exp                             {  }
        ;
exp     :   exp MUL mat                     { $$ = calculate($1, $3, $2); }
        |   mat                             { }
        ;
mat     :   '(' expr ')'                    { $$ = $2;  }
        |   '[' NUMBER ',' NUMBER ']'       { $$ = newMatrix($2,$4); }
        ;
%%

void yyerror (const char *message) {
    cout << "Invalid format";
}
// ---------------- New  ----------------------
Node* newNode(Node *l, Node *r, string type, int rtype, int ival, string name, bool bval) {
    Node* n = (Node *)malloc(sizeof(Node));
    n->left = l;
    n->right = r;
    n->type = type;
    n->rtype = rtype;
    n->ival = ival;
    n->name = name;
    n->bval = bval;
    return n;
}

Var* newVar(int rtype, int ival, bool bval) {
    Var* v = (Var *)malloc(sizeof(Var));
    v->rtype = rtype;
    v->ival = ival;
    v->bval = bval;
    return v;
}

Matrix* newMatrix(int lval, int rval){
    Matrix* m = (Matrix *)malloc(sizeof(Matrix));
    m->left_value = lval;
    m->right_value = rval;
    return m;
}
// ----------------- Support Function ---------------------


// -------------------------------------------
void printResult() {
    if(error)
        cout << "error message ";
    else
        cout << "Accepted";
}
// -------------------------------------------

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
