all:
	bison -d BA2.y
	flex BA2.l
	g++ lex.yy.c BA2.tab.c

test: all
	./a.out < input.txt
	make clean

clean:
	rm lex.yy.c BA2.tab.c BA2.tab.h 