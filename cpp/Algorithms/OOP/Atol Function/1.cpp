#include <iostream>
#include <cctype>
#include <string>

int atol(std::string s)
{
    int num = 0;
    std::string::const_iterator i;
 
    for (i = s.begin(); i != s.end(); i++)
    {
        if (*i == ' ' || *i == '\t' || isalpha(*i))
            continue;
        else
            break;
    }
    if (i == s.end())
        return -1;
    for (std::string::const_iterator j = i; j != s.end(); j++)
    {
        if (isdigit(*j))
            num = num * 10 + (*j - '0');
        else
            break;
    }
    return num;
}
 
int main()
{
    std::string s;
    int num;
 
    std::cout << "Enter a numerical string : ";
    std::cin >> s;
    num = atol(s);
    if (atol(s) >= 0)
        std::cout << "The Numerical Value is  : " << num << std::endl;
    else
        std::cout << "No numerical digit found " << std::endl;
}