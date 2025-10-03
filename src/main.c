#include <stdio.h>
#include <windows.h>

typedef int (CALLBACK* ADDTWONUMS)(UINT,UINT);

__declspec(dllimport) int multiply(int, int);

int main(int argc, char** argv) {
  int num1 = 3;
  int num2 = 4;


  // helper.dll

  int res = multiply(num1, num2);
  printf("res from helper.dll: %d\n", res);


  // asmhelper.dll
  
  HINSTANCE asmHelperDll = LoadLibrary("asmhelper");
  ADDTWONUMS addTwoNums = (ADDTWONUMS)GetProcAddress(asmHelperDll, "addTwoNums");
  int asmRes = addTwoNums(num1, num2);
  printf("res from asmhelper.dll: %d\n", asmRes);
  FreeLibrary(asmHelperDll);
  
  return 0;
}
