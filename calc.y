/* my own calculator */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <cmath>
    #include <unistd.h>
    #include <cstring>
    #include "fact.h"
    extern FILE* yyin;

    extern int yyparse();
    extern int yylex();
    void yyerror(const char* s);

    typedef struct yy_buffer_state * YY_BUFFER_STATE;
    extern YY_BUFFER_STATE yy_scan_string(const char* str);
    extern void yy_delete_buffer(YY_BUFFER_STATE buffer);


    int calc(char * const str);
%}

%define parse.error verbose // To make bison report errors more clearly

%union {  
    double num;
}
%token<num> NUMBER
%token<num> COLON
// BINARY OPERATORS
%token<num> MUL DIV ADD SUB EQUALS

// UNARY OPERATORS
%token<num> ABS OP CP SQRT CBRT LOG POW SIN COS TAN FACT NTHROOT
%token<num> EOL

// CONSTANTS
%token<num> PI E


%type<num> pline
%type<num> expr
%type<num> functions 
%type<num> constants
// SETTING OPERATORS PRECEDENCE USING BODMAS RULES

// Brackets (parts of a calculation inside brackets always come first).
// Orders (numbers involving powers or square roots).
// Division.
// Multiplication.
// Addition.
// Subtraction.

// THE FIRST ONE TO BE SET GETS THE LOWEST PRECEDENCE 

%left SUB;
%left ADD;
%left MUL;
%left DIV;
%left SQRT CBRT LOG POW SIN COS TAN FACT NTHROOT;
%left OP CP;

%%
pline: expr { printf("%.2f\n",$1); YYACCEPT; }
;


expr:   SUB expr  {$$=-$2;};
    | ADD expr {$$=$2;}
    | NUMBER    { $$= $1; };
    | expr ADD expr { $$ = $1+$3; }
    | expr SUB expr { $$ = $1-$3; }
    | expr DIV expr { if ($3 == 0) { yyerror("Cannot divide by zero");}  else $$ = $1/$3; }
    | expr MUL expr { $$ = $1 * $3; }
    | OP expr CP { $$ = $2; }
    | functions
    | constants
;
 
functions : ABS expr ABS { if ($2 >=0) $$=$2; else $$=-$2;}
    | SQRT expr { $$ = sqrt($2); }
    | CBRT expr { $$ = cbrt($2); }
    | NTHROOT OP expr COLON expr CP { $$ = pow($5,1/$3); }
    | POW OP expr COLON expr CP { $$ = pow($3,$5); } 
    | LOG OP expr COLON expr CP { if($3==1) { yyerror("The base of the logarithms must not be 1 and must be larger than 0");} else $$ = log10($5)/log10($3); }
    | SIN expr  { $$ = sin($2); }
    | COS expr  { $$ = cos($2); }
    | TAN expr  { $$ = tan($2); }
    | expr FACT { $$ = factorial($2);}
;

constants: PI { $$ = 3.14; }
    | E { $$ = 2.71828;}
;
%%

int main(int argc, char *argv[]) {
    if(argc>1) {
        for(size_t i=1;i<argc;i++) {
            calc(argv[i]);
        }
        return 0;
    }
    else yyparse();
    return 0;
}

int calc(char str[]) {
    YY_BUFFER_STATE buffer = yy_scan_string(str);
    yyparse();
    yy_delete_buffer(buffer);
    return 0;
}



void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}



