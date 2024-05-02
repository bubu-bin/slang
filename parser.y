%{
    #include <stdio.h>
    
    void yyerror(const char *s);
    int yylex(void);
%}

%union {
    char *identifier;
}

%token <identifier> IDENTIFIER 
%token SEMICOLON

%%

    statements: statement 
              | statements statement
              ;
              
    statement: IDENTIFIER SEMICOLON { printf("identifier is %s\n", $1);}

%%

int main() {
    yyparse();
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}