%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "y.tab.h"
    #include "hashtable.h"
    
    void yyerror(const char *s);
%}

alpha [a-zA-Z]
digit [0-9]

%%

"homie"                   { return VAR;}
{alpha}({alpha}|{digit})* { 
                            yylval.symbol.value = createStringValue(yytext);
                            yylval.symbol.type=2;
                            return IDENTIFIER; 
                          }
\"[^\"]*\"                { 
                            yylval.symbol.value = createStringValue(yytext);
                            yylval.symbol.type=1; 
                            return STR;
                          }
[-]?{digit}+              { 
                            yylval.symbol.value = createIntValue(atoi(yytext)); 
                            yylval.symbol.type = 0; 
                            return NUMBER; 
                          }
"+"                       { return ADD; }
"-"                       { return SUBSTRACT; }
"/"                       { return DIVIDE; }
"*"                       { return MULTIPLY; }
\/\/.*                    { ; }
\/\*(.*\n)*.*\*\/         { ; } 
[ \t]*                    { ; }
.	                        { return *yytext; }                   

%%

int yywrap() {
    return 1;
}
