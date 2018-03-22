#include<iostream>
#include<regex>

using namespace std;

int main(){

    string scanStr;
    regex targetStr("[a-zA-Z]+\\s*[a-zA-Z]+\\s*(noodles)\\s*[a-zA-Z]+");

    while(getline(cin, scanStr)) {
        if(regex_match(scanStr, targetStr))
            cout << scanStr << endl;
    }
    return 0;
}
