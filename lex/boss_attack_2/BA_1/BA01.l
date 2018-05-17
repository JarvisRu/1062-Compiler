%option noyywrap
%{
%}
nor          [\+\-]?[1-9]
nor2         [\+\-]?[1-9]\.[0-9]*
exp          [\+\-]?[0-9]+
scientific   ^{nor}E{exp}$
scientific2  ^{nor2}E{exp}$
space        ^[ \t]
eol          \n
%%
{scientific}     { printf("%s\n", yytext);}
{scientific2}    { printf("%s\n", yytext);}
{eol}            { }
.                { }
%%
int main(int argc, char *argv[]){
    yylex();
    return(0);
}