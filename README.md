# DLL playground
I was really interested in how one builds a DLL and how a PE executable (`.exe`) interacts with it. This repo is the result of my learning process that followed.

This project contains a DLL built from a C file, exporting functions, and another DLL built from an x86_64 MASM assembly file, also exporting functions.

## Building
You must be on Windows and have the Visual Studio build tools installed. This repo was made with the VS 2022 build tools. Make sure you have access to `cl.exe`, `ml64.exe`, and `link.exe`. Windows Terminal makes this easy by clicking the + to open a new terminal tab, and selecting "Developer PowerShell for VS 20xx". (Alternatively, the build tools include scripts for entering a developer cmd or PS session; they essentially just add all the build tools to your PATH.)

Once the above build tools are in your PATH, just run

```powershell
.\build
```

to build the main C file and both DLLs. To build just one thing, run any one of

```powershell
.\build --main
.\build --c-dll
.\build --asm-dll
```

Append the `--nologo` option to hide the Microsoft signature at the top of each build output.
