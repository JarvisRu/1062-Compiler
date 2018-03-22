#include<iostream>
#include<regex>
#include<string>

using namespace std;

class scanner{

  public:
    regex dcl,astring,stmt;
    string dclCode,stmtCode;
    smatch dclMatch,astringMatch,stmtMatch;

    // initialize regex mask
    scanner() {
        dcl = "(s)\\s+([a-ot-z]|[qr])\\s+(.*)";
        astring = "^(\")([a-zA-Z0-9]*)(\")$";
        stmt = "(p)\\s+([a-ot-z]|[qr])";
        this->proc();
    }

    // proc -> Dcl Stmt $
    void proc() {
        if(this->Dcl())
            this->Stmt();
    }

    // Dcl -> strdcl id Astring
    bool Dcl(){
        getline(cin, dclCode);

        if(dclCode!="") {
            if(regex_match(dclCode, dclMatch, dcl)) {
                string tmp = dclMatch[3].str();
                if(regex_match(tmp, astringMatch, astring)) {
                    cout <<"strdcl " << dclMatch[1] << endl;
                    cout <<"id " << dclMatch[2] << endl;
                    cout <<"quote " << astringMatch[1] << endl;
                    cout << "string " << astringMatch[2] << endl;
                    cout << "quote " << astringMatch[3] << endl;
                }
                else{
                    this->invalid();
                    return false;
                }
            }
            else{
                this->invalid();
                return false;
            }
        }
        else{
            this->invalid();
            return false;
        }
        return true;
    }

    // stmt -> print id
    void Stmt() {
        getline(cin, stmtCode);

        if(stmtCode != "") {
            if(regex_match(stmtCode, stmtMatch, stmt)) {
                cout << "print " << stmtMatch[1] << endl;
                cout << "id " << stmtMatch[2];
            }
            else
                this->invalid();
        }
    }

    void invalid() {
        cout << "valid input";
    }

};


int main(){

    scanner *s = new scanner;
    delete s;

    return 0;
}
