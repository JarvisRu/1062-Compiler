%option noyywrap
%{
    // c code
    // int times = 0;
    // char ans[500][30];
%}
%s one
space   ^[ \t\r]
eol     \n
%%
{}      { sscanf(yytext, "%s", ans[times]); times++;}
{eol}   { }
.       { }
%%
int main(int argc, char *argv[]){
    yylex();
    for(int i = 0 ; i < times ; i++) {
        printf("%s\n", ans[i]);
    }
    return(0);
}