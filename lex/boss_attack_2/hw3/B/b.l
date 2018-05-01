%option noyywrap
%{
    // c code
    int times = 0;
    char col1[500][100];
    char col2[500][100];
    char col3[500][100];
    char col4[500][100];
%}
%s one
col     [a-zA-Z0-9]+
space   [ \t\r]+
row     {col}{space}{col}{space}noodles{space}{col}
eol     \n
%%
{row}   { sscanf(yytext, "%s %s %s %s", col1[times], col2[times], col3[times], col4[times]); times++;}
{eol}   { }
.       { }
%%
int main(int argc, char *argv[]){
    yylex();
    for(int i = 0 ; i < times ; i++) {
        printf("%s %s %s %s\n", col1[i], col2[i], col3[i], col4[i]);
    }
    return(0);
}