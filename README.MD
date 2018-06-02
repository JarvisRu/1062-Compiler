# 1062 Compiler

## Homework File
- [ProblemA (link)](https://www.dropbox.com/s/r3iuzmq02iw89xn/PA.pdf?dl=0)
- [ProblemB (link)](https://www.dropbox.com/s/ie8sij7o7gd7siu/PB.pdf?dl=0)
- [Problem3A.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013780/Ch3.Problem.A.pdf)
- [Problem3B.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013784/Ch3.Problem.B.pdf)
- [Problem3C.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013791/Hex.literal.pdf)
- [Problem3D.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013795/IP.Address.pdf)
- [Problem6A.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013834/matrix.calculator.pdf)
- [Problem6B.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013836/Equilibrim.pdf)

## Boss Attack 1
- [BA01.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013809/BA01.pdf)
- [BA02.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013814/BA02.-.pdf)

## Boss Attack 2
- [BA01 - Scientific Notation.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013817/Scientific.Notation.pdf)
- [BA02 - Table.pdf](https://github.com/JarvisRu/1062-Compiler/files/2013818/Table.pdf)

## Boss Attack 3
- [BA01 - Simple LaTeX Evaluation.pdf](https://github.com/JarvisRu/Cplus-Socket-ChessGame/files/2064900/Simple.LaTeX.Evaluation.pdf)
- [BA02 - Stack base machine.pdf](https://github.com/JarvisRu/Cplus-Socket-ChessGame/files/2064897/Stack.base.machine.pdf)

## Compile
### Lex
```=
flex example.l                # create lex.yy.c
gcc -o example lex.yy.c       # compile, output as example.exe
# windows
cat input.txt | ./example.exe # using input.txt as input for example.exe in Windows
# Linux
./example.out < input.txt     # using input.txt as input for example.out in Linux
```
### Lex + Yacc(C++)
```
# Linux
bison -d examle.y             # create example.tab.h and example.tab.c
flex example.l                # create lex.yy.c
g++ lex.yy.c example.tab.c    # compile, output as a.out
./a.out < input.txt           # using input.txt as input for a.out in Linux
```