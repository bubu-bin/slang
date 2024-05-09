.PHONY: clean

CC = gcc
CFLAGS = -g
TARGET = program
LEX = lex
YACC = yacc
YFLAGS = -v -d

$(TARGET): y.tab.c lex.yy.c hashtable.c
	$(CC) $(CFLAGS) -o $(TARGET) lex.yy.c y.tab.c hashtable.c  

lex.yy.c: y.tab.c lexer.l
	$(LEX) lexer.l

y.tab.c: parser.y
	$(YACC) $(YFLAGS) parser.y

clean:
	rm -f y.tab.c y.tab.h y.output lex.yy.c $(TARGET) 
