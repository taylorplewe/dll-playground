# DLL playground
I was really interested in one builds a DLL and how a PE executable (`.exe`) interacts with it. This repo is the result of my learning process that followed.

## Building
You must be on Windows and have the Visual Studio build tools installed. This repo was made with the VS 2022 build tools. Make sure you have access to `cl.exe`, `ml64.exe`, and `link.exe`. Windows Terminal makes this easy by clicking the + to open a new terminal tab, and selecting "Developer PowerShell for VS 20xx". (Alternatively, the build tools include scripts for entering a developer cmd or PS session; they essentially just add all the build tools to your PATH.)

Once the above build tools are in your PATH, just run

```powershell
.\build
```
