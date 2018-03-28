#include<iostream>
#include<string>
#include<sstream>
#include<vector>
#include <utility>
using namespace std;

stringstream ss;
string input;
string id, asign, val;
vector<pair<string,string>> tokenStream;

bool check(string t, string v) {
    if(t == "id") {
        if (v.length() == 1 && v[0] >= 'a' && v[0] <= 'z')
            tokenStream.push_back(make_pair(t, v));
        else
            return false;
    }
    else if(t == "assign") {
        if (v.length() == 1 && v[0] == '=')
            tokenStream.push_back(make_pair(t, v));
        else
            return false;
    }
    else if(t == "inum") {
        int inum_length = v.length();
        if(inum_length == 0)
            return false;
        for(int i=0 ; i<inum_length ; ++i) {
            if(v[i] >= '0' && v[i] <= '9'){}
            else
                return false;
        }
        tokenStream.push_back(make_pair(t, v));
    }
    return true;
}

bool Val(){
    if(!check("id", val) && !check("inum", val))
        return false;
    else 
        return true;
}


bool Stmt(){
    ss << input;
    ss >> id >> asign >> val;
    ss.clear();
    if(!check("id", id) || !check("assign", asign) || !Val() )
        return false;
    else
        return true;
}

void Proc() {
    if(!Stmt())
        cout << "valid input" << endl;
    else {
        for(int i=0 ; i<tokenStream.size() ; ++i) {
            cout << tokenStream[i].first << " " << tokenStream[i].second << endl;
        }
    }
    tokenStream.erase(tokenStream.begin(), tokenStream.end());
}

int main(){
    while(getline(cin, input)) {
        if(input == "")
            continue;
        else
            Proc();
    }
    return 0;
}

