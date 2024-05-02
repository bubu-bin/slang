%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
    
    void yyerror(const char *s);
%}

alpha [a-zA-Z]
digit [0-9]

%%

";"                       { return SEMICOLON; }
{alpha}({alpha}|{digit})* {  yylval.identifier = strdup(yytext); return IDENTIFIER; }
\/\/.*                    { ; }
\/\*(.*\n)*.*\*\/         { ; } 
[ \t]*                    { ; }
.                         { ECHO; yyerror("unexpected character"); }

%%

int yywrap() {
    return 1;
}