all:
	bison -d cal.y
	flex cal.l
	g++ lex.yy.c cal.tab.c

test: all
	./a.out < input.txt
	make clean

clean:
	rm lex.yy.c cal.tab.c cal.tab.h 