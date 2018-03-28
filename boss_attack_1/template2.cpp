#include<iostream>
#include<string>
#include<sstream>
#include<vector>
#include <utility>
using namespace std;

stringstream ss;
string input;
string id, asign, val;
string print;
string floatdcl, intdcl;
string expr, symbol;
vector<pair<string,string>> tokenStream;
bool error = false;
bool used = false;

bool Val();
bool Expr();
bool check(string, string);
void Proc();
void Dcls();
void Dcl();
void Stmts();
void Stmt();
void CutFrontSpaceOfInput();
void CutFrontSpaceOfExpr();

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
		if((!check("plus", symbol) && !check("minus", symbol)) || !Val())
			return false;
		else {
			if(!expr.empty())
				Expr();
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

void Stmt(){
	if(input[0] == 'p') {
		ss << input;
		ss >> print >> id;
		if (!check("print", print) || !check("id", id))
			error = true;
	}
	// Without Expr in grammar
	// else {
	// 	ss << input;
	// 	ss >> id >> asign >> val;
	// 	if (!check("id", id) || !check("assign", asign) || !Val())
	// 		error = true;
	// }
	else {
		ss << input;
		ss >> id >> asign >> val;
		getline(ss, expr);
		if (!check("id", id) || !check("assign", asign) || !Val() || !Expr())
			error = true;
	}
	ss.clear();
}

void Stmts(){
	if(!error) {
		if(used)
			getline(cin, input);
		used = true;
		CutFrontSpaceOfInput();
		if((input[0] >= 'a' || input[0] <= 'z') && input[0]!='$' && !input.empty()) {
			Stmt();
			Stmts();	
		}
		else if(input[0] == '$' || input.empty()){
		}
		else
			error = true;
	}
}

void Dcl(){
	if(input[0] == 'f') {
		ss << input;
		ss >> floatdcl >> id;
		if (!check("floatdcl", floatdcl) || !check("id", id))
			error = true;
	}
	else {
		ss << input;
		ss >> intdcl >> id;
		if (!check("intdcl", intdcl) || !check("id", id))
			error = true;
	}
	ss.clear();
}

void Dcls(){
	if(!error) {
		getline(cin, input);
		CutFrontSpaceOfInput();
		if((input[0] == 'f' || input[0] == 'i')) {
			used = true;
			Dcl();
			Dcls();	
		}
		else {
			used = false;
		}
	}
}

void Proc(){
	Dcls();
	if(error) {
		cout << "valid input at Dcls" << endl;
	}
	else {
		Stmts();
		if(error) {
			cout << "valid input at Stmts" << endl;
		}
		else {
			for(int i=0 ; i<tokenStream.size() ; ++i) {
				cout << tokenStream[i].first << " " << tokenStream[i].second << endl;
			}
			// tokenStream.erase(tokenStream.begin(), tokenStream.end());
		}
	}
}

int main(){
	Proc();
    return 0;
}

