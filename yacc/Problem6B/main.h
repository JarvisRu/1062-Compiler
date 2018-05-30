#include<iostream>  
#include<string>  
#include<sstream>  
#include<stdio.h>
#include<map>

using namespace std;

extern "C"
{   
    int yylex(void);
    void yyerror(const char *s);  
}  

void updateForElement(string, bool);
void updateForInner(int);
void updateForCompound(int);
void printResult();