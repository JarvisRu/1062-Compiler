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

    typedef struct{
        int left_value;
        int right_value;
    } Matrix; 

    typedef struct{
        char *type;
        int pos;
    } Operator;

    Matrix* newMatrix(int, int);
    Matrix* transpose(Matrix*);
    Matrix* calculate(Matrix*, Matrix*, Operator);
    void printResult();
}
%{
    bool error = false;
    int error_pos = 0;
%}


%union {
    int ival;
    Matrix *mat;
    Operator op;
}
%token<ival> NUMBER
%token<op> PLUS
%token<op> SUB
%token<op> MUL
%token<op> TRANS
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
        |   mat TRANS                       { $$ = transpose($1);  }
        |   '[' NUMBER ',' NUMBER ']'       { $$ = newMatrix($2,$4); }
        ;
%%

void yyerror (const char *message) {
    cout << "Invalid format";
}

Matrix* calculate(Matrix *lMatrix, Matrix *rMatrix, Operator op){
    Matrix* m = (Matrix *)malloc(sizeof(Matrix));
    if(op.type[0] == '+' || op.type[0] == '-') {
        if(lMatrix->left_value == rMatrix->left_value && lMatrix->right_value == rMatrix->right_value) {
            m->left_value = lMatrix->left_value;
            m->right_value = lMatrix->right_value;
        } else {
            if (!error) {
                error = true;
                error_pos = op.pos;
            }
        }
    } else {
        if(lMatrix->right_value == rMatrix->left_value) {
            m->left_value = lMatrix->left_value;
            m->right_value = lMatrix->left_value;
        } else {
            if (!error) {
                error = true;
                error_pos = op.pos;
            }
        }
    }
    return m;
}

Matrix* newMatrix(int lval, int rval){
    Matrix* m = (Matrix *)malloc(sizeof(Matrix));
    m->left_value = lval;
    m->right_value = rval;
    return m;
}

Matrix* transpose(Matrix *m){
    int tmp = m->left_value;
    m->left_value = m->right_value;
    m->right_value = tmp;
    return m;
}

void printResult() {
    if(error)
        cout << "Semantic error on col " << error_pos;
    else
        cout << "Accepted";
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}
