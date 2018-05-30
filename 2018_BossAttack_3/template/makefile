all:
	bison -d template.y
	flex template.l
	g++ lex.yy.c template.tab.c

test: all
	./a.out < input.txt
	make clean

clean:
	rm lex.yy.c template.tab.c template.tab.h 