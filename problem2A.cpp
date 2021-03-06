#include<iostream>
#include<regex>
#include<string>

using namespace std;

void invalid(){
    cout<<"valid input"<<endl;
}

int main(){

    string stmt, tmp;
    regex stmtRE("([a-z])\\s*(=)\\s*([0-9]+|[a-z])");
    regex id("[a-z]");
    smatch matchStr;

    while(getline(cin, stmt)) {
        if(stmt == "")    continue;
        if(regex_match(stmt, matchStr, stmtRE)){
            cout << "id " << matchStr[1] << endl;
            cout << "assign " << matchStr[2] << endl;
            tmp = matchStr[3].str();
            if(regex_match(tmp, id))
                cout << "id " << matchStr[3] << endl;
            else
                cout << "inum " << matchStr[3] << endl;
        }
        else
            invalid();
    }

    return 0;
}
