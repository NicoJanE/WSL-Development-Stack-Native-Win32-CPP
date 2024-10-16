@echo on
setlocal

:: Update these if needed
:: Define a constant for the Visual Studio Command Prompt path
set "VSDEV_CMD_PATH=C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat"

:: Check if an argument was provided
if "%~1"=="" (
    echo Usage: %0 [task]
    echo Available tasks: build-release, build-debug, clean-all
    exit /b 1
)

:: Main function, task is 1st param
set task=%~1



:: Directors
:: ===========================================================
::

if /i "%task%"=="build-release" (
    echo "Starting Release Build"
    set "TYPE=Release" 
    set "BUILD_DIR=_build64"
    goto build
)

if /i "%task%"=="build-debug" (
    echo "Starting Debug Build"
    set "TYPE=Debug" 
    set "BUILD_DIR=_build64"
    goto build
)

if /i "%task%"=="run-release" (
    echo "Starting Release run"
    set "TYPE=Release" 
    set "BUILD_DIR=_build64"
    goto run
)

if /i "%task%"=="run-debug" (
    echo "Starting Release run"
    set "TYPE=Debug" 
    set "BUILD_DIR=_build64"
    goto run
)



if /i "%task%"=="config-make64" (
    echo "Starting configuriing make fro 64 app development"
    set "TYPE=x64" 
    set "BUILD_DIR=_build64"
    goto config-make64
)

if /i "%task%"=="clean-all" (
    set "DIRS=_build64"
    goto clean
)

if /i "%task%"=="clean-debug" (
    set "DIRS=_build64\bin\Debug _build64\outapp.dir\Debug"
    goto clean
)

if /i "%task%"=="clean-release" (
    set "DIRS=_build64\bin\Release _build64\outapp.dir\Release"
    goto clean
)

echo Unknown task: %task% 
exit /b 1 :: End  Excecutors

:: End Directors
:: ===========================================================




:: Excecutors
:: ===========================================================
::
:: Build function
:build
echo Building the project...
call "%VSDEV_CMD_PATH%"
cmake --build %BUILD_DIR% --config %TYPE%
goto end

:: configure make 64
:: cmd.exe /c "call "C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/VsDevCmd.bat"     && cmake -S . -B build  -G "Visual Studio 17 2022" -A x64"
:config-make64
echo Configuring the make project files...
call "%VSDEV_CMD_PATH%"
cmake -S . -B %BUILD_DIR%  -G "Visual Studio 17 2022" -A x64
goto end


:://            "call "C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/VsDevCmd.bat" && ".\\build\\bin\\Release\\out32.exe" "
:run
echo Run...
call "%VSDEV_CMD_PATH%"
 %BUILD_DIR%\\bin\\%TYPE%\\outapp.exe  
goto end



:: Clean function
:clean
echo Cleaning the build directory...
rd /s /q %DIRS%
goto end

:: End  Excecutors
:: ===========================================================



:end
echo Task %task% completed.
endlocal
exit /b 0
