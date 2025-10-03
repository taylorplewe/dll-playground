----------------
C LANGUAGE DLL
----------------

compile helper.c with:

	> cl /LD helper.c

as long as it decorates its functions with

	__declspec(dllexport) int func...

then it will create a .lib file alongside the .dll. As I understand it this helps the linker map functions to memory addresses or something.

Then in the main C file you would do:

	__declspec(dllimport) int func...

(with the same signature)
and compile with:

	> cl main.c helper.lib

and you can just call "func" from within main.c like normal, as if it was defined inside there.


----------------
x64 ASSEMBLY DLL
----------------

I was also able to create a functioning DLL with C-callable functions from an x86_64 assmbler source file.
The contents of asmhelper.s are:

.code
addTwoNums proc export
	mov eax, ecx
	add eax, edx
	ret
addTwoNums endp
end

I then assemble that with:

	> ml64 asmhelper.s /c

and then link into a .dll with:

	> link asmhelper.obj /dll /noentry

and voil-a, asmhelper.dll is created. Then main.c can look like:

--- main.c
#include <stdio.h>
#include <windows.h>

typedef int (CALLBACK* ADDTWONUMS)(UINT,UINT); // define the function signature for C

int main(int argc, char** argv) {
	int num1 = 3;
	int num2 = 4;

	HINSTANCE asmHelperDll = LoadLibrary("asmhelper");
	ADDTWONUMS addTwoNums = (ADDTWONUMS)GetProcAddress(asmHelperDll, "addTwoNums");
	int asmRes = addTwoNums(num1, num2);
	printf("res from asmhelper.dll: %d\n", asmRes);
	FreeLibrary(asmHelperDll);

	return 0;
}
---

and just compile that like normal:

	> cl main.c

and run:

	> main.exe

and you get:

	< res from asmhelper.dll: 7



-----

The C part I had help from ChatGPT. The assembly part, almost none. I just struggled making a dll from ml64, doing "ml64 asmhelper.s /link /dll /noentry" insisted on creating a .exe. I could only get a .dll from separating the assemble and link steps. But other than that, I figured everything out just with the help doc.