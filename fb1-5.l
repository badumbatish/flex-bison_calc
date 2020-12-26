%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "fb1-5.tab.h"
%}
%option c++
%%
"+"+    { return ADD; }
"--"+  { return ADD; }
"-"    { return SUB; }

"*"    { return MUL; }
"/"    { return DIV; }
"("    { return OP; }
")"    { return CP; }
","    { return COLON;}
"="    { return EQUALS;}
[0-9]+(\.[0-9]+)? { yylval.num = atof(yytext); return NUMBER; }
\n     { return EOL; }
[\t]  { /* ignore whitespace */ }

("pi")|("PI") { return PI;}
"e"  { return E;}

("pow")|("POW") { return POW; }
("sqrt")|("SQRT") { return SQRT; }
"|"    { return ABS; }
("log")|("LOG") { return LOG; }
.      { printf("Mystery character %c\n", *yytext); }

%%