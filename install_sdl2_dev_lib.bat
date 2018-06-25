:: Title:        install_sdl2_dev_lib.bat
:: Description:  Installs the SDL2 development libraries on the specified path.
:: Requirements: Windows environment. 
::               7z and wget must be in the path environment variable.
:: Author:       azarrias
:: Date:         20180622
:: Usage:        install_sdl2_dev_lib.bat "C:\libraries"
::================================================================================
@echo off
setlocal enabledelayedexpansion

set V_LIB_VERSION=2.0.8

set v_arg_count=0
for %%x in (%*) do (
   set /A v_arg_count+=1
)

if %v_arg_count% NEQ 1 (
   echo ERROR: You entered %v_arg_count% arguments.
   echo This script must be run with exactly one argument
   echo (the path on which to install this library^).
   echo e.g. %~nx0 "C:\libraries"
   exit /b 1
)

cd /d %SYSTEMDRIVE%\
echo INFO: You are about to install SDL2 development libraries v%V_LIB_VERSION%
echo INFO: Looking for available compilers...
for /f "tokens=*" %%x in ('dir gcc.exe /b /s') do (
   set v_compiler_path=%%x
   set v_compiler=mingw
   echo INFO: Found %%x
)
for /f "tokens=*" %%x in ('dir cl.exe /b /s') do (
   set v_compiler_path=%%x
   set v_compiler=VC
   echo INFO: Found %%x
)

if "%v_compiler%"=="VC" (
   set v_file_extension=.zip
) else if "%v_compiler%"=="mingw" (
   set v_file_extension=.tar.gz
) else (
   echo ERROR: No compiler was found in the system
   exit /b 1
)

echo INFO: Downloading Windows development libraries for %v_compiler%
wget https://www.libsdl.org/release/SDL2-devel-%V_LIB_VERSION%-%v_compiler%%v_file_extension% -P %TEMP% --continue
cd %TEMP%
if "%v_file_extension%"==".zip" (
   7z x SDL2-devel-%V_LIB_VERSION%-%v_compiler%%v_file_extension%
) else if "%v_file_extension%"==".tar.gz" (
   7z x SDL2-devel-%V_LIB_VERSION%-%v_compiler%%v_file_extension% -so | 7z x -aoa -si -ttar
) else (
   echo ERROR: Unknown file extension
   exit /b 1
)

if "%v_compiler%"=="mingw" (
   for /f "tokens=*" %%x in ('%v_compiler_path% -dumpmachine') do (
	  set v_mingw_arch=%%x
   )
   if "!v_mingw_arch!"=="mingw32" (
      echo INFO: TODO - Grab mingw32 folder (32 bit version)
   )
) else if "%v_compiler%"=="VC" (
   echo INFO: TODO - Copy lib and include folders to the desired location
)

::cd /d D:\Users\azarrias\Documents\GitHub\batch-util

endlocal