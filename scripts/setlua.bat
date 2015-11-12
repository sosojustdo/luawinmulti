@echo off

REM Save the original path in case this file is called more than once
if "%BEFORE_LUA_PATH_BACKUP%"=="" (
   set "BEFORE_LUA_PATH_BACKUP=%PATH%"
) else (
   set "PATH=%BEFORE_LUA_PATH_BACKUP%"
)
SET myownpath=%~dp0
IF "%1"=="51" goto VersionOK
IF "%1"=="52" goto VersionOK
IF "%1"=="53" goto VersionOK
IF "%1"=="" goto NoVersion

echo Usage:
echo    %~n0 ^<LuaVersion^>
echo Where the optional LuaVersion is any of; 51, 52, or 53
exit /b 1

:VersionOK
copy "%myownpath%\lua%1.exe" "%myownpath%\lua.exe"
Echo Done. Installed lua%1.exe as lua.exe.
REM create wrapper to LuaRocks
ECHO @ECHO OFF                          >  "%~dp0luarocks.bat"
ECHO SETLOCAL                           >> "%~dp0luarocks.bat"
ECHO CALL "%%~dpn0%1.bat" %%*           >> "%~dp0luarocks.bat"
ECHO exit /b %%ERRORLEVEL%%             >> "%~dp0luarocks.bat"
Echo Done. Installed luarocks%1.bat as luarocks.bat.

:NoVersion

REM setup system path
set path=%myownpath%;%PATH%
REM setup Lua paths for 5.1
set LUA_PATH=;;%myownpath%\..\lib\lua\5.1\?.dll
set LUA_CPATH=;;%myownpath%\..\share\lua\5.1\?.lua;%myownpath%\..\share\lua\5.1\?\init.lua
REM setup Lua paths for 5.2
set LUA_PATH_5_2=;;%myownpath%\..\lib\lua\5.2\?.dll
set LUA_CPATH_5_2=;;%myownpath%\..\share\lua\5.2\?.lua;%myownpath%\..\share\lua\5.2\?\init.lua
REM setup Lua paths for 5.3, defaults will do, but we need to set something to prevent the LUA_PATH from overruling
set LUA_PATH_5_3=;;
set LUA_CPATH_5_3=;;

:cleanup
set myownpath=
