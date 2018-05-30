%code requires {
    #include<iostream>  
    #include<string>    
    #include<stdio.h>
    using namespace std;

    extern "C"
    {   
        int yylex(void);
        void yyerror(const char *s);  
    }  

    int calculate(int, int, char);
    void printResult(int);
}
%{

%}


%union {
    int ival;
    char op;
}
%token<ival> NUMBER
%token<op> PLUS
%token<op> SUB
%token<op> MUL
%token<op> DIV
%token<op> NEG
%type <ival> num
%type <ival> expr
%type <ival> exp

%%
final   :   expr                            { printResult($1);}              
expr    :   expr PLUS exp                   { $$ = calculate($1, $3, $2); }  
        |   expr SUB exp                    { $$ = calculate($1, $3, $2); }  
        |   exp                             {  }
        ;
exp     :   exp MUL num                     { $$ = calculate($1, $3, $2); }
        |   exp DIV num                     { $$ = calculate($1, $3, $2); }
        |   num                             { }
        ;
num     :   '(' expr ')'                     { $$ = $2;  }
        |   SUB num                          { $$ = -1 * $2;  }
        |   NUMBER                           { $$ = $1; }
        ;
%%

void yyerror (const char *message) {
    cout << "Invalid format" << endl;
}

int calculate(int left, int right, char op){
    int res;
    switch(op){
        case '+':
                res = left + right;
                break;
        case '-':
                res = left - right;
                break;
        case '*':
                res = left * right;
                break;
        case '/':
                res = left / right;
                break;
    }
    return res;
}


void printResult(int res) {
    cout << "Accepted : " << res << endl;
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
