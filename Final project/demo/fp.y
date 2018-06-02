
%{
    #include <vector>
    #include <string>
    #include <map>
    #include "main.h"
    using namespace std;

    vector<int> num_action;         // store for EXPS : Plus Mul Equal
    vector<bool> bool_action;       // store for EXPS : And Or Not

    map<string,Var> varTable;                        // store variables for normal
    map<string,Var>::iterator it;  

    string funMode = "none";
    map<string, map<string, Var_ptr> > parTable;         // store parameters for function < FUN-NAME , variables name >
    vector<Var_ptr> args;                                // store args for function
    map<string, Node_ptr> funTable;                      // register named-function, store FUN_EXP node ptr 
    map<string, map<string, Var_ptr> >::iterator it2;  
    map<string, Var_ptr>::iterator it3;  
    map<string, Node_ptr>::iterator it4;  

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
%type <node> DEF_STMT PRINT_STMT
%type <node> VARIABLE 
%type <node> NUM_OP LOGICAL_OP
%type <node> IF_EXP TEST_EXP THAN_ELSE_EXP
%type <node> FUN_EXP FUN_CALL 
%type <node> FUN_IDs FUN_BODY 
%type <node> PARAMETERS ARGUMENTS


%%
PROGRAM         :   STMTS                       { traverseAST($1); }
                ;

STMTS           :   STMT STMTS                  { $$ = newNode($1, $2, "STMTS"); }
                |   STMT                        { $$ = $1; }
                ;
STMT            :   EXP                         { $$ = $1; }
                |   DEF_STMT                    { $$ = $1; }
                |   PRINT_STMT                  { $$ = $1; }
                ;

DEF_STMT        :   '(' DEFINE VARIABLE EXP ')' { $$ = newNode($3, $4, "DEFINE");  }
                ;
PRINT_STMT      :   '(' PRINT_NUM EXP ')'       { $$ = newNode($3, NULL, "PRINT_NUM"); }
                |   '(' PRINT_BOOL EXP ')'      { $$ = newNode($3, NULL, "PRINT_BOOL");}
                ;

EXPS            :   EXP EXPS                    { $$ = newNode($1, $2, "EXPS"); }
                |   EXP                         {  }
                ;
EXP             :   bool_val                    { $$ = newNode(NULL, NULL, "bool_val", 1, 0, " ", $1); }
                |   number                      { $$ = newNode(NULL, NULL, "number", 0, $1); }
                |   VARIABLE                    { $$ = $1; }
                |   NUM_OP                      { $$ = $1; }
                |   LOGICAL_OP                  { $$ = $1; }
                |   IF_EXP                      { $$ = $1; }
                |   FUN_EXP                     { $$ = $1; }
                |   FUN_CALL                    {}
                ;

NUM_OP          :   '(' Plus EXP EXPS ')'       { $$ = newNode($3, $4, "Plus", 0); }
                |   '(' Minus EXP EXP ')'       { $$ = newNode($3, $4, "Minus", 0); }
                |   '(' Mul EXP EXPS ')'        { $$ = newNode($3, $4, "Mul", 0);}
                |   '(' Div EXP EXP ')'         { $$ = newNode($3, $4, "Div", 0); }
                |   '(' Mod EXP EXP ')'         { $$ = newNode($3, $4, "Mod", 0); }
                |   '(' Greater EXP EXP ')'     { $$ = newNode($3, $4, "Greater", 1); }
                |   '(' Smaller EXP EXP ')'     { $$ = newNode($3, $4, "Smaller", 1); }
                |   '(' Equal EXP EXPS ')'      { $$ = newNode($3, $4, "Equal", 1); }
                ;
LOGICAL_OP      :   '(' And EXP EXPS ')'        { $$ = newNode($3, $4, "And", 1); }
                |   '(' Or EXP EXPS ')'         { $$ = newNode($3, $4, "Or", 1); }
                |   '(' Not EXP ')'             { $$ = newNode($3, NULL, "Not", 1); }
                ;

IF_EXP          :   '(' IF TEST_EXP THAN_ELSE_EXP ')'   { $$ = newNode($3, $4, "IF", 0);}
                ;
TEST_EXP        :   EXP                                 { $$ = $1; }
                ;
THAN_ELSE_EXP   :   EXP EXP                             { $$ = newNode($1, $2, "THAN_ELSE_EXP"); }
                ;

FUN_EXP         :   '(' FUN FUN_IDs FUN_BODY ')'        { $$ = newNode($3, $4, "FUN", 3); }
                ;
FUN_IDs         :   '(' PARAMETERS ')'                  { $$ = $2; }
                ;
FUN_BODY        :   EXP                                 { $$ = $1; }
                ;
FUN_CALL        :   '(' FUN_EXP ARGUMENTS ')'           { $$ = newNode($2, $3, "FUN_CALL", 3); }
                |   '(' VARIABLE ARGUMENTS ')'          { $$ = newNode($2, $3, "NAMED-FUN_CALL", 3);}
                ;

ARGUMENTS       :   EXP ARGUMENTS               { $$ = newNode($1, $2, "ARGUMENTS", 4);}
                |   EXP                         { $$ = newNode($1, NULL, "ARGUMENTS", 4); }
                |                               { $$ = newNode(NULL, NULL, "ARGUMENTS", 4); }
                ;
PARAMETERS      :   VARIABLE PARAMETERS         { $$ = newNode($1, $2, "PARAMETERS", 4);}
                |   VARIABLE                    { $$ = newNode($1, NULL, "PARAMETERS", 4); }
                |                               { $$ = newNode(NULL, NULL, "PARAMETERS", 4); }
                ;
VARIABLE        :   id                          { $$ = newNode(NULL, NULL, "id", 2, 0, $1);  }
                ;
%%

void yyerror (const char *message) {
    cout << message;
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
    if(node->type == "number") {} 
    else if(node->type == "bool_val") {} 
    else if(node->type == "id") {
        if(funMode == "none") {
            it = varTable.find(node->name); 
            if(it != varTable.end()){
                node->rtype = it->second.rtype;
                node->ival = it->second.ival;
                node->bval = it->second.bval;
            }
        } else {
            if(funMode != "noNameFun")                  // if is no-named func, traverse FUN first
                traverseAST(funTable[node->name]);
            it3 = parTable[funMode].find(node->name);
            if(it3 != parTable[funMode].end()){
                node->rtype = it3->second->rtype;
                node->ival = it3->second->ival;
                node->bval = it3->second->bval;
            }
        }
    } 
    // ----------------------- ( Operator EXP EXPS ) -----------------------
    else if(node->type == "Plus") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = (node->right->type == "EXPS") ? node->left->ival + num_op_action(node->type) : node->left->ival + node->right->ival;
        num_action.clear();
    } 
    else if(node->type == "Mul") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = (node->right->type == "EXPS") ? node->left->ival * num_op_action(node->type) : node->left->ival * node->right->ival;
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
        num_action.clear();
    } 
    else if(node->type == "And") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->bval = (node->right->type == "EXPS") ? node->left->bval && bool_op_action(node->type) : node->left->bval && node->right->bval;
        bool_action.clear();
    } 
    else if(node->type == "Or") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->bval = (node->right->type == "EXPS") ? node->left->bval || bool_op_action(node->type) : node->left->bval || node->right->bval;
        bool_action.clear();
    } 
    //  ----------------------- ( Operator EXP EXP ) -----------------------
    else if(node->type == "Minus") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = node->left->ival - node->right->ival;
    } 
    else if(node->type == "Div") {
        traverseAST(node->left);
        traverseAST(node->right);
        node->ival = node->left->ival / node->right->ival;
    } 
    else if(node->type == "Mod") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->ival = node->left->ival % node->right->ival;
    }
    else if(node->type == "Greater") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->bval = (node->left->ival > node->right->ival)? 1 : 0;
    }
    else if(node->type == "Smaller") {
        traverseAST(node->left);
        traverseAST(node->right); 
        node->bval = (node->left->ival < node->right->ival)? 1 : 0;
    }
    // ----------------------- PRINT -----------------------
    else if(node->type == "PRINT_NUM") {
        traverseAST(node->left);
        int res;
        if(node->left->type == "id") 
            res = varTable[node->left->name].ival;
        else 
            res = node->left->ival;
        cout << res << endl;
    }
    else if(node->type == "PRINT_BOOL") {
        traverseAST(node->left);
        string res;
        if(node->left->type == "id") 
            res = (varTable[node->left->name].bval)? "#t" : "#f";
        else 
            res = (node->left->bval)? "#t" : "#f";
        cout << res << endl;
    }
    //  ----------------------- EXPS -----------------------
    else if(node->type == "EXPS") {
        traverseAST(node->left);
        traverseAST(node->right);
        // for LOGIC
        if (node->left->rtype == 1 && node->right->rtype == 1) {
            bool_action.push_back(node->left->bval);
            if(node->right->type != "EXPS")
                bool_action.push_back(node->right->bval);
        }
        // for NUM
        else {
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
    }
    //  ----------------------- DEFINE -----------------------
    else if(node->type == "DEFINE") {
        traverseAST(node->left);
        // define a variable : store ival or bval 
        if(node->right->rtype == 0 || node->right->rtype == 1) {
            traverseAST(node->right);
            node->name = node->left->name;
            node->rtype = node->right->rtype;
            if(allow2Define(node->name, 1)){
                varTable[node->name].rtype = node->right->rtype;  
                varTable[node->name].ival = (node->right->rtype == 0)? node->right->ival : 0;  
                varTable[node->name].bval = (node->right->rtype == 1)? node->right->bval : 0;  
            } else {
            }
        }
        // define a function name : store function ptr in funTable 
        else if(node->right->rtype == 3){
            
            node->name = node->left->name;
            node->rtype = node->right->rtype;
            if(allow2Define(node->name, 2)){
                funTable[node->name] = node->right;  
            } else {
                cout << "You can't redefining exist function name !!" << endl;
            }
        }
    }
    //  ----------------------- IF_EXP -----------------------
    else if(node->type == "IF") {
        traverseAST(node->left);

        // if TEST_EXP = TRUE -> do THAN-EXP(left child of THAN_ELSE_EXP node)
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
        // if TEST_EXP = FALSE -> do ELSE-EXP(right child of THAN_ELSE_EXP node)
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
    }
    //  ----------------------- FUN -----------------------
    else if(node->type == "FUN") { 
        traverseAST(node->left);                // traverse parameters first, create parTable for <funMode>
        bindArgs2Pars(funMode);                 // node(id) will find value in parameter
        traverseAST(node->right);               // traverse FUN_EXP with arguments 
        node->rtype = node->right->rtype;
        node->ival = node->right->ival;
        node->bval = node->right->bval;
    }
    else if(node->type == "FUN_CALL") { 
        traverseAST(node->right);               // trace arguments first
        funMode = "noNameFun";
        traverseAST(node->left);                // then trace FUN
        node->rtype = node->left->rtype;
        node->ival = node->left->ival;
        node->bval = node->left->bval;

        // reset
        parTable["noNameFun"].clear();
        args.clear();
        funMode = "none"; 
    }
    else if(node->type == "NAMED-FUN_CALL") { 
        traverseAST(node->right);               // trace arguments first
        funMode = node->left->name;
        traverseAST(node->left);                // then trace variable(FUN-NAME) -> trace FUN
        // get fun result
        node->rtype = funTable[funMode]->rtype;
        node->ival  = funTable[funMode]->ival;
        node->bval  = funTable[funMode]->bval;

        // reset
        parTable[node->left->name].clear();
        args.clear();
        funMode = "none"; 
    }
    else if(node->type == "PARAMETERS") {
        traverseAST(node->left);
        traverseAST(node->right);
        if(node->right != NULL && node->right->type != "PARAMETERS")
            parTable[funMode][node->right->name] = newVar(0, 0, 0);
        if(node->left != NULL && node->left->type != "PARAMETERS")
            parTable[funMode][node->left->name] = newVar(0, 0, 0);
    } 
    else if(node->type == "ARGUMENTS") {
        traverseAST(node->left);
        traverseAST(node->right);
        if(node->right != NULL && node->right->type != "ARGUMENTS") {
            if(node->right->rtype == 0) {
                args.push_back(newVar(0, node->right->ival, 0));
            }else if(node->right->rtype == 1) {
                args.push_back(newVar(1, 0, node->right->bval));
            } 
        }
        if(node->left != NULL && node->left->type != "ARGUMENTS") {
            if(node->left->rtype == 0) {
                args.push_back(newVar(0, node->left->ival, 0));
            }else if(node->left->rtype == 1) {
                args.push_back(newVar(1, 0, node->left->bval));
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
    return res;
}

bool allow2Define(string name, int mode) {
    if(mode == 1) {
        it = varTable.find(name);
        if(it == varTable.end())
            return true;
    } else {
        it4 = funTable.find(name);
        if(it4 == funTable.end())
            return true;
    }
    return false;
}

void bindArgs2Pars(string funName) {
    it3 = parTable[funName].begin();
    for(int i = args.size() - 1 ; i >= 0 ; i--, it3++) {
        it3->second = args[i];
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
    if (!varTable.empty()) {
        cout << "[ Variables ]" << endl;
        string rtype;
        for(it = varTable.begin() ; it != varTable.end() ; ++it) {
            rtype = (it->second.rtype == 0)? "ival" : "bval";
            cout << it->first << " = " << rtype << ", " << it->second.ival << ", " << it->second.bval << endl;
        }
    }
}

void printAllFunPars(){
    if (!parTable.empty()) {
        cout << "[ Parameters ]" << endl;
        for(it2 = parTable.begin() ; it2 != parTable.end() ; ++it2) {
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
    // cout << endl << "========================" << endl;
    // printAllVariable();
    // cout << "========================" << endl;
    // printAllFunPars();
    // cout << "========================" << endl;
    // printAllFunArgs();

    return(0);
}
