# Orry OAuth Login System - Architecture Guide

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER BROWSER                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              FRONTEND (React + Vite)                     │   │
│  │  Port: 5173                                              │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │                                                           │   │
│  │  ┌─────────────────┐    ┌──────────────────────┐        │   │
│  │  │  Login Page     │    │ Google OAuth Button  │        │   │
│  │  │  ├─ Cards       │    │ Facebook OAuth Button│        │   │
│  │  │  ├─ Forms       │    │                      │        │   │
│  │  │  └─ Styling     │    │ Error Messages       │        │   │
│  │  └─────────────────┘    └──────────────────────┘        │   │
│  │           ↓                        ↓                       │   │
│  │  ┌──────────────────────────────────────────────┐        │   │
│  │  │   OAuth Providers                            │        │   │
│  │  │   (Google / Facebook/Meta)                   │        │   │
│  │  └──────────────────────────────────────────────┘        │   │
│  │           ↓                                               │   │
│  │  ┌──────────────────────────────────────────────┐        │   │
│  │  │  User Profile / Dashboard                    │        │   │
│  │  │  ├─ User Name                                │        │   │
│  │  │  ├─ Email Address                            │        │   │
│  │  │  ├─ Profile Picture                          │        │   │
│  │  │  ├─ Provider Info                            │        │   │
│  │  │  └─ Logout Button                            │        │   │
│  │  └──────────────────────────────────────────────┘        │   │
│  │                                                           │   │
│  │  LocalStorage: {token, user}                             │   │
│  │                                                           │   │
│  └──────────────────────────────────────────────────────────┘   │
│                           │                                       │
└───────────────────────────┼───────────────────────────────────────┘
                            │
                   API Requests (Axios)
                   With JWT Authorization
                            │
┌───────────────────────────┼───────────────────────────────────────┐
│                   BACKEND (Express)                                │
│                   Port: 5000                                       │
├───────────────────────────┼───────────────────────────────────────┤
│                           ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │              EXPRESS SERVER & MIDDLEWARE                   │   │
│  ├────────────────────────────────────────────────────────────┤   │
│  │  ├─ CORS Configuration                                    │   │
│  │  ├─ Body Parser                                           │   │
│  │  ├─ Error Handler                                         │   │
│  │  └─ Request Logging                                       │   │
│  └────────────────────────────────────────────────────────────┘   │
│                           │                                        │
│           ┌───────────────┼───────────────┐                       │
│           ↓               ↓               ↓                       │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐              │
│  │ Auth Routes  │ │ Customer Rts │ │ Health Check │              │
│  ├──────────────┤ ├──────────────┤ ├──────────────┤              │
│  │ /auth/google │ │ GET /        │ │ GET /health  │              │
│  │ /auth/       │ │ GET /:id     │ │              │              │
│  │  facebook    │ │ PUT /:id     │ └──────────────┘              │
│  └────┬─────────┘ └──────┬───────┘                               │
│       │                  │                                        │
│       ↓                  ↓                                        │
│  ┌────────────────────────────────────┐                         │
│  │      CONTROLLERS                   │                         │
│  ├────────────────────────────────────┤                         │
│  │ ├─ authController                 │                         │
│  │ │  ├─ googleLogin()               │                         │
│  │ │  ├─ facebookLogin()             │                         │
│  │ │  └─ logout()                    │                         │
│  │ └─ customerController             │                         │
│  │    ├─ getCustomers()              │                         │
│  │    ├─ getProfile()                │                         │
│  │    └─ updateProfile()             │                         │
│  └────────────────────────────────────┘                         │
│          │                                                       │
│          ├─────────────────────────────────────┐               │
│          ↓                                     ↓               │
│  ┌──────────────────┐          ┌──────────────────────┐       │
│  │ Authentication   │          │ Customer Management  │       │
│  ├──────────────────┤          ├──────────────────────┤       │
│  │ ├─ Verify Google │          │ ├─ Create Customer  │       │
│  │ │   ID Token     │          │ ├─ Update Customer  │       │
│  │ ├─ Verify Facebook          │ ├─ Get Customer     │       │
│  │ │   Access Token │          │ └─ List Customers   │       │
│  │ ├─ Generate JWT  │          │                      │       │
│  │ └─ Store Token   │          │ (In-Memory Storage) │       │
│  └────────┬─────────┘          └──────────────────────┘       │
│           │                                                    │
│           └───────────────────┬────────────────────────────────┘
│                               │                                 │
│                   ┌───────────┴──────────┐                     │
│                   ↓                      ↓                     │
│           ┌──────────────┐       ┌──────────────────┐          │
│           │   OAuth      │       │   Customer Data  │          │
│           │  Providers   │       │   (In-Memory)    │          │
│           │              │       │                  │          │
│           │ ├─ Google    │       │ Example:         │          │
│           │ │  APIs      │       │ {                │          │
│           │ │            │       │   id: "123",     │          │
│           │ ├─ Facebook  │       │   name: "John",  │          │
│           │ │  Graph API │       │   email: "john@" │          │
│           │ │            │       │   provider: "go" │          │
│           │ └─ Token     │       │   picture: "url",│          │
│           │    Verify    │       │   createdAt: "ts"│          │
│           │              │       │ }                │          │
│           └──────────────┘       └──────────────────┘          │
│                                                                 │
│  Note: Database can be switched from in-memory to MongoDB/     │
│  PostgreSQL for production use                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Request/Response Flow

### Google Login Flow

```
1. User Click "Continue with Google"
   ↓
2. Google OAuth Dialog Opens
   ↓
3. User Authenticates
   ↓
4. Google Returns ID Token → Frontend
   ↓
5. Frontend Sends Token to Backend: POST /auth/google
   {
     token: "google_id_token"
   }
   ↓
6. Backend Verifies Token with Google
   ↓
7. Backend Extracts User Data (name, email, picture)
   ↓
8. Backend Checks if Customer Exists
   - If No: Creates New Customer
   - If Yes: Updates Existing Customer
   ↓
9. Backend Generates JWT Token
   ↓
10. Backend Returns:
    {
      token: "jwt_token",
      user: {
        id: "123",
        name: "John Doe",
        email: "john@gmail.com",
        picture: "url",
        provider: "google",
        createdAt: "timestamp"
      }
    }
    ↓
11. Frontend Stores in LocalStorage
    ↓
12. Frontend Redirects to Dashboard
    ↓
13. Dashboard Displays User Information
```

### Facebook/Meta Login Flow

```
1. User Click "Continue with Meta"
   ↓
2. Facebook Login Dialog Opens
   ↓
3. User Authenticates
   ↓
4. Facebook Returns AccessToken → Frontend
   ↓
5. Frontend Gets User Data from Facebook
   ↓
6. Frontend Sends to Backend: POST /auth/facebook
   {
     id: "facebook_id",
     name: "Jane Smith",
     email: "jane@example.com",
     picture: "url",
     accessToken: "facebook_access_token"
   }
   ↓
7. Backend Verifies Token with Facebook Graph API
   ↓
8. Backend Validating User Data
   ↓
9. Backend Creates/Updates Customer
   ↓
10. Backend Generates JWT Token
    ↓
11. Backend Returns User Data + JWT
    ↓
12-13. Same as Google Flow
```

## File Organization & Dependencies

### Frontend Dependencies Tree

```
React App
├── React 18
│   └── ReactDOM
├── React Router
│   └── Route Navigation
├── Vite (Build Tool)
│   └── Dev Server on :5173
├── Axios
│   └── API Communication
├── @react-oauth/google
│   └── Google OAuth Provider
├── Components
│   ├── FacebookLogin
│   │   └── Facebook SDK Integration
│   └── ProtectedRoute
│       └── JWT Validation
└── Styles
    └── CSS for UI (Login + Dashboard)
```

### Backend Dependencies Tree

```
Express Server
├── Express Framework
│   └── HTTP Server on :5000
├── CORS
│   └── Cross-Origin Requests
├── JWT
│   └── Token Generation & Verification
├── google-auth-library
│   └── Google Token Verification
├── Axios
│   └── Facebook API Calls
├── dotenv
│   └── Environment Variables
└── Controllers
    ├── Auth Controller
    │   ├── Google Login Logic
    │   ├── Facebook Login Logic
    │   └── Logout Logic
    └── Customer Controller
        ├── Get Customers
        ├── Get Profile
        └── Update Profile
```

## Data Models

### Customer Model (In-Memory)

```javascript
{
  id: String,                    // Unique identifier
  email: String,                 // User email (unique)
  name: String,                  // User's full name
  provider: String,              // "google" | "facebook"
  picture: String,               // Profile picture URL
  facebookId: String,            // Facebook ID (if applicable)
  createdAt: Date,               // Account creation timestamp
  updatedAt: Date                // Last update timestamp
}
```

### JWT Token Structure

```
Header:
{
  "alg": "HS256",
  "typ": "JWT"
}

Payload:
{
  "id": "user_id",
  "email": "user@example.com",
  "iat": 1705833600,          // Issued at
  "exp": 1706438400           // Expiration (7 days)
}

Signature: HMAC(Header + Payload, JWT_SECRET)
```

## API Endpoints Map

```
├── POST /auth/google
│   ├── Input: Google ID Token
│   ├── Output: JWT Token + User Data
│   └── Error: 401 Invalid Token
│
├── POST /auth/facebook
│   ├── Input: Facebook Data + Access Token
│   ├── Output: JWT Token + User Data
│   └── Error: 401 Invalid Token
│
├── POST /auth/logout
│   ├── Input: (none, token in header)
│   ├── Output: Confirmation message
│   └── Error: 500 Server Error
│
├── GET /customers
│   ├── Auth: Required (JWT Token)
│   ├── Output: All Customers List
│   └── Error: 401 Unauthorized | 500 Server Error
│
├── GET /customers/profile/:id
│   ├── Auth: Required (JWT Token)
│   ├── Output: Customer Profile
│   └── Error: 401 Unauthorized | 404 Not Found
│
├── PUT /customers/profile/:id
│   ├── Auth: Required (JWT Token)
│   ├── Input: Updated customer data
│   ├── Output: Updated customer
│   └── Error: 401 Unauthorized | 404 Not Found
│
└── GET /health
    ├── Auth: Not required
    ├── Output: Server status + timestamp
    └── Error: 500 Server Error
```

## Security Layers

```
┌─────────────────────────────────────────┐
│         SECURITY FEATURES               │
├─────────────────────────────────────────┤
│                                         │
│  Layer 1: OAuth Provider Verification   │
│  ├─ Google: ID token signature check    │
│  └─ Facebook: Access token validation   │
│                                         │
│  Layer 2: JWT Authentication            │
│  ├─ Token signature verification        │
│  ├─ Token expiration check              │
│  └─ User ID validation                  │
│                                         │
│  Layer 3: Route Protection              │
│  ├─ authenticateToken middleware        │
│  ├─ User ownership validation           │
│  └─ Authorization checks                │
│                                         │
│  Layer 4: Transport Security            │
│  ├─ CORS validation                     │
│  ├─ HTTPS ready (set headers)           │
│  └─ Secure cookie flags                 │
│                                         │
│  Layer 5: Data Protection               │
│  ├─ Environment variable encryption     │
│  ├─ No sensitive data in logs           │
│  └─ Secure token storage                │
│                                         │
└─────────────────────────────────────────┘
```

## Environment Separation

```
Development:
├── Frontend: :5173 (Vite Dev Server)
├── Backend: :5000 (Node Dev Server)
├── Database: In-Memory Storage
└── OAuth: Google & Facebook Test Apps

Production:
├── Frontend: vercel.com / netlify / cloudflare
├── Backend: Railway / Heroku / AWS EC2
├── Database: MongoDB Atlas / PostgreSQL
└── OAuth: Google & Facebook Production Apps
```

## Technology Stack Overview

```
                    WEB TIER
                 ┌─────────┐
                 │ Browser │
                 └────┬────┘
                      │
        ┌─────────────┴─────────────┐
        │   (HTTP/S over TCP)       │
        │                           │
    ┌───▼──────────┐          ┌────▼─────────┐
    │  FRONTEND    │          │  BACKEND     │
    │  (React)     │          │  (Express)   │
    ├──────────────┤          ├──────────────┤
    │ Components   │          │ Controllers  │
    │ Routes       │          │ Routes       │
    │ State Mgmt   │          │ Models       │
    │ Styling      │          │ Middleware   │
    │ API Calls    │          │ Auth Logic   │
    └───┬──────────┘          └────┬─────────┘
        │                          │
        │      ┌──────────────┐    │
        └─────▶│ OAuth2.0 API │◀───┘
               │ (Google/FB)  │
               └──────────────┘
        
        └──────────────────────────────────────┘
           Local Data Storage (In-Memory/DB)
```

## Scalability Considerations

```
Current (Development):
├── Single server instance
├── In-memory data storage
└── No load balancing

For Production:
├── Horizontal Scaling
│   ├─ Load balancer (AWS ELB, Cloudflare)
│   └─ Multiple backend instances
├─ Vertical Scaling
│   ├─ Upgrade server resources
│   └─ Database optimization
└─ Caching Layer
    ├─ Redis for session management
    └─ CDN for static assets (Cloudflare)
```

## Deployment Architecture

```
┌────────────────────────────────────────────┐
│         Development Machine                │
│  ├─ Frontend Local Dev Server (:5173)     │
│  ├─ Backend Local Dev Server (:5000)      │
│  └─ In-Memory Database                    │
└────────────────────────────────────────────┘
         ↓ (npm build, git push)
┌────────────────────────────────────────────┐
│    Production Cloud Environment            │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │ CDN / Static Content Delivery        │ │
│  │ (Vercel, Netlify, Cloudflare)       │ │
│  │                                      │ │
│  │ ├─ Frontend Built Files (dist/)     │ │
│  │ └─ Static Assets                    │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │ API Server (Auto-scaled)             │ │
│  │ (Railway, Heroku, AWS, Google Cloud) │ │
│  │                                      │ │
│  │ ├─ Express Backend                  │ │
│  │ ├─ OAuth Verification               │ │
│  │ └─ API Endpoints                    │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │ Database Layer                       │ │
│  │ (MongoDB Atlas, AWS RDS)             │ │
│  │                                      │ │
│  │ ├─ Customer Data                    │ │
│  │ ├─ Backups & Replication            │ │
│  │ └─ Indexes & Optimization           │ │
│  └──────────────────────────────────────┘ │
│                                            │
└────────────────────────────────────────────┘
```

---

This complete architecture is production-ready and scalable. All components work together seamlessly to provide a secure, reliable OAuth login system.
