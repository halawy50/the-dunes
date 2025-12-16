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

echo [1/4] Checking Flutter installation...
flutter --version
echo.

echo [2/4] Getting Flutter dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo [3/4] Building Flutter web (release mode)...
flutter build web --release
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)
echo.

echo [4/4] Checking if Vercel CLI is installed...
where vercel >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Vercel CLI is not installed
    echo Installing Vercel CLI...
    call npm install -g vercel@latest
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to install Vercel CLI
        echo Please install Node.js and npm first
        pause
        exit /b 1
    )
)
echo.

echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Navigate to build/web directory: cd build\web
echo 2. Deploy to Vercel: vercel --prod
echo.
echo Or run this command now:
echo   cd build\web ^&^& vercel --prod
echo.
set /p deploy="Deploy now? (y/n): "
if /i "%deploy%"=="y" (
    cd build\web
    echo.
    echo Deploying to Vercel...
    vercel --prod
) else (
    echo.
    echo Build files are ready in: build\web
    echo You can deploy manually later by running:
    echo   cd build\web
    echo   vercel --prod
)

pause
