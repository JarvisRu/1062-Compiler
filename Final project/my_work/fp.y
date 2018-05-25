%code requires {
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
        int num;
        string name;
        bool bval;
    } Node; 
    
    Node* newNode(Node*, Node*, string, int = 0, string = " ", bool = false);
    void traverseAST(Node*);
    int num_op_action(string);      // for operator Plus Mul Equal
    bool bool_op_action(string);    // for operator And Or Not
    void printNodeInfo(Node*);      // for debug
}

%{
    #include <vector>
    using namespace std;
    vector<int> num_action;         // store for EXPS : Plus Mul Equal
    vector<bool> bool_action;       // store for EXPS : And Or Not
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
PROGRAM     :   STMTS                       { cout << "Accepted, Root | "; printNodeInfo($1); traverseAST($1); }
            ;
STMTS       :   STMT STMTS
            |   STMT                        { cout << "STMT -> STMTS | "; $$ = $1; printNodeInfo($$); }
            ;
STMT        :   EXP                         { cout << "EXP -> STMT | ";  $$ = $1; printNodeInfo($$); }
            |   DEF-STMT                    { cout << "D-STMT -> STMT | "; $$ = $1; printNodeInfo($$); }
            |   PRINT-STMT                  { cout << "P-STMT -> STMT | "; $$ = $1; printNodeInfo($$); }
            ;
DEF-STMT    :   '(' DEFINE VARIABLE EXP ')' { }
            ;
PRINT-STMT  :   '(' PRINT_NUM EXP ')'       { cout << "New node for PRINT_NUM" << endl;     $$ = newNode($3, NULL, "PRINT_NUM"); }
            |   '(' PRINT_BOOL EXP ')'      { cout << "New node for PRINT_BOOL" << endl;    $$ = newNode($3, NULL, "PRINT_BOOL");}
            ;
EXPS        :   EXP EXPS                    {  cout << "EXP EXPS -> EXPS" << endl;          $$ = newNode($1, $2, "EXPS"); }
            |   EXP                         {  cout << "EXP -> EXPS | ";  $$ = $1; printNodeInfo($$); }
            ;
EXP         :   bool_val                    { cout << "Node bool_val -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "bool_val", 0, " ", $1); }
            |   number                      { cout << "Node number -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "number", $1); }
            |   VARIABLE                    { }
            |   NUM-OP                      { cout << "NUM-OP -> EXP " << endl; $$ = $1;}
            |   LOGICAL-OP                  { cout << "LOGICAL-OPP -> EXP " << endl; $$ = $1;}
            ;
NUM-OP      :   '(' Plus EXP EXPS ')'       { cout << "New node for plus " << $3->num << " + " << $4->num << endl; $$ = newNode($3, $4, "Plus"); }
            |   '(' Minus EXP EXP ')'       { cout << "New node for sub " << $3->num << " - " << $4->num << endl; $$ = newNode($3, $4, "Minus"); }
            |   '(' Mul EXP EXPS ')'        { cout << "New node for mul " << $3->num << " * " << $4->num << endl; $$ = newNode($3, $4, "Mul");}
            |   '(' Div EXP EXP ')'         { cout << "New node for div " << $3->num << " / " << $4->num << endl; $$ = newNode($3, $4, "Div"); }
            |   '(' Mod EXP EXP ')'         { cout << "New node for mod " << $3->num << " % " << $4->num << endl; $$ = newNode($3, $4, "Mod"); }
            |   '(' Greater EXP EXP ')'     { cout << "New node for greater " << $3->num << " > " << $4->num << endl; $$ = newNode($3, $4, "Greater"); }
            |   '(' Smaller EXP EXP ')'     { cout << "New node for smaller " << $3->num << " < " << $4->num << endl; $$ = newNode($3, $4, "Smaller"); }
            |   '(' Equal EXP EXPS ')'      { cout << "New node for equal " << $3->num << " == " << $4->num << endl; $$ = newNode($3, $4, "Equal");}
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
        cout << "[ Traverse Node - Bool_val ]: " << node->bval << endl;
    } 
    else if(node->type == "id") {
        cout << "[ Traverse Node - ID ]: " << node->name << endl;
    } 
    // ( Operator EXP EXPS )
    else if(node->type == "Plus") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->num = (node->right->type == "EXPS") ? node->left->num + num_op_action(node->type) : node->left->num + node->right->num;
        cout << "[ Traverse Node - Plus ]: " << node->num << endl;
        num_action.clear();
    } 
    else if(node->type == "Mul") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->num = (node->right->type == "EXPS") ? node->left->num * num_op_action(node->type) : node->left->num * node->right->num;
        cout << "[ Traverse Node - Mul ]: " << node->num << endl;
        num_action.clear();
    } 
    else if(node->type == "Equal") {
        traverseAST(node->left);
        traverseAST(node->right);
        if(node->right->type == "EXPS") {
            if(num_op_action(node->type) == NOT_EQUAL)
                node->bval = 0;
            else
                node->bval = (node->left->num == num_op_action(node->type))? 1 : 0;
        } else {
             node->bval = (node->left->num ==  node->right->num)? 1 : 0;
        }
        cout << "[ Traverse Node - Equal ]: " << node->bval << endl;
        num_action.clear();
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
    else if(node->type == "Greater") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->bval = (node->left->num > node->right->num)? 1 : 0;
        cout << "[ Traverse Node - Greater ]: " << node->bval << endl;
    }
    else if(node->type == "Smaller") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->bval = (node->left->num < node->right->num)? 1 : 0;
        cout << "[ Traverse Node - Smaller ]: " << node->bval << endl;
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
    // EXPS
    else if(node->type == "EXPS") {
        traverseAST(node->left);
        traverseAST(node->right);
        cout << "[ Traverse Node - EXPS ] " << node->left->num << " | " << node->right->num << endl;
        num_action.push_back(node->left->num);
        num_action.push_back(node->right->num);
    } 

}

int num_op_action(string type){
    int res = (type == "Mul")? 1 : 0;
    if(type == "Equal")
        res = num_action[0];

    for(int i = 0 ; i < num_action.size(); i++) {
        if(type == "Plus")
            res += num_action[i];
        else if(type == "Mul")
            res *= num_action[i];
        else if(type == "Equal") {
            if(res != num_action[i])
                return NOT_EQUAL;
        }
    }
    cout << "OP_ACTION_INT RES: " << res << endl;
    return res;
}

void printNodeInfo(Node *node) {
    if(node->type == "bool_val") {
        cout << "Type: bool |" << node->bval << endl;
    } else if (node->type == "number") {
        cout << "Type: number |" << node->num << endl;
    } else {
        cout << "Type: " << node->type << endl;
    }
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
