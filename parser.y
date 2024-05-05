%{
    #include "hashtable.h"
    #include <stdio.h>
     
    void yyerror(const char *s);
    int yylex(void);
    struct HashTable *tbl;
%}

%union {
    struct symbol {
        int type; // INT = 0; STRING = 1; IDENTIFIER = 2;
        void *value;
    } symbol;
}

%token <symbol> IDENTIFIER STR NUMBER
%token DEF

%type <symbol> expr

%start program

%%

program     :
            | program stmt
            ;
 
stmt        : DEF IDENTIFIER '=' expr ';' {
                struct Entry *def = search(tbl, $2.value);

                if (def != NULL) {
                    printf("Error: Variable '%s' already defined.\n", (char*)$2.value);
                    YYABORT;
                }

                if ($4.type == 0) {
                   add(tbl, $2.value, $4.value, INT);
                } else if ($4.type == 1) {
                   add(tbl, $2.value, $4.value, STRING);
                } else if ($4.type == 2) {
                   struct Entry *entry = search(tbl, $4.value);

                   if (entry == NULL) {
                    printf("Error: Variable '%s' is not defined.\n", (char*)$4.value);
                    YYABORT;
                   }

                   add(tbl, $2.value, entry->value, entry->type); 
                }

                printHashTable(tbl);
            }
            ;
    
expr        : STR    {$$ = $1;}
            | NUMBER {$$ = $1;}
            | IDENTIFIER {$$ = $1;}

%%

int main() {
    tbl = createHashTable(20);
    yyparse();
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}