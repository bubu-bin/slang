%{
    #include "hashtable.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include <stdarg.h>
     
    extern int yylineno;
    void yyerror(const char *s);
    int yylex(void);
    struct HashTable *tbl;
    struct Entry *getVar(char *name);
    void logError(const char *format, ...);
    struct ErrorMessage {
        char message[100];
        int line;
    };

    int errorCnt = 0;
    struct ErrorMessage semErrors[100];
    int logCnt = 0;
    char logs[100][100];
    char reserved[][10] = {"homie"};
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
                    sprintf(logs[logCnt++], "%d", *(int *)$3.value);
                } else if ($3.type == 1) {
                    sprintf(logs[logCnt++], "%s", (char *)$3.value);
                } else if ($3.type == 2) { 
                    struct Entry *exprVar = getVar((char *)$3.value);
                    if (exprVar == NULL) 
                        YYABORT;
                    
                    if (exprVar->type == STRING) {
                        sprintf(logs[logCnt++], "%s", (char*)exprVar->value);
                    } else if (exprVar->type == INT) {
                        sprintf(logs[logCnt++], "%d", *(int *)exprVar->value);
                    }
                }
            }

stmt        : VAR IDENTIFIER '=' expr {
                for (int i = 0; i < sizeof(reserved) / sizeof(reserved[0]); i++) {
                    if (!strcmp(reserved[i], strdup((char *)$2.value))) {
                        logError("Variable name \"%s\" is a reserved keyword!\n", (char *)$2.value);
                        YYABORT;
                    }
                }

                struct Entry *var = search(tbl, $2.value);

                if (var != NULL) {
                    logError("Variable '%s' is already defined.\n", (char*)$2.value);
                }

                if ($4.type == 0) {
                    add(tbl, $2.value, $4.value, INT);
                } else if ($4.type == 1) {
                    add(tbl, $2.value, $4.value, STRING);
                } else if ($4.type == 2) {
                    struct Entry *exprVar = getVar((char *)$4.value);
                    if (exprVar == NULL)
                        YYABORT;

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
                    logError("Cannot perform addition on STRING.\n");
                }

                if ($1.type == 2) {
                    struct Entry *var = getVar((char *)$1.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$1.value);
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVar((char *)$3.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$3.value);
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
                    logError("Cannot perform substraction on STRING.\n");
                }

                if ($1.type == 2) {
                    struct Entry *var = getVar((char *)$1.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$1.value);
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVar((char *)$3.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$3.value);
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
                    logError("Cannot perform multiplication on STRING.\n");
                }

                if ($1.type == 2) {
                    struct Entry *var = getVar((char *)$1.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$1.value);
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVar((char *)$3.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$3.value);
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
                    logError("Cannot perform division on STRING.\n");
                }

                if ($1.type == 2) {
                    struct Entry *var = getVar((char *)$1.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$1.value);
                    }
                    $1.value = var->value;
                };

                if ($3.type == 2) {
                    struct Entry *var = getVar((char *)$3.value);
                    if (var == NULL) 
                        YYABORT;

                    if (var->type != INT) {
                        logError("Variable '%s' is not of type INT.\n", (char*)$3.value);
                    }
                    $3.value = var->value;
                };
                
                if (*(int *)$3.value == 0) {
                    logError("Division by zero is not allowed.\n");
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

    if (errorCnt > 0) {
        for (int i = 0; i < errorCnt; i++) {
            printf("Line: %d %s", semErrors[i].line, semErrors[i].message);
        }

        return EXIT_FAILURE;
    } 

    for (int i = 0; i < logCnt; i++) {
        printf("%s", logs[i]);
    }

    return EXIT_SUCCESS;
}

void yyerror(const char* msg) {
    fprintf(stderr, "Line: %d %s\n", yylineno, msg);
}

struct Entry *getVar(char *name) {
    struct Entry *var = search(tbl, name);

     if (var == NULL) {
        logError("Variable '%s' is not defined.\n", name);
        return NULL;
    }

    return var;
}

void logError(const char *format, ...) {
    if (errorCnt < 100) {
        va_list args;
        va_start(args, format);

        vsnprintf(semErrors[errorCnt].message, sizeof(semErrors[errorCnt].message), format, args);
        semErrors[errorCnt].line = yylineno;
        errorCnt++;

        va_end(args);
    } else {
        fprintf(stderr, "Error buffer overflow\n");
    }
}