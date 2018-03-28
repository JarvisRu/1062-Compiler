#include<iostream>
#include<string>
#include<cstdio>
#include<cstdlib>
#include<sstream>
#include<cctype>
using namespace std;


bool check_str(string target){
    int str_len = target.length();
    if (target[0] != '\"' || target[str_len-1] != '\"') {
        return false;
    }
    string contain = target.substr(1, str_len-2);
    for (int i=0 ; i<contain.length() ; ++i) {
        if(isdigit(contain[i]) || (contain[i]>='a' && contain[i]<='z') || (contain[i]>='A' && contain[i]<='Z') ){}
        else
            return false;
    }

    return true;
}


bool judge(string strdcl, string id, string astring){

    bool check_strdcl = false;
    bool check_id = false;
    bool check_astring = false;

    if (strdcl.length() == 1 && strdcl[0] == 's') {
        check_strdcl = true;
    }

    if (id.length() == 1 && id[0] >= 'a' && id[0] <= 'z' && id[0] != 'p' && id[0] != 's') {
        check_id = true;
    }

    if (check_str(astring))
        check_astring = true;
    else
        check_astring = false;

    if (check_strdcl && check_id && check_astring)
        return true;
    else
        return false;

}

int main(){

    stringstream ss;
    string input,input2;
    string strdcl, id, astring;
    string print;
    int str_length;

    getline(cin, input);
    if (input[0] == 's') {
        ss << input;
        ss >> strdcl >> id >> astring;
        if(judge(strdcl, id, astring)) {
            cout << "strdcl " << strdcl << endl;
            cout << "id " << id << endl;
            cout << "quote " << "\"" << endl;
            str_length = astring.length();
            cout << "string " << astring.substr(1, str_length-2) << endl;
            cout << "quote " << "\"" << endl;
        }
        else {
            cout << "valid input" << endl;
            return 0;
        }
    }
    else{
        cout << "valid input" << endl;
        return 0;
    }

    ss.clear();

    getline(cin, input2);
    if (input2[0] == 'p') {
        ss << input2;
        ss >> print >> id;
        if (print.length() == 1 && print[0] == 'p' && id.length() == 1 && id[0] >= 'a' && id[0] <= 'z' && id[0] != 'p' && id[0] != 's') {
            cout << "print " << print << endl;
            cout << "id " << id << endl;
        }
        else
            cout << "valid input" << endl;
    }
    else
        cout << "valid input" << endl;

    

    return 0;
}
