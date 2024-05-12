# Slang
## Table of Contents

- [About the Slang](#about-the-slang)
- [Features](#features)
- [Demo code](#demo-code)
- [Get started](#get-started)
- [Good to know](#good-to-know)

## About the Slang
Slang is a simple tool designed to execute programs written in a custom scripting language. Named after the lexicon of street style, Slang introduces a playful twist to programming.

#### Implemented with
- **Yacc parser**: For parsing the program's syntax, Yacc (Yet Another Compiler Compiler) is used, which translates custom language's grammar into a C program that acts as the parser.
- **Lex tokenizer**: Lexical analysis is handled by Lex, which breaks down the input into a series of tokens based on regular expressions. This process is crucial for the parser to understand the structure of the code.
- **Hash table**: The interpreter uses a hash table to manage variables. Given that variable lookup and assignment are frequent operations, the hash table optimizes these to run in constant `O(1)` time, speeding up the execution.

## Features
#### Supported types
  - `Int` for signed integers.
  - `Str` for string values, encapsulated in double quotes.
#### Variables
  - Declared with the keyword `homie`.
  - Supports assigning values from one variable to another but prohibits reassignment to already declared variables.
#### Arithmetic operations
  - Full support for basic arithmetic operations `(+, -, *, /)`, including proper associativity rules to respect operation precedence, such as in expressions like `(123 + 12) / 2`.
  - Implements type validation and safe operations, including checks to prevent division by zero.
#### Terminal output
  - The `shout({expression})` function allows for printing evaluated expressions to the terminal.
#### Comments
  - Single line comments start with `//`.
  - Multi-line comments are wrapped between `/** and */`.

## Demo code
This example illustrates how to convert temperatures from Celsius to Fahrenheit in Slang. It demonstrates variable declarations, basic arithmetic, and outputting results.
```shell
/**
 * This program converts a temperature from Celsius to Fahrenheit.
 */

homie factor = 18;  // Scaled factor to avoid floating-point (1.8 scaled by 10)
homie offset = 32;
homie celsius = 24;

shout("Temperature in Celsius:");
shout(celsius);

// Perform the conversion
homie fahrenheit = (celsius * factor) / 10 + offset; 

shout("Temperature in Fahrenheit:");
shout(fahrenheit);
```

## Get started
The following tool versions were used during the development of this project. While Slang should work with similar versions, using these specific versions can help ensure compatibility and stability:
- `yacc` GNU Bison version 2.3
- `lex` Flex version 2.6.4
- `gcc` Apple clang version 13.1.6 / MinGW-w64 GCC (For Windows users)
- `make` GNU Make

#### 1. Compiling the program
To compile the project navigate to the project root directory and run command below. This command will execute the instructions defined in `Makefile` to build the project and create an executable file `program`.

```shell
make
```

#### 2. Executing the program
To execute a program run in root directory: 
```shell
# You can run your own script, replace {path_to_script} with your script file's path
./program < {path_to_script}

# Or you can run a demo provided with the project
./program < ./examples/demo.slang
```

## Good to know
#### What is LEX?
LEX is a tool used to generate a lexical analyzer. The input is a set of regular expressions in addition to actions. The output is a table driven scanner called lex.yy.c.
#### What is YACC?
YACC (Yet Another Compiler Compiler) is a tool used to generate a parser. It parses the input file and does semantic analysis on the stream of tokens produced by the LEX file. YACC translates a given Context Free Grammar (CFG) specifications into a C implementation y.tab.c. This C program when compiled, yields an executable parser.

