:: Title:            unity_multi_platform_build.bat
:: Description:      Builds unity projects for multiple platforms
:: Requirements:     Windows environment
::                   7z and wget must be in the path environment variable
:: Author:           azarrias
:: Date:             20181202
:: Usage:            unity_multi_platform_build.bat "super-sparty-bros" "1.0.0"

@echo off
setlocal enabledelayedexpansion

set v_arg_count=0
for %%x in (%*) do (
   set /A v_arg_count+=1
)

if %v_arg_count% NEQ 2 (
   echo ERROR: You entered %v_arg_count% arguments.
   echo This script must be run with exactly two arguments
   echo (the base name of the build plus the version^).
   echo e.g. %~nx0 "super-sparty-bros" "1.0.0"
   exit /b 1
)

set V_BASE_NAME=%1
set V_VERSION=%2
set V_BUILD_NAME=%V_BASE_NAME%-%V_VERSION%

set V_PLATFORMS[0]=android
set V_PLATFORMS[1]=webgl
set V_PLATFORMS[2]=win_x86_64

set v_iter=0

:CreateZip
if defined V_PLATFORMS[%v_iter%] (
    call 7z.exe a %V_BUILD_NAME%-%%V_PLATFORMS[%v_iter%]%%.zip %V_BUILD_NAME%-%%V_PLATFORMS[%v_iter%]%%
    set /A v_iter+=1
    GOTO :CreateZip
)

:: Create .tar.gz for linux build
7z.exe a -ttar -so %V_BUILD_NAME%-lin_x86_64.tar %V_BUILD_NAME%-lin_x86_64 | 7z.exe a -si %V_BUILD_NAME%-lin_x86_64.tar.gz

endlocal