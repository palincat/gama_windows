@echo off
setlocal
cls

:main_menu
mode con: cols=59 lines=30
color 0B
cls

echo.
echo   =======================================================
echo.
echo          GPU API Manager for Android-based devices 
echo          (GAMA v1.3.1)
echo.
echo   =======================================================
echo.
echo     Hey there! What would you like the script to do?
echo.
echo      [1] Set GPU API to Vulkan, then close all apps
echo.
echo      [2] Set GPU API to OpenGL, then close all apps
echo.
echo      [3] Launch all app
echo.
echo     Additionally...
echo.
echo      [4] Visit GAMA's GitHub repository
echo.
echo      [5] Exit
echo.
echo.
echo    ======================================================
echo.

echo     Enter your choice: 
choice /c 12345 /n >nul
goto screen%errorlevel%

:screen1
call :set_vulkan_kill_apps
goto :eof

:screen2
call :set_opengl_kill_apps
goto :eof

:screen3
call :launch_all_apps
goto :eof

:screen4
start https://github.com/popovicialinc/gama
goto :main_menu

:screen5
exit



:set_vulkan_kill_apps
color 0F
cls
echo.
echo      Setting GPU API to Vulkan and stopping all apps...
echo.
adb shell "(setprop debug.hwui.renderer skiavk; for a in $(pm list packages | grep -v ia.mo | cut -f2 -d:); do am force-stop \"$a\"; done) >/dev/null 2>&1"

if %ERRORLEVEL%==0 (
    color 0A
    echo.
    echo      Vulkan set - All apps have been stopped.
    echo.
    pause
    goto :main_menu
)

if not %ERRORLEVEL%==0 (
    color 0C
    echo.
    echo      Something went wrong. Is your device connected?
    echo.
    pause
    goto :main_menu
)


:set_opengl_kill_apps
color 0F
cls
echo.
echo      Setting GPU API to OpenGL and stopping all apps...
echo.
adb shell "(setprop debug.hwui.renderer opengl; for a in $(pm list packages | grep -v ia.mo | cut -f2 -d:); do am force-stop \"$a\"; done) >/dev/null 2>&1"


if %ERRORLEVEL%==0 (
    color 0A
    echo.
    echo      OpenGL set - All apps have been stopped.
    echo.
    pause
    goto :main_menu
)

if not %ERRORLEVEL%==0 (
    color 0C
    echo.
    echo      Something went wrong. Is your device connected?
    echo.
    pause
    goto :main_menu
)



:launch_all_apps
mode con: cols=89 lines=30
color 0F
cls
echo.
echo    ===================================================================================
echo.
echo      WARNING: Launching all apps may heat up your device! It may also take a while...
echo.
echo    ===================================================================================
echo.
echo.     Do you REALLY want to launch all apps? [Y/N]
choice /c YN >nul
goto option%errorlevel%

:option1
call :launch_apps

:option2
call :main_menu



:launch_apps
color 0F
cls
echo.
echo      Launching all apps in 2 seconds...
timeout /t 2 >nul
echo.
adb shell "for pkg in $(pm list packages | cut -f2 -d:); do monkey -p "$pkg" -c android.intent.category.LAUNCHER 1; done"
pause
goto :main_menu

