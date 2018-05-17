%option noyywrap
%{
    int times = 0;
    char ans[500][20];
%}
%s one
ip1     0|[1-9]|[1-9][0-9]
ip2     1[0-9][0-9]
ip3     2[0-4][0-9]
ip4     25[0-5]
ip      {ip1}|{ip2}|{ip3}|{ip4}
full_ip {ip}\.{ip}\.{ip}\.{ip}
eol     \n
%%
{full_ip} { sscanf(yytext, "%s\n", ans[times]); times++;}
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