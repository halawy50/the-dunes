@echo off
REM Script to build and deploy Flutter Web to Vercel

echo Cleaning project...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building web release...
flutter build web --release

echo.
echo Build completed!
echo.
echo To deploy to Vercel:
echo    cd build\web
echo    npx vercel --prod
echo.
echo Or upload build\web folder contents via Vercel Dashboard

pause

