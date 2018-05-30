all:
	bison -d BA1.y
	flex BA1.l
	g++ lex.yy.c BA1.tab.c

test: all
	./a.out < input.txt
	make clean

clean:
	rm lex.yy.c BA1.tab.c BA1.tab.h 