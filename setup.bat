@echo off
REM Orry OAuth Login System - Setup Script for Windows

echo 🚀 Starting Orry OAuth Login System Setup...
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js is not installed. Please install Node.js v16 or higher.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo ✓ Node.js version: %NODE_VERSION%
echo.

REM Setup Frontend
echo 📦 Setting up Frontend...
cd frontend
if not exist "node_modules" (
    echo Installing frontend dependencies...
    call npm install
    echo ✓ Frontend dependencies installed
) else (
    echo ✓ Frontend dependencies already installed
)

if not exist ".env.local" (
    echo.
    echo ⚠️  Create .env.local in frontend folder with:
    echo VITE_GOOGLE_CLIENT_ID=your_google_client_id
    echo VITE_FACEBOOK_APP_ID=your_facebook_app_id
    echo.
)

cd ..

REM Setup Backend
echo.
echo 📦 Setting up Backend...
cd backend
if not exist "node_modules" (
    echo Installing backend dependencies...
    call npm install
    echo ✓ Backend dependencies installed
) else (
    echo ✓ Backend dependencies already installed
)

if not exist ".env" (
    echo.
    echo ⚠️  Create .env in backend folder with:
    echo PORT=5000
    echo FRONTEND_URL=http://localhost:5173
    echo GOOGLE_CLIENT_ID=your_google_client_id
    echo GOOGLE_CLIENT_SECRET=your_google_client_secret
    echo FACEBOOK_APP_ID=your_facebook_app_id
    echo FACEBOOK_APP_SECRET=your_facebook_app_secret
    echo JWT_SECRET=your_secure_jwt_secret
    echo.
)

cd ..

echo.
echo ✅ Setup complete!
echo.
echo Next steps:
echo 1. Create .env files with your OAuth credentials
echo 2. Run backend: cd backend ^& npm run dev
echo 3. Run frontend: cd frontend ^& npm run dev
echo 4. Visit http://localhost:5173
echo.
pause
