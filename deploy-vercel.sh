#!/bin/bash

echo "========================================"
echo "Flutter Web Deployment to Vercel"
echo "========================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "[ERROR] Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

echo "[1/4] Checking Flutter installation..."
flutter --version
echo ""

echo "[2/4] Getting Flutter dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to get dependencies"
    exit 1
fi
echo ""

echo "[3/4] Building Flutter web (release mode)..."
flutter build web --release
if [ $? -ne 0 ]; then
    echo "[ERROR] Build failed"
    exit 1
fi
echo ""

echo "[4/4] Checking if Vercel CLI is installed..."
if ! command -v vercel &> /dev/null; then
    echo "[WARNING] Vercel CLI is not installed"
    echo "Installing Vercel CLI..."
    npm install -g vercel@latest
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to install Vercel CLI"
        echo "Please install Node.js and npm first"
        exit 1
    fi
fi
echo ""

echo "========================================"
echo "Build completed successfully!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Navigate to build/web directory: cd build/web"
echo "2. Deploy to Vercel: vercel --prod"
echo ""
read -p "Deploy now? (y/n): " deploy

if [[ "$deploy" == "y" || "$deploy" == "Y" ]]; then
    cd build/web
    echo ""
    echo "Deploying to Vercel..."
    vercel --prod
else
    echo ""
    echo "Build files are ready in: build/web"
    echo "You can deploy manually later by running:"
    echo "  cd build/web"
    echo "  vercel --prod"
fi
