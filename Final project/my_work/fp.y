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
        int rtype;     // return type, 0 as NUM, 1 as LOGIC, 2 as ID, 3 as FUN, 4 as Pars or Args
        int ival;
        string name;
        bool bval;
    } Node; 

    Node* newNode(Node*, Node*, string, int = 2, int = 0, string = " ", bool = false);
    void traverseAST(Node*);

    int num_op_action(string);      // return result in EXPS for operator : Plus Mul Equal
    bool bool_op_action(string);    // return result in EXPS for operator : And Or Not

    bool allow2Define(string);      // to check if this variable is defined already

    void bindArgs2Pars(string);     // bind arguments to parameters for function 
    
    // for debug
    void printNodeInfo(Node*);      
    void printAllVariable();
    void printAllFunPars();
    void printAllFunArgs();
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

    typedef Var* Var_ptr;

    Var* newVar(int, int, bool);

    vector<int> num_action;         // store for EXPS : Plus Mul Equal
    vector<bool> bool_action;       // store for EXPS : And Or Not

    map<string,Var> var_Map;                        // store variables for normal
    map<string,Var>::iterator it;  

    string funMode = "none";
    map<string, map<string, Var_ptr> > par_Map;         // store parameters for function < FUN-NAME , variables name >
    vector<Var_ptr> args;                               // store args for function
    map<string, map<string, Var_ptr> >::iterator it2;  
    map<string, Var_ptr>::iterator it3;   

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
%token<str> PRINT_NUM PRINT_BOOL DEFINE IF FUN
%type <node> STMTS STMT
%type <node> EXPS EXP
%type <node> DEF-STMT PRINT-STMT
%type <node> VARIABLE 
%type <node> NUM-OP LOGICAL-OP
%type <node> IF-EXP TEST-EXP THAN-ELSE-EXP
%type <node> FUN-EXP FUN-CALL 
%type <node> FUN_IDs FUN-BODY 
%type <node> PARAMETERS ARGUMENTS


%%
PROGRAM         :   STMTS                       { cout << "[ Accepted ]" << endl; traverseAST($1); }
                ;

STMTS           :   STMT STMTS                  { cout << "STMT STMTS -> STMTS "; $$ = newNode($1, $2, "STMTS"); }
                |   STMT                        { cout << "STMT -> STMTS | "; $$ = $1; printNodeInfo($$); }
                ;
STMT            :   EXP                         { cout << "EXP -> STMT | ";  $$ = $1; printNodeInfo($$); }
                |   DEF-STMT                    { cout << "D-STMT -> STMT | "; $$ = $1; printNodeInfo($$); }
                |   PRINT-STMT                  { cout << "P-STMT -> STMT | "; $$ = $1; printNodeInfo($$); }
                ;

DEF-STMT        :   '(' DEFINE VARIABLE EXP ')' { cout << "New node for DEFINE | V_Name " << $3->name << endl;    $$ = newNode($3, $4, "DEFINE");  }
                ;
PRINT-STMT      :   '(' PRINT_NUM EXP ')'       { cout << "New node for PRINT_NUM" << endl;     $$ = newNode($3, NULL, "PRINT_NUM"); }
                |   '(' PRINT_BOOL EXP ')'      { cout << "New node for PRINT_BOOL" << endl;    $$ = newNode($3, NULL, "PRINT_BOOL");}
                ;

EXPS            :   EXP EXPS                    {  cout << "EXP EXPS -> EXPS" << endl;          $$ = newNode($1, $2, "EXPS"); }
                |   EXP                         {  cout << "EXP -> EXPS | ";  $$ = $1; printNodeInfo($$); }
                ;
EXP             :   bool_val                    { cout << "Node bool_val -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "bool_val", 1, 0, " ", $1); }
                |   number                      { cout << "Node number -> EXP " << $1 << endl; $$ = newNode(NULL, NULL, "number", 0, $1); }
                |   VARIABLE                    { cout << "VARIABLE -> EXP " << endl;       $$ = $1; }
                |   NUM-OP                      { cout << "NUM-OP -> EXP " << endl;         $$ = $1; }
                |   LOGICAL-OP                  { cout << "LOGICAL-OPP -> EXP " << endl;    $$ = $1; }
                |   IF-EXP                      { cout << "IF-EXP -> EXP " << endl;         $$ = $1; }
                |   FUN-EXP                     { cout << "FUN-EXP -> EXP " << endl;        $$ = $1; }
                |   FUN-CALL                    {}
                ;

NUM-OP          :   '(' Plus EXP EXPS ')'       { cout << "New node for plus " << endl; $$ = newNode($3, $4, "Plus", 0); }
                |   '(' Minus EXP EXP ')'       { cout << "New node for sub " << $3->ival << " - " << $4->ival << endl; $$ = newNode($3, $4, "Minus", 0); }
                |   '(' Mul EXP EXPS ')'        { cout << "New node for mul " << endl; $$ = newNode($3, $4, "Mul", 0);}
                |   '(' Div EXP EXP ')'         { cout << "New node for div " << $3->ival << " / " << $4->ival << endl; $$ = newNode($3, $4, "Div", 0); }
                |   '(' Mod EXP EXP ')'         { cout << "New node for mod " << $3->ival << " % " << $4->ival << endl; $$ = newNode($3, $4, "Mod", 0); }
                |   '(' Greater EXP EXP ')'     { cout << "New node for greater " << $3->ival << " > " << $4->ival << endl; $$ = newNode($3, $4, "Greater", 1); }
                |   '(' Smaller EXP EXP ')'     { cout << "New node for smaller " << $3->ival << " < " << $4->ival << endl; $$ = newNode($3, $4, "Smaller", 1); }
                |   '(' Equal EXP EXPS ')'      { cout << "New node for equal " << endl; $$ = newNode($3, $4, "Equal", 1); }
                ;
LOGICAL-OP      :   '(' And EXP EXPS ')'        { cout << "New node for and " << endl; $$ = newNode($3, $4, "And", 1); }
                |   '(' Or EXP EXPS ')'         { cout << "New node for or " << endl; $$ = newNode($3, $4, "Or", 1); }
                |   '(' Not EXP ')'             { cout << "New node for not " << $3->bval << endl; $$ = newNode($3, NULL, "Not", 1); }
                ;

IF-EXP          :   '(' IF TEST-EXP THAN-ELSE-EXP ')'   { cout << "New node for IF-EXP " << endl; $$ = newNode($3, $4, "IF", 0);}
                ;
TEST-EXP        :   EXP                                 { cout << "EXP -> TEST-EXP | "; $$ = $1; printNodeInfo($$); }
                ;
THAN-ELSE-EXP   :   EXP EXP                             { cout << "New node for THAN-ELSE EXP" << endl; $$ = newNode($1, $2, "THAN-ELSE-EXP"); }
                ;

FUN-EXP         :   '(' FUN FUN_IDs FUN-BODY ')'       { cout << "New node for FUN-EXP " << endl; $$ = newNode($3, $4, "FUN", 3); }
                ;
FUN_IDs         :   '(' PARAMETERS ')'                  { cout << "FUN_IDs complete !!" << endl; $$ = $2; }
                ;
FUN-BODY        :   EXP                                 {  cout << "EXP -> FUN-BODY | "; $$ = $1; printNodeInfo($$); }
                ;
FUN-CALL        :   '(' FUN-EXP ARGUMENTS ')'   {  cout << "New node for FUN-CALL " << endl; $$ = newNode($2, $3, "FUN-CALL", 3); }
                ;

ARGUMENTS       :   EXP ARGUMENTS               { cout << "New node for ARGUMENTS " << endl; $$ = newNode($1, $2, "ARGUMENTS", 4);}
                |   EXP                         { $$ = newNode($1, NULL, "ARGUMENTS", 4); }
                |                               
                ;
PARAMETERS      :   VARIABLE PARAMETERS         { cout << "New node for PARAMETERS " << endl; $$ = newNode($1, $2, "PARAMETERS", 4);}
                |   VARIABLE                    { $$ = newNode($1, NULL, "PARAMETERS", 4); }
                |                               
                ;
VARIABLE        :   id                          { cout << "New node for id " << $1 << endl; $$ = newNode(NULL, NULL, "id", 2, 0, $1);  }
                ;
%%

void yyerror (const char *message) {
    cout << "Syntax error";
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
// ---------------- Traverse ----------------------

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
        if(funMode == "none") {
            it = var_Map.find(node->name); 
            if(it != var_Map.end()){
                cout << "assign value from existed variable" << endl;
                node->rtype = it->second.rtype;
                node->ival = it->second.ival;
                node->bval = it->second.bval;
            }
        } else {
            it3 = par_Map[funMode].find(node->name);
            if(it3 != par_Map[funMode].end()){
                cout << "assign value from parameters - " << funMode << endl;
                node->rtype = it3->second->rtype;
                node->ival = it3->second->ival;
                node->bval = it3->second->bval;
            }
        }
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
    // ----------------------- PRINT -----------------------
    else if(node->type == "PRINT_NUM") {
        traverseAST(node->left);
        int res;
        if(node->left->type == "id") 
            res = var_Map[node->left->name].ival;
        else 
            res = node->left->ival;
        cout << "[ Traverse Node - PRINT_NUM RESULT ]: " << res << endl;
    }
    else if(node->type == "PRINT_BOOL") {
        traverseAST(node->left);
        string res;
        if(node->left->type == "id") 
            res = (var_Map[node->left->name].bval)? "#t" : "#f";
        else 
            res = (node->left->bval)? "#t" : "#f";
        cout << "[ Traverse Node - PRINT_BOOL RESULT ]: " << res << endl;
    }
    //  ----------------------- EXPS -----------------------
    else if(node->type == "EXPS") {
        traverseAST(node->left);
        traverseAST(node->right);
        // for LOGIC
        if (node->left->rtype == 1 && node->right->rtype == 1) {
            cout << "[ Traverse Node - EXPS(LOGIC) ] " << node->left->bval << " | " << node->right->bval << endl;
            bool_action.push_back(node->left->bval);
            if(node->right->type != "EXPS")
                bool_action.push_back(node->right->bval);
        }
        // for NUM
        else {
            cout << "[ Traverse Node - EXPS(NUM) ] " << node->left->ival << " | " << node->right->ival << endl;
            num_action.push_back(node->left->ival);
            if(node->right->type != "EXPS")
                num_action.push_back(node->right->ival);
        }
    } 
    //  ----------------------- Not -----------------------
    else if(node->type == "Not") {
        traverseAST(node->left);
        node->bval = !node->left->bval;
        node->rtype = node->left->rtype;
        cout << "[ Traverse Node - Not ]: " << node->bval << endl;
    }
    //  ----------------------- DEFINE -----------------------
    else if(node->type == "DEFINE") {
        // for variable
        traverseAST(node->left);
        traverseAST(node->right);
        node->name = node->left->name;
        node->rtype = node->right->rtype;
        if(allow2Define(node->name)){
            var_Map[node->name].rtype = node->right->rtype;  
            var_Map[node->name].ival = (node->right->rtype == 0)? node->right->ival : 0;  
            var_Map[node->name].bval = (node->right->rtype == 1)? node->right->bval : 0;  
            cout << "[ Traverse Node - DEFINE ]: " << node->name << " - into map" << endl;
        } else {
            cout << "You can't redefining exist variable !!" << endl;
        }
    }
    //  ----------------------- IF-EXP -----------------------
    else if(node->type == "IF") {
        traverseAST(node->left);

        // if TEST-EXP = TRUE -> do THAN-EXP(left child of THAN-ELSE-EXP node)
        if(node->left->bval){
            traverseAST(node->right->left);
            if(node->right->left->rtype == 0){
                node->ival = node->right->left->ival; 
                node->rtype = 0;
            }
            else if(node->right->left->rtype == 1){
                node->bval = node->right->left->bval; 
                node->rtype = 1;
            }
        }
        // if TEST-EXP = FALSE -> do ELSE-EXP(right child of THAN-ELSE-EXP node)
        else{
            traverseAST(node->right->right);
            if(node->right->right->rtype == 0){
                node->ival = node->right->right->ival; 
                node->rtype = 0;
            }
            else if(node->right->right->rtype == 1){
                node->bval = node->right->right->bval; 
                node->rtype = 1;
            }
        }
        cout << "[ Traverse Node - IF-EXP ]: Test is " << node->left->bval << endl;
    }
    //  ----------------------- FUN -----------------------
    else if(node->type == "FUN") { 
        traverseAST(node->left);
        bindArgs2Pars("noName");
        funMode = "noName";             // node(id) will find value in parameter
        traverseAST(node->right);
        funMode = "none";  
        node->rtype = node->right->rtype;
        node->ival = node->right->ival;
        node->bval = node->right->bval;
        cout << "[ Traverse Node - FUN] " << endl;
    }
    else if(node->type == "FUN-CALL") { 
        traverseAST(node->right);
        traverseAST(node->left);
        node->rtype = node->left->rtype;
        node->ival = node->left->ival;
        node->bval = node->left->bval;
        cout << "[ Traverse Node - FUN-CALL] " << endl;
        par_Map["noName"].clear();
        args.clear();
    }
    else if(node->type == "PARAMETERS") {
        traverseAST(node->left);
        traverseAST(node->right);
        cout << "[ Traverse Node - PARAMETERS] " << endl;
        if(node->right != NULL && node->right->type != "PARAMETERS")
            par_Map["noName"][node->right->name] = newVar(0, 0, 0);
        if(node->left != NULL && node->left->type != "PARAMETERS")
            par_Map["noName"][node->left->name] = newVar(0, 0, 0);
    } 
    else if(node->type == "ARGUMENTS") {
        traverseAST(node->left);
        traverseAST(node->right);
        cout << "[ Traverse Node - ARGUMENTS] " << endl;
        if(node->right != NULL && node->right->type != "ARGUMENTS") {
            if(node->right->rtype == 0) {
                args.push_back(newVar(0, node->right->ival, 0));
                cout << "Push one var as arg - " << node->right->ival << endl;
            }else if(node->right->rtype == 1) {
                args.push_back(newVar(1, 0, node->right->bval));
                cout << "Push one var as arg - " << node->right->bval << endl;
            } 
        }
        if(node->left != NULL && node->left->type != "ARGUMENTS") {
            if(node->left->rtype == 0) {
                args.push_back(newVar(0, node->left->ival, 0));
                cout << "Push one var as arg - " << node->left->ival << endl;
            }else if(node->left->rtype == 1) {
                args.push_back(newVar(1, 0, node->left->bval));
                cout << "Push one var as arg - " << node->left->bval << endl;
            } 
        }
        
    } 
    //  ----------------------- STMTS -----------------------
    else if(node->type == "STMTS") {
        traverseAST(node->left);
        traverseAST(node->right);
    }
    

}

// ---------------- Support function ----------------------

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

void bindArgs2Pars(string funName) {
    it3 = par_Map[funName].begin();
    for(int i = args.size() - 1 ; i >= 0 ; i--, it3++) {
        it3->second = args[i];
        cout << "[ Bind ]" << it3->first << endl;
    }
}

// ----------------For Debugging----------------------

void printNodeInfo(Node *node) {
    if(node->type == "bool_val") {
        cout << "Type: bool |" << node->bval << endl;
    } else if (node->type == "number") {
        cout << "Type: number | " << node->ival << endl;
    } else {
        cout << "Type: " << node->type << endl;
    }
}

void printAllVariable(){
    if (!var_Map.empty()) {
        cout << "[ Variables ]" << endl;
        string rtype;
        for(it = var_Map.begin() ; it != var_Map.end() ; ++it) {
            rtype = (it->second.rtype == 0)? "ival" : "bval";
            cout << it->first << " = " << rtype << ", " << it->second.ival << ", " << it->second.bval << endl;
        }
    }
}

void printAllFunPars(){
    if (!par_Map.empty()) {
        cout << "[ Parameters ]" << endl;
        for(it2 = par_Map.begin() ; it2 != par_Map.end() ; ++it2) {
            cout << "Fun - " << it2->first << endl;
            for(it3 = it2->second.begin() ; it3 != it2->second.end() ; ++it3) {
                cout << it3->first << " = " << it3->second->ival << ", " ;
            }
            cout << endl << "----------" << endl;
        }
    }
}

void printAllFunArgs(){
    if (!args.empty()) {
        cout << "[ Arguments ]" << endl;
        for(int i = 0 ; i < args.size() ; i++) {
            if (args[i]->rtype == 0) {
                cout << args[i]->ival << " ";
            } else {
                cout << args[i]->bval << " ";
            }
        }
        cout << endl;
    }
}

int main(int argc, char *argv[]) {
    yyparse();
    
    // debugging
    cout << "========================" << endl;
    printAllVariable();
    cout << "========================" << endl;
    printAllFunPars();
    cout << "========================" << endl;
    printAllFunArgs();

    return(0);
}
