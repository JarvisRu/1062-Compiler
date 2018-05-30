%{
char str[10] = "# ";
unsigned int b = 0;
%}
decimal [0-9]+
fraction [1-9][0-9]*\/[1-9][0-9]*
mixed {decimal}[ ]{fraction}
unit (cups?|tablespoons?|teaspoons?)
token ({decimal}|{fraction}|{mixed})[ ]{unit}
dir Directions
%%
{token} {
		  if ( b != 0 ) {
			printf ("%s", str);
		  }
		  printf("%s\n", yytext); 
		}
{dir}   { b++; }
.|\n	{}
%%
int main(int argc, char* argv[]) {
        yylex();
        return 0;
}