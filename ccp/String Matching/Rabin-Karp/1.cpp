#include<stdio.h>
#include<string.h>
#include<iostream>
#include<vector>
using namespace std;

#define d 256
 
void get_input(vector<char>& a)
{
    char c;
    while (1)
    {
        c = getchar();
        if (c == '\n')
        break;
        a.push_back(c);
    }
    return;
}
 
 
void search(char *pat, char *txt, int q)
{
    int M = strlen(pat);
    int N = strlen(txt);
    int i, j;
    int p = 0;  
    int t = 0;
    int h = 1;
 
    for (i = 0; i < M-1; i++)
        h = (h*d)%q;

    for (i = 0; i < M; i++)
    {
        p = (d * p + pat[i]) % q;
        t = (d * t + txt[i]) % q;
    }
 
    for (i = 0; i <= N - M; i++)
    {
 
        if ( p == t )
        {
            for (j = 0; j < M; j++)
            {
                if (txt[i + j] != pat[j])
                    break;
            }
            if (j == M)
            {
                printf("Pattern found at index %d \n", i);
            }
        }

        if ( i < N - M )
        {
            t = (d * (t - txt[i] * h) + txt[i + M]) % q;

            if (t < 0)
                t = (t + q);
        }
    }
}
 
int main()
{
    vector<char> txt;
    vector<char> pat;
    cout<<"Enter Text:";
    get_input(txt);
    cout<<"Enter Pattern to Search:";
    get_input(pat);
    char *text,*pattern;
    text=&txt[0];
    text[txt.size()]='\0';
    pattern=&pat[0];
    pattern[pat.size()]='\0';
    int q = 101;  // A prime number
    search(pattern, text, q);
    getchar();
    return 0;
}
