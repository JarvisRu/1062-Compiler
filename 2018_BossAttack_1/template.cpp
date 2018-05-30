#include<iostream>
#include<string>
#include<sstream>
#include<vector>
#include <utility>
#include<cctype>
using namespace std;

stringstream ss;
string input;
string id, asign, val;
string print;
string floatdcl, intdcl;
string expr, symbol;
vector<pair<string,string>> tokenStream;

//  -------------------Match----------------------------------
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
    else if(t == "fnum") {
		int fnum_length = v.length();
		bool dot = false;
        if(fnum_length == 0)
            return false;
        for(int i=0 ; i<fnum_length ; ++i) {
            if(v[i] >= '0' && v[i] <= '9'){}
		    else if(v[i] == '.' && !dot)
			    dot = true;
		    else if(v[i] == '.' && dot)
			    return false;
            else
                return false;
        }
        tokenStream.push_back(make_pair(t, v));
	}
	else if(t == "plus") {
		if (v.length() == 1 && v[0] == '+')
            tokenStream.push_back(make_pair(t, v));
        else
            return false;
	}
	else if(t == "minus") {
		if (v.length() == 1 && v[0] == '-')
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
    else if(t == "floatdcl") {
		if (v.length() == 1 && v[0] == 'f')
            tokenStream.push_back(make_pair(t, v));
        else
            return false;
	}
	else if(t == "intdcl") {
		if (v.length() == 1 && v[0] == 'i')
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

// --------------------CutFrontSpaceOf---------------------------------
void CutFrontSpaceOfInput() {
	while(input[0] == ' ' && !input.empty()) {
        input = input.substr(1, input.length()-1);
	}
}

void CutFrontSpaceOfExpr() {
	while(expr[0] == ' ' && !expr.empty()) {
        expr = expr.substr(1, expr.length()-1);
	}
}

// -------------------Expr() and Val()----------------------------------

bool Expr(){
	if(expr == "")
		return true;
	else {
		CutFrontSpaceOfExpr();
		ss.clear();
		ss << expr;
		ss >> symbol >> val;
		ss.clear();
		expr = "";
		getline(ss, expr);
		if(!expr.empty()) {
			if((!check("plus", symbol) || !check("minus", symbol)) && !Val())
				return false;
			else 
				Expr();
		}
		else {
			if((!check("plus", symbol) || !check("minus", symbol)) && !Val())
				return false;
			else 
				return true;
		}
	}
	return true;
}

bool Val(){
    if(!check("id", val) && !check("inum", val) && !check("fnum", val))
        return false;
    else 
        return true;
}

// --------------------------main---------------------------------

int main(){

    // get input
    getline(cin, input);
    ss << input;
    ss >> id >> asign >> val;
    ss.clear();

    // check token
    if(!check("id", id) || !check("assign", asign) || !Val() )
        return false;
    else
        return true;

    // print token
    for(int i=0 ; i<tokenStream.size() ; ++i) {
        cout << tokenStream[i].first << " " << tokenStream[i].second << endl;
    }
    // erase token
    tokenStream.erase(tokenStream.begin(), tokenStream.end());

    return 0;
}