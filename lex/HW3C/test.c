#include <stdio.h>
#include <string.h>

int main ()
{
  char str[] = " 0x2222";
  char hex[10];
  char *pch;
  pch=strchr(str,'0');
  printf ("found at %d\n",pch-str+1);
  int start = pch-str;
  strncpy(hex,str+start,10);

  printf("%s",hex);
  return 0;
}
