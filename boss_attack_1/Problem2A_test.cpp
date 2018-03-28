#include<iostream>
#include<string>
#include<cstdio>
#include<cstdlib>
#include<sstream>
using namespace std;

int judge(string id, string asign, string val){
    bool check_id = false;
    bool check_asign = false;
    bool check_val = false;
    bool val_is_int = false;

    if (id.length() == 1 && id[0] >= 'a' && id[0] <= 'z') {
        check_id = true;
    }

    if (asign.length() == 1 && asign[0] == '=') {
        check_asign = true;
    }

    int val2 = atoi(val.c_str());
    stringstream s;
    string val2_str;
    s << val2;
    s >> val2_str;
    if (val2 != 0 && val[0] != '0' && val2_str == val) {
        check_val = true;
        val_is_int = true;
    } else if (val.length() == 1 && val[0] >= 'a' && val[0] <= 'z') {
        check_val = true;
        val_is_int = false;
    } else {
        check_val = false;
    }

    if (check_id && check_asign && check_val) {
        if (val_is_int)
            return 1;
        else
            return 2;
    } else {
        return 0;
    }

}

int main(){

    stringstream ss;
    string input;
    string id, asign, val;
    int ans;

    while (getline(cin, input)) {
        if (input == "")    continue;
        ss << input;
        ss >> id >> asign >> val;
        ans = judge(id, asign, val);
        if (ans != 0) {
            cout << "id " << id << endl;
            cout << "assign " << asign << endl;
            if (ans == 1)
                cout << "inum " << val << endl;
            else
                cout << "id " << val << endl;
        } else {
            cout << "valid input" << endl;
        }
        ss.clear();
    }

    return 0;
}
