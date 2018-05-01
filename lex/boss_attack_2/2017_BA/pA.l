%{
unsigned int space = 0;
unsigned int b = 0;
unsigned int line = 0;
char result[1000][3000];
char s = ' ';
%}
tagID [A-Za-z_]+
lefttag <
righttab >
token {lefttag}{tagID}{righttab}
error ([ \t]+[^< \t\n(\r\n)]|^[ \t]*[^< \t]|<{tagID}*[^A-Za-z_]{tagID}*>)
%%
{error} { 
			b++;
		}
{token} { 
			sscanf(yytext, "%s", result[line]);
			line++;
		}
.|\n	{}
%%
int main(int argc, char* argv[]) {
		yylex();
		if (b > 0) {
			printf("%s", "please don't eat me");
		}
		else {
			printf("%s\n", result[0]); 
			for (int k = 1; k < line; k++) {
				for (int i = 0; i < 20; i++) {
					if (result[k][i] != result[k-1][i]) {
						space += 2;
						break;
					}
				}
				for (int i = 0; i < space; i++) {
					printf("%c", s);
				}
				printf("%s", result[k]);
				if ( k < line - 1) {
					printf("\n");
				}
			}
		}
        return 0;
}



