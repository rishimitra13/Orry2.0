# Environment Configuration Guide

## Frontend (.env.local)

```env
# Google OAuth
VITE_GOOGLE_CLIENT_ID=your_google_client_id_here

# Facebook/Meta OAuth
VITE_FACEBOOK_APP_ID=your_facebook_app_id_here

# API Configuration
VITE_API_URL=http://localhost:5000/api
```

## Backend (.env)

```env
# Server Configuration
PORT=5000
FRONTEND_URL=http://localhost:5173

# Google OAuth Configuration
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here

# Facebook/Meta OAuth Configuration
FACEBOOK_APP_ID=your_facebook_app_id_here
FACEBOOK_APP_SECRET=your_facebook_app_secret_here

# JWT Token Configuration
JWT_SECRET=your_super_secure_random_key_here_must_be_unique

# Database (Optional - for MongoDB)
MONGODB_URI=mongodb://localhost:27017/orry

# Environment
NODE_ENV=development
```

## Getting OAuth Credentials

### Google OAuth

1. Visit [Google Cloud Console](https://console.cloud.google.com/)
2. Click on "Select a Project" → "New Project"
3. Name it "Orry" and click Create
4. Wait for project creation to complete
5. Go to "APIs & Services" → "Library"
6. Search for "Google Identity Service" and enable it
7. Go to "APIs & Services" → "Credentials"
8. Click "Create Credentials" → "OAuth client ID"
9. Select "Web application"
10. Add Authorized JavaScript origins:
    - `http://localhost:5173`
    - `http://localhost:5000`
11. Add Authorized redirect URIs:
    - `http://localhost:5173`
    - `http://localhost:5000/auth/callback` (if needed)
12. Click Create and copy the Client ID and Secret

### Facebook/Meta OAuth

1. Visit [Facebook Developers](https://developers.facebook.com/)
2. Click "My Apps" → "Create App"
3. Choose "Consumer" as app type
4. Fill in app details (name: "Orry")
5. Click Create App
6. Add "Facebook Login" product
7. Go to Settings → Basic and copy App ID and App Secret
8. Go to Facebook Login → Settings
9. Add Valid OAuth Redirect URIs:
    - `http://localhost:5173`
    - `http://localhost:5173/`
10. Go to App Roles → Test Users and create a test account

## Production Environment

For production deployment, use strong, random values:

```env
JWT_SECRET=<generate 32+ character random string>
GOOGLE_CLIENT_ID=your_production_google_id
GOOGLE_CLIENT_SECRET=your_production_google_secret
FACEBOOK_APP_ID=your_production_facebook_app_id
FACEBOOK_APP_SECRET=your_production_facebook_app_secret
```

Use services like:
- Environment variable managers in your hosting platform
- Secrets management tools (AWS Secrets Manager, Azure Key Vault, etc.)
- Never commit .env files to version control

## Securing Credentials

1. **Never commit .env files** to git
2. **Use .gitignore** to exclude:
   ```
   .env
   .env.local
   .env.*.local
   node_modules/
   ```
3. **Rotate secrets regularly** in production
4. **Use different credentials** for development and production
5. **Add IP whitelisting** in OAuth provider settings
6. **Enable 2FA** on OAuth provider accounts

## Troubleshooting

### "Invalid Client ID"
- Verify ID matches exactly in both frontend and Google Console
- Check for extra spaces or newlines

### "Redirect URI mismatch"
- Ensure redirect URIs in OAuth provider match your application URLs
- Include trailing slashes if needed
- Use exact same protocol (http vs https)

### "Token verification failed"
- Check Client Secret in backend .env
- Ensure JWT_SECRET is consistent
- Verify audience claim in token

### "CORS blocking request"
- Check FRONTEND_URL in backend .env
- Verify CORS middleware allows your origin
- Check browser console for specific error
