%code requires {
    #include <iostream>  
    #include <string>  
    #include <cstdlib>
    using namespace std;  

    extern "C"
    {   
        int yylex(void);
        void yyerror(const char *s);  
    }  

    typedef struct treeNode{
        struct treeNode *left, *right;
        string type;
        int num;
        string name;
        bool bval;
    } Node; 
    
    Node* newNode(Node*, Node*, string, int = 0, string = " ", bool = false);
    void traverseAST(Node*);
}
%{
    
%}


%union {
    int ival;
    char *str;
    bool bval;
    char *op;
    Node *node;
}
%token<ival> number
%token<str> id
%token<bval> bool_val
%token<op> Plus Minus Mul Div Mod
%token<op> Greater Smaller Equal
%token<op> And Or Not
%token<str> PRINT_NUM PRINT_BOOL DEFINE
%type <node> STMTS STMT
%type <node> EXPS EXP
%type <node> DEF-STMT PRINT-STMT
%type <node> VARIABLE
%type <node> NUM-OP LOGICAL-OP

%%
PROGRAM     :   STMTS                       { cout << "Accepted, Root type " << $1->type << endl; traverseAST($1); }
            ;
STMTS       :   STMT STMTS
            |   STMT                        { cout << "STMT -> STMTS | type " << $1->type << endl; $$ = $1;  }
            ;
STMT        :   EXP                         { cout << "EXP -> STMT | type " << $1->type << endl; $$ = $1;  }
            |   DEF-STMT                    { cout << "D-STMT -> STMT | type " << $1->type << endl; $$ = $1;  }
            |   PRINT-STMT                  { cout << "P-STMT -> STMT | type " << $1->type << endl; $$ = $1;  }
            ;
DEF-STMT    :   '(' DEFINE VARIABLE EXP ')' { }
            ;
PRINT-STMT  :   '(' PRINT_NUM EXP ')'       { cout << "New node for PRINT_NUM" << endl; $$ = newNode($3, NULL, "PRINT_NUM"); }
            |   '(' PRINT_BOOL EXP ')'      { cout << "New node for PRINT_BOOL" << endl; $$ = newNode($3, NULL, "PRINT_BOOL");}
            ;
EXPS        :   EXP EXPS                    {  cout << "EXP EXPS -> EXPS" << endl;                  $$ = newNode($1, $2, "EXPS"); }
            |   EXP                         {  cout << "EXP -> EXPS | type " << $1->type << endl;   $$ = $1;  }
            ;
EXP         :   bool_val                    { cout << "Node bool_val -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "bool_val", 0, "", $1); }
            |   number                      { cout << "Node number -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "number", $1); }
            |   VARIABLE                    { }
            |   NUM-OP                      { cout << "NUM-OP -> EXP " << endl; $$ = $1;}
            |   LOGICAL-OP                  { cout << "LOGICAL-OPP -> EXP " << endl; $$ = $1;}
            ;
NUM-OP      :   '(' Plus EXP EXPS ')'       { }
            |   '(' Minus EXP EXP ')'       { cout << "New node for sub " << $3->num << "-" << $4->num << endl; $$ = newNode($3, $4, "Minus");  }
            |   '(' Mul EXP EXPS ')'        { }
            |   '(' Div EXP EXP ')'         { cout << "New node for div " << $3->num << "div" << $4->num << endl; $$ = newNode($3, $4, "Div"); }
            |   '(' Mod EXP EXP ')'         { cout << "New node for mod " << $3->num << "mod" << $4->num << endl; $$ = newNode($3, $4, "Mod"); }
            |   '(' Greater EXP EXP ')'     { }
            |   '(' Smaller EXP EXP ')'     { }
            |   '(' Equal EXP EXPS ')'      { }
            ;
LOGICAL-OP  :   '(' And EXP EXPS ')'        { }
            |   '(' Or EXP EXPS ')'         { }
            |   '(' Not EXP ')'             { }
            ;
VARIABLE    :   id                          { $$ = newNode(NULL, NULL, "id", 0, $1); cout << "New node for id " << $1 << endl; }
            ;
%%

void yyerror (const char *message) {
    cout << "Syntax error";
}

Node* newNode(Node *l, Node *r, string type, int num, string name, bool bval) {
    Node* n = (Node *)malloc(sizeof(Node));
    n->left = l;
    n->right = r;
    n->type = type;
    n->num = num;
    n->name = name;
    n->bval = bval;
    cout << "New Node done" << endl;
    return n;
}

void traverseAST(Node *node) {
    if(node == NULL)
        return;

    // do action
    if(node->type == "number") {
        cout << "[ Traverse Node - Number ]: " << node->num << endl;
    } 
    else if(node->type == "bool_val") {
        cout << "[ Traverse Node - Bool_val ]: " << node->name << endl;
    } 
    else if(node->type == "id") {
        cout << "[ Traverse Node - ID ]: " << node->name << endl;
    } 
    // ( Operator EXP EXP )
    else if(node->type == "Minus") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->num = node->left->num - node->right->num;
        cout << "[ Traverse Node - Minus ]: " << node->num << endl;
    } 
    else if(node->type == "Div") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->num = node->left->num / node->right->num;
        cout << "[ Traverse Node - Div ]: " << node->num << endl;
    } 
    else if(node->type == "Mod") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->num = node->left->num % node->right->num;
        cout << "[ Traverse Node - Div ]: " << node->num << endl;
    }
    // PRINT
    else if(node->type == "PRINT_NUM") {
        traverseAST(node->left);
        cout << "[ Traverse Node - PRINT_NUM RESULT ]: " << node->left->num << endl;
    }
    else if(node->type == "PRINT_BOOL") {
        traverseAST(node->left);
        cout << "[ Traverse Node - PRINT_BOOL RESULT ]: " << node->left->bval << endl;
    }
    
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
