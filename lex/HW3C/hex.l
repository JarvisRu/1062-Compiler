%option noyywrap
%{
#include <string.h>
char hex[10];
char *find;
%}
hex1    ^0(x|X)[0-9A-Fa-f]{1,8}$
hex2    ^[ \t\r]*0(x|X)[0-9A-Fa-f]{1,8}$
eol     \n  
%%
{hex1}   { printf("%s\n",yytext); }
{hex2}   { find = strchr(yytext, '0'); strncpy(hex, find, 10); printf("%s\n", hex); }
{eol}   { }
.       { }
%%
int main(int argc, char *argv[]){
    yylex();
    return(0);
}