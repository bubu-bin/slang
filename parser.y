%{
    #include "hashtable.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
     
    void yyerror(const char *s);
    int yylex(void);
    struct HashTable *tbl;
    struct Entry *getVarOrThrow(char *name);

    static int parse_error = 0;
%}

%union {
    struct Symbol {
        int type; // INT = 0; STRING = 1; IDENTIFIER = 2;
        void *value;
    } symbol;
}

%token <symbol> IDENTIFIER STR NUMBER
%token VAR ADD SUBSTRACT DIVIDE MULTIPLY FPRINT 

%type <symbol> expr

%left ADD SUBSTRACT
%left MULTIPLY DIVIDE

%start program

%%

program     : stmt ';'
            | print ';'
            | program stmt ';'
            | program print ';'
            ;

print       : FPRINT '(' expr ')' {
                if ($3.type == 0) {
                    printf("%d", *(int *)$3.value);
                } else if ($3.type == 1) {
                    printf("%s", (char *)$3.value);
                } else if ($3.type == 2) { 
                    struct Entry *exprVar= getVarOrThrow((char *)$3.value);
                    
                    if (exprVar->type == STRING) {
                        printf("%s", (char*)exprVar->value);
                    } else if (exprVar->type == INT) {
                        printf("%d", *(int *)exprVar->value);
                    }
                }
            }

stmt        : VAR IDENTIFIER '=' expr {
                struct Entry *var = search(tbl, $2.value);

                if (var != NULL) {
                    printf("Reference error: Variable '%s' already defined.\n", (char*)$2.value);
                    parse_error = 1;
                }

                if ($4.type == 0) {
                    add(tbl, $2.value, $4.value, INT);
                } else if ($4.type == 1) {
                    add(tbl, $2.value, $4.value, STRING);
                } else if ($4.type == 2) {
                    struct Entry *exprVar= getVarOrThrow((char *)$4.value);
                    add(tbl, $2.value, exprVar->value, exprVar->type); 
                }
            }
            ;
    
expr        : STR    {$$ = $1;}
            | NUMBER {$$ = $1;}
            | IDENTIFIER {$$ = $1;}
            | expr ADD expr {
                void *value1, *value2;

                if ($1.type == 1 || $3.type == 1) {
                    printf("Error: Can not perform addition on STRING.\n");
                    parse_error = 1;
                }

                if ($1.type == 2) {
                    struct Entry *var = getVarOrThrow((char *)$1.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$1.value); 
                        parse_error = 1;
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVarOrThrow((char*)$3.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$3.value); 
                        parse_error = 1;
                    }
                    $3.value = var->value;
                };

                struct Symbol result;
                result.type = 0;
                result.value = createIntValue(*(int *)$1.value + *(int *)$3.value);
                $$ = result;
            }
            | expr SUBSTRACT expr {
                void *value1, *value2;

                if ($1.type == 1 || $3.type == 1) {
                    printf("Error: Can not perform substraction on STRING.\n");
                    parse_error = 1;
                }

                if ($1.type == 2) {
                    struct Entry *var = getVarOrThrow((char *)$1.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$1.value); 
                        parse_error = 1;
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVarOrThrow((char*)$3.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$3.value); 
                        parse_error = 1;
                    }
                    $3.value = var->value;
                };

                struct Symbol result;
                result.type = 0;
                result.value = createIntValue(*(int *)$1.value - *(int *)$3.value);
                $$ = result;
            }
            | expr MULTIPLY expr {
                void *value1, *value2;

                if ($1.type == 1 || $3.type == 1) {
                    printf("Error: Can not perform multiplication on STRING.\n");
                    parse_error = 1;
                }

                if ($1.type == 2) {
                    struct Entry *var = getVarOrThrow((char *)$1.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$1.value); 
                        parse_error = 1;
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVarOrThrow((char*)$3.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$3.value); 
                        parse_error = 1;
                    }
                    $3.value = var->value;
                };

                struct Symbol result;
                result.type = 0;
                result.value = createIntValue(*(int *)$1.value * *(int *)$3.value);
                $$ = result;
            }
            | expr DIVIDE expr {
                void *value1, *value2;

                if ($1.type == 1 || $3.type == 1) {
                    printf("Error: Can not perform division on STRING.\n");
                    parse_error = 1;
                }

                if ($1.type == 2) {
                    struct Entry *var = getVarOrThrow((char *)$1.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$1.value); 
                        parse_error = 1;
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVarOrThrow((char*)$3.value);
                    if (var->type != INT) {
                        printf("Error: Variable '%s' is not of type INT.\n", (char*)$3.value); 
                        parse_error = 1;
                    }
                    $3.value = var->value;
                };
                
                if (*(int *)$3.value == 0) {
                    printf("Error: Division by zero is not allowed.\n");
                    parse_error = 1;
                }

                struct Symbol result;
                result.type = 0;
                result.value = createIntValue(*(int *)$1.value / *(int *)$3.value);
                $$ = result;
            }
            | '(' expr ')'  { $$ = $2; } 


%%

int main() {
    tbl = createHashTable(20);
    yyparse();

    if (parse_error) {
        fprintf(stdout, "Parsing terminated due to errors.\n");
        return EXIT_FAILURE;
    } 

    return EXIT_SUCCESS;
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}

struct Entry *getVarOrThrow(char *name) {
    struct Entry *var = search(tbl, name);

     if (var == NULL) {
        printf("Reference error: Variable '%s' is not defined.\n", name);
        parse_error = 1;
    }

    return var;
}
