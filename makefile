snazzle: 
	bison -d snazzle.y
	g++ -c snazzle.tab.c -o snazzle.o
	flex snazzle.l
	g++ -c lex.yy.c -o lex.yy.o
	g++ lex.yy.o snazzle.o  -o snazzle