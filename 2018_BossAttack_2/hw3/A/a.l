%option noyywrap
%{
    // c code
    int times = 0;
    char ans[500][100];
%}
v       cpy
vv      [a-zA-Z_$][a-zA-Z0-9_$]*{v}[a-zA-Z0-9_$]*
vv2     {v}[a-zA-Z0-9_$]*
eol     \n
%%
{vv}        { sscanf(yytext, "%s", ans[times]); times++; }
{vv2}       { sscanf(yytext, "%s", ans[times]); times++; }
{eol}       { }
.           { }
%%
int main(int argc, char *argv[]){
    yylex();
    for(int i = 0 ; i < times ; i++) {
        printf("%s\n", ans[i]);
    }
    return(0);
}