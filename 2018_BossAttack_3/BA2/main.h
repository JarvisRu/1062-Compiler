#include<iostream>  
#include<string>  
#include<sstream>  
#include<stdio.h>
#include<stack>

using namespace std;

extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

void printResult();
bool check(int);