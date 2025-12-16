@echo off
echo ========================================
echo Starting Flutter Web with CORS DISABLED
echo ========================================
echo.
echo This will open Chrome with web security disabled.
echo WARNING: This is for DEVELOPMENT ONLY!
echo.
pause
echo.
echo Opening Chrome with CORS disabled...
start chrome.exe --user-data-dir="%TEMP%\chrome_dev_session" --disable-web-security --disable-features=VizDisplayCompositor --disable-site-isolation-trials
echo.
echo Waiting 3 seconds for Chrome to start...
timeout /t 3 /nobreak >nul
echo.
echo Starting Flutter Web...
echo The app will open in Chrome with CORS disabled
echo.
flutter run -d chrome

