@echo off
cls
echo  = ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ =
echo  = Hey there! This script will:                          =
echo  = Force Vulkan rendering and force-stop all apps;       =
echo  = (Optionally) Launch all apps.                         =
echo  = ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ =

echo.
pause
echo.

echo Step 1: Setting renderer to Vulkan and force-stopping all apps...
adb shell "(setprop debug.hwui.renderer skiavk;for a in $(pm list packages|grep -v ia.mo|cut -f2 -d:);do am force-stop "$a"&done)>/dev/null 2>&1&"
echo.

echo Done! You can safely close this panel.
echo.

echo If you want to launch all apps . . . 
pause
echo.

echo Your device will get quite warm. Are you ABSOLUTELY sure you want to launch ALL apps?
pause

echo Launching all apps...
adb shell "for pkg in $(pm list packages | cut -f2 -d:); do monkey -p "$pkg" -c android.intent.category.LAUNCHER 1; done"
echo All apps have been launched! You should close them from the Recents menu. Script completed.
pause
exit