#ifndef MAIN_HPP  
#define MAIN_HPP  
  
#include <iostream>  
#include <string>  
#include <stdio.h>
using namespace std;  

// C++ link to C
extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

#endif  