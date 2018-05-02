%option noyywrap
%{
    // #include<string.h>
    // strcat(destination, source)
    // strcpy(destination, source)
    // strncpy(destination, source, size)
    // strcmp(str1, str2) == 0 if equal
    // strchr(source, finding str) == (ptr to source + somewhere)
    // strlen(source) = string length

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