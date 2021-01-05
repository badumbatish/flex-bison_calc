# flex-bison_calc
Smoll Calculator Alert!!

Calc is a small string-parsing calculator library that I write using flex and bison. It can either act as a executable or a library function depending on your needs. Output is through stdout but you can tweak the code to make it return the calculated value.
## Usage
### As a executable
``` 
// Only accept string, no text file parameter right now
./calc "1+2" // With 1 argument
./calc "1+2" "2+3" // With multiple arguments
```
#### Output
```
3.00
5.00
```
### As a function
```
// Simply extern the function int calc(char str[])
extern int calc(char str[]);

int main(int argc, char *argv[]) {
    calc("1+2");
    return 0;
}
```
#### Output
```
3.00
```
## Compile
### As an executable
```
bison -v -d calc.y
flex  calc.l
g++ -o $@.o calc.tab.c lex.yy.c -ll -lfl
```
### As a library
```
bison -v -d calc.y
flex  calc.l
g++ -shared -fpic -o $@.so calc.tab.c lex.yy.c -ll -lfl
```

### Use it with your program
<em>Suppose library is in /home/foo <em>
```
g++ main.cpp -L/home/foo -lcalc -Wl,-rpath=/home/foo
```

