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
void Stmt();
void Val();

int main() {
    getline(cin , s);
    Proc();

    if (error) {
        cout << "valid input";
    } else {
        for (int i = 0; i < tokenStream.size(); i++) {
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
    } else if (t == "id") {
        if (s[0] >= 'a' && s[0] <= 'z') {
            tokenStream.push_back(make_pair(t, s.substr(0,1)));
            s = s.substr(1, s.size());
        } else {
            return false;
        }
    } else if (t == "assign") {
        if(s[0] == '=') {
            tokenStream.push_back(make_pair(t, s.substr(0,1)));
            s = s.substr(1, s.size());
        } else {
            return false;
        }
    } else if (t == "inum") {
        int inum_length = 0;
        while (s[inum_length] >= '0' && s[inum_length] <= '9') {
            inum_length++;
        }

        if (inum_length == 0) {
            return false;
        } else {
            tokenStream.push_back(make_pair(t, s.substr(0, inum_length)));
            s = s.substr(inum_length, s.size());
        }
    } else {
        cout << "Compiler Error" << endl;
        return false;
    }
    return true;
}
void Proc() {
    Stmt();
    if (!Match("")) {
        error = true;
    }
}
void Stmt() {
    if (!Match("id")) {
        error = true;
    }
    if(!Match("assign")) {
        error = true;
    }
    Val();
}
void Val() {
    if (!Match("id") && !Match("inum")){
        error = true;
    }
}