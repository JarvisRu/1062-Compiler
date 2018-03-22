#include<iostream>
#include<regex>
#include<string>

using namespace std;

int main(){
    regex _RE("  ");
    smatch matchStr;
    string scanStr,tmp;

    // read line by line
    while(getline(cin, scanStr)) {
        if(regex_match(scanStr, matchStr, _RE)) {
            // tmp = matchStr[ ];
            
        }
    }

    // read line for many times
    while(getline(cin,scanStr)) {
        while(regex_search(scanStr, matchStr, _RE)) {
            // cout << matchStr[0] << endl;
            // scanStr = matchStr.suffix().str();
        }
    }


    return 0;
}