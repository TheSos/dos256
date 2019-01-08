@echo off
call compile.bat %1
if errorlevel 1 goto error
%1.com
goto end
:error
echo [ERROR]
:end
