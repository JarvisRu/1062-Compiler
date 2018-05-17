%option noyywrap
%{
%}
word    ^[A-Z][a-zA-Z]*$
ip1     0|[1-9]|[1-9][0-9]
ip2     1[0-9][0-9]
ip3     2[0-4][0-9]
ip4     25[0-5]
ip      {ip1}|{ip2}|{ip3}|{ip4}
full_ip ^{ip}\.{ip}\.{ip}\.{ip}$
email   ^[a-zA-Z0-9]+@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+$
eol     \n
%%
{word}      { printf("%s is a word\n", yytext); }
{full_ip}   { printf("%s is an IP address\n", yytext); }
{email}     { printf("%s is an email address\n", yytext); }
{eol}       { }
.           { }
%%
int main(int argc, char *argv[]){
    yylex();
    return(0);
}