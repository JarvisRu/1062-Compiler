#include<iostream>
#include<regex>

using namespace std;

int main(){

    string scanStr;
    regex targetStr(".*\\b(noodles)\\b.*");

    while(getline(cin,scanStr)){
        if(regex_match(scanStr,targetStr))
            cout<<scanStr<<endl;
    }
    return 0;
}
