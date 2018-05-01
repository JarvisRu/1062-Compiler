#include <iostream>
#include <string>
#include <vector>
#include <utility>
using namespace std;

string s = "";
vector<pair<string, string>> tokenStream;
bool error = false;

void removeFrontSpace();
bool Match(string t);
void Proc();
void Dcl();
void Astring();
void Stmt();

int main() {
    getline(cin , s);
    string temp;
    getline(cin , temp);
    s += temp;
    
    Proc();

    if (error) {
        cout << "valid input";
    } else {
        for(int i = 0; i < tokenStream.size(); i++) {
            cout << tokenStream[i].first << " "
                 << tokenStream[i].second << endl;
        }
    }
}

void removeFrontSpace() {
    while (!s.empty() && s[0] == ' ') {
        s = s.substr(1, s.size());
    }
}
bool Match(string t) {
    removeFrontSpace();
    if (t == "") {
        if (!s.empty()) {
            return false;
        }
    } else if (t == "strdcl") {
        if (s[0] == 's') {
            tokenStream.push_back(make_pair(t, "s"));
            s = s.substr(1, s.size());
        } else {
            return false;
        }
    } else if (t == "id") {
        if ((s[0] >= 'a' && s[0] <= 'o') ||
            (s[0] >= 'q' && s[0] <= 'r') ||
            (s[0] >= 't' && s[0] <= 'z')) {
            tokenStream.push_back(make_pair(t, s.substr(0,1)));
            s = s.substr(1, s.size());
        } else {
            return false;
        }
    } else if (t == "quote") {
        if (s[0] == '\"') {
            tokenStream.push_back(make_pair(t, "\""));
            s = s.substr(1, s.size());
        } else {
            return false;
        }
    } else if (t == "string") {
        int str_length = 0;
        while ((s[str_length] >= 'a' && s[str_length] <= 'z') ||
               (s[str_length] >= 'A' && s[str_length] <= 'Z') ||
               (s[str_length] >= '0' && s[str_length] <= '9')) {
            str_length++;
        }

        if (str_length == 0) {
            return false;
        } else {
            tokenStream.push_back(make_pair(t, s.substr(0, str_length)));
            s = s.substr(str_length, s.size());
        }
    } else if (t == "print") {
        if (s[0] == 'p') {
            tokenStream.push_back(make_pair(t, "p"));
            s = s.substr(1, s.size());
        } else {
            return false;
        }
    } else {
        cout << "Compiler Error" << endl;
        return false;
    }
    return true;
}
void Proc() {
    Dcl();
    Stmt();
    if (!Match(""))       error = true;
}
void Dcl() {
    if (!Match("strdcl")) error = true;
    if (!Match("id"))     error = true;
    Astring();
}
void Astring() {
    if (!Match("quote"))  error = true;
    if (!Match("string")) error = true;
    if (!Match("quote"))  error = true;
}
void Stmt() {
    if (!Match("print"))  error = true;
    if (!Match("id"))     error = true;
}
