# Orry OAuth Login System - Testing Guide

## Frontend Testing

### Test Login Functionality

1. **Google Login Test**
   - Navigate to http://localhost:5173
   - Click "Continue with Google"
   - Use your Google account to sign in
   - Verify redirect to dashboard
   - Check user data is displayed

2. **Facebook Login Test**
   - Navigate to http://localhost:5173
   - Click "Continue with Meta"
   - Use Facebook account connected to your app
   - Verify redirect to dashboard
   - Check user data is displayed

3. **Protected Routes Test**
   - Log out from dashboard
   - Manually navigate to http://localhost:5173/dashboard
   - Should be redirected to login page
   - Verify token is cleared from localStorage

4. **Error Handling Test**
   - Try accessing without internet
   - Check error messages display properly
   - Verify UI doesn't break

## Backend Testing

### Using curl or Postman

```bash
# Test Google Login
curl -X POST http://localhost:5000/auth/google \
  -H "Content-Type: application/json" \
  -d '{"token": "your_google_id_token"}'

# Test get all customers
curl http://localhost:5000/customers \
  -H "Authorization: Bearer your_jwt_token"

# Test get customer profile
curl http://localhost:5000/customers/profile/user_id \
  -H "Authorization: Bearer your_jwt_token"

# Test health check
curl http://localhost:5000/health
```

### Expected Responses

**Successful Google Login:**
```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "1234567890",
    "name": "John Doe",
    "email": "john@gmail.com",
    "picture": "url_to_profile_pic",
    "provider": "google",
    "createdAt": "2024-02-21T00:00:00.000Z"
  }
}
```

**Successful Facebook Login:**
```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "9876543210",
    "name": "Jane Smith",
    "email": "jane@example.com",
    "picture": "url_to_profile_pic",
    "provider": "facebook",
    "createdAt": "2024-02-21T00:00:00.000Z"
  }
}
```

## Browser Testing

### Chrome DevTools

1. **Application Tab**
   - Check localStorage for "token" and "user"
   - Verify token format (should be JWT with 3 parts)

2. **Network Tab**
   - Monitor requests to /auth endpoints
   - Check response status and timing
   - Verify CORS headers are present

3. **Console Tab**
   - Check for JavaScript errors
   - Verify no console warnings about CORS

### Browser Console Commands

```javascript
// Check stored token
localStorage.getItem('token')

// Check stored user
JSON.parse(localStorage.getItem('user'))

// Clear storage (for testing logout)
localStorage.clear()

// Decode JWT (install jwt-decode)
// Can see: token structure, expiration, user info
```

## Performance Testing

### Frontend
- Use Chrome DevTools Lighthouse
- Check First Contentful Paint (FCP)
- Check Largest Contentful Paint (LCP)
- Target: <3s load time

### Backend
- Use Apache Bench or wrk
- Test concurrent requests
- Monitor memory usage
- Check response times

```bash
# Test backend performance
ab -n 100 -c 10 http://localhost:5000/health
```

## Security Testing

1. **Token Expiration**
   - Log in and note token
   - Wait 7 days (or modify JWT_SECRET to trigger expiration)
   - Try accessing dashboard
   - Should be redirected to login

2. **Invalid Tokens**
   - Modify token in localStorage
   - Try accessing protected routes
   - Should get 403 error

3. **CSRF Protection**
   - Verify form submissions include tokens
   - Check origin header validation

4. **XSS Protection**
   - Verify no `dangerouslySetInnerHTML` usage
   - Check input sanitization
   - Test with special characters in name field

## Mobile Testing

1. **Responsive Design**
   - Test on mobile viewport (375px width)
   - Test on tablet viewport (768px width)
   - Verify buttons are tap-friendly
   - Check text readability

2. **Touch Events**
   - Test login buttons on actual mobile device
   - Verify OAuth redirects work on mobile
   - Test keyboard appears for input fields

## Database Testing (When using MongoDB)

```bash
# Connect to MongoDB
mongo mongodb://admin:password@localhost:27017/orry

# Check customers collection
db.customers.find()

# Check indexes
db.customers.getIndexes()

# Count documents
db.customers.countDocuments()
```

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Invalid token" | Clear localStorage and re-login |
| OAuth won't load | Check client IDs in .env files |
| CORS errors | Verify FRONTEND_URL in backend .env |
| Page not rendering | Check browser console for errors |
| Data not saving | Check backend is running on port 5000 |

## Automated Testing (Future)

Create test files for:
- Unit tests (Jest)
- Integration tests (Supertest for API)
- E2E tests (Cypress for frontend)
- Load testing (k6 or JMeter)

```bash
# Example (when setup)
npm run test
npm run test:e2e
npm run test:load
```
