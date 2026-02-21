# Orry - OAuth Login System

A complete, fully functional login system with Google and Meta authentication that collects customer details.

## 📁 Project Structure

```
Orry2.0/
├── frontend/                 # React application
│   ├── src/
│   │   ├── pages/           # Login & Dashboard pages
│   │   ├── components/      # OAuth components
│   │   └── styles/          # CSS styling
│   ├── package.json
│   └── vite.config.js
│
└── backend/                  # Node.js Express API
    ├── controllers/         # Business logic
    ├── routes/              # API endpoints
    ├── middleware/          # Authentication
    ├── models/              # Data models
    ├── package.json
    └── server.js
```

## 🚀 Quick Start

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn

### Step 1: Frontend Setup

```bash
cd frontend
npm install
```

Create `.env.local`:
```
VITE_GOOGLE_CLIENT_ID=your_google_client_id
VITE_FACEBOOK_APP_ID=your_facebook_app_id
VITE_API_URL=http://localhost:5000/api
```

### Step 2: Backend Setup

```bash
cd backend
npm install
```

Create `.env`:
```
PORT=5000
FRONTEND_URL=http://localhost:5173

GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
JWT_SECRET=your_secure_random_key_here
```

### Step 3: Get OAuth Credentials

#### Google OAuth Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project → "Orry"
3. Enable APIs: Google Identity Service
4. Go to Credentials → Create OAuth 2.0 Web credentials
5. Authorized JavaScript origins:
   - `http://localhost:5173`
   - `http://localhost:5000`
6. Authorized redirect URIs:
   - `http://localhost:5173`
   - `http://localhost:5000`
7. Copy Client ID and Secret

#### Facebook/Meta OAuth Setup
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create new app → "Orry"
3. Add "Facebook Login" product
4. Settings → Configure:
   - Valid OAuth Redirect URIs: `http://localhost:5173/`
5. Get App ID and App Secret
6. In frontend `index.html`, replace `YOUR_FACEBOOK_APP_ID`

### Step 4: Run the Application

**Terminal 1 - Start Backend:**
```bash
cd backend
npm run dev
```
Backend will run on `http://localhost:5000`

**Terminal 2 - Start Frontend:**
```bash
cd frontend
npm run dev
```
Frontend will run on `http://localhost:5173`

## 📝 Features Implemented

### Frontend ✓
- [x] Clean, modern login page UI
- [x] Google OAuth login button
- [x] Meta/Facebook login button
- [x] Error handling and user feedback
- [x] Protected routes (Dashboard only for logged-in users)
- [x] User profile display
- [x] Logout functionality
- [x] Responsive design (mobile, tablet, desktop)
- [x] Loading states

### Backend ✓
- [x] Google token verification
- [x] Facebook token verification
- [x] JWT token generation
- [x] Customer data collection
- [x] Customer storage (in-memory or database)
- [x] Protected API routes
- [x] Error handling
- [x] CORS configuration

## 🔑 Authentication Flow

```
1. User clicks "Login with Google" or "Login with Meta"
   ↓
2. OAuth provider dialog opens
   ↓
3. User authenticates with provider
   ↓
4. Frontend receives provider token
   ↓
5. Frontend sends token to backend
   ↓
6. Backend verifies token with provider
   ↓
7. Backend creates/updates customer record
   ↓
8. Backend generates JWT token
   ↓
9. Frontend stores JWT and user data
   ↓
10. User redirected to dashboard
```

## 📊 Customer Data Collected

```json
{
  "id": "unique_id",
  "name": "User's Name",
  "email": "user@example.com",
  "picture": "profile_picture_url",
  "provider": "google" | "facebook",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 🔐 Security Features

- OAuth 2.0 token verification
- JWT token-based authentication
- Protected API routes
- CORS enabled
- Secure credential storage in environment variables
- Token expiration (7 days)

## 📦 API Endpoints

### Authentication
```
POST /auth/google
  Body: { token: "google_token" }
  Returns: { token: "jwt_token", user: {...} }

POST /auth/facebook
  Body: { id, name, email, picture, accessToken }
  Returns: { token: "jwt_token", user: {...} }

POST /auth/logout
  Returns: { message: "Logged out successfully" }
```

### Customer Management
```
GET /customers
  Headers: Authorization: Bearer <token>
  Returns: { total: number, customers: [...] }

GET /customers/profile/:id
  Headers: Authorization: Bearer <token>
  Returns: { customer_details }

PUT /customers/profile/:id
  Headers: Authorization: Bearer <token>
  Body: { name?, email?, phone? }
  Returns: { message, customer: {...} }
```

## 🎨 Customization

### Change Colors
Edit [frontend/src/styles/login.css](frontend/src/styles/login.css) and [frontend/src/styles/dashboard.css](frontend/src/styles/dashboard.css)

### Add More OAuth Providers
1. Add provider SDK to frontend
2. Create login component
3. Add provider controller in backend
4. Register route in authRoutes

### Use a Database
Replace in-memory storage in [backend/models/customer.js](backend/models/customer.js) with:
- MongoDB with Mongoose
- PostgreSQL with Sequelize
- Firebase Realtime Database

## 🐛 Troubleshooting

### "Invalid Google Token"
- Verify Google Client ID in `.env`
- Check OAuth credentials on Google Cloud Console
- Ensure redirect URIs are correct

### "Facebook Login Not Working"
- Verify Facebook App ID in `.env` and HTML
- Check OAuth redirect URIs on Facebook
- Clear browser cache and cookies

### "CORS Error"
- Verify FRONTEND_URL in backend .env
- Ensure Port 5173 is not blocked
- Check browser console for specific error

### "Token Not Working"
- Clear localStorage in browser DevTools
- Check JWT_SECRET is same in .env
- Verify token expiration (check console logs)

## 📱 Testing

### Test Google Login
1. Use test account: testuser@gmail.com
2. Check backend console for token verification
3. Verify user data in dashboard

### Test Facebook Login
1. Use test account connected to your Facebook app
2. Grant permissions when prompted
3. Verify user data in dashboard

## 🚀 Deployment

### Frontend (Vercel/Netlify)
```bash
npm run build
# Deploy 'dist' folder
```

Update environment variables:
- VITE_API_URL=https://api.yourdomain.com

### Backend (Heroku/Railway)
```bash
npm install
npm start
```

Update environment variables in hosting platform

## 📞 Support

For issues:
1. Check error messages in browser console
2. Check backend logs in terminal
3. Verify OAuth credentials and URLs
4. Clear cache and restart servers

## ✅ Checklist

- [ ] Google OAuth credentials obtained
- [ ] Facebook OAuth credentials obtained
- [ ] Frontend .env.local created
- [ ] Backend .env created
- [ ] `npm install` run in both folders
- [ ] Backend running on port 5000
- [ ] Frontend running on port 5173
- [ ] Can see login page at http://localhost:5173
- [ ] Google login works
- [ ] Facebook login works
- [ ] Dashboard displays after login
- [ ] Logout works correctly

## 📄 License

MIT

---

**Built with React, Node.js, Express, and OAuth 2.0**
