@echo off
echo Starting Flutter Web with CORS disabled...
start chrome.exe --user-data-dir="C:/temp/chrome_dev" --disable-web-security --disable-features=VizDisplayCompositor http://localhost:8080
flutter run -d chrome --web-port=8080

