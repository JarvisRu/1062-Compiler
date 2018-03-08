#include<iostream>
#include<regex>
#include<string>

using namespace std;

int main(){

    string scanStr;
    regex targetStr("([_$a-zA-Z]*)(cpy)([_$a-zA-Z0-9]*)");
    smatch matchStr;

    while(getline(cin,scanStr)){
        while(regex_search(scanStr,matchStr,targetStr)){
            cout<<matchStr[0]<<endl;
            scanStr = matchStr.suffix().str();
        }
    }

    return 0;
}
