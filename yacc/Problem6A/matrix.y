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
    Matrix* calculate(Matrix*, Matrix*, Operator);
    void printM(Matrix*);
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
%type <mat> M
%type <mat> expr

%%
final   :   expr                            { printResult();}              
expr    :   expr PLUS M                      { $$ = calculate($1, $3, $2); cout << "Plus Occurs "; printM($$);}  
        |   expr SUB M                       { $$ = calculate($1, $3, $2); cout << "Plus Occurs "; printM($$);}  
        |   M                                { cout << "M to expr "; printM($1); }
        ;
M       :   '[' NUMBER ',' NUMBER ']'      { $$ = newMatrix($2,$4); printM($$); }
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

    }
    return m;
}

Matrix* newMatrix(int lval, int rval){
    Matrix* m = (Matrix *)malloc(sizeof(Matrix));
    m->left_value = lval;
    m->right_value = rval;
    return m;
}

void printM(Matrix *m) {
    cout << "[" << m->left_value << "," << m->right_value << "]" << endl;
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
