#include<iostream>
#include<stdio.h>
#include<sstream>
#include<string>
#include<vector>
#include<utility>
#include<cctype>
#include<stack>
using namespace std;

// form string stream to token stream
string input;
vector<pair<string,string>> tokenStream;

// check formula
vector<pair<string,string>> tokenTmp;
bool isDivision = false;
int countDivisionNumber = 0;
bool divideZero = false;
bool illegalFormula = false;

// check error token
bool error = false;
string error_token;

void Exps();
void Exp();
bool check(string);
void Program();
void CutFrontSpaceOfInput();
void evalFormula();
void ExpForCheck();
void evalPrefix();
void PrintErrorMessage(int);
void reset();

int main(){
    Program();
    cout << "ByeBye~";
    return 0;
}

void Program(){
    cout << "Welcome use our calculator!" << endl;
    while(true) {
        cout << "> ";
        char tmp=' ';
        input.clear();
        do {
            input += tmp;
            tmp = getchar();
        }while(tmp != '\n' && tmp != EOF);
        
        // add &$ in the end to detect if this input is empty
        input += "&$";
        CutFrontSpaceOfInput();

        // detect eof
        if(tmp == EOF) {
            return;
        }

        if(input[0] == '&' && input[1] == '$'){}
        else {
            input = input.substr(0, input.size()-2);
            Exps();
            if(!error) {
                // all valid token
                int token_size = tokenStream.size();
                for(int i=0 ; i<token_size ; ++i) {
                    if(tokenStream[i].first == "INT" && tokenStream[i].second[0] == '+')
                        tokenStream[i].second.substr(1, input.size()-1);
                }

                // eval formula and eval prefix
                evalFormula();
            }
            // erase tokens and reset
            reset();
        }
    }
}

void Exp(){
    CutFrontSpaceOfInput();
    if(!error && input.length() != 0) {
        // Exp -> INT
        if( isdigit(input[0]) || ((input[0] == '+' || input[0] == '-') && isdigit(input[1])) ) {
            if(!check("INT")) {
                error = true;
                PrintErrorMessage(1);
            }
        }
        // Exp -> OPERATOR Exp Exp EOL
        else {
            if(!check("OPERATOR")) {
                error = true;
                PrintErrorMessage(1);
                return;
            }
            Exp();
            Exp();
        }
    }
}

void Exps(){
    if(!error) {
        CutFrontSpaceOfInput();
        if(input.length() != 0) {
            Exp();
            Exps();
        }
        else if (input.length() == 0){}
    }
}

bool check(string t) {
    CutFrontSpaceOfInput();
    if(t == "INT") {
        int int_length = 0;
        // if integer has symbol
        if(input[int_length] == '+' || input[int_length] == '-') {
            int_length++;
        }
        while(isdigit(input[int_length])) {
            int_length++;
        }
        // integer is valid or not
        if(input.length() == int_length || input[int_length] == ' ' || input[int_length] == '+' || input[int_length] == '-' || input[int_length] == '*' || input[int_length] == '/') {
            tokenStream.push_back(make_pair(t, input.substr(0, int_length)));
            input = input.substr(int_length, input.size()-int_length);
        }
        else {
            while(input[int_length] != ' ' && int_length < input.length()) {
                int_length++;
            }
            error_token = input.substr(0, int_length);
            return false;
        }
    }
    else if(t == "OPERATOR") {
        // operator is valid
        if(input[0] == '+' || input[0] == '-' || input[0] == '*' || input[0] == '/') {
            tokenStream.push_back(make_pair(t, input.substr(0,1)));
            input = input.substr(1, input.size()-1);
        }
        // not a operator
        else {
            int len = 0;
            while(input[len] != ' ' && len < input.length()) {
                len++;
            }
            error_token = input.substr(0, len);
            return false;
        }
    }

    return true;
}

void ExpForCheck(){
    if(tokenTmp.size() > 0) {
        if(tokenTmp[0].first == "OPERATOR") {
            if(tokenTmp[0].second == "/") 
                isDivision = true;
            else {
                isDivision = false;
                countDivisionNumber = 0;
            }
            
            tokenTmp.erase(tokenTmp.begin());
            
            if(!divideZero)
                ExpForCheck();
            if(tokenTmp.size() == 0) {
                illegalFormula = true;
                return;
            }
            if(!divideZero)
                ExpForCheck();
        }
        else {
            if(isDivision) {
                if(countDivisionNumber == 1 && tokenTmp[0].second == "0") {
                    divideZero = true;
                    return;
                }
                else 
                    countDivisionNumber++;
            }
            tokenTmp.erase(tokenTmp.begin());
        }
    }
    
}


void evalFormula(){
    tokenTmp.assign(tokenStream.begin(), tokenStream.end());
    
    ExpForCheck();
    if(illegalFormula) {
        PrintErrorMessage(2);
        return;
    }
    if(divideZero) {
        PrintErrorMessage(3);
        return;
    }
    evalPrefix();
}

void evalPrefix(){
    stack<int> s;

    for(int i=tokenStream.size() ; i>0 ; --i) {
        pair<string, string> target;
        target.first = tokenStream[i-1].first;
        target.second = tokenStream[i-1].second;
        tokenStream.pop_back();

        if(target.first == "INT") {
            stringstream ss;
            int tmp;
            ss << target.second;
            ss >> tmp;
            s.push(tmp);
        }
        else if(target.first == "OPERATOR") {
            if(s.size()<2) {
                PrintErrorMessage(2);
                return;
            }
            if(target.second == "+") {
                int x = s.top();
                s.pop();
                int y = s.top();
                s.pop();
                s.push(x+y);
            }
            else if (target.second == "-") {
                int x = s.top();
                s.pop();
                int y = s.top();
                s.pop();
                s.push(x-y);
            }
            else if (target.second == "*") {
                int x = s.top();
                s.pop();
                int y = s.top();
                s.pop();
                s.push(x*y);
            }
            else if (target.second == "/") {
                int x = s.top();
                s.pop();
                int y = s.top();
                s.pop();
                if(y == 0) {
                    error = true;
                    // push as trash
                    s.push(x);
                }
                else {
                    s.push(x/y);
                }
            }
        }
    }
    if(s.size() != 1)
        PrintErrorMessage(2);
    else if(error)
        PrintErrorMessage(3);
    else
    cout << s.top() << endl;
}

void CutFrontSpaceOfInput() {
	while(input[0] == ' ' && !input.empty()) {
        input = input.substr(1, input.size()-1);
	}
}

void PrintErrorMessage(int type){
    switch(type){
        case 1:
            cout << "Error: Unknown token " << error_token << endl;
            break;
        case 2:
            cout << "Error: Illegal formula!" << endl;
            break;
        case 3:
            cout << "Error: Divide by ZERO!" << endl;
            break;
    }
}

void reset(){
    error = false;
    error_token.clear();
    tokenStream.erase(tokenStream.begin(), tokenStream.end());
    tokenTmp.erase(tokenTmp.begin(), tokenTmp.end());
    isDivision = false;
    countDivisionNumber = 0;
    divideZero = false;
    illegalFormula = false;
}