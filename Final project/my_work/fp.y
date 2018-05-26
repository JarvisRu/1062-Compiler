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

    // Tree Node
    typedef struct treeNode{
        struct treeNode *left, *right;
        string type;
        int rtype;     // return type, 0 as NUM, 1 as LOGIC, 2 as others
        int ival;
        string name;
        bool bval;
    } Node; 

    Node* newNode(Node*, Node*, string, int = 2, int = 0, string = " ", bool = false);
    void traverseAST(Node*);

    int num_op_action(string);      // return result in EXPS for operator : Plus Mul Equal
    bool bool_op_action(string);    // return result in EXPS for operator : And Or Not

    bool allow2Define(string);      // to check if this variable is defined already
    
    // for debug
    void printNodeInfo(Node*);      
    void printAllVariable();
}

%{
    #include <vector>
    #include <string>
    #include <map>
    using namespace std;

    typedef struct{
        int rtype;
        int ival;
        bool bval;
    } Var;

    vector<int> num_action;         // store for EXPS : Plus Mul Equal
    vector<bool> bool_action;       // store for EXPS : And Or Not

    map<string,Var> var_Map;        // store variables
    map<string,Var>::iterator it;  
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
PROGRAM     :   STMTS                       { cout << " --- Accepted ---" << endl; traverseAST($1); printAllVariable();}
            ;
STMTS       :   STMT STMTS                  { cout << "STMT STMTS -> STMTS "; $$ = newNode($1, $2, "STMTS"); }
            |   STMT                        { cout << "STMT -> STMTS | "; $$ = $1; printNodeInfo($$); }
            ;
STMT        :   EXP                         { cout << "EXP -> STMT | ";  $$ = $1; printNodeInfo($$); }
            |   DEF-STMT                    { cout << "D-STMT -> STMT | "; $$ = $1; printNodeInfo($$); }
            |   PRINT-STMT                  { cout << "P-STMT -> STMT | "; $$ = $1; printNodeInfo($$); }
            ;
DEF-STMT    :   '(' DEFINE VARIABLE EXP ')' { cout << "New node for DEFINE | V_Name " << $3->name << endl;    $$ = newNode($3, $4, "DEFINE");  }
            ;
PRINT-STMT  :   '(' PRINT_NUM EXP ')'       { cout << "New node for PRINT_NUM" << endl;     $$ = newNode($3, NULL, "PRINT_NUM"); }
            |   '(' PRINT_BOOL EXP ')'      { cout << "New node for PRINT_BOOL" << endl;    $$ = newNode($3, NULL, "PRINT_BOOL");}
            ;
EXPS        :   EXP EXPS                    {  cout << "EXP EXPS -> EXPS" << endl;          $$ = newNode($1, $2, "EXPS"); }
            |   EXP                         {  cout << "EXP -> EXPS | ";  $$ = $1; printNodeInfo($$); }
            ;
EXP         :   bool_val                    { cout << "Node bool_val -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "bool_val", 1, 0, " ", $1); }
            |   number                      { cout << "Node number -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "number", 0, $1); }
            |   VARIABLE                    { cout << "VARIABLE -> EXP " << endl;       $$ = $1;}
            |   NUM-OP                      { cout << "NUM-OP -> EXP " << endl;         $$ = $1;}
            |   LOGICAL-OP                  { cout << "LOGICAL-OPP -> EXP " << endl;    $$ = $1;}
            ;
NUM-OP      :   '(' Plus EXP EXPS ')'       { cout << "New node for plus " << endl; $$ = newNode($3, $4, "Plus", 0); }
            |   '(' Minus EXP EXP ')'       { cout << "New node for sub " << $3->ival << " - " << $4->ival << endl; $$ = newNode($3, $4, "Minus", 0); }
            |   '(' Mul EXP EXPS ')'        { cout << "New node for mul " << endl; $$ = newNode($3, $4, "Mul", 0);}
            |   '(' Div EXP EXP ')'         { cout << "New node for div " << $3->ival << " / " << $4->ival << endl; $$ = newNode($3, $4, "Div", 0); }
            |   '(' Mod EXP EXP ')'         { cout << "New node for mod " << $3->ival << " % " << $4->ival << endl; $$ = newNode($3, $4, "Mod", 0); }
            |   '(' Greater EXP EXP ')'     { cout << "New node for greater " << $3->ival << " > " << $4->ival << endl; $$ = newNode($3, $4, "Greater", 1); }
            |   '(' Smaller EXP EXP ')'     { cout << "New node for smaller " << $3->ival << " < " << $4->ival << endl; $$ = newNode($3, $4, "Smaller", 1); }
            |   '(' Equal EXP EXPS ')'      { cout << "New node for equal " << endl; $$ = newNode($3, $4, "Equal", 1); }
            ;
LOGICAL-OP  :   '(' And EXP EXPS ')'        { cout << "New node for and " << endl; $$ = newNode($3, $4, "And", 1); }
            |   '(' Or EXP EXPS ')'         { cout << "New node for or " << endl; $$ = newNode($3, $4, "Or", 1); }
            |   '(' Not EXP ')'             { cout << "New node for not " << $3->bval << endl; $$ = newNode($3, NULL, "Not", 1); }
            ;
VARIABLE    :   id                          { cout << "New node for id " << $1 << endl; $$ = newNode(NULL, NULL, "id", 2, 0, $1);  }
            ;
%%

void yyerror (const char *message) {
    cout << "Syntax error";
}

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

void traverseAST(Node *node) {
    if(node == NULL)
        return;

    // do action based on node's type
    if(node->type == "number") {
        cout << "[ Traverse Node - Number ]: " << node->ival << endl;
    } 
    else if(node->type == "bool_val") {
        cout << "[ Traverse Node - Bool_val ]: " << node->bval << endl;
    } 
    else if(node->type == "id") {
        cout << "[ Traverse Node - ID ]: " << node->name << endl;
    } 
    // ----------------------- ( Operator EXP EXPS ) -----------------------
    else if(node->type == "Plus") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = (node->right->type == "EXPS") ? node->left->ival + num_op_action(node->type) : node->left->ival + node->right->ival;
        cout << "[ Traverse Node - Plus ]: " << node->ival << endl;
        num_action.clear();
    } 
    else if(node->type == "Mul") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = (node->right->type == "EXPS") ? node->left->ival * num_op_action(node->type) : node->left->ival * node->right->ival;
        cout << "[ Traverse Node - Mul ]: " << node->ival << endl;
        num_action.clear();
    } 
    else if(node->type == "Equal") {
        traverseAST(node->left);
        traverseAST(node->right);
        if(node->right->type == "EXPS") {
            if(num_op_action(node->type) == NOT_EQUAL)
                node->bval = 0;
            else
                node->bval = (node->left->ival == num_op_action(node->type))? 1 : 0;
        } else {
             node->bval = (node->left->ival ==  node->right->ival)? 1 : 0;
        }
        cout << "[ Traverse Node - Equal ]: " << node->bval << endl;
        num_action.clear();
    } 
    else if(node->type == "And") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->bval = (node->right->type == "EXPS") ? node->left->bval && bool_op_action(node->type) : node->left->bval && node->right->bval;
        cout << "[ Traverse Node - And ]: " << node->bval << endl;
        bool_action.clear();
    } 
    else if(node->type == "Or") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->bval = (node->right->type == "EXPS") ? node->left->bval || bool_op_action(node->type) : node->left->bval || node->right->bval;
        cout << "[ Traverse Node - Or ]: " << node->bval << endl;
        bool_action.clear();
    } 
    //  ----------------------- ( Operator EXP EXP ) -----------------------
    else if(node->type == "Minus") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = node->left->ival - node->right->ival;
        cout << "[ Traverse Node - Minus ]: " << node->ival << endl;
    } 
    else if(node->type == "Div") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = node->left->ival / node->right->ival;
        cout << "[ Traverse Node - Div ]: " << node->ival << endl;
    } 
    else if(node->type == "Mod") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->ival = node->left->ival % node->right->ival;
        cout << "[ Traverse Node - Div ]: " << node->ival << endl;
    }
    else if(node->type == "Greater") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->bval = (node->left->ival > node->right->ival)? 1 : 0;
        cout << "[ Traverse Node - Greater ]: " << node->bval << endl;
    }
    else if(node->type == "Smaller") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->bval = (node->left->ival < node->right->ival)? 1 : 0;
        cout << "[ Traverse Node - Smaller ]: " << node->bval << endl;
    }
    // PRINT
    else if(node->type == "PRINT_NUM") {
        traverseAST(node->left);
        cout << "[ Traverse Node - PRINT_NUM RESULT ]: " << node->left->ival << endl;
    }
    else if(node->type == "PRINT_BOOL") {
        traverseAST(node->left);
        cout << "[ Traverse Node - PRINT_BOOL RESULT ]: " << node->left->bval << endl;
    }
    //  ----------------------- EXPS -----------------------
    else if(node->type == "EXPS") {
        traverseAST(node->left);
        traverseAST(node->right);
        // for LOGIC
        if (node->left->rtype == 1 && node->right->rtype == 1) {
            cout << "[ Traverse Node - EXPS(LOGIC) ] " << node->left->bval << " | " << node->right->bval << endl;
            bool_action.push_back(node->left->bval);
            bool_action.push_back(node->right->bval);
        }
        // for NUM
        else {
            cout << "[ Traverse Node - EXPS(NUM) ] " << node->left->ival << " | " << node->right->ival << endl;
            num_action.push_back(node->left->ival);
            num_action.push_back(node->right->ival);
        }
    } 
    //  ----------------------- Not -----------------------
    else if(node->type == "Not") {
        traverseAST(node->left);
        node->bval = !node->left->bval;
        cout << "[ Traverse Node - Not ]: " << node->bval << endl;
    }
    //  ----------------------- DEFINE -----------------------
    else if(node->type == "DEFINE") {
        // for variable
        traverseAST(node->left);
        traverseAST(node->right);
        node->name = node->left->name;
        if(allow2Define(node->name)){
            var_Map[node->name].rtype = node->right->rtype;  
            var_Map[node->name].ival = (node->right->rtype == 0)? node->right->ival : 0;  
            var_Map[node->name].bval = (node->right->rtype == 1)? node->right->bval : 0;  
            cout << "[ Traverse Node - DEFINE ]: " << node->name << " - has stored in map" << endl;
        } else {
            cout << "You can't redefining exist variable !!" << endl;
        }
    }
    //  ----------------------- STMTS -----------------------
    else if(node->type == "STMTS") {
        traverseAST(node->left);
        traverseAST(node->right);
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
    cout << "num_op_action RES: " << res << endl;
    return res;
}

bool bool_op_action(string type){
    bool res = (type == "And")? 1 : 0;

    for(int i = 0 ; i < bool_action.size(); i++) {
        if(type == "And")
            res = (res && bool_action[i])? 1 : 0;
        else if(type == "Or")
            res = (res || bool_action[i])? 1 : 0;
    }
    cout << "bool_op_action RES: " << res << endl;
    return res;
}



bool allow2Define(string name) {
    it = var_Map.find(name);

    if(it == var_Map.end())
        return true;
    else 
        return false;
}

// ----------------For Debugging----------------------

void printNodeInfo(Node *node) {
    if(node->type == "bool_val") {
        cout << "Type: bool |" << node->bval << endl;
    } else if (node->type == "number") {
        cout << "Type: number |" << node->ival << endl;
    } else {
        cout << "Type: " << node->type << endl;
    }
}

void printAllVariable(){
    cout << "--------Variables-------" << endl;
    string rtype;
    for(it = var_Map.begin() ; it != var_Map.end() ; ++it) {
        rtype = (it->second.rtype == 0)? "ival" : "bval";
        cout << it->first << " = " << rtype << ", " << it->second.ival << ", " << it->second.bval << endl;
    }
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
