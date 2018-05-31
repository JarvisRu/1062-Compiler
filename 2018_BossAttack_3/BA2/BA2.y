
%{
    #include "main.h"
    using namespace std;

    // declare global variable
    bool error = false;
    stack<int> s;
    int tmp1;
%}

%union {
    int ival;
    char *op;
}
%token<ival> NUMBER
%token<op> LOAD
%token<op> PLUS
%token<op> SUB
%token<op> MUL
%token<op> MOD
%token<op> INC
%token<op> DEC
%type <ival> expr
%type <ival> exp

%%
final   :   expr                    { printResult();}              
expr    :   expr exp                    
        |   exp                             
        ;
exp     :   LOAD NUMBER             { s.push($2); }
        |   PLUS                    { if(check(2)){ tmp1 = s.top(); s.pop(); s.top() = tmp1 + s.top();  } }
        |   SUB                     { if(check(2)){ tmp1 = s.top(); s.pop(); s.top() = tmp1 - s.top();  } }
        |   MUL                     { if(check(2)){ tmp1 = s.top(); s.pop(); s.top() = tmp1 * s.top();  } }
        |   MOD                     { if(check(2)){ tmp1 = s.top(); s.pop(); s.top() = tmp1 % s.top();  } }
        |   INC                     { if(check(1)){ s.top() += 1;  } }
        |   DEC                     { if(check(1)){ s.top() -= 1;  } }
        ;

%%

void yyerror (const char *message) {
    cout << "Invalid format";
}

// ----------------- Support Function ---------------------

bool check(int number) {
    if(s.size() < number) {
        error = true;
        return false;
    }
    return true;
}

void printResult() {
    if(error)
        cout << "Invalid format";
    else if(s.size() > 1)
        cout << "Invalid format";
    else
        cout << s.top();
}
// -------------------------------------------

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
