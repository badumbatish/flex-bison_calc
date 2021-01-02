/* my own calculator */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <cmath>
    #include <unistd.h>
    #include <cstring>
    #include <iostream>
    #include "fact.h"
    extern FILE* yyin;

    typedef struct yy_buffer_state * YY_BUFFER_STATE;
    extern int yyparse();
    int yylex();

    extern YY_BUFFER_STATE yy_scan_string(const char* str);
    extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

    void yyerror(const char* s);
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


%type<num> program_input
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
program_input: %empty {}
    | program_input pline
;
pline: EOL
    | expr EOL { printf("%.2f\n",$1);}
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
    | SQRT OP expr CP { $$ = sqrt($3); }
    | CBRT OP expr CP { $$ = cbrt($3); }
    | NTHROOT OP expr COLON expr CP { $$ = pow($5,1/$3); }
    | POW OP expr COLON expr CP { $$ = pow($3,$5); } 
    | LOG OP expr COLON expr CP { if($3==1) { yyerror("The base of the logarithms must not be 1 and must be larger than 0");} else $$ = log10($5)/log10($3); }
    | SIN OP expr CP  { $$ = sin($3); }
    | COS OP expr CP  { $$ = cos($3); }
    | TAN OP expr CP  { $$ = tan($3); }
    | expr FACT       { $$ = factorial($2);}
;

constants: PI { $$ = 3.14; }
    | E { $$ = 2,71828;}
;
%%
int main(int argc, char *argv[]) {
    yyparse();
    return 0;
}
void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

