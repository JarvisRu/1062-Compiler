%option noyywrap
%{
    #include<string.h>
    int times = 0;
    char ans[100][1000]; 

    char* cutFrontSpace(char* target){
        while(target[0] == ' ' || target[0] == '\t') {
            target = target+1;
        }
        return target;
    }
%}
hex     ^[ \t]*0(x|X)[0-9A-Fa-f]{1,8}$
eol     \n
%%
{hex}   { sscanf(cutFrontSpace(yytext), "%s", ans[times]); times++;}
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