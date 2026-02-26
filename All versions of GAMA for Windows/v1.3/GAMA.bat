@echo off
setlocal
cls


:main_menu
cls
echo =============================================================
echo.
echo   GPU API Manager for Android-based devices (GAMA v1.3)
echo.
echo =============================================================
echo.
echo  Hey there! What would you like the script to do?
echo.
echo  [1] Set GPU API to Vulkan, then close all apps
echo.
echo  [2] Set GPU API to OpenGL, then close all apps
echo.
echo  [3] Launch every app (optional)
echo.
echo  Additionally...
echo.
echo  [4] Visit GAMA's GitHub repository
echo.
echo  [5] Exit
echo.
echo.
echo =============================================================
echo.

choice /c 12345 /m "Select an option: "
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
start https://github.com/popovicialinc/s23_oneui7_vulkan
goto :main_menu

:screen5
exit



:set_vulkan_kill_apps
cls
echo Setting GPU API to Vulkan and stopping all apps...
adb shell "(setprop debug.hwui.renderer skiavk;for a in $(pm list packages|grep -v ia.mo|cut -f2 -d:);do am force-stop \"$a\"&done)>/dev/null 2>&1&"

IF ERRORLEVEL 1 (
	echo.
	echo Something went wrong. Is your device connected?
	pause
	goto :main_menu
)

echo.
echo Vulkan set - All apps have been stopped.
echo.
pause
goto :main_menu



:set_opengl_kill_apps
cls
echo Setting GPU API to OpenGL and stopping all apps...
adb shell "(setprop debug.hwui.renderer opengl;for a in $(pm list packages|grep -v ia.mo|cut -f2 -d:);do am force-stop \"$a\"&done)>/dev/null 2>&1&"

IF ERRORLEVEL 1 (
	echo.
	echo Something went wrong. Is your device connected?
	pause
	goto :main_menu
)

echo OpenGL set - All apps have been stopped.
echo.
pause
goto :main_menu



:launch_all_apps
cls
echo WARNING: Launching all apps may heat up your device! It may also take a while...
choice /c YN /m "Do you REALLY want to launch all apps? "
goto option%errorlevel%

:option1
call :launch_apps
goto :eof

:option2
call :main_menu
goto :eof



:launch_apps
cls
echo [2/2] Launching all apps...
adb shell "for pkg in $(pm list packages | cut -f2 -d:); do monkey -p \"$pkg\" -c android.intent.category.LAUNCHER 1; done"
IF ERRORLEVEL 1 (
	echo.
	echo Something went wrong. Is your device connected?
	pause
	goto :main_menu
)
echo All apps have been launched! Close them via the Recents menu.
pause
call :main_menu
goto :eof
