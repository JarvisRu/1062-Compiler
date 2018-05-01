%option noyywrap
%{
    int times = 0;
    char ans[100][1000];  // set string max_num = 100, string max_buffer = 1000
%}
%s one
hex     ^0(x|X)[0-9A-Fa-f]{1,8}$
hex1    0(x|X)[0-9A-Fa-f]{1,8}$
space   ^[ \t\r]*
eol     \n
%%
{hex}       { sscanf(yytext, "%s", ans[times]); times++;}
{space}     { BEGIN one; }
<one>{hex1} { sscanf(yytext, "%s", ans[times]); times++; BEGIN INITIAL;}
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