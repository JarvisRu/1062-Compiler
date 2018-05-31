#include<iostream>  
#include<string>  
#include<sstream>  
#include<stdio.h>
#include<iomanip>
#include<math.h>

using namespace std;

extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

