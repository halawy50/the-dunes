@echo off
echo ========================================
echo Flutter Web Deployment to Vercel
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev
    pause
    exit /b 1
)

echo [1/6] Checking Flutter installation...
flutter --version
echo.

echo [2/6] Getting Flutter dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo [3/6] Cleaning previous build...
if exist build\web (
    rmdir /s /q build\web
)
echo.

echo [4/6] Building Flutter web (release mode)...
flutter build web --release
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)
echo.

echo [5/6] Copying vercel.json to build/web...
copy vercel.json build\web\vercel.json >nul
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Failed to copy vercel.json, but continuing...
)
echo.

echo [6/6] Checking if Node.js and npm are installed...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b 1
)
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] npm is not installed
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b 1
)
echo Node.js and npm are installed. Using npx vercel...
echo.

echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Navigate to build/web directory: cd build\web
echo 2. Deploy to Vercel: npx vercel --prod
echo.
echo Or run this command now:
echo   cd build\web ^&^& npx vercel --prod
echo.
set /p deploy="Deploy now? (y/n): "
if /i "%deploy%"=="y" (
    cd build\web
    echo.
    echo Deploying to Vercel...
    npx vercel --prod
) else (
    echo.
    echo Build files are ready in: build\web
    echo You can deploy manually later by running:
    echo   cd build\web
    echo   npx vercel --prod
)

pause
