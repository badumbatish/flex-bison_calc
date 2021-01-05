all: main
main: libcalc
	g++ main.cpp -L/home/jack2510/Documents/code/project/flex_bison -lcalc -Wl,-rpath=/home/jack2510/Documents/code/project/flex_bison
run: main
	./a.out
calc: calc.y calc.l
		bison -v -d calc.y
		flex  calc.l
		g++ -o $@.o calc.tab.c lex.yy.c -ll -lfl
libcalc: calc.y calc.l
		bison -v -d calc.y
		flex  calc.l
		g++ -shared -fpic -o $@.so calc.tab.c lex.yy.c -ll -lfl

install: 
	sudo cp libcalc.so /usr/local/bin