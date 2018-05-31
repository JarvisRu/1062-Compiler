all:
	bison -d fp.y
	flex fp.l
	g++ lex.yy.c fp.tab.c

test: all
	./a.out < input.txt
	make clean

clean:
	rm lex.yy.c fp.tab.c fp.tab.h 