#include<iostream>
#include<string>
#include<sstream>
#include<vector>
#include <utility>
#include<cctype>
using namespace std;

stringstream ss;
string input, input2;
string strdcl, id, astring;
string print, id2;
vector<pair<string,string>> tokenStream;

bool check(string t, string v) {
    if(t == "id") {
        if (v.length() == 1 && v[0] >= 'a' && v[0] <= 'z' && v[0] != 'p' && v[0] != 's')
            tokenStream.push_back(make_pair(t, v));
        else
            return false;
    }
    else if(t == "strdcl") {
        if (v.length() == 1 && v[0] == 's')
            tokenStream.push_back(make_pair(t, v));
        else
            return false;
    }
    else if(t == "astring") {
        int str_len = v.length();
        if (v[0] != '\"' || v[str_len-1] != '\"') {
            return false;
        }
        string contain = v.substr(1, str_len-2);
        for (int i=0 ; i<contain.length() ; ++i) {
            if(isdigit(contain[i]) || (contain[i]>='a' && contain[i]<='z') || (contain[i]>='A' && contain[i]<='Z') ){}
            else
                return false;
        }
        tokenStream.push_back(make_pair("quote", "\""));
        tokenStream.push_back(make_pair("string", contain));
        tokenStream.push_back(make_pair("quote", "\""));
    }
    else if(t == "print") {
        if (v.length() == 1 && v[0] == 'p')
            tokenStream.push_back(make_pair(t, v));
        else
            return false;
    }
    return true;
}

bool Dcl(){
    getline(cin, input);
    ss << input;
    ss >> strdcl >> id >> astring;
    ss.clear();
    if(!check("strdcl", strdcl) || !check("id", id) || !check("astring", astring)){
        cout << "valid input" << endl;
        return false;
    }
    else {
        for(int i=0 ; i<tokenStream.size() ; ++i) {
            cout << tokenStream[i].first << " " << tokenStream[i].second << endl;
        }
        tokenStream.erase(tokenStream.begin(), tokenStream.end());
        return true;
    }
}

bool Stmt(){
    getline(cin, input2);
    ss << input2;
    ss >> print >> id2;
    ss.clear();
    if(!check("print", print) || !check("id", id2)) {
        cout << "valid input" << endl;
        return false;
    }
    else {
        for(int i=0 ; i<tokenStream.size() ; ++i) {
            cout << tokenStream[i].first << " " << tokenStream[i].second << endl;
        }
        tokenStream.erase(tokenStream.begin(), tokenStream.end());
        return true;
    }
}

void Proc() {
    if(Dcl())
        Stmt();
}

int main(){
    Proc();
    return 0;
}