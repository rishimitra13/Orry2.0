#!/bin/bash

# Orry OAuth Login System - Setup Script

echo "🚀 Starting Orry OAuth Login System Setup..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js v16 or higher."
    exit 1
fi

echo "✓ Node.js version: $(node --version)"
echo ""

# Setup Frontend
echo "📦 Setting up Frontend..."
cd frontend
if [ ! -d "node_modules" ]; then
    npm install
    echo "✓ Frontend dependencies installed"
else
    echo "✓ Frontend dependencies already installed"
fi

if [ ! -f ".env.local" ]; then
    echo ""
    echo "⚠️  Create .env.local in frontend folder with:"
    echo "VITE_GOOGLE_CLIENT_ID=your_google_client_id"
    echo "VITE_FACEBOOK_APP_ID=your_facebook_app_id"
    echo ""
fi

cd ..

# Setup Backend
echo ""
echo "📦 Setting up Backend..."
cd backend
if [ ! -d "node_modules" ]; then
    npm install
    echo "✓ Backend dependencies installed"
else
    echo "✓ Backend dependencies already installed"
fi

if [ ! -f ".env" ]; then
    echo ""
    echo "⚠️  Create .env in backend folder with:"
    echo "PORT=5000"
    echo "FRONTEND_URL=http://localhost:5173"
    echo "GOOGLE_CLIENT_ID=your_google_client_id"
    echo "GOOGLE_CLIENT_SECRET=your_google_client_secret"
    echo "FACEBOOK_APP_ID=your_facebook_app_id"
    echo "FACEBOOK_APP_SECRET=your_facebook_app_secret"
    echo "JWT_SECRET=your_secure_jwt_secret"
    echo ""
fi

cd ..

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Create .env files with your OAuth credentials"
echo "2. Run backend: cd backend && npm run dev"
echo "3. Run frontend: cd frontend && npm run dev"
echo "4. Visit http://localhost:5173"
