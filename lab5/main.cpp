#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

extern "C" void Convert(char*);

int main () {
    string str;
    cout << "Введите строку: ";
    getline(cin, str);
    reverse(str.begin(), str.end());
    str.append(" \n");
    Convert(&str[0]);
    reverse(str.begin(), str.end());
    str.append(" \n");
    cout << str;
    return 0;
}

