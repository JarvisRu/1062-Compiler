# Final Project - Mini LISP

## Requirement
- flex
- bison
- g++

## Directory detial
- /demo
    - Demo version
    - without calling debug function
    - comment unimportant messages
- /my_work
    - Testing version
    - print debugging message
    - record variables, functions, arguments
- /doc
    - Compiler Final Project.pdf
        - Evalution for grade
    - MiniLisp.pdf
        - Detail about Mini-Lisp
        - Grammar and Token-definition and Behavior is provided 
- /test_data
    - all testcase 

## Features
- Syntax Validation
- Print
- Numerical Operations
- Logical Operations
- if Expression
- Variable Definition
- Function
- Named Function

## Compile
```
# Linux
bison -d fp.y
flex fp.l
g++ lex.yy.c fp.tab.c
./a.out < input.txt

# Lazy
make test
```