%option noyywrap
%{
unsigned int charCount=0, wordCount=0, lineCount=0;
%}
word    [^ \t\n]+
eol     \n
%%
{word}  { wordCount++; charCount+=yyleng; }
{eol}   { charCount++; lineCount++; }
.       charCount++;
%%
int main(int argc, char *argv[]){
    yylex();
    printf("%u %u %u\n",lineCount, wordCount, charCount);
    return(0);
}