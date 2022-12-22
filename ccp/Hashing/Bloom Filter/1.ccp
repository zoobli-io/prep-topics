#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
using namespace std;
 
#define POLYNOMIAL 0x04C11DB7L
#define M 32
#define K 4
typedef unsigned short int word16;
typedef unsigned int word32;
 
static word32 CrcTable[256];
char BFilter[M / 8];
word32 NumBytes;
 
void gen_crc_table(void);
word32 update_crc(word32 crc_accum, char *data_ptr, word32 data_size);
void mapBloom(word32 hash);
int testBloom(word32 hash);

int main()
{
    FILE *fp1;
    FILE *fp2;
    char inFile1[256];
    char inFile2[256];
    char inString[1024];
    word32 crc32;
    int retCode;
    word32 i;
    cout<<"------------------------------------------ "<<endl;
    cout<<"-  Program to implement a general Bloom filter\n";
    cout<<"------------------------------------------ "<<endl;
    NumBytes = M / 8;
    if ((M % 8) != 0)
    {
        cout<<"*** ERROR - M value must be divisible by 8 \n";
        exit(1);
    }
    for (i = 0; i < NumBytes; i++)
        BFilter[i] = 0x00;
    gen_crc_table();
    cout<<"File name of input list to add to filter ===========> ";
    cin>>inFile1;
    fp1 = fopen(inFile1, "r");
    if (fp1 == NULL)
    {
        cout<<"ERROR in opening input file #1 ("<<inFile1<<") *** \n";
        exit(1);
    }
    cout<<"File name of input list to check for match =========> ";
    cin>>inFile2;
    fp2 = fopen(inFile2, "r");
    if (fp2 == NULL)
    {
        cout<<"ERROR in opening input file #1 ("<<inFile2<<") *** \n";
        exit(1);
    }
    while (1)
    {
        fgets(inString, 1024, fp1);
        if (feof(fp1))
            break;
        for (i = 0; i < K; i++)
        {
            crc32 = update_crc(i, inString, strlen(inString));
            mapBloom(crc32);
        }
    }
    fclose(fp1);
    cout<<"-------------------------------------------------------- \n";
    cout<<"Bloom filter is (M = "<<M<<" bits and K = "<<K<<" mappings)... \n";
    for (i = 0; i < NumBytes; i++)
        printf("%2d", i);
    cout<<endl;
    for (i = 0; i < NumBytes; i++)
        printf("%02X", BFilter[i]);
    cout<<endl;
    cout<<"-----------------------------------------------------\n";
    cout<<"Matching strings are... \n";
 
    while(1)
    {
        fgets(inString, 1024, fp2);
        if (feof(fp2))
            break;
        for (i = 0; i < K; i++)
        {
            crc32 = update_crc(i, inString, strlen(inString));
            retCode = testBloom(crc32);
            if (retCode == 0)
	           break;
    }
    if (retCode == 1)
        cout<<inString;
  }
  fclose(fp2);
}

void gen_crc_table(void)
{
    register word32 crc_accum;
    register word16 i, j;
    for (i = 0; i < 256; i++)
    {
        crc_accum = ((word32) i << 24);
        for (j = 0; j < 8; j++)
        {
            if (crc_accum & 0x80000000L)
                crc_accum = (crc_accum << 1) ^ POLYNOMIAL;
            else
                crc_accum = (crc_accum << 1);
        }
        CrcTable[i] = crc_accum;
    }
}
word32 update_crc(word32 crc_accum, char *data_blk_ptr, word32 data_blk_size)
{
    register word32 i, j;
    for (j = 0; j < data_blk_size; j++)
    {
        i = ((int) (crc_accum >> 24) ^ *data_blk_ptr++) & 0xFF;
        crc_accum = (crc_accum << 8) ^ CrcTable[i];
    }
    crc_accum = ~crc_accum;
 
    return crc_accum;
}
void mapBloom(word32 hash)
{
    int tempInt;
    int bitNum;
    int byteNum;
    unsigned char mapBit;
    tempInt = hash % M;
    byteNum = tempInt / 8;
    bitNum = tempInt % 8;
 
    mapBit = 0x80;
    mapBit = mapBit >> bitNum;
 
    BFilter[byteNum] = BFilter[byteNum] | mapBit;
}
int testBloom(word32 hash)
{
    int tempInt;
    int bitNum;
    int byteNum;
    unsigned char testBit;
    int retCode;
    tempInt = hash % M;
    byteNum = tempInt / 8;
    bitNum = tempInt % 8;
 
    testBit = 0x80;
    testBit = testBit >> bitNum;
    if (BFilter[byteNum] & testBit)
        retCode = 1;
    else
        retCode = 0;
    return retCode;
}
