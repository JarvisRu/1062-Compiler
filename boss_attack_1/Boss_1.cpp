#include<iostream>
#include<string>
#include<vector>
#include<utility>
#include<cctype>
using namespace std;

string input;
string ID, STRLIT, LBR, RBR, Dot, SEMICOLON;
vector<pair<string,string>> tokenStream;
bool error = false;

bool check(string);
void Program();
void Stmts();
void Stmt();
void Exp();
void Primary();
void Primary_tail();
void CutFrontSpaceOfInput();

int main(){
    Program();
    return 0;
}

void Program(){
    Stmts();
    if(error) {
        cout << "invalid input";
    }
    else {
        for(int i=0 ; i<tokenStream.size() ; ++i) {
            cout << tokenStream[i].first << " " << tokenStream[i].second << endl;
        }
    }
}


void Stmts(){
    if(!error) {
        getline(cin, input);
        CutFrontSpaceOfInput();
        if(input.length() != 0 && (input[0] == '\"' || input[0] == '_' || ((input[0] >= 'a' && input[0] <= 'z') || (input[0] >= 'A' && input[0] <= 'Z')))){
            Stmt();
            Stmts();
        }
        else if(input.length() == 0){}
        else {
            error = true;
        }
    }
}

void Stmt(){
    Exp();
    // cout << "input after Exp:"<< input << endl;
    if(!check("SEMICOLON")) {
        error = true;
    }
}


void Exp(){
    if(input[0] == '\"') {
        if(!check("STRLIT"))
            error = true;
    }
    else if (input[0] == ';' || input[0] == '\)'){
        // cout << "nope in Exp()" << endl;
    }
    else {
        Primary();
    }       
}

void Primary(){
    if(!check("ID")) {
        error = true;
        // cout << "Error with ID:"<< input << endl;
    }
    Primary_tail();
}

void Primary_tail(){
    if(input[0] == ';'){}
    else if(input[0] == '\.') {
        if(!check("Dot")) {
            error = true;
            // cout << "Error with Dot:"<< input << endl;
        }
        if(!check("ID")) {
            error = true;
            // cout << "Error with ID in p-tail:"<< input << endl;
        }
        Primary_tail();
    }
    else if(input[0] == '\(') {
        if(!check("LBR")) {
            error = true;
            // cout << "Error with LBR:"<< input << endl;
        }
        Exp();
        if(!check("RBR")) {
            error = true;
            // cout << "Error with RBR:"<< input << endl;
        }
        Primary_tail();
    }
    else {
        error = false;
        // cout << "invalid in p-tail !!" << endl;
    }
}

bool check(string t){
    CutFrontSpaceOfInput();
    if(t == "SEMICOLON") {
        if(input[0] == ';') {
            tokenStream.push_back(make_pair(t, input.substr(0,1)));
            input = input.substr(1);
        } 
        else 
            return false;
    }
    else if(t == "STRLIT") {
        int str_length = 1;
        while (input[str_length] != '\"') {
            str_length++;
        }

        if (str_length == 0) {
            return false;
        } 
        else {
            tokenStream.push_back(make_pair(t, input.substr(0, str_length+1)));
            input = input.substr(str_length+1, input.size());
        }
    }
    else if(t == "ID") {
        int id_length = 0;
        if(input[id_length] == '_' || ((input[id_length] >= 'a' && input[id_length] <= 'z') || (input[id_length] >= 'A' && input[id_length] <= 'Z'))){
            id_length++;
            while (isdigit(input[id_length]) || input[id_length] == '_' || (input[id_length]>='a' && input[id_length]<='z') || (input[id_length]>='A' && input[id_length]<='Z')) {
                id_length++;
            }

            if (id_length == 0) {
                return false;
            } 
            else {
                tokenStream.push_back(make_pair(t, input.substr(0, id_length)));
                input = input.substr(id_length);
            }
        }
        else
            return false;
    }
    else if(t == "Dot") {
        if(input[0] == '\.') {
            tokenStream.push_back(make_pair(t, input.substr(0,1)));
            input = input.substr(1);
        } 
        else 
            return false;
    }
    else if(t == "LBR") {
        if(input[0] == '\(') {
            tokenStream.push_back(make_pair(t, input.substr(0,1)));
            // cout << "input in LBR:" << input << endl;
            input = input.substr(1);
        } 
        else 
            return false;
    }
    else if(t == "RBR") {
        if(input[0] == '\)') {
            tokenStream.push_back(make_pair(t, input.substr(0,1)));
            // cout << "input in RBR:" << input << endl;
            input = input.substr(1);
        } 
        else 
            return false;
    }
    return true;
}

void CutFrontSpaceOfInput() {
	while(input[0] == ' ' && !input.empty()) {
        input = input.substr(1);
	}
}