call generateParser.bat
dotnet build -c Release --no-incremental -v d SLangParser.sln

@IF %ERRORLEVEL% NEQ 0 PAUSE
move obj\Release\SLangParser.dll ..\..\..\bin\
move obj\Release\SLangParser.pdb ..\..\..\bin\
@IF %ERRORLEVEL% NEQ 0 PAUSE